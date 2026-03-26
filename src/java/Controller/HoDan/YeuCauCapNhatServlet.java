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
    //  - CCCD và NgaySinh KHÔNG cho phép sửa
    //  - Họ và tên gửi 1 chuỗi "hoTen", Servlet tự tách → Ho + Ten
    // ------------------------------------------------------------------ //
    private void handleTao(HttpServletRequest req, HttpServletResponse resp,
                           int nguoiDungID) throws IOException {

        String lyDo = emptyToNull(req.getParameter("lyDo"));
        if (lyDo == null) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                    false, "Vui lòng nhập lý do cập nhật.");
            return;
        }

        // ── Tách họ và tên từ 1 chuỗi đầy đủ ──
        String ho  = null;
        String ten = null;
        String hoTenDayDu = emptyToNull(req.getParameter("hoTen"));
        if (hoTenDayDu != null) {
            String[] parts = hoTenDayDu.trim().split("\\s+");
            if (parts.length < 2) {
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                        false, "Họ và tên phải có ít nhất 2 từ (ví dụ: Nguyễn An).");
                return;
            }
            // Chữ cuối cùng = Tên, phần còn lại = Họ và chữ đệm
            ten = parts[parts.length - 1];
            ho  = hoTenDayDu.substring(0, hoTenDayDu.lastIndexOf(ten)).trim();
        }

        // ── Các trường khác ──
        String gioiTinh    = emptyToNull(req.getParameter("gioiTinh"));
        String email       = emptyToNull(req.getParameter("email"));
        String soDienThoai = emptyToNull(req.getParameter("soDienThoai"));

        // ── Phải chọn ít nhất 1 trường ──
        if (ho == null && gioiTinh == null && email == null && soDienThoai == null) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                    false, "Vui lòng chọn ít nhất 1 trường muốn cập nhật.");
            return;
        }

        // ── Build entity — CCCD_Moi và NgaySinh_Moi luôn null ──
        YeuCauDoiTrangThai thongTinMoi = new YeuCauDoiTrangThai();
        thongTinMoi.setHo_Moi(ho);
        thongTinMoi.setTen_Moi(ten);
        thongTinMoi.setGioiTinh_Moi(gioiTinh);
        thongTinMoi.setEmail_Moi(email);
        thongTinMoi.setSDT_Moi(soDienThoai);
        // CCCD_Moi và NgaySinh_Moi không set → mặc định null

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