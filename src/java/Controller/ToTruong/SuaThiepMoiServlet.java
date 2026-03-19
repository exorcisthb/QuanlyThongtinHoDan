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

@WebServlet("/thiepmoi/sua")
public class SuaThiepMoiServlet extends HttpServlet {

    private final ThiepMoiDAO thiepMoiDAO = new ThiepMoiDAO();
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final int PHUT_KHOA_TRUOC = 30;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isToTruong(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            ThiepMoi thiepMoi = thiepMoiDAO.getByID(id);

            if (thiepMoi == null) {
                session.setAttribute("errorMsg", "Không tìm thấy thiệp mời.");
                response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                return;
            }

            if (thiepMoi.isDaIn()) {
                session.setAttribute("errorMsg", "Thiệp mời đã in — không thể chỉnh sửa.");
                response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                return;
            }

            // << SỬA: dùng hằng số thay vì hard-code 1
            if (thiepMoi.getTrangThaiID() != ThiepMoiDAO.TRANG_THAI_SAP_DIEN_RA) {
                session.setAttribute("errorMsg", "Chỉ có thể sửa thiệp mời ở trạng thái \"Sắp diễn ra\".");
                response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                return;
            }

            if (thiepMoi.getThoiGianBatDau() != null) {
                long millisConLai = thiepMoi.getThoiGianBatDau().getTime() - System.currentTimeMillis();
                long phutConLai = millisConLai / 60000;
                if (phutConLai < PHUT_KHOA_TRUOC) {
                    session.setAttribute("errorMsg",
                        "Không thể chỉnh sửa — cuộc họp diễn ra trong vòng " + PHUT_KHOA_TRUOC + " phút nữa.");
                    response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                    return;
                }
                request.setAttribute("phutConLai", phutConLai);
            }

            request.setAttribute("thiepMoi", thiepMoi);
            request.getRequestDispatcher("/Views/ToTruong/SuaThiepMoi.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
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

        String idStr      = request.getParameter("thiepMoiID");
        String noiDung    = request.getParameter("noiDung");
        String diaDiem    = request.getParameter("diaDiem");
        String strBatDau  = request.getParameter("thoiGianBatDau");
        String strKetThuc = request.getParameter("thoiGianKetThuc");

        int thiepMoiID;
        try {
            thiepMoiID = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }

        // << SỬA: dùng hằng số thay vì hard-code 1
        ThiepMoi existing = thiepMoiDAO.getByID(thiepMoiID);
        if (existing == null || existing.isDaIn()
                || existing.getTrangThaiID() != ThiepMoiDAO.TRANG_THAI_SAP_DIEN_RA) {
            session.setAttribute("errorMsg", "Thiệp mời không hợp lệ hoặc đã bị khóa.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
            return;
        }
        if (existing.getThoiGianBatDau() != null) {
            long phutConLai = (existing.getThoiGianBatDau().getTime() - System.currentTimeMillis()) / 60000;
            if (phutConLai < PHUT_KHOA_TRUOC) {
                session.setAttribute("errorMsg",
                    "Không thể lưu — cuộc họp diễn ra trong vòng " + PHUT_KHOA_TRUOC + " phút nữa.");
                response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
                return;
            }
        }

        Timestamp tgBatDau  = null;
        Timestamp tgKetThuc = null;
        try {
            if (strBatDau != null && !strBatDau.isBlank())
                tgBatDau = Timestamp.valueOf(LocalDateTime.parse(strBatDau, FORMATTER));
            if (strKetThuc != null && !strKetThuc.isBlank())
                tgKetThuc = Timestamp.valueOf(LocalDateTime.parse(strKetThuc, FORMATTER));
        } catch (DateTimeParseException e) {
            forwardBackWithError(request, response, existing, "Định dạng thời gian không hợp lệ.");
            return;
        }

        if (tgBatDau != null) {
            long phutConLaiMoi = (tgBatDau.getTime() - System.currentTimeMillis()) / 60000;
            if (phutConLaiMoi < PHUT_KHOA_TRUOC) {
                forwardBackWithError(request, response, existing,
                    "Thời gian bắt đầu mới phải cách hiện tại ít nhất " + PHUT_KHOA_TRUOC + " phút.");
                return;
            }
            if (tgKetThuc != null && tgKetThuc.before(tgBatDau)) {
                forwardBackWithError(request, response, existing,
                    "Thời gian kết thúc phải sau thời gian bắt đầu.");
                return;
            }
        }

        ThiepMoi t = new ThiepMoi();
        t.setThiepMoiID(thiepMoiID);
        t.setTieuDe(existing.getTieuDe()); // LOCK tiêu đề
        t.setNoiDung(noiDung);
        t.setDiaDiem(diaDiem);
        t.setThoiGianBatDau(tgBatDau != null ? tgBatDau : existing.getThoiGianBatDau());
        t.setThoiGianKetThuc(tgKetThuc);

        boolean ok = thiepMoiDAO.suaThiepMoi(t, nguoiDung.getNguoiDungID());

        if (ok) {
            session.setAttribute("successMsg",
                    "Cập nhật thiệp mời thành công! Thông báo đã được gửi đến các hộ dân.");
            response.sendRedirect(request.getContextPath() + "/thiepmoi/danh-sach");
        } else {
            forwardBackWithError(request, response, existing, "Cập nhật thất bại. Vui lòng thử lại.");
        }
    }

    private void forwardBackWithError(HttpServletRequest req, HttpServletResponse resp,
                                      ThiepMoi thiepMoi, String error)
            throws ServletException, IOException {
        req.setAttribute("thiepMoi", thiepMoi);
        req.setAttribute("errorMsg", error);
        req.getRequestDispatcher("/Views/ToTruong/SuaThiepMoi.jsp").forward(req, resp);
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return "ToTruong".equals(nd.getTenVaiTro());
    }
}