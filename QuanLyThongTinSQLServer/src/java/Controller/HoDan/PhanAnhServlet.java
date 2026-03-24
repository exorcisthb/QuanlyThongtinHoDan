package Controller.HoDan;

import Model.Entity.NguoiDung;
import Model.Service.PhanAnhService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/hodan/phan-anh")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024L,
    maxRequestSize    = 20 * 1024 * 1024L
)
public class PhanAnhServlet extends HttpServlet {

    private final PhanAnhService phanAnhService = new PhanAnhService();
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isHoDan(session)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        NguoiDung nd = getNguoiDung(session);
        String action = req.getParameter("action");

        // ── Chi tiết 1 phản ánh (AJAX) ──
        if ("chiTiet".equals(action)) {
            int id = parseInt(req.getParameter("id"), 0);
            if (id == 0) {
                sendJson(resp, 400, Map.of("success", false, "message", "Thiếu ID phản ánh."));
                return;
            }
            Map<String, Object> data = phanAnhService.getChiTiet(id);
            if (data == null || (int) data.get("nguoiGuiID") != nd.getNguoiDungID()) {
                sendJson(resp, 404, Map.of("success", false, "message", "Không tìm thấy phản ánh."));
                return;
            }
            // ── Chuẩn hóa Timestamp → String để Gson serialize đúng ──
            normalizeTimestamps(data);
            sendJson(resp, 200, data);
            return;
        }

        // ── Danh sách phản ánh của hộ dân ──
        List<Map<String, Object>> danhSach =
                phanAnhService.getDanhSachCuaHoDan(nd.getNguoiDungID());
        req.setAttribute("danhSachPhanAnh", danhSach);
        req.getRequestDispatcher("/Views/HoDan/PhanAnh.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (!isHoDan(session)) {
            sendJson(resp, 401, Map.of("success", false, "message", "Chưa đăng nhập."));
            return;
        }

        NguoiDung nd = getNguoiDung(session);
        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "sua" -> {
                int phanAnhID   = parseInt(req.getParameter("phanAnhID"), 0);
                String noiDung  = req.getParameter("noiDung");
                int mucDoUuTien = parseInt(req.getParameter("mucDoUuTien"), 2);

                if (phanAnhID == 0) {
                    sendJson(resp, 400, Map.of("success", false, "message", "Thiếu ID phản ánh."));
                    return;
                }

                List<Integer> fileIDXoa = new ArrayList<>();
                String[] xoaArr = req.getParameterValues("fileIDXoa");
                if (xoaArr != null) {
                    for (String s : xoaArr) {
                        try { fileIDXoa.add(Integer.parseInt(s)); } catch (Exception ignored) {}
                    }
                }

                List<Part> partsAnhMoi = new ArrayList<>();
                try {
                    for (Part part : req.getParts()) {
                        if (!"anh".equals(part.getName())) continue;
                        if (part.getSize() > 0) partsAnhMoi.add(part);
                    }
                } catch (Exception e) {
                    sendJson(resp, 400, Map.of("success", false, "message", "Lỗi đọc file đính kèm."));
                    return;
                }

                Map<String, Object> hien = phanAnhService.getDanhSachCuaHoDan(nd.getNguoiDungID())
                        .stream().filter(p -> (int) p.get("phanAnhID") == phanAnhID)
                        .findFirst().orElse(null);
                int loaiID    = hien != null ? (int)    hien.get("loaiID")  : 0;
                String tieuDe = hien != null ? String.valueOf(hien.get("tieuDe")) : "";

                String appPath = req.getServletContext().getRealPath("/");
                Map<String, Object> result;
                try {
                    result = phanAnhService.suaPhanAnh(
                            phanAnhID, nd.getNguoiDungID(),
                            loaiID, mucDoUuTien,
                            tieuDe, noiDung,
                            fileIDXoa, partsAnhMoi, appPath);
                } catch (Exception e) {
                    e.printStackTrace();
                    result = Map.of("success", false, "message", "Lỗi server: " + e.getMessage());
                }
                sendJson(resp, 200, result);
            }

            case "huy" -> {
                int phanAnhID = parseInt(req.getParameter("phanAnhID"), 0);
                String lyDo   = req.getParameter("lyDo");
                if (phanAnhID == 0) {
                    sendJson(resp, 400, Map.of("success", false, "message", "Thiếu ID phản ánh."));
                    return;
                }
                Map<String, Object> result =
                        phanAnhService.huyPhanAnh(phanAnhID, nd.getNguoiDungID(), lyDo);
                sendJson(resp, 200, result);
            }

            default -> sendJson(resp, 400, Map.of("success", false, "message", "Action không hợp lệ."));
        }
    }

    // ── Chuẩn hóa Timestamp/Date thành String ──────────────────────────
    @SuppressWarnings("unchecked")
    private void normalizeTimestamps(Map<String, Object> map) {
        map.replaceAll((k, v) -> {
            if (v instanceof java.sql.Timestamp || v instanceof java.util.Date) {
                return v.toString();
            }
            return v;
        });
        // Chuẩn hóa danhSachAnh
        Object anh = map.get("danhSachAnh");
        if (anh instanceof List) {
            for (Object item : (List<?>) anh) {
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

    // ── Helpers ────────────────────────────────────────────────────────
    private boolean isHoDan(HttpSession session) {
        NguoiDung nd = getNguoiDung(session);
        return nd != null && nd.getVaiTroID() == 4;
    }

    private NguoiDung getNguoiDung(HttpSession session) {
        if (session == null) return null;
        Object obj = session.getAttribute("nguoiDung");
        return obj instanceof NguoiDung ? (NguoiDung) obj : null;
    }

    private int parseInt(String value, int defaultVal) {
        try { return Integer.parseInt(value); }
        catch (Exception e) { return defaultVal; }
    }

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }
}