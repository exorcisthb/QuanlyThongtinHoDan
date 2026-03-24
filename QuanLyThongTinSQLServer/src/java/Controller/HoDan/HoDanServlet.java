package Controller.HoDan;

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

@WebServlet("/hodan/ho-dan")
public class HoDanServlet extends HttpServlet {

    private final HoDanService hoDanService = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung currentUser = (NguoiDung) session.getAttribute("nguoiDung");
        request.setAttribute("currentUser", currentUser);

        try {
            HoDan hoDan = hoDanService.getHoDanCuaUser(currentUser.getNguoiDungID());

            if (hoDan == null) {
                request.setAttribute("errorMsg", "Bạn chưa được thêm vào hộ dân nào. Vui lòng liên hệ tổ trưởng.");
                request.getRequestDispatcher("/Views/HoDan/ThongTinHoDan.jsp")
                        .forward(request, response);
                return;
            }

            List<NguoiDung> thanhVien = hoDanService.getThanhVienByHoDanID(hoDan.getHoDanID());

            request.setAttribute("hoDan", hoDan);
            request.setAttribute("thanhVien", thanhVien);
            request.setAttribute("soNhanKhau", thanhVien.size());

            // Load danh sách quan hệ cho modal
            request.setAttribute("danhSachQuanHe", hoDanService.getDanhSachQuanHe());

            // ✅ Kiểm tra người dùng hiện tại có phải chủ hộ không
            boolean isChuHo = hoDan.getChuHoID() != null
                           && hoDan.getChuHoID() == currentUser.getNguoiDungID();
            request.setAttribute("isChuHo", isChuHo);

            // Thông báo sau khi sửa
            String success = request.getParameter("success");
            String error   = request.getParameter("error");
            if (success != null) request.setAttribute("successMsg", success);
            if (error   != null) request.setAttribute("errorMsg",   error);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Có lỗi xảy ra khi tải thông tin hộ dân.");
        }

        request.getRequestDispatcher("/Views/HoDan/ThongTinHoDan.jsp")
                .forward(request, response);
    }
}