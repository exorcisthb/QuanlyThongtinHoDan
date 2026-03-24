package Controller.ToTruong;

import Model.Entity.NguoiDung;
import Model.Entity.ThiepMoi;
import Model.Service.ThiepMoiService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/thiepmoi/danh-sach")
public class DanhSachThiepMoiServlet extends HttpServlet {

    private final ThiepMoiService service = new ThiepMoiService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy tổ dân phố của người đang đăng nhập
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        int toDanPhoID = nguoiDung.getToDanPhoID();

        // Lấy tham số lọc
        String keyword     = req.getParameter("keyword");
        int    trangThaiID = parseIntOrZero(req.getParameter("trangThaiID"));

        // Lấy danh sách — luôn lọc theo tổ của người đang đăng nhập
        List<ThiepMoi> danhSach = service.getDanhSach(keyword, toDanPhoID, trangThaiID);

        // Đẩy sang JSP
        req.setAttribute("danhSach",    danhSach);
        req.setAttribute("keyword",     keyword != null ? keyword : "");
        req.setAttribute("toDanPhoID",  toDanPhoID);
        req.setAttribute("trangThaiID", trangThaiID);

        // Lấy message từ redirect (nếu có)
        req.setAttribute("successMsg", session.getAttribute("successMsg"));
        req.setAttribute("errorMsg",   session.getAttribute("errorMsg"));
        session.removeAttribute("successMsg");
        session.removeAttribute("errorMsg");

        req.getRequestDispatcher("/Views/ToTruong/Danhsachthiepmoi.jsp")
           .forward(req, resp);
    }

    private int parseIntOrZero(String value) {
        try {
            return (value != null && !value.isEmpty()) ? Integer.parseInt(value) : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}