package Controller.ToTruong;

import Model.DAO.ThiepMoiDAO;
import Model.Entity.NguoiDung;
import Model.Entity.ThiepMoi;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/thiepmoi/tam-hoan")
public class TamHoanThiepMoiServlet extends HttpServlet {

    private final ThiepMoiDAO thiepMoiDAO = new ThiepMoiDAO();
    private static final int GIO_KHOA_HOAN = 3;

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

        String idStr      = request.getParameter("thiepMoiID");
        String ghiChuHoan = request.getParameter("ghiChuHoan");

        // Validate
        if (idStr == null || idStr.isBlank()) {
            session.setAttribute("errorMsg", "Thiếu thông tin thiệp mời.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (ghiChuHoan == null || ghiChuHoan.isBlank()) {
            session.setAttribute("errorMsg", "Vui lòng nhập lý do tạm hoãn.");
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

        // Kiểm tra server-side trước khi gọi DAO
        ThiepMoi tm = thiepMoiDAO.getByID(thiepMoiID);
        if (tm == null) {
            session.setAttribute("errorMsg", "Không tìm thấy thiệp mời.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (tm.isDaIn()) {
            session.setAttribute("errorMsg", "Thiệp mời đã in — không thể tạm hoãn.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        // Dùng hằng số thay vì gọi DB
        if (tm.getTrangThaiID() != ThiepMoiDAO.TRANG_THAI_SAP_DIEN_RA) {
            session.setAttribute("errorMsg", "Chỉ có thể tạm hoãn thiệp ở trạng thái \"Sắp diễn ra\".");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (tm.getThoiGianBatDau() != null) {
            long gioConLai = (tm.getThoiGianBatDau().getTime() - System.currentTimeMillis()) / 3600000;
            if (gioConLai < GIO_KHOA_HOAN) {
                session.setAttribute("errorMsg",
                    "Không thể tạm hoãn — cuộc họp còn dưới " + GIO_KHOA_HOAN + " tiếng nữa.");
                response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                return;
            }
        }

        boolean ok = thiepMoiDAO.tamHoanThiepMoi(thiepMoiID, nguoiDung.getNguoiDungID(), ghiChuHoan.trim());

        if (ok) {
            session.setAttribute("successMsg",
                "Đã tạm hoãn thiệp mời. Thông báo [TẠM HOÃN] đã được gửi đến toàn bộ hộ dân.");
        } else {
            session.setAttribute("errorMsg", "Tạm hoãn thất bại. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return "ToTruong".equals(nd.getTenVaiTro());
    }
}