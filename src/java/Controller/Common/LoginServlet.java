package Controller.Common;

import Model.DAO.NguoiDungDAO;
import Model.Entity.NguoiDung;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("nguoiDung") != null) {
            NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
            switch (nd.getTenVaiTro()) {
                case "Admin":
                    request.setAttribute("currentAdmin", nd);
                    request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
                            .forward(request, response);
                    break;
                case "ToTruong":
                    response.sendRedirect(request.getContextPath() + "/totruong/dashboard");
                    break;
                default:
                    request.getRequestDispatcher("/Views/Common/Login.jsp")
                            .forward(request, response);
                    break;
            }
            return;
        }
        request.getRequestDispatcher("/Views/Common/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String matKhau = request.getParameter("matKhau");

        // Validate đầu vào
        if (email == null || email.trim().isEmpty()
                || matKhau == null || matKhau.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu.");
            request.getRequestDispatcher("/Views/Common/Login.jsp").forward(request, response);
            return;
        }

        try {
            NguoiDungDAO dao = new NguoiDungDAO();
            NguoiDung nguoiDung = dao.dangNhap(email.trim(), matKhau.trim());

            if (nguoiDung == null) {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/Views/Common/Login.jsp").forward(request, response);
                return;
            }

            if (!nguoiDung.isIsActivated()) {
                request.setAttribute("error", "Tài khoản chưa được kích hoạt.");
                request.getRequestDispatcher("/Views/Common/Login.jsp").forward(request, response);
                return;
            }

            // Lưu thông tin vào session
            HttpSession session = request.getSession();
            session.setAttribute("nguoiDung", nguoiDung);
            session.setAttribute("vaiTro", nguoiDung.getTenVaiTro());

            // Redirect theo vai trò
            switch (nguoiDung.getTenVaiTro()) {
                case "Admin":
                    request.setAttribute("currentAdmin", nguoiDung);
                    request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
                            .forward(request, response);
                    break;
                case "ToTruong":  // ✅ khớp với DB
                    response.sendRedirect(request.getContextPath() + "/totruong/dashboard");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/login");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại.");
            request.getRequestDispatcher("/Views/Common/Login.jsp").forward(request, response);
        }
    }
}
