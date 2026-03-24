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
 * GET  /hodan/sua-phan-anh?id=X  → load form sửa
 * POST /hodan/phan-anh?action=sua → xử lý lưu (MultipartConfig đã có ở PhanAnhServlet)
 *
 * Lưu ý: POST sửa được xử lý tại PhanAnhServlet (action=sua)
 * Servlet này chỉ phụ trách GET để load form.
 */
@WebServlet("/hodan/sua-phan-anh")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024L,
    maxRequestSize    = 20 * 1024 * 1024L
)
public class SuaPhanAnhServlet extends HttpServlet {

    private final PhanAnhService phanAnhService = new PhanAnhService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isHoDan(session)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int phanAnhID = parseInt(req.getParameter("id"), 0);
        if (phanAnhID == 0) {
            resp.sendRedirect(req.getContextPath() + "/hodan/phan-anh");
            return;
        }

        NguoiDung nd = getNguoiDung(session);

        // Lấy chi tiết phản ánh
        Map<String, Object> pa = phanAnhService.getChiTiet(phanAnhID);

        // Kiểm tra tồn tại và quyền sở hữu
        if (pa == null || (int) pa.get("nguoiGuiID") != nd.getNguoiDungID()) {
            resp.sendRedirect(req.getContextPath() + "/hodan/phan-anh");
            return;
        }

        // Kiểm tra trạng thái — không cho sửa nếu đã kết thúc
        int tt = (int) pa.get("trangThaiID");
        if (tt == 4 || tt == 5 || tt == 6 || tt == 7) {
            resp.sendRedirect(req.getContextPath() + "/hodan/phan-anh");
            return;
        }

        req.setAttribute("phanAnh",     pa);
        req.setAttribute("danhSachAnh", pa.get("danhSachAnh"));
        req.getRequestDispatcher("/Views/HoDan/SuaPhanAnh.jsp")
           .forward(req, resp);
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
}