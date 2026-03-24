package Controller.Common;

import Model.Entity.NguoiDung;
import Model.Entity.TokenResetMatKhau;
import Model.Service.QuenMatKhauService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/quen-mat-khau")
public class QuenMatKhauServlet extends HttpServlet {

    private final QuenMatKhauService service = new QuenMatKhauService();

    // ==================== GET: load trang ====================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/Common/QuenMatKhau.jsp")
               .forward(request, response);
    }

    // ==================== POST: xử lý AJAX ====================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "kiemTraEmail":  xuLyKiemTraEmail(request, response);  break;
            case "xacMinh":       xuLyXacMinh(request, response);       break;
            case "doiMatKhau":    xuLyDoiMatKhau(request, response);    break;
            default:              writeJson(response, false, "Action không hợp lệ.", null);
        }
    }

    // ── BƯỚC 1: Kiểm tra Gmail ──
    private void xuLyKiemTraEmail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            writeJson(response, false, "Vui lòng nhập Gmail tài khoản.", null);
            return;
        }

        NguoiDung nd = service.timNguoiDungTheoEmail(email.trim());

        if (nd == null) {
            writeJson(response, false, "Gmail này chưa được đăng ký hoặc tài khoản chưa kích hoạt.", null);
            return;
        }

        // Lưu session để bước 2 dùng
        HttpSession session = request.getSession();
        session.setAttribute("verifiedEmail", email.trim());
        session.setAttribute("verifiedNguoiDungID", nd.getNguoiDungID());

        writeJson(response, true, "Gmail hợp lệ.", null);
    }

    // ── BƯỚC 2: Xác minh CCCD + SĐT ──
    private void xuLyXacMinh(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("verifiedEmail") == null) {
            writeJson(response, false, "Phiên làm việc đã hết hạn, vui lòng nhập lại Gmail.", null);
            return;
        }

        String cccd = request.getParameter("cccd");
        String sdt  = request.getParameter("sdt");

        if (cccd == null || cccd.trim().isEmpty() ||
            sdt  == null || sdt.trim().isEmpty()) {
            writeJson(response, false, "Vui lòng nhập đầy đủ CCCD và số điện thoại.", null);
            return;
        }

        NguoiDung nd = service.xacMinhNguoiDung(cccd.trim(), sdt.trim());

        if (nd == null) {
            writeJson(response, false, "CCCD hoặc số điện thoại không khớp với tài khoản.", null);
            return;
        }

        // Tạo token lưu DB + session
        String token = service.taoVaLuuToken(nd.getNguoiDungID());

        if (token == null) {
            writeJson(response, false, "Có lỗi xảy ra, vui lòng thử lại.", null);
            return;
        }

        session.setAttribute("resetToken", token);
        session.setAttribute("resetHoTen", nd.getHo() + " " + nd.getTen());
        session.removeAttribute("verifiedEmail");
        session.removeAttribute("verifiedNguoiDungID");

        writeJson(response, true, "Xác minh thành công.", token);
    }

    // ── BƯỚC 3: Đổi mật khẩu ──
    private void xuLyDoiMatKhau(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetToken") == null) {
            writeJson(response, false, "Phiên xác minh không hợp lệ, vui lòng thử lại từ đầu.", null);
            return;
        }

        String tokenFromSession = (String) session.getAttribute("resetToken");
        String tokenFromClient  = request.getParameter("token");

        // Kiểm tra token client gửi lên khớp session không
        if (!tokenFromSession.equals(tokenFromClient)) {
            writeJson(response, false, "Token không hợp lệ.", null);
            return;
        }

        String matKhauMoi     = request.getParameter("matKhauMoi");
        String xacNhanMatKhau = request.getParameter("xacNhanMatKhau");

        boolean ok = service.doiMatKhau(tokenFromSession, matKhauMoi, xacNhanMatKhau);

        if (!ok) {
            writeJson(response, false, "Phiên làm việc đã hết hạn hoặc mật khẩu không hợp lệ.", null);
            return;
        }

        session.removeAttribute("resetToken");
        session.removeAttribute("resetHoTen");

        writeJson(response, true, "Đổi mật khẩu thành công.", null);
    }

    // ── Helper: ghi JSON ra response ──
    private void writeJson(HttpServletResponse response, boolean success, String message, String token)
            throws IOException {
        PrintWriter out = response.getWriter();
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\"");
        if (token != null) {
            json.append(",\"token\":\"").append(escapeJson(token)).append("\"");
        }
        json.append("}");
        out.print(json.toString());
        out.flush();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}