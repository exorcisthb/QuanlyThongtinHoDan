package Controller.ToTruong;

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

@WebServlet("/todan/hodan")
public class ListHoDanServlet extends HttpServlet {

    private final HoDanService hoDanService = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        if (!"ToTruong".equals(user.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }

        // ── Kiểm tra tổ trưởng có được gán tổ chưa ──
        if (user.getToDanPhoID() == null) {
            request.setAttribute("errorMsg",
                "Tài khoản tổ trưởng chưa được gán tổ dân phố. Vui lòng liên hệ cán bộ phường.");
            request.setAttribute("currentUser", user);
            request.getRequestDispatcher("/Views/ToTruong/DanhSachHoDan.jsp").forward(request, response);
            return;
        }

        String keyword   = request.getParameter("keyword");
        String tuoiMinS  = request.getParameter("tuoiMin");
        String tuoiMaxS  = request.getParameter("tuoiMax");
        String vung      = request.getParameter("vung");
        String chuHo     = request.getParameter("chuHo");
        String kichHoat  = request.getParameter("kichHoat");
        String trangThai = request.getParameter("trangThai");

        Integer tuoiMin = null, tuoiMax = null;
        try { if (tuoiMinS != null && !tuoiMinS.isBlank()) tuoiMin = Integer.parseInt(tuoiMinS); } catch (Exception ignored) {}
        try { if (tuoiMaxS != null && !tuoiMaxS.isBlank()) tuoiMax = Integer.parseInt(tuoiMaxS); } catch (Exception ignored) {}

        Integer trangThaiID = null;
        try { if (trangThai != null && !trangThai.isBlank()) trangThaiID = Integer.parseInt(trangThai); } catch (Exception ignored) {}

        Boolean daKichHoat = null;
        if ("co".equals(kichHoat))   daKichHoat = true;
        if ("chua".equals(kichHoat)) daKichHoat = false;

        Boolean coChuHo = null;
        if ("co".equals(chuHo))   coChuHo = true;
        if ("chua".equals(chuHo)) coChuHo = false;

        int toDanPhoID = user.getToDanPhoID(); // an toàn vì đã check null ở trên

        boolean coFilter = (keyword != null && !keyword.trim().isEmpty())
                || tuoiMin != null || tuoiMax != null
                || (vung != null && !vung.trim().isEmpty())
                || coChuHo != null || daKichHoat != null || trangThaiID != null;

        request.setAttribute("coFilter",    coFilter);
        request.setAttribute("keyword",     keyword);
        request.setAttribute("currentUser", user);

        if (coFilter) {
            Map<String, List<Map<String, Object>>> nhomCaNhan =
                hoDanService.getDanhSachCaNhanNhomTheoDuong(
                    toDanPhoID, keyword, tuoiMin, tuoiMax,
                    vung, coChuHo, daKichHoat, trangThaiID);
            request.setAttribute("nhomCaNhan",    nhomCaNhan);
            request.setAttribute("tongSoCaNhan",  hoDanService.tongSoCaNhan(nhomCaNhan));
        } else {
            Map<String, List<HoDan>> nhomTheoDuong =
                hoDanService.getDanhSachNhomTheoDuong(toDanPhoID, null);
            request.setAttribute("nhomTheoDuong", nhomTheoDuong);
            request.setAttribute("tongSoHo",      hoDanService.tongSoHo(nhomTheoDuong));
        }

        request.getRequestDispatcher("/Views/ToTruong/DanhSachHoDan.jsp")
               .forward(request, response);
    }
}