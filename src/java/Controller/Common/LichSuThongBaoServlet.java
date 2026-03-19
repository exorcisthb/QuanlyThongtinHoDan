package Controller.Common;

import Model.DAO.ThongBaoDAO;
import Model.Entity.NguoiDung;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/thong-bao/lich-su")
public class LichSuThongBaoServlet extends HttpServlet {

    private final ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        List<Map<String, Object>> danhSach =
                thongBaoDAO.layThongBaoCuaNguoiDung(nd.getNguoiDungID());

        long soChuaDoc = danhSach.stream()
                .filter(tb -> Boolean.FALSE.equals(tb.get("daDoc")))
                .count();

        request.setAttribute("danhSachThongBao", danhSach);
        request.setAttribute("soChuaDoc", (int) soChuaDoc);
        request.setAttribute("vaiTro", nd.getTenVaiTro());

        request.getRequestDispatcher("/Views/Common/LichSuThongBao.jsp")
               .forward(request, response);
    }
}