package Controller.ToTruong;

import Model.DAO.ThongBaoDAO;
import Model.Entity.NguoiDung;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/totruong/dashboard")
public class ToTruongDashboardServlet extends HttpServlet {

    private final ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        if (!"ToTruong".equals(user.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load thông báo từ DB
        List<Map<String, Object>> danhSachThongBao =
                thongBaoDAO.layThongBaoCuaNguoiDung(user.getNguoiDungID());
        int soChuaDoc = (int) danhSachThongBao.stream()
                .filter(tb -> Boolean.FALSE.equals(tb.get("daDoc")))
                .count();

        request.setAttribute("currentUser",       user);
        request.setAttribute("danhSachThongBao",  danhSachThongBao);
        request.setAttribute("soChuaDoc",         soChuaDoc);

        request.getRequestDispatcher("/Views/ToTruong/ToTruongDashboard.jsp")
               .forward(request, response);
    }
}