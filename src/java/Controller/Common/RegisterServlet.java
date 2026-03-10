package Controller.Common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang đăng ký riêng
        request.getRequestDispatcher("/Views/Common/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Thêm logic đăng ký thật ở đây (sau này)
        // Lấy params, kiểm tra, hash mật khẩu BCrypt, insert vào DB
        // Nếu thành công → redirect về login với thông báo
        // response.sendRedirect(request.getContextPath() + "/login?success=registered");

        // Tạm thời: giả lập lỗi để test
        request.setAttribute("error", "Vui lòng kiểm tra lại thông tin đăng ký");
        request.getRequestDispatcher("/Views/Common/Register.jsp").forward(request, response);
    }
}