package Controller.ToTruong;

import Model.Common.VaiTroConst;
import Model.Entity.NguoiDung;
import Model.Service.YeuCauDoiTrangThaiService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet("/yeu-cau-doi-trang-thai")
public class YeuCauDoiTrangThaiServlet extends HttpServlet {

    private final YeuCauDoiTrangThaiService service = new YeuCauDoiTrangThaiService();
    private final Gson gson = new Gson();

    // ------------------------------------------------------------------ //
    //  GET — load trang danh sách
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isLoggedIn(session)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String tenVaiTro = getTenVaiTro(session);
        int nguoiDungID  = getNguoiDungID(session);
        String action    = req.getParameter("action");

        // ── JSON list cho dashboard widget ──────────────────────────────
        if ("json".equals(req.getParameter("format"))) {
            List<Map<String, Object>> danhSach;
            if (VaiTroConst.CAN_BO_PHUONG.equals(tenVaiTro)) {
                String filter = req.getParameter("filter");
                danhSach = "cho-duyet".equals(filter)
                        ? service.layDanhSachChoDuyet()
                        : service.layTatCa();
            } else if (VaiTroConst.TO_TRUONG.equals(tenVaiTro)) {
                int toDanPhoID = getToDanPhoID(session);
                danhSach = service.layDanhSachTheoTo(toDanPhoID);
            } else {
                sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                         false, "Không có quyền.");
                return;
            }
            // Thêm field ttYC (string) để JS dễ filter
            for (Map<String, Object> row : danhSach) {
                Object ttObj = row.get("trangThaiYeuCauID");
                int ttID = ttObj instanceof Integer ? (Integer) ttObj : 0;
                String ttYC = ttID == 1 ? "cho"
                            : ttID == 2 ? "duyet"
                            : ttID == 3 ? "tuchoi"
                            : "huy";
                row.put("ttYC", ttYC);
            }
            sendJsonObject(resp, HttpServletResponse.SC_OK, danhSach);
            return;
        }
        // ────────────────────────────────────────────────────────────────

        // --- Chi tiết 1 yêu cầu (forward JSP) ---
        if ("chitiet".equals(action)) {
            int yeuCauID = parseInt(req.getParameter("id"), 0);
            if (yeuCauID == 0) {
                resp.sendRedirect(req.getContextPath() + "/yeu-cau-doi-trang-thai");
                return;
            }
            Map<String, Object> chiTiet = service.layChiTiet(yeuCauID);
            req.setAttribute("chiTiet", chiTiet);
            req.getRequestDispatcher("/WEB-INF/views/yeucau/chitiet.jsp")
               .forward(req, resp);
            return;
        }

        // --- Chi tiết yêu cầu theo thongBaoID (trả JSON cho modal chuông) ---
        if ("chitiet-notif".equals(action)) {
            int thongBaoID = parseInt(req.getParameter("thongBaoID"), 0);
            if (thongBaoID == 0) {
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                         false, "Thiếu ID thông báo.");
                return;
            }
            Map<String, Object> chiTiet = service.layChiTietTheoThongBao(thongBaoID);
            if (chiTiet == null) {
                sendJson(resp, HttpServletResponse.SC_NOT_FOUND,
                         false, "Không tìm thấy yêu cầu liên quan.");
                return;
            }
            sendJsonObject(resp, HttpServletResponse.SC_OK, chiTiet);
            return;
        }

        // --- Danh sách ---
        List<Map<String, Object>> danhSach;

        if (VaiTroConst.CAN_BO_PHUONG.equals(tenVaiTro)) {
            String filter = req.getParameter("filter");
            if ("cho-duyet".equals(filter)) {
                danhSach = service.layDanhSachChoDuyet();
            } else {
                danhSach = service.layTatCa();
            }
            req.setAttribute("filter", filter);

        } else if (VaiTroConst.TO_TRUONG.equals(tenVaiTro)) {
            int toDanPhoID = getToDanPhoID(session);
            danhSach = service.layDanhSachTheoTo(toDanPhoID);

        } else {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.setAttribute("danhSach", danhSach);
        req.setAttribute("tenVaiTro", tenVaiTro);
        req.getRequestDispatcher("/WEB-INF/views/yeucau/danhsach.jsp")
           .forward(req, resp);
    }

    // ------------------------------------------------------------------ //
    //  POST — xử lý các action
    // ------------------------------------------------------------------ //
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (!isLoggedIn(session)) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                     false, "Phiên đăng nhập đã hết hạn.");
            return;
        }

        String tenVaiTro = getTenVaiTro(session);
        int nguoiDungID  = getNguoiDungID(session);
        String action    = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "tao"    -> handleTao(req, resp, nguoiDungID, tenVaiTro);
            case "duyet"  -> handleDuyet(req, resp, nguoiDungID, tenVaiTro);
            case "tuchoi" -> handleTuChoi(req, resp, nguoiDungID, tenVaiTro);
            case "huy"    -> handleHuy(req, resp, nguoiDungID, tenVaiTro);
            default       -> sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                                      false, "Action không hợp lệ.");
        }
    }

    // ------------------------------------------------------------------ //
    //  HANDLER: Tạo yêu cầu (tổ trưởng)
    // ------------------------------------------------------------------ //
    private void handleTao(HttpServletRequest req, HttpServletResponse resp,
                           int nguoiDungID, String tenVaiTro)
            throws IOException {

        if (!VaiTroConst.TO_TRUONG.equals(tenVaiTro)) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                     false, "Bạn không có quyền tạo yêu cầu.");
            return;
        }

        int    hoDanID        = parseInt(req.getParameter("hoDanID"),        0);
        int    trangThaiCuID  = parseInt(req.getParameter("trangThaiCuID"),  0);
        int    trangThaiMoiID = parseInt(req.getParameter("trangThaiMoiID"), 0);
        String lyDo           = req.getParameter("lyDo");

        if (hoDanID == 0 || trangThaiCuID == 0 || trangThaiMoiID == 0) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                     false, "Dữ liệu đầu vào không hợp lệ.");
            return;
        }

        Map<String, Object> result = service.taoYeuCau(
                hoDanID, trangThaiCuID, trangThaiMoiID, nguoiDungID, lyDo);

        int status = (boolean) result.get("success")
                ? HttpServletResponse.SC_OK
                : HttpServletResponse.SC_BAD_REQUEST;
        sendJson(resp, status, (boolean) result.get("success"),
                 (String) result.get("message"));
    }

    // ------------------------------------------------------------------ //
    //  HANDLER: Duyệt yêu cầu (cán bộ phường)
    // ------------------------------------------------------------------ //
    private void handleDuyet(HttpServletRequest req, HttpServletResponse resp,
                             int nguoiDungID, String tenVaiTro)
            throws IOException {

        if (!VaiTroConst.CAN_BO_PHUONG.equals(tenVaiTro)) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                     false, "Bạn không có quyền duyệt yêu cầu.");
            return;
        }

        int    yeuCauID = parseInt(req.getParameter("yeuCauID"), 0);
        String ghiChu   = req.getParameter("ghiChu");

        if (yeuCauID == 0) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                     false, "Thiếu mã yêu cầu.");
            return;
        }

        Map<String, Object> result = service.duyetYeuCau(yeuCauID, nguoiDungID, ghiChu);

        int status = (boolean) result.get("success")
                ? HttpServletResponse.SC_OK
                : HttpServletResponse.SC_BAD_REQUEST;
        sendJson(resp, status, (boolean) result.get("success"),
                 (String) result.get("message"));
    }

    // ------------------------------------------------------------------ //
    //  HANDLER: Từ chối yêu cầu (cán bộ phường)
    // ------------------------------------------------------------------ //
    private void handleTuChoi(HttpServletRequest req, HttpServletResponse resp,
                              int nguoiDungID, String tenVaiTro)
            throws IOException {

        if (!VaiTroConst.CAN_BO_PHUONG.equals(tenVaiTro)) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                     false, "Bạn không có quyền từ chối yêu cầu.");
            return;
        }

        int    yeuCauID   = parseInt(req.getParameter("yeuCauID"), 0);
        String lyDoTuChoi = req.getParameter("lyDoTuChoi");

        if (yeuCauID == 0) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                     false, "Thiếu mã yêu cầu.");
            return;
        }

        Map<String, Object> result = service.tuChoiYeuCau(yeuCauID, nguoiDungID, lyDoTuChoi);

        int status = (boolean) result.get("success")
                ? HttpServletResponse.SC_OK
                : HttpServletResponse.SC_BAD_REQUEST;
        sendJson(resp, status, (boolean) result.get("success"),
                 (String) result.get("message"));
    }

    // ------------------------------------------------------------------ //
    //  HANDLER: Huỷ yêu cầu (tổ trưởng tự huỷ)
    // ------------------------------------------------------------------ //
    private void handleHuy(HttpServletRequest req, HttpServletResponse resp,
                           int nguoiDungID, String tenVaiTro)
            throws IOException {

        if (!VaiTroConst.TO_TRUONG.equals(tenVaiTro)) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                     false, "Bạn không có quyền huỷ yêu cầu.");
            return;
        }

        int yeuCauID = parseInt(req.getParameter("yeuCauID"), 0);

        if (yeuCauID == 0) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                     false, "Thiếu mã yêu cầu.");
            return;
        }

        Map<String, Object> result = service.huyYeuCau(yeuCauID, nguoiDungID);

        int status = (boolean) result.get("success")
                ? HttpServletResponse.SC_OK
                : HttpServletResponse.SC_BAD_REQUEST;
        sendJson(resp, status, (boolean) result.get("success"),
                 (String) result.get("message"));
    }

    // ------------------------------------------------------------------ //
    //  HELPERS
    // ------------------------------------------------------------------ //
    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("nguoiDung") != null
            || session.getAttribute("nguoiDungID") != null;
    }

    private String getTenVaiTro(HttpSession session) {
        Object vaiTro = session.getAttribute("vaiTro");
        if (vaiTro != null) return vaiTro.toString();
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null ? nd.getTenVaiTro() : "";
    }

    private int getNguoiDungID(HttpSession session) {
        Object id = session.getAttribute("nguoiDungID");
        if (id instanceof Integer) return (Integer) id;
        if (id != null) try { return Integer.parseInt(id.toString()); } catch (Exception ignored) {}
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null ? nd.getNguoiDungID() : 0;
    }

    private int getToDanPhoID(HttpSession session) {
        Object id = session.getAttribute("toDanPhoID");
        if (id instanceof Integer) return (Integer) id;
        if (id != null) try { return Integer.parseInt(id.toString()); } catch (Exception ignored) {}
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null ? nd.getToDanPhoID() : 0;
    }

    private int parseInt(String value, int defaultVal) {
        try { return Integer.parseInt(value); }
        catch (Exception e) { return defaultVal; }
    }

    private void sendJson(HttpServletResponse resp, int statusCode,
                          boolean success, String message) throws IOException {
        resp.setStatus(statusCode);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> json = new LinkedHashMap<>();
        json.put("success", success);
        json.put("message", message);
        resp.getWriter().write(gson.toJson(json));
    }

    private void sendJsonObject(HttpServletResponse resp, int statusCode,
                                Object data) throws IOException {
        resp.setStatus(statusCode);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }
}