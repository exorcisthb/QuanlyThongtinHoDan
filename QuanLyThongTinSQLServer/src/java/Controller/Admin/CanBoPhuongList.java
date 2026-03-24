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

@WebServlet("/admin/ds_canbophuong")
public class CanBoPhuongList extends HttpServlet {

    private final NguoiDungService nguoiDungService = new NguoiDungService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ Chuyển flash message từ session sang request rồi xóa
        if (session.getAttribute("message") != null) {
            request.setAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        String keyword = request.getParameter("keyword");
        List<NguoiDung> danhSach = nguoiDungService.getDanhSachCanBoPhuong(keyword);

        request.setAttribute("danhSachCanBo", danhSach);
        request.setAttribute("keyword",       keyword);
        request.setAttribute("showCanBo",     true);
        request.setAttribute("currentAdmin",  session.getAttribute("nguoiDung"));

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

        // ✅ Xử lý đổi trạng thái nhân sự
        if ("toggleTrangThai".equals(action) && idStr != null) {
            try {
                int id           = Integer.parseInt(idStr);
                int trangThaiMoi = Integer.parseInt(request.getParameter("trangThaiNhanSu"));
                boolean ok = nguoiDungService.updateTrangThaiNhanSu(id, trangThaiMoi);
                if (ok) {
                    request.getSession().setAttribute("message", "Đã cập nhật trạng thái nhân sự thành công.");
                } else {
                    request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại, vui lòng thử lại.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
            }
        }

        String keyword = request.getParameter("keyword");
        String redirect = request.getContextPath() + "/admin/ds_canbophuong"
                + (keyword != null && !keyword.isBlank()
                    ? "?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8")
                    : "");
        response.sendRedirect(redirect);
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        return nd != null && "Admin".equals(nd.getTenVaiTro());
    }
}