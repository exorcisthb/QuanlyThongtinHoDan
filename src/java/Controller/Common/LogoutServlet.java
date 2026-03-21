package Controller.Common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Lấy session hiện tại (không tạo mới nếu chưa có)
        HttpSession session = req.getSession(false);

        // 2. Invalidate session — xóa toàn bộ attribute
        if (session != null) {
            session.invalidate();
        }

        // 3. Xóa cookie JSESSIONID để browser không gửi lại
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JSESSIONID".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
                    cookie.setMaxAge(0); // Xóa ngay lập tức
                    resp.addCookie(cookie);
                }
            }
        }

        // 4. Chống cache — không cho browser lưu trang sau đăng xuất
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        // 5. Redirect về trang đăng nhập
        resp.sendRedirect(req.getContextPath() + "/");
    }
}