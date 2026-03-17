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

@WebServlet("/admin/create_canbophuong")
public class CreateCanBoPhuongServlet extends HttpServlet {
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
        // SỬA: trỏ về AdminDashboard.jsp thay vì AdminCanBoDashboard.jsp
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
        String ho          = request.getParameter("ho");
        String ten         = request.getParameter("ten");
        String ngaySinh    = request.getParameter("ngaySinh");
        String gioiTinh    = request.getParameter("gioiTinh");
        String email       = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");
        String matKhau     = request.getParameter("matKhau");
        String xacNhanMk   = request.getParameter("xacNhanMk");

        request.setAttribute("oldHo",       ho);
        request.setAttribute("oldTen",      ten);
        request.setAttribute("oldNgaySinh", ngaySinh);
        request.setAttribute("oldGioiTinh", gioiTinh);
        request.setAttribute("oldEmail",    email);
        request.setAttribute("oldSdt",      soDienThoai);
        request.setAttribute("currentAdmin", session.getAttribute("nguoiDung"));

        if (matKhau == null || !matKhau.equals(xacNhanMk)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            // SỬA: trỏ về AdminDashboard.jsp
            request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
                   .forward(request, response);
            return;
        }

        String error = nguoiDungService.taoCanBoPhuong(
                ho, ten, ngaySinh, gioiTinh,
                email, soDienThoai, matKhau);

        if (error == null) {
            // SỬA: dùng redirect sau khi tạo thành công để tránh resubmit form
            request.getSession().setAttribute("flashMessage",
                    "Tạo tài khoản Cán bộ phường thành công cho: " + ho + " " + ten);
            response.sendRedirect(request.getContextPath() + "/admin/ds_canbophuong");
        } else {
            request.setAttribute("error", error);
            // SỬA: trỏ về AdminDashboard.jsp
            request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
                   .forward(request, response);
        }
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null && "Admin".equals(nd.getTenVaiTro());
    }
}