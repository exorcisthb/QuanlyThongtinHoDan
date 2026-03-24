package Controller.CanBoPhuong;

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

@WebServlet("/canbophuong/phan-anh")
public class CanBoPhuongPhanAnhServlet extends HttpServlet {

    private final PhanAnhService service = new PhanAnhService();
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private NguoiDung getCanBo(HttpServletRequest req, HttpServletResponse resp)
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
        NguoiDung canBo = getCanBo(req, resp);
        if (canBo == null) return;

        String action = req.getParameter("action");

        // ── action=lichSu: trả JSON lịch sử xử lý (dùng cho AJAX modal chi tiết) ──
        if ("lichSu".equals(action)) {
            String idParam = req.getParameter("phanAnhID");
            if (idParam == null || !idParam.matches("\\d+")) {
                sendJson(resp, 400, List.of());
                return;
            }
            int phanAnhID = Integer.parseInt(idParam);
            Map<String, Object> chiTiet = service.getChiTiet(phanAnhID);
            if (chiTiet == null) {
                sendJson(resp, 404, List.of());
                return;
            }
            // Lấy lichSuXuLy và chuyển Timestamp thành String cho dễ render
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> lichSu =
                    (List<Map<String, Object>>) chiTiet.get("lichSuXuLy");
            if (lichSu == null) lichSu = List.of();
            // Chuẩn hóa thoiGian thành String
            for (Map<String, Object> ls : lichSu) {
                if (ls.get("thoiGian") != null) {
                    ls.put("thoiGian", ls.get("thoiGian").toString());
                }
            }
            sendJson(resp, 200, lichSu);
            return;
        }

        // ── action=chiTiet: trả JSON chi tiết phản ánh ──
        if ("chiTiet".equals(action)) {
            String idParam = req.getParameter("phanAnhID");
            if (idParam == null || !idParam.matches("\\d+")) {
                sendJson(resp, 400, Map.of("success", false, "message", "Thiếu ID."));
                return;
            }
            int phanAnhID = Integer.parseInt(idParam);
            Map<String, Object> data = service.getChiTiet(phanAnhID);
            if (data == null) {
                sendJson(resp, 404, Map.of("success", false, "message", "Không tìm thấy."));
                return;
            }
            // Chuẩn hóa timestamp thành String
            normalizeTimestamps(data);
            sendJson(resp, 200, data);
            return;
        }

        // ── Tra về JSON đếm badge từ dashboard ──
        String format = req.getParameter("format");
        if ("count".equals(format)) {
            List<Map<String, Object>> all = service.getDanhSachDaChuyenCap();
            long soChuaXuLy = all.stream()
                    .filter(p -> (int) p.get("trangThaiID") == 3).count();
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"soChuaXuLy\":" + soChuaXuLy + "}");
            return;
        }

        // ── Trang danh sách ──
        String keyword = req.getParameter("keyword");
        String ttParam = req.getParameter("trangThai");
        String mucDoP  = req.getParameter("mucDo");
        String toParam = req.getParameter("toDanPho");

        List<Map<String, Object>> goc      = service.getDanhSachDaChuyenCap();
        List<Map<String, Object>> danhSach = service.getDanhSachDaChuyenCap();

        long soChuaXuLy  = goc.stream().filter(p -> (int) p.get("trangThaiID") == 3).count();
        long soGiaiQuyet = goc.stream().filter(p -> (int) p.get("trangThaiID") == 4).count();

        if (ttParam != null && !ttParam.isBlank()) {
            int ttFilter = Integer.parseInt(ttParam);
            danhSach.removeIf(p -> (int) p.get("trangThaiID") != ttFilter);
        }
        if (mucDoP != null && !mucDoP.isBlank()) {
            int mdFilter = Integer.parseInt(mucDoP);
            danhSach.removeIf(p -> (int) p.get("mucDoUuTien") != mdFilter);
        }
        if (toParam != null && !toParam.isBlank()) {
            danhSach.removeIf(p -> !toParam.equals(
                    p.get("tenToDanPho") != null ? p.get("tenToDanPho").toString() : ""));
        }
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            danhSach.removeIf(p -> {
                String td  = p.get("tieuDe")      != null ? p.get("tieuDe").toString().toLowerCase()      : "";
                String ng  = p.get("tenNguoiGui") != null ? p.get("tenNguoiGui").toString().toLowerCase() : "";
                String ten = p.get("tenToDanPho") != null ? p.get("tenToDanPho").toString().toLowerCase() : "";
                return !td.contains(kw) && !ng.contains(kw) && !ten.contains(kw);
            });
        }

        List<String> danhSachTo = goc.stream()
                .map(p -> p.get("tenToDanPho") != null ? p.get("tenToDanPho").toString() : "")
                .filter(s -> !s.isBlank()).distinct().sorted().toList();

        req.setAttribute("nguoiDung",       canBo);
        req.setAttribute("danhSachPhanAnh", danhSach);
        req.setAttribute("total",           danhSach.size());
        req.setAttribute("tongTat",         goc.size());
        req.setAttribute("soChuaXuLy",      soChuaXuLy);
        req.setAttribute("soGiaiQuyet",     soGiaiQuyet);
        req.setAttribute("keyword",         keyword);
        req.setAttribute("trangThaiFilter", ttParam);
        req.setAttribute("mucDoFilter",     mucDoP);
        req.setAttribute("toDanPhoFilter",  toParam);
        req.setAttribute("danhSachTo",      danhSachTo);

        req.getRequestDispatcher("/Views/CanBoPhuong/DanhSachTatCaPhanAnh.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        NguoiDung canBo = getCanBo(req, resp);
        if (canBo == null) return;

        String action  = req.getParameter("action");
        String idParam = req.getParameter("phanAnhID");
        int    nguoiID = canBo.getNguoiDungID();

        if (idParam == null || !idParam.matches("\\d+")) {
            setFlash(req, "Yêu cầu không hợp lệ.", true);
            redirect(req, resp); return;
        }
        int phanAnhID = Integer.parseInt(idParam);

        Map<String, Object> result = switch (action == null ? "" : action) {
            case "giaiQuyet" -> {
                String ketQua = req.getParameter("ketQua");
                yield service.giaiquyetPhanAnh(phanAnhID, nguoiID, ketQua);
            }
            case "phanHoi" -> {
                String noiDung = req.getParameter("noiDungPhanHoi");
                yield service.guiPhanHoi(phanAnhID, nguoiID, noiDung);
            }
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

    /** Chuyển tất cả Timestamp/Date trong Map thành String để Gson serialize đúng */
    @SuppressWarnings("unchecked")
    private void normalizeTimestamps(Map<String, Object> map) {
        map.replaceAll((k, v) -> {
            if (v instanceof java.sql.Timestamp || v instanceof java.util.Date) {
                return v.toString();
            }
            return v;
        });
        // Chuẩn hóa lichSuXuLy
        Object ls = map.get("lichSuXuLy");
        if (ls instanceof List) {
            for (Object item : (List<?>) ls) {
                if (item instanceof Map) {
                    ((Map<String, Object>) item).replaceAll((k, v) -> {
                        if (v instanceof java.sql.Timestamp || v instanceof java.util.Date) {
                            return v.toString();
                        }
                        return v;
                    });
                }
            }
        }
    }

    private void setFlash(HttpServletRequest req, String msg, boolean isError) {
        req.getSession().setAttribute(isError ? "error" : "message", msg);
    }

    private void redirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        StringBuilder url = new StringBuilder(req.getContextPath() + "/canbophuong/phan-anh?");
        appendParam(url, "keyword",   req.getParameter("keyword"));
        appendParam(url, "trangThai", req.getParameter("trangThai"));
        appendParam(url, "mucDo",     req.getParameter("mucDo"));
        appendParam(url, "toDanPho",  req.getParameter("toDanPho"));
        resp.sendRedirect(url.toString());
    }

    private void appendParam(StringBuilder sb, String key, String val) {
        if (val != null && !val.isBlank())
            sb.append(key).append("=").append(val).append("&");
    }
}