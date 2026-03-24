package Controller.ToTruong;

import Model.Entity.NguoiDung;
import Model.Service.LichHopService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * GET /chi-tiet-lich-hop?id=X&ajax=true
 *   → Trả JSON cho modal trong DanhSachLichHop.jsp (tổ trưởng)
 *
 * JSON trả về:
 * {
 *   "lichHop": { ...thông tin chi tiết... },
 *   "lichSu":  [ ...lịch sử sửa... ],
 *   "docTB":   [ ...trạng thái đọc thông báo... ]
 * }
 */
@WebServlet("/chi-tiet-lich-hop")
public class ChiTietLichHopServlet extends HttpServlet {

    private final LichHopService lichHopService = new LichHopService();
    private final ObjectMapper   objectMapper   = new ObjectMapper();
    private final SimpleDateFormat sdf          = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isToTruong(session)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idStr  = request.getParameter("id");
        boolean isAjax = "true".equals(request.getParameter("ajax"));

        if (idStr == null || idStr.trim().isEmpty()) {
            if (isAjax) sendError(response, "Thiếu ID lịch họp.");
            else response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
            return;
        }

        try {
            int lichHopID = Integer.parseInt(idStr.trim());

            Map<String, Object>       chiTiet      = lichHopService.getLichHopByID(lichHopID);
            List<Map<String, Object>> lichSuSua    = lichHopService.getLichSuSua(lichHopID);
            List<Map<String, Object>> trangThaiDoc = lichHopService.getTrangThaiDocThongBao(lichHopID);

            if (!isAjax) {
                // Tổ trưởng không có trang riêng — dùng modal AJAX trong danh sách
                response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
                return;
            }

            // Format Timestamp → String trước khi serialize JSON
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("lichHop", fmtMap(chiTiet));
            result.put("lichSu",  fmtList(lichSuSua));
            result.put("docTB",   fmtList(trangThaiDoc));

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(result));

        } catch (NumberFormatException e) {
            if (isAjax) sendError(response, "ID không hợp lệ.");
            else response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
        } catch (IllegalArgumentException e) {
            if (isAjax) sendError(response, e.getMessage());
            else response.sendRedirect(request.getContextPath() + "/danh-sach-lich-hop");
        }
    }

    // ── Helpers ─────────────────────────────────────────────────────────

    /** Chuyển Timestamp → "dd/MM/yyyy HH:mm" trong 1 map */
    private Map<String, Object> fmtMap(Map<String, Object> map) {
        Map<String, Object> out = new LinkedHashMap<>();
        for (Map.Entry<String, Object> e : map.entrySet()) {
            out.put(e.getKey(),
                e.getValue() instanceof Timestamp
                    ? sdf.format((Timestamp) e.getValue())
                    : e.getValue());
        }
        return out;
    }

    /** Chuyển Timestamp trong từng map của list */
    private List<Map<String, Object>> fmtList(List<Map<String, Object>> list) {
        List<Map<String, Object>> out = new ArrayList<>();
        for (Map<String, Object> m : list) out.add(fmtMap(m));
        return out;
    }

    private void sendError(HttpServletResponse resp, String msg) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        resp.getWriter().write("{\"error\":\"" + msg.replace("\"", "'") + "\"}");
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        return "ToTruong".equals(((NguoiDung) session.getAttribute("nguoiDung")).getTenVaiTro());
    }
}