package Controller.Admin;

import Model.Entity.NguoiDung;
import Model.Service.NguoiDungService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/create_totruong")
public class CreateToTruongServlet extends HttpServlet {

    private final NguoiDungService nguoiDungService = new NguoiDungService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("currentAdmin", session.getAttribute("nguoiDung"));
        request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String cccd        = request.getParameter("cccd");
        String ho          = request.getParameter("ho");
        String ten         = request.getParameter("ten");
        String ngaySinh    = request.getParameter("ngaySinh");
        String gioiTinh    = request.getParameter("gioiTinh");
        String email       = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");
        String matKhau     = request.getParameter("matKhau");
        String xacNhanMk   = request.getParameter("xacNhanMk");
        String tenTo       = request.getParameter("tenTo");

        request.setAttribute("oldCccd",     cccd);
        request.setAttribute("oldHo",       ho);
        request.setAttribute("oldTen",      ten);
        request.setAttribute("oldNgaySinh", ngaySinh);
        request.setAttribute("oldGioiTinh", gioiTinh);
        request.setAttribute("oldEmail",    email);
        request.setAttribute("oldSdt",      soDienThoai);
        request.setAttribute("oldTenTo",    tenTo);
        request.setAttribute("currentAdmin", session.getAttribute("nguoiDung"));

        if (matKhau == null || !matKhau.equals(xacNhanMk)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
                   .forward(request, response);
            return;
        }

        // ✅ Gọi service và lấy lỗi chi tiết
        String error = nguoiDungService.taoToTruong(
                cccd, ho, ten, ngaySinh, gioiTinh,
                email, soDienThoai, matKhau, tenTo);

        if (error == null) {
            clearOldValues(request);
            request.setAttribute("message",
                    "Tạo tài khoản Tổ trưởng thành công cho: " + ho + " " + ten);
        } else {
            request.setAttribute("error", error);

            // ✅ DEBUG: hiển thị toàn bộ thông tin nhận được
            request.setAttribute("debugInfo",
                "cccd=" + cccd
                + " | ho=" + ho
                + " | ten=" + ten
                + " | ngaySinh=" + ngaySinh
                + " | gioiTinh=[" + gioiTinh + "]"
                + " | email=" + email
                + " | sdt=" + soDienThoai
                + " | tenTo=[" + tenTo + "]"
                + " | matKhau.length=" + (matKhau != null ? matKhau.length() : "null")
                + " | hasUpper=" + (matKhau != null && matKhau.matches(".*[A-Z].*"))
                + " | hasDigit=" + (matKhau != null && matKhau.matches(".*[0-9].*"))
                + " | hasSpecial=" + (matKhau != null && matKhau.matches(".*[^A-Za-z0-9].*"))
            );
        }

        request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
               .forward(request, response);
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null && "Admin".equals(nd.getTenVaiTro());
    }

    private void clearOldValues(HttpServletRequest request) {
        request.removeAttribute("oldCccd");
        request.removeAttribute("oldHo");
        request.removeAttribute("oldTen");
        request.removeAttribute("oldNgaySinh");
        request.removeAttribute("oldGioiTinh");
        request.removeAttribute("oldEmail");
        request.removeAttribute("oldSdt");
        request.removeAttribute("oldTenTo");
    }
}