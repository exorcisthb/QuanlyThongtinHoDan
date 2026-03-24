package Controller.HoDan;

import Model.Entity.LoaiPhanAnh;
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
 * Servlet xử lý form gửi phản ánh mới.
 * GET  /hodan/gui-phan-anh  → hiển thị form
 * POST /hodan/gui-phan-anh  → xử lý gửi phản ánh (multipart/form-data)
 */
@WebServlet("/hodan/gui-phan-anh")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1MB
    maxFileSize       = 5 * 1024 * 1024L,  // 5MB / file
    maxRequestSize    = 20 * 1024 * 1024L  // 20MB toàn request
)
public class GuiPhanAnhServlet extends HttpServlet {

    private final PhanAnhService phanAnhService = new PhanAnhService();
    private final Gson gson = new Gson();

    // ------------------------------------------------------------------ //
    //  GET — Hiển thị form
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isHoDan(session)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        List<LoaiPhanAnh> danhSachLoai = phanAnhService.getDanhSachLoai();
        req.setAttribute("danhSachLoai", danhSachLoai);

        req.getRequestDispatcher("/Views/HoDan/GuiPhanAnh.jsp")
           .forward(req, resp);
    }

    // ------------------------------------------------------------------ //
    //  POST — Xử lý gửi phản ánh
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

        NguoiDung nd   = getNguoiDung(session);
        int nguoiGuiID = nd.getNguoiDungID();
        int toDanPhoID = nd.getToDanPhoID();

        // Kiểm tra tài khoản đã được gán tổ dân phố chưa
        if (toDanPhoID == 0) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                    Map.of("success", false,
                           "message", "Tài khoản chưa được gán tổ dân phố. Vui lòng liên hệ quản trị viên."));
            return;
        }

        // ── Tham số văn bản ──
        String tieuDe   = req.getParameter("tieuDe");
        String noiDung  = req.getParameter("noiDung");
        int loaiID      = parseInt(req.getParameter("loaiID"), 0);
        int mucDoUuTien = parseInt(req.getParameter("mucDoUuTien"), 2);

        // ── Ảnh đính kèm (field name = "anh", tối đa 3) ──
        List<Part> parts = new ArrayList<>();
        try {
            for (Part part : req.getParts()) {
                if (!"anh".equals(part.getName())) continue;
                if (part.getSize() > 0) {
                    parts.add(part);
                    if (parts.size() == 3) break;
                }
            }
        } catch (Exception e) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                    Map.of("success", false, "message", "Lỗi đọc file đính kèm."));
            return;
        }

        // ── Gọi Service ──
        String appPath = req.getServletContext().getRealPath("/");
        Map<String, Object> result;
        try {
            result = phanAnhService.guiPhanAnh(
                    nguoiGuiID, toDanPhoID, loaiID, mucDoUuTien,
                    tieuDe, noiDung, parts, appPath);
        } catch (Exception e) {
            e.printStackTrace();
            result = Map.of("success", false, "message", "Lỗi server: " + e.getMessage());
        }

        sendJson(resp, HttpServletResponse.SC_OK, result);
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