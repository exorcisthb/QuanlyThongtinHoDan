package Controller.ToTruong;

import Model.Entity.HoDan;
import Model.Entity.NguoiDung;
import Model.Service.HoDanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/scan")
public class ScanServlet extends HttpServlet {

    private final HoDanService service = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Chưa đăng nhập → redirect login
        if (session == null || session.getAttribute("nguoiDung") == null) {
            String token = request.getParameter("token");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung scanner = (NguoiDung) session.getAttribute("nguoiDung");
        String vaiTro = scanner.getTenVaiTro();

        // Chỉ tổ trưởng và cán bộ phường được xem
        if (!"ToTruong".equals(vaiTro) && !"CanBoPhuong".equals(vaiTro)) {
            request.setAttribute("error", "Bạn không có quyền xem thông tin này.");
            request.getRequestDispatcher("/Views/ToTruong/ScanResult.jsp").forward(request, response);
            return;
        }

        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Mã QR không hợp lệ.");
            request.getRequestDispatcher("/Views/ToTruong/ScanResult.jsp").forward(request, response);
            return;
        }

        // Tra cứu hộ dân theo token
        HoDan hoDan = service.getHoDanByToken(token);
        if (hoDan == null) {
            request.setAttribute("error", "Mã QR không tồn tại hoặc đã bị vô hiệu hóa.");
            request.getRequestDispatcher("/Views/ToTruong/ScanResult.jsp").forward(request, response);
            return;
        }

        // Lấy danh sách nhân khẩu
        List<NguoiDung> danhSachTV = service.getThanhVienByHoDanID(hoDan.getHoDanID());

        request.setAttribute("hoDan", hoDan);
        request.setAttribute("danhSachTV", danhSachTV);
        request.setAttribute("scanner", scanner);
        request.getRequestDispatcher("/Views/ToTruong/ScanResult.jsp").forward(request, response);
    }
}