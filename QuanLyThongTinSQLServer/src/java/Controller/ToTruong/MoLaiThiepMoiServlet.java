package Controller.ToTruong;

import Model.DAO.ThiepMoiDAO;
import Model.Entity.NguoiDung;
import Model.Entity.ThiepMoi;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet("/thiepmoi/mo-lai")
public class MoLaiThiepMoiServlet extends HttpServlet {

    private final ThiepMoiDAO thiepMoiDAO = new ThiepMoiDAO();
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

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

        String idStr         = request.getParameter("thiepMoiID");
        String tgBatDauStr   = request.getParameter("thoiGianBatDau");
        String tgKetThucStr  = request.getParameter("thoiGianKetThuc");
        String noiDung       = request.getParameter("noiDung");
        String diaDiem       = request.getParameter("diaDiem");

        // Validate cơ bản
        if (idStr == null || idStr.isBlank()) {
            session.setAttribute("errorMsg", "Thiếu thông tin thiệp mời.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (tgBatDauStr == null || tgBatDauStr.isBlank()) {
            session.setAttribute("errorMsg", "Vui lòng nhập thời gian bắt đầu mới.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (diaDiem == null || diaDiem.isBlank()) {
            session.setAttribute("errorMsg", "Vui lòng nhập địa điểm.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        int thiepMoiID;
        try {
            thiepMoiID = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Thiệp mời không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        // Parse thời gian
        Timestamp thoiGianBatDau;
        Timestamp thoiGianKetThuc = null;
        try {
            thoiGianBatDau = Timestamp.valueOf(LocalDateTime.parse(tgBatDauStr, FMT));
        } catch (DateTimeParseException e) {
            session.setAttribute("errorMsg", "Định dạng thời gian không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (tgKetThucStr != null && !tgKetThucStr.isBlank()) {
            try {
                thoiGianKetThuc = Timestamp.valueOf(LocalDateTime.parse(tgKetThucStr, FMT));
            } catch (DateTimeParseException e) {
                session.setAttribute("errorMsg", "Định dạng thời gian kết thúc không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                return;
            }
        }

        // Validate thời gian > now
        if (thoiGianBatDau.getTime() <= System.currentTimeMillis()) {
            session.setAttribute("errorMsg", "Thời gian bắt đầu mới phải sau thời điểm hiện tại.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        // Kiểm tra thiệp tồn tại và đang tạm hoãn
        ThiepMoi tm = thiepMoiDAO.getByID(thiepMoiID);
        if (tm == null) {
            session.setAttribute("errorMsg", "Không tìm thấy thiệp mời.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (tm.getTrangThaiID() != ThiepMoiDAO.TRANG_THAI_TAM_HOAN) {
            session.setAttribute("errorMsg", "Chỉ có thể mở lại thiệp đang ở trạng thái \"Tạm hoãn\".");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        boolean ok = thiepMoiDAO.moLaiThiepMoi(
            thiepMoiID,
            nguoiDung.getNguoiDungID(),
            thoiGianBatDau,
            thoiGianKetThuc,
            noiDung,
            diaDiem.trim()
        );

        if (ok) {
            session.setAttribute("successMsg",
                "Đã mở lại thiệp mời với thời gian mới. Thông báo [MỞ LẠI] đã được gửi đến toàn bộ hộ dân.");
        } else {
            session.setAttribute("errorMsg", "Mở lại thất bại. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return "ToTruong".equals(nd.getTenVaiTro());
    }
}