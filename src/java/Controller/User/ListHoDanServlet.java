package Controller.User;

import Model.Entity.HoDan;
import Model.Entity.NguoiDung;
import Model.Service.HoDanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/todan/hodan")
public class ListHoDanServlet extends HttpServlet {

    private final HoDanService hoDanService = new HoDanService();

    @Override
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

        String keyword = request.getParameter("keyword");
        int toDanPhoID = user.getToDanPhoID();

        Map<String, List<HoDan>> nhomTheoDuong =
            hoDanService.getDanhSachNhomTheoDuong(toDanPhoID, keyword);

        request.setAttribute("nhomTheoDuong", nhomTheoDuong);
        request.setAttribute("tongSoHo", hoDanService.tongSoHo(nhomTheoDuong));
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentUser", user);

        request.getRequestDispatcher("/Views/ToTruong/DanhSachHoDan.jsp")
               .forward(request, response);
    }
}