package Controller.ToTruong;

import Model.Entity.ThiepMoi;
import Model.Entity.NguoiDung;
import Model.Service.ThiepMoiService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/thiepmoi/in")
public class InThiepMoiServlet extends HttpServlet {

    private final ThiepMoiService service = new ThiepMoiService();

    // ------------------------------------------------------------------ //
    //  GET — mở trang cài đặt in (chọn số lượng, khổ giấy, bố cục)
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int id = parseIntOrZero(req.getParameter("id"));
        ThiepMoi thiep = service.getChiTiet(id);
        if (thiep == null) {
            resp.sendRedirect(req.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        req.setAttribute("thiep", thiep);
        req.getRequestDispatcher("/Views/ToTruong/InThiepMoi.jsp")
           .forward(req, resp);
    }

    // ------------------------------------------------------------------ //
    //  POST — xác nhận in (khóa thiệp lại sau khi in)
    // ------------------------------------------------------------------ //
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        int thiepMoiID = parseIntOrZero(req.getParameter("thiepMoiID"));

        boolean ok = service.inThiepMoi(thiepMoiID, nguoiDung.getNguoiDungID());
        if (ok) {
            session.setAttribute("successMsg", "Đã xác nhận in thiệp. Thiệp không thể sửa hoặc xóa.");
        } else {
            session.setAttribute("errorMsg", "Xác nhận in thất bại hoặc thiệp đã được in trước đó.");
        }
        resp.sendRedirect(req.getContextPath() + "/thiepmoi/chi-tiet?id=" + thiepMoiID);
    }

    private int parseIntOrZero(String val) {
        try { return val != null ? Integer.parseInt(val) : 0; }
        catch (NumberFormatException e) { return 0; }
    }
}