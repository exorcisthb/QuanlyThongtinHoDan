package Controller.HoDan;

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

@WebServlet("/hodan/dashboard")
public class HoDanDashBoardServlet extends HttpServlet {

    private final ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Kiểm tra session ────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        if (!"HoDan".equals(user.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Load thông báo cho chuông bell ──────────────────────────────
        try {
            List<Map<String, Object>> danhSachTB =
                    thongBaoDAO.layThongBaoCuaNguoiDung(user.getNguoiDungID());
            int soChuaDoc = thongBaoDAO.demChuaDoc(user.getNguoiDungID());
            request.setAttribute("danhSachThongBao", danhSachTB);
            request.setAttribute("soChuaDoc",        soChuaDoc);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("danhSachThongBao", List.of());
            request.setAttribute("soChuaDoc",        0);
        }

        // ── Forward ────────────────────────────────────────────────────
        request.setAttribute("currentUser", user);
        request.getRequestDispatcher("/Views/HoDan/HoDanDashBoard.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}