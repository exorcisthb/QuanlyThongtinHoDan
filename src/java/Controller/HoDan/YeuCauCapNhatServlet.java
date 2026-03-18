package Controller.HoDan;

import Model.Common.VaiTroConst;
import Model.Entity.NguoiDung;
import Model.Entity.YeuCauDoiTrangThai;
import Model.Service.YeuCauDoiTrangThaiService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.*;

@WebServlet("/hodan/yeu-cau-cap-nhat")
public class YeuCauCapNhatServlet extends HttpServlet {

    private final YeuCauDoiTrangThaiService service = new YeuCauDoiTrangThaiService();
    private final Gson gson = new Gson();

    // ------------------------------------------------------------------ //
    //  GET — lịch sử yêu cầu cập nhật của hộ dân (JSON)
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isLoggedIn(session)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!VaiTroConst.HO_DAN.equals(getTenVaiTro(session))) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                    false, "Không có quyền truy cập.");
            return;
        }

        int nguoiDungID = getNguoiDungID(session);
        List<Map<String, Object>> danhSach =
                service.layDanhSachCapNhatCuaNguoiDung(nguoiDungID);

        sendJsonObject(resp, HttpServletResponse.SC_OK, danhSach);
    }

    // ------------------------------------------------------------------ //
    //  POST — action: tao | huy
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
        if (!VaiTroConst.HO_DAN.equals(getTenVaiTro(session))) {
            sendJson(resp, HttpServletResponse.SC_FORBIDDEN,
                    false, "Không có quyền.");
            return;
        }

        String action   = req.getParameter("action");
        int nguoiDungID = getNguoiDungID(session);

        switch (action == null ? "" : action) {
            case "tao" -> handleTao(req, resp, nguoiDungID);
            case "huy" -> handleHuy(req, resp, nguoiDungID);
            default    -> sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                                   false, "Action không hợp lệ.");
        }
    }

    // ------------------------------------------------------------------ //
    //  HANDLER: Tạo yêu cầu cập nhật thông tin
    // ------------------------------------------------------------------ //
    private void handleTao(HttpServletRequest req, HttpServletResponse resp,
                           int nguoiDungID) throws IOException {

        String lyDo = req.getParameter("lyDo");

        // Đọc thông tin mới từ form (null/rỗng = không thay đổi trường đó)
        YeuCauDoiTrangThai thongTinMoi = new YeuCauDoiTrangThai();
        thongTinMoi.setHo_Moi(emptyToNull(req.getParameter("ho")));
        thongTinMoi.setTen_Moi(emptyToNull(req.getParameter("ten")));
        thongTinMoi.setGioiTinh_Moi(emptyToNull(req.getParameter("gioiTinh")));
        thongTinMoi.setEmail_Moi(emptyToNull(req.getParameter("email")));
        thongTinMoi.setSDT_Moi(emptyToNull(req.getParameter("soDienThoai")));
        thongTinMoi.setCCCD_Moi(emptyToNull(req.getParameter("cccd")));

        String ngaySinhStr = req.getParameter("ngaySinh");
        if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
            try {
                thongTinMoi.setNgaySinh_Moi(Date.valueOf(ngaySinhStr));
            } catch (Exception e) {
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                        false, "Ngày sinh không hợp lệ (định dạng: yyyy-MM-dd).");
                return;
            }
        }

        Map<String, Object> result = service.taoYeuCauCapNhat(
                nguoiDungID, thongTinMoi, lyDo);

        int status = (boolean) result.get("success")
                ? HttpServletResponse.SC_OK
                : HttpServletResponse.SC_BAD_REQUEST;
        sendJson(resp, status,
                (boolean) result.get("success"),
                (String)  result.get("message"));
    }

    // ------------------------------------------------------------------ //
    //  HANDLER: Huỷ yêu cầu
    // ------------------------------------------------------------------ //
    private void handleHuy(HttpServletRequest req, HttpServletResponse resp,
                           int nguoiDungID) throws IOException {

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
        sendJson(resp, status,
                (boolean) result.get("success"),
                (String)  result.get("message"));
    }

    // ------------------------------------------------------------------ //
    //  HELPERS
    // ------------------------------------------------------------------ //
    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("nguoiDung") != null;
    }

    private String getTenVaiTro(HttpSession session) {
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null ? nd.getTenVaiTro() : "";
    }

    private int getNguoiDungID(HttpSession session) {
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null ? nd.getNguoiDungID() : 0;
    }

    private int parseInt(String value, int defaultVal) {
        try { return Integer.parseInt(value); }
        catch (Exception e) { return defaultVal; }
    }

    private String emptyToNull(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    private void sendJson(HttpServletResponse resp, int status,
                          boolean success, String message) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> json = new LinkedHashMap<>();
        json.put("success", success);
        json.put("message", message);
        resp.getWriter().write(gson.toJson(json));
    }

    private void sendJsonObject(HttpServletResponse resp, int status,
                                Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }
}