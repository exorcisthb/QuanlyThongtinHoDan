package Controller.CanBoPhuong;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import Model.Entity.NguoiDung;
@WebServlet("/canbophuong/dashboard")
public class CanBoPhuongDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        if (!"CanBoPhuong".equals(user.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Truyền dữ liệu cần thiết
        request.setAttribute("currentUser", user);
        // Nếu cần tên tổ: query DB hoặc lưu vào session lúc login

        request.getRequestDispatcher("/Views/CanBoPhuong/CanBoPhuongDashBoard.jsp")
               .forward(request, response);
    }
}