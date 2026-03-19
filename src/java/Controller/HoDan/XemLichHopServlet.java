package Controller.HoDan;

import Model.Entity.NguoiDung;
import Model.Service.LichHopService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet dùng chung cho cả danh sách lẫn chi tiết lịch họp của người dân.
 *
 * URL patterns:
 *   GET /nguoidan/lich-hop              → Danh sách (panel phải hiện placeholder)
 *   GET /nguoidan/lich-hop?id=X         → Danh sách + mở chi tiết lịch họp ID=X
 *   GET /nguoidan/lich-hop?id=X&trangThai=1&tuNgay=...  → có lọc + chi tiết
 */
@WebServlet("/nguoidan/lich-hop")
public class XemLichHopServlet extends HttpServlet {

    private final LichHopService lichHopService = new LichHopService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── 1. Kiểm tra session ──────────────────────────────────────────
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");

        // ── 2. Lấy tham số filter ────────────────────────────────────────
        String trangThai = req.getParameter("trangThai");
        String tuNgay    = req.getParameter("tuNgay");
        String denNgay   = req.getParameter("denNgay");
        String idStr     = req.getParameter("id");          // ID chi tiết

        // ── 3. Lấy danh sách lịch họp ───────────────────────────────────
        try {
            List<Map<String, Object>> danhSach = lichHopService.getLichHopNguoiDan(
                    nguoiDung.getToDanPhoID(), trangThai, tuNgay, denNgay);
            req.setAttribute("danhSachLichHop", danhSach);
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.setAttribute("danhSachLichHop", List.of());
        }

        // ── 4. Nếu có id → lấy thêm chi tiết ───────────────────────────
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int lichHopID = Integer.parseInt(idStr.trim());
                Map<String, Object> chiTiet = lichHopService
                        .getChiTietLichHopNguoiDan(lichHopID, nguoiDung.getToDanPhoID());
                req.setAttribute("chiTietLichHop", chiTiet);

                // Lịch sử sửa — người dân cũng được xem
                List<Map<String, Object>> lichSuSua = lichHopService.getLichSuSua(lichHopID);
                req.setAttribute("lichSuSua", lichSuSua);

            } catch (NumberFormatException e) {
                req.setAttribute("errorMsg", "ID lịch họp không hợp lệ.");
            } catch (IllegalArgumentException e) {
                req.setAttribute("errorMsg", e.getMessage());
            }
        }

        // ── 5. Trả lại giá trị filter để JSP giữ nguyên form ────────────
        req.setAttribute("filterTrangThai", trangThai != null ? trangThai : "");
        req.setAttribute("filterTuNgay",    tuNgay    != null ? tuNgay    : "");
        req.setAttribute("filterDenNgay",   denNgay   != null ? denNgay   : "");

        // ── 6. Forward đến trang kết hợp ─────────────────────────────────
        req.getRequestDispatcher("/Views/HoDan/XemLichHop.jsp")
           .forward(req, resp);
    }
}