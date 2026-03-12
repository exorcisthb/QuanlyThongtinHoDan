package Controller.User;

import Model.Entity.NguoiDung;
import Model.Service.NguoiDungService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/ds_totruong")
public class ToTruongListServlet extends HttpServlet {

    private final NguoiDungService nguoiDungService = new NguoiDungService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String keyword    = request.getParameter("keyword");
        // ✅ SỬA: đổi "filterTrangThai" → "trangThai", "filterToSo" → "toSo"
        String trangThai  = request.getParameter("trangThai");
        String toSo       = request.getParameter("toSo");

        List<NguoiDung> danhSach = nguoiDungService.getDanhSachToTruong(keyword);

        // Lọc trạng thái
        if (trangThai != null && !trangThai.isEmpty()) {
            boolean activated = "active".equals(trangThai); // ✅ "active" / "locked"
            List<NguoiDung> temp = new java.util.ArrayList<>();
            for (NguoiDung u : danhSach) {
                if (u.isIsActivated() == activated) temp.add(u);
            }
            danhSach = temp;
        }

        // Lọc tổ số
        if (toSo != null && !toSo.trim().isEmpty()) {
            List<NguoiDung> temp = new java.util.ArrayList<>();
            for (NguoiDung u : danhSach) {
                if (String.valueOf(u.getToDanPhoID()).equals(toSo.trim())) temp.add(u);
            }
            danhSach = temp;
        }

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        request.setAttribute("danhSachToTruong", danhSach);
        request.setAttribute("keyword",          keyword);
        request.setAttribute("trangThai",        trangThai);  // ✅ SỬA
        request.setAttribute("toSo",             toSo);       // ✅ SỬA
        request.setAttribute("showDanhSach",     true);
        request.setAttribute("currentAdmin",     nd);

        request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isAdmin(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idStr  = request.getParameter("nguoiDungID");

        if ("toggleKhoa".equals(action) && idStr != null) {
            int id      = Integer.parseInt(idStr);
            boolean mo  = "true".equals(request.getParameter("activated"));
            nguoiDungService.toggleKhoaTaiKhoan(id, mo);
        }

        // ✅ SỬA: đổi tên param cho khớp
        String keyword   = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");
        String toSo      = request.getParameter("toSo");

        StringBuilder redirect = new StringBuilder(
                request.getContextPath() + "/admin/ds_totruong?");

        if (keyword != null && !keyword.isEmpty())
            redirect.append("keyword=")
                    .append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
        if (trangThai != null && !trangThai.isEmpty())
            redirect.append("trangThai=").append(trangThai).append("&");   // ✅ SỬA
        if (toSo != null && !toSo.isEmpty())
            redirect.append("toSo=")
                    .append(java.net.URLEncoder.encode(toSo, "UTF-8")).append("&"); // ✅ SỬA

        response.sendRedirect(redirect.toString().replaceAll("[&?]$", ""));
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        if (nd == null) return false;
        String vaiTro = nd.getTenVaiTro();
        return vaiTro != null && vaiTro.equalsIgnoreCase("Admin");
    }
}