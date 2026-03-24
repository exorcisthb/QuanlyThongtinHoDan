package Controller.CanBoPhuong;

import Model.Entity.HoDan;
import Model.Entity.NguoiDung;
import Model.Service.HoDanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/canbophuong/hodan")
public class ListAllHoDanServlet extends HttpServlet {

    private final HoDanService hoDanService = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        NguoiDung currentUser = session != null
                ? (NguoiDung) session.getAttribute("nguoiDung") : null;
        if (currentUser == null || !"CanBoPhuong".equals(currentUser.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Đọc params ────────────────────────────────────────────────────
        String keyword    = request.getParameter("keyword");

        Integer tuoiMin   = parseIntOrNull(request.getParameter("tuoiMin"));
        Integer tuoiMax   = parseIntOrNull(request.getParameter("tuoiMax"));
        Boolean daKichHoat = parseBoolFilter(request.getParameter("kichHoat"));
        Integer trangThaiID = parseIntOrNull(request.getParameter("trangThai"));

        // ── Xác định có filter không (ngoài keyword) ─────────────────────
        boolean coFilter = tuoiMin != null || tuoiMax != null
                        || daKichHoat != null || trangThaiID != null;

        // ── Xác định có bất kỳ tham số nào không (để hiện nút Xoá) ───────
        boolean coThamSo = (keyword != null && !keyword.isBlank()) || coFilter;

        if (coFilter) {
            // ── CHẾ ĐỘ CÁ NHÂN: nhóm Tổ → Đường → từng người ─────────────
            Map<String, Map<String, List<Map<String, Object>>>> nhomCaNhan =
                    hoDanService.getDanhSachCaNhanCBP(
                            keyword, tuoiMin, tuoiMax, daKichHoat, trangThaiID);

            int tongSoCaNhan = hoDanService.tongSoCaNhanCBP(nhomCaNhan);

            request.setAttribute("nhomCaNhan",    nhomCaNhan);
            request.setAttribute("tongSoCaNhan",  tongSoCaNhan);
            request.setAttribute("coFilter",      true);
            request.setAttribute("tongSoHo",      0);
            request.setAttribute("nhomTheoTo",    null);

        } else {
            // ── CHẾ ĐỘ HỘ: nhóm Tổ → Đường → từng hộ ────────────────────
            Map<String, Map<String, List<HoDan>>> nhomTheoTo =
                    hoDanService.getDanhSachNhomTheoTo(keyword);

            int tongSoHo = nhomTheoTo.values().stream()
                    .flatMap(m -> m.values().stream())
                    .mapToInt(List::size)
                    .sum();

            request.setAttribute("nhomTheoTo",  nhomTheoTo);
            request.setAttribute("tongSoHo",    tongSoHo);
            request.setAttribute("coFilter",    false);
            request.setAttribute("nhomCaNhan",  null);
        }

        // ── Truyền lại params để giữ state filter trên form ───────────────
        request.setAttribute("keyword",    keyword);
        request.setAttribute("coThamSo",   coThamSo);
        request.setAttribute("currentUser", currentUser);

        request.getRequestDispatcher("/Views/CanBoPhuong/DanhSachTatCaHoDan.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        String redirect = request.getContextPath() + "/canbophuong/hodan"
                + (keyword != null && !keyword.isBlank() ? "?keyword=" + keyword : "");
        response.sendRedirect(redirect);
    }

    // ── Helpers ───────────────────────────────────────────────────────────
    private Integer parseIntOrNull(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Integer.parseInt(val.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    /** "co" → true, "chua" → false, else → null */
    private Boolean parseBoolFilter(String val) {
        if ("co".equals(val))   return Boolean.TRUE;
        if ("chua".equals(val)) return Boolean.FALSE;
        return null;
    }
}