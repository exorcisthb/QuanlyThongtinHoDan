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
import java.util.Map;

@WebServlet("/sua-lich-hop")
public class SuaLichHopServlet extends HttpServlet {

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

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
            return;
        }

        try {
            int lichHopID = Integer.parseInt(idStr);
            Map<String, Object> lichHop = lichHopService.getLichHopByID(lichHopID);
            request.setAttribute("lichHop", lichHop);
            request.getRequestDispatcher("/Views/ToTruong/SuaLichHop.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Không tìm thấy lịch họp.");
            response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
        }
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

        String idStr     = request.getParameter("lichHopID");
        String tieuDe    = request.getParameter("tieuDe");
        String noiDung   = request.getParameter("noiDung");
        String diaDiem   = request.getParameter("diaDiem");
        String strBatDau = request.getParameter("thoiGianBatDau");
        String strKetThuc= request.getParameter("thoiGianKetThuc");
        String mucDoStr  = request.getParameter("mucDo");
        String lyDoSua   = request.getParameter("lyDoSua");
        String[] doiTuongArr = request.getParameterValues("doiTuong");
        String doiTuong  = doiTuongArr != null ? String.join(",", doiTuongArr) : "";
        String trangThaiStr = request.getParameter("trangThai");

        int lichHopID = 0;
        try { lichHopID = Integer.parseInt(idStr); }
        catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
            return;
        }

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
            forwardBack(request, response, lichHopID);
            return;
        }

        int mucDo = 1;
        try { if (mucDoStr != null) mucDo = Integer.parseInt(mucDoStr); }
        catch (NumberFormatException ignored) {}

        int trangThai = 1;
        try { if (trangThaiStr != null) trangThai = Integer.parseInt(trangThaiStr); }
        catch (NumberFormatException ignored) {}

        LichHop lh = new LichHop();
        lh.setLichHopID(lichHopID);
        lh.setTieuDe(tieuDe);
        lh.setNoiDung(noiDung);
        lh.setDiaDiem(diaDiem);
        lh.setThoiGianBatDau(thoiGianBatDau);
        lh.setThoiGianKetThuc(thoiGianKetThuc);
        lh.setToDanPhoID(nguoiDung.getToDanPhoID());
        lh.setMucDo(mucDo);
        lh.setDoiTuong(doiTuong);
        lh.setTrangThai(trangThai);

        try {
            boolean ok = lichHopService.suaLichHop(lh, nguoiDung.getNguoiDungID(), lyDoSua);
            if (ok) {
                session.setAttribute("thanhCong",
                        "Cập nhật lịch họp thành công! Thông báo đã được gửi đến các chủ hộ.");
                response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
            } else {
                request.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại.");
                forwardBack(request, response, lichHopID);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            forwardBack(request, response, lichHopID);
        }
    }

    private void forwardBack(HttpServletRequest req, HttpServletResponse resp, int lichHopID)
            throws ServletException, IOException {
        try {
            Map<String, Object> lichHop = lichHopService.getLichHopByID(lichHopID);
            req.setAttribute("lichHop", lichHop);
        } catch (Exception ignored) {}
        req.getRequestDispatcher("/Views/ToTruong/SuaLichHop.jsp").forward(req, resp);
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return "ToTruong".equals(nd.getTenVaiTro());
    }
}