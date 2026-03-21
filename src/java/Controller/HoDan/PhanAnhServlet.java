package Controller.HoDan;

import Model.Entity.NguoiDung;
import Model.Service.PhanAnhService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Servlet xử lý trang danh sách phản ánh của hộ dân.
 * GET  /hodan/phan-anh                    → hiển thị danh sách
 * GET  /hodan/phan-anh?action=chiTiet&id= → trả JSON chi tiết
 * POST /hodan/phan-anh?action=sua         → sửa phản ánh (multipart)
 * POST /hodan/phan-anh?action=huy         → hủy phản ánh
 */
@WebServlet("/hodan/phan-anh")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024L,
    maxRequestSize    = 20 * 1024 * 1024L
)
public class PhanAnhServlet extends HttpServlet {

    private final PhanAnhService phanAnhService = new PhanAnhService();
    private final Gson gson = new Gson();

    // ------------------------------------------------------------------ //
    //  GET
    // ------------------------------------------------------------------ //
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
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                        Map.of("success", false, "message", "Thiếu ID phản ánh."));
                return;
            }
            Map<String, Object> data = phanAnhService.getChiTiet(id);
            // Kiểm tra quyền — chỉ cho xem của chính mình
            if (data == null || (int) data.get("nguoiGuiID") != nd.getNguoiDungID()) {
                sendJson(resp, HttpServletResponse.SC_NOT_FOUND,
                        Map.of("success", false, "message", "Không tìm thấy phản ánh."));
                return;
            }
            sendJson(resp, HttpServletResponse.SC_OK, data);
            return;
        }

        // ── Danh sách phản ánh của hộ dân ──
        List<Map<String, Object>> danhSach =
                phanAnhService.getDanhSachCuaHoDan(nd.getNguoiDungID());
        req.setAttribute("danhSachPhanAnh", danhSach);
        req.getRequestDispatcher("/Views/HoDan/PhanAnh.jsp")
           .forward(req, resp);
    }

    // ------------------------------------------------------------------ //
    //  POST
    // ------------------------------------------------------------------ //
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (!isHoDan(session)) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                    Map.of("success", false, "message", "Chưa đăng nhập."));
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
                    sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                            Map.of("success", false, "message", "Thiếu ID phản ánh."));
                    return;
                }

                // Lấy fileID cần xóa
                List<Integer> fileIDXoa = new ArrayList<>();
                String[] xoaArr = req.getParameterValues("fileIDXoa");
                if (xoaArr != null) {
                    for (String s : xoaArr) {
                        try { fileIDXoa.add(Integer.parseInt(s)); } catch (Exception ignored) {}
                    }
                }

                // Lấy ảnh mới
                List<Part> partsAnhMoi = new ArrayList<>();
                try {
                    for (Part part : req.getParts()) {
                        if (!"anh".equals(part.getName())) continue;
                        if (part.getSize() > 0) partsAnhMoi.add(part);
                    }
                } catch (Exception e) {
                    sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                            Map.of("success", false, "message", "Lỗi đọc file đính kèm."));
                    return;
                }

                // Lấy loaiID từ phản ánh hiện tại (không cho đổi)
                Map<String, Object> hien = phanAnhService.getDanhSachCuaHoDan(nd.getNguoiDungID())
                        .stream().filter(p -> (int) p.get("phanAnhID") == phanAnhID)
                        .findFirst().orElse(null);
                int loaiID = hien != null ? (int) hien.get("loaiID") : 0;
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
                sendJson(resp, HttpServletResponse.SC_OK, result);
            }

            case "huy" -> {
                int phanAnhID = parseInt(req.getParameter("phanAnhID"), 0);
                String lyDo   = req.getParameter("lyDo");
                if (phanAnhID == 0) {
                    sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                            Map.of("success", false, "message", "Thiếu ID phản ánh."));
                    return;
                }
                Map<String, Object> result =
                        phanAnhService.huyPhanAnh(phanAnhID, nd.getNguoiDungID(), lyDo);
                sendJson(resp, HttpServletResponse.SC_OK, result);
            }

            default -> sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                    Map.of("success", false, "message", "Action không hợp lệ."));
        }
    }

    // ------------------------------------------------------------------ //
    //  HELPERS
    // ------------------------------------------------------------------ //

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

    private void sendJson(HttpServletResponse resp, int status,
                           Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }
}