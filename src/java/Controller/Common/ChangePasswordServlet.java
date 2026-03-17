package Controller.Common;
import Model.Entity.NguoiDung;
import Model.Service.NguoiDungService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/change_password")
public class ChangePasswordServlet extends HttpServlet {
    private final NguoiDungService nguoiDungService = new NguoiDungService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung admin = (NguoiDung) session.getAttribute("nguoiDung");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/Views/Common/Change_Password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        NguoiDung admin = (NguoiDung) session.getAttribute("nguoiDung");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPw = request.getParameter("currentPassword");
        String newPw     = request.getParameter("newPassword");
        String confirmPw = request.getParameter("confirmPassword");

        boolean success = nguoiDungService.changePassword(
                admin.getNguoiDungID(), currentPw, newPw, confirmPw);

        if (success) {
            session.invalidate(); // xóa session cũ
            response.sendRedirect(request.getContextPath() + "/login?msg=password_changed");
            return;
        } else {
            request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng kiểm tra lại mật khẩu hiện tại hoặc xác nhận mật khẩu mới.");
        }
        request.getRequestDispatcher("/Views/Common/Change_Password.jsp").forward(request, response);
    }
}