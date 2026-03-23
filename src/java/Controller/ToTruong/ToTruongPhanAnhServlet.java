package Controller.ToTruong;

import Model.Entity.NguoiDung;
import Model.Service.PhanAnhService;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/totruong/phan-anh")
public class ToTruongPhanAnhServlet extends HttpServlet {

    private final PhanAnhService service = new PhanAnhService();
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private NguoiDung getToTruong(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/"); return null; }
        NguoiDung u = (NguoiDung) session.getAttribute("nguoiDung");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/"); return null; }
        return u;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        NguoiDung toTruong = getToTruong(req, resp);
        if (toTruong == null) return;

        String action = req.getParameter("action");

        // ── action=chiTiet: trả JSON đầy đủ (ảnh + lịch sử) ──
        if ("chiTiet".equals(action) || "lichSu".equals(action)) {
            String idParam = req.getParameter("phanAnhID");
            if (idParam == null || !idParam.matches("\\d+")) {
                sendJson(resp, 400, List.of());
                return;
            }
            int phanAnhID = Integer.parseInt(idParam);
            Map<String, Object> data = service.getChiTiet(phanAnhID);
            if (data == null) {
                sendJson(resp, 404, List.of());
                return;
            }
            normalizeTimestamps(data);

            // action=lichSu → chỉ trả mảng lịch sử
            if ("lichSu".equals(action)) {
                Object ls = data.get("lichSuXuLy");
                sendJson(resp, 200, ls != null ? ls : List.of());
            } else {
                // action=chiTiet → trả toàn bộ
                sendJson(resp, 200, data);
            }
            return;
        }

        // ── Trang danh sách ──
        int toDanPhoID    = toTruong.getToDanPhoID();
        String keyword    = req.getParameter("keyword");
        String ttParam    = req.getParameter("trangThai");
        String mucDoParam = req.getParameter("mucDo");

        List<Map<String, Object>> goc      = service.getDanhSachTheoTo(toDanPhoID);
        List<Map<String, Object>> danhSach = service.getDanhSachTheoTo(toDanPhoID);

        long soChoXuLy   = goc.stream().filter(p -> (int)p.get("trangThaiID") == 1).count();
        long soDangXuLy  = goc.stream().filter(p -> (int)p.get("trangThaiID") == 2).count();
        long soChuyenCap = goc.stream().filter(p -> (int)p.get("trangThaiID") == 3).count();
        long soGiaiQuyet = goc.stream().filter(p -> (int)p.get("trangThaiID") == 4).count();
        long soTuChoi    = goc.stream().filter(p -> (int)p.get("trangThaiID") == 5).count();
        long soSpam      = goc.stream().filter(p -> Boolean.TRUE.equals(p.get("isSpam"))).count();

        if (ttParam != null && !ttParam.isBlank()) {
            int ttFilter = Integer.parseInt(ttParam);
            danhSach.removeIf(p -> (int) p.get("trangThaiID") != ttFilter);
        }
        if (mucDoParam != null && !mucDoParam.isBlank()) {
            int mdFilter = Integer.parseInt(mucDoParam);
            danhSach.removeIf(p -> (int) p.get("mucDoUuTien") != mdFilter);
        }
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            danhSach.removeIf(p -> {
                String td = p.get("tieuDe")      != null ? p.get("tieuDe").toString().toLowerCase()      : "";
                String ng = p.get("tenNguoiGui") != null ? p.get("tenNguoiGui").toString().toLowerCase() : "";
                return !td.contains(kw) && !ng.contains(kw);
            });
        }

        req.setAttribute("nguoiDung",       toTruong);
        req.setAttribute("danhSachPhanAnh", danhSach);
        req.setAttribute("total",           danhSach.size());
        req.setAttribute("keyword",         keyword);
        req.setAttribute("trangThaiFilter", ttParam);
        req.setAttribute("mucDoFilter",     mucDoParam);
        req.setAttribute("soChoXuLy",       soChoXuLy);
        req.setAttribute("soDangXuLy",      soDangXuLy);
        req.setAttribute("soChuyenCap",     soChuyenCap);
        req.setAttribute("soGiaiQuyet",     soGiaiQuyet);
        req.setAttribute("soTuChoi",        soTuChoi);
        req.setAttribute("soSpam",          soSpam);

        req.getRequestDispatcher("/Views/ToTruong/DanhSachPhanAnh.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        NguoiDung toTruong = getToTruong(req, resp);
        if (toTruong == null) return;

        String action  = req.getParameter("action");
        String idParam = req.getParameter("phanAnhID");
        int    nguoiID = toTruong.getNguoiDungID();

        if (idParam == null || !idParam.matches("\\d+")) {
            setFlash(req, "Yêu cầu không hợp lệ.", true);
            redirect(req, resp); return;
        }
        int phanAnhID = Integer.parseInt(idParam);

        Map<String, Object> result = switch (action == null ? "" : action) {
            case "tiepNhan"    -> service.tiepNhan(phanAnhID, nguoiID, null);
            case "giaiQuyet"   -> service.giaiQuyetToTruong(phanAnhID, nguoiID, req.getParameter("ketQua"));
            case "tuChoi"      -> service.tuChoi(phanAnhID, nguoiID, req.getParameter("lyDo"));
            case "danhDauSpam" -> service.danhDauSpam(phanAnhID, nguoiID, req.getParameter("ghiChu"));
            case "chuyenCap"   -> service.chuyenCapCanBo(phanAnhID, nguoiID, req.getParameter("ghiChu"));
            case "phanHoi"     -> service.guiPhanHoi(phanAnhID, nguoiID, req.getParameter("noiDungPhanHoi"));
            default -> Map.of("success", false, "message", "Hành động không được hỗ trợ.");
        };

        boolean ok = Boolean.TRUE.equals(result.get("success"));
        setFlash(req, (String) result.get("message"), !ok);
        redirect(req, resp);
    }

    // ── Helpers ────────────────────────────────────────────────────────
    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }

    @SuppressWarnings("unchecked")
    private void normalizeTimestamps(Map<String, Object> map) {
        map.replaceAll((k, v) -> (v instanceof java.sql.Timestamp || v instanceof java.util.Date)
                ? v.toString() : v);
        for (String key : new String[]{"danhSachAnh", "lichSuXuLy"}) {
            Object list = map.get(key);
            if (list instanceof List) {
                for (Object item : (List<?>) list) {
                    if (item instanceof Map) {
                        ((Map<String, Object>) item).replaceAll((k, v) ->
                                (v instanceof java.sql.Timestamp || v instanceof java.util.Date)
                                        ? v.toString() : v);
                    }
                }
            }
        }
    }

    private void setFlash(HttpServletRequest req, String msg, boolean isError) {
        req.getSession().setAttribute(isError ? "error" : "message", msg);
    }

    private void redirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        StringBuilder url = new StringBuilder(req.getContextPath() + "/totruong/phan-anh?");
        appendParam(url, "keyword",   req.getParameter("keyword"));
        appendParam(url, "trangThai", req.getParameter("trangThai"));
        appendParam(url, "mucDo",     req.getParameter("mucDo"));
        resp.sendRedirect(url.toString());
    }

    private void appendParam(StringBuilder sb, String key, String val) {
        if (val != null && !val.isBlank())
            sb.append(key).append("=").append(val).append("&");
    }
}