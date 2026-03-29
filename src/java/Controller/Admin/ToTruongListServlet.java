package Controller.Admin;

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

        // Chuyển flash message từ session sang request rồi xóa
        if (session.getAttribute("flashMessage") != null) {
            request.setAttribute("message", session.getAttribute("flashMessage"));
            session.removeAttribute("flashMessage");
        }
        if (session.getAttribute("message") != null) {
            request.setAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        String keyword   = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");
        String toSo      = request.getParameter("toSo");

        List<NguoiDung> danhSach = nguoiDungService.getDanhSachToTruong(keyword);

        if (trangThai != null && !trangThai.isEmpty()) {
            boolean activated = "active".equals(trangThai);
            List<NguoiDung> temp = new java.util.ArrayList<>();
            for (NguoiDung u : danhSach) {
                if (u.isIsActivated() == activated) temp.add(u);
            }
            danhSach = temp;
        }

        if (toSo != null && !toSo.trim().isEmpty()) {
            List<NguoiDung> temp = new java.util.ArrayList<>();
            for (NguoiDung u : danhSach) {
                if (String.valueOf(u.getToDanPhoID()).equals(toSo.trim())) temp.add(u);
            }
            danhSach = temp;
        }

        request.setAttribute("danhSachToTruong", danhSach);
        request.setAttribute("keyword",          keyword);
        request.setAttribute("trangThai",        trangThai);
        request.setAttribute("toSo",             toSo);
        request.setAttribute("showDanhSach",     true);
        request.setAttribute("currentAdmin",     session.getAttribute("nguoiDung"));

        request.getRequestDispatcher("/Views/Admin/AdminDashboard.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idStr  = request.getParameter("nguoiDungID");

        if ("toggleKhoa".equals(action) && idStr != null) {
            int id     = Integer.parseInt(idStr);
            boolean mo = "true".equals(request.getParameter("activated"));
            nguoiDungService.toggleKhoaTaiKhoan(id, mo);
        }

        if ("toggleTrangThai".equals(action) && idStr != null) {
            try {
                int id           = Integer.parseInt(idStr);
                int trangThaiMoi = Integer.parseInt(request.getParameter("trangThaiNhanSu"));

                // ✅ Service giờ trả String: null = thành công, có nội dung = lỗi
                String err = nguoiDungService.updateTrangThaiNhanSu(id, trangThaiMoi);
                if (err == null) {
                    session.setAttribute("message", "Đã cập nhật trạng thái nhân sự thành công.");
                } else {
                    session.setAttribute("error", err);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Dữ liệu không hợp lệ.");
            }
        }

        String keyword   = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");
        String toSo      = request.getParameter("toSo");

        StringBuilder redirect = new StringBuilder(
                request.getContextPath() + "/admin/ds_totruong?");
        if (keyword != null && !keyword.isEmpty())
            redirect.append("keyword=")
                    .append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
        if (trangThai != null && !trangThai.isEmpty())
            redirect.append("trangThai=").append(trangThai).append("&");
        if (toSo != null && !toSo.isEmpty())
            redirect.append("toSo=")
                    .append(java.net.URLEncoder.encode(toSo, "UTF-8")).append("&");

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