package Controller.HoDan;

import Model.DAO.ThiepMoiDAO;
import Model.Entity.NguoiDung;
import Model.Entity.ThiepMoi;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/hodan/thiepmoi")
public class XemThiepMoiServlet extends HttpServlet {

    private final ThiepMoiDAO dao = new ThiepMoiDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        // Chỉ lấy thiệp mời của tổ người dân đang ở
        List<ThiepMoi> danhSach = dao.getByTo(nd.getToDanPhoID());

        request.setAttribute("danhSach", danhSach);
        request.getRequestDispatcher("/Views/HoDan/XemThiepMoi.jsp")
               .forward(request, response);
    }
}