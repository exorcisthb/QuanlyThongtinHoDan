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
import java.sql.Timestamp;

@WebServlet("/thiepmoi/tao-moi")
public class TaoThiepMoiServlet extends HttpServlet {

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

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        req.setAttribute("toDanPhoID", nguoiDung.getToDanPhoID());
        req.setAttribute("tenTo", nguoiDung.getTenTo());

        req.getRequestDispatcher("/Views/ToTruong/TaoThiepMoi.jsp")
           .forward(req, resp);
    }

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
        int nguoiTaoID = nguoiDung.getNguoiDungID();

        String tieuDe  = req.getParameter("tieuDe");
        String noiDung = req.getParameter("noiDung");
        String diaDiem = req.getParameter("diaDiem");
        String tgbdStr = req.getParameter("thoiGianBatDau");
        String tgktStr = req.getParameter("thoiGianKetThuc");
        String toStr   = req.getParameter("toDanPhoID");

        if (tieuDe == null || tieuDe.trim().isEmpty()
                || tgbdStr == null || tgbdStr.isEmpty()
                || toStr == null || toStr.isEmpty()) {

            session.setAttribute("errorMsg", "Vui lòng điền đầy đủ thông tin bắt buộc.");
            resp.sendRedirect(req.getContextPath() + "/thiepmoi/tao-moi");
            return;
        }

        ThiepMoi t = new ThiepMoi();
        t.setTieuDe(tieuDe.trim());
        t.setNoiDung(noiDung);
        t.setDiaDiem(diaDiem);
        t.setToDanPhoID(Integer.parseInt(toStr));

        try {
            t.setThoiGianBatDau(Timestamp.valueOf(tgbdStr.replace("T", " ") + ":00"));
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Thời gian bắt đầu không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/thiepmoi/tao-moi");
            return;
        }

        if (tgktStr != null && !tgktStr.isEmpty()) {
            try {
                t.setThoiGianKetThuc(Timestamp.valueOf(tgktStr.replace("T", " ") + ":00"));
            } catch (Exception ignored) {}
        }

        boolean ok = service.taoThiepMoi(t, nguoiTaoID);

        if (ok) {
            session.setAttribute("successMsg", "Tạo thiệp mời thành công! Đã gửi thông báo đến người dân.");
        } else {
            session.setAttribute("errorMsg", "Tạo thiệp mời thất bại. Vui lòng thử lại.");
        }

        resp.sendRedirect(req.getContextPath() + "/thiepmoi/danh-sach");
    }
}