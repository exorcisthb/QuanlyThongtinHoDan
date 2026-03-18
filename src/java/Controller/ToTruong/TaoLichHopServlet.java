package Controller.ToTruong;

import Model.Entity.LichHop;
import Model.Entity.NguoiDung;
import Model.Service.LichHopService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet("/tao-lich-hop")
public class TaoLichHopServlet extends HttpServlet {

    private final LichHopService lichHopService = new LichHopService();
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isToTruong(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/Views/ToTruong/TaoLichHop.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!isToTruong(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");

        String tieuDe        = request.getParameter("tieuDe");
        String noiDung       = request.getParameter("noiDung");
        String diaDiem       = request.getParameter("diaDiem");
        String strBatDau     = request.getParameter("thoiGianBatDau");
        String strKetThuc    = request.getParameter("thoiGianKetThuc");
        String mucDoStr      = request.getParameter("mucDo");
        String[] doiTuongArr = request.getParameterValues("doiTuong");
        String doiTuong      = (doiTuongArr != null) ? String.join(",", doiTuongArr) : "";

        // Parse mucDo
        int mucDo = 1;
        try {
            if (mucDoStr != null && !mucDoStr.isEmpty())
                mucDo = Integer.parseInt(mucDoStr);
        } catch (NumberFormatException ignored) {}

        // Parse thời gian
        LocalDateTime thoiGianBatDau  = null;
        LocalDateTime thoiGianKetThuc = null;
        try {
            if (strBatDau != null && !strBatDau.isEmpty())
                thoiGianBatDau = LocalDateTime.parse(strBatDau, FORMATTER);
            if (strKetThuc != null && !strKetThuc.isEmpty())
                thoiGianKetThuc = LocalDateTime.parse(strKetThuc, FORMATTER);
        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Định dạng thời gian không hợp lệ.");
            request.getRequestDispatcher("/Views/ToTruong/TaoLichHop.jsp")
                   .forward(request, response);
            return;
        }

        // Build entity
        LichHop lh = new LichHop();
        lh.setTieuDe(tieuDe);
        lh.setNoiDung(noiDung);
        lh.setDiaDiem(diaDiem);
        lh.setThoiGianBatDau(thoiGianBatDau);
        lh.setThoiGianKetThuc(thoiGianKetThuc);
        lh.setToDanPhoID(nguoiDung.getToDanPhoID());
        lh.setMucDo(mucDo);
        lh.setDoiTuong(doiTuong);

        try {
            boolean ok = lichHopService.taoLichHop(lh, nguoiDung.getNguoiDungID());
            if (ok) {
                session.setAttribute("thanhCong",
                        "Tạo lịch họp thành công! Thông báo đã được gửi đến các chủ hộ.");
                response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
            } else {
                request.setAttribute("error", "Tạo lịch họp thất bại, vui lòng thử lại.");
                request.getRequestDispatcher("/Views/ToTruong/TaoLichHop.jsp")
                       .forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/Views/ToTruong/TaoLichHop.jsp")
                   .forward(request, response);
        }
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        return "ToTruong".equals(nguoiDung.getTenVaiTro());
    }
}