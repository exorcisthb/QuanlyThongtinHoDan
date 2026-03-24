package Controller.HoDan;

import Model.Entity.HoDan;
import Model.Entity.NguoiDung;
import Model.Service.HoDanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/hodan/qr")
public class HoDanQRServlet extends HttpServlet {

    private final HoDanService service = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        if (!"HoDan".equals(user.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Tìm hộ dân của user này
        HoDan hoDan = service.getHoDanCuaUser(user.getNguoiDungID());
        if (hoDan == null) {
            request.setAttribute("error", "Bạn chưa được gắn vào hộ dân nào. Vui lòng liên hệ tổ trưởng.");
            request.setAttribute("currentUser", user);
            request.getRequestDispatcher("/Views/HoDan/QRCode.jsp").forward(request, response);
            return;
        }

        // Tạo base URL
        String baseUrl = request.getScheme() + "://"
                       + request.getServerName() + ":"
                       + request.getServerPort()
                       + request.getContextPath();

        // Tạo ảnh QR base64
        String qrBase64 = service.taoQRBase64(hoDan.getHoDanID(), baseUrl);
        if (qrBase64 == null) {
            request.setAttribute("error", "Không thể tạo mã QR. Vui lòng thử lại.");
            request.setAttribute("currentUser", user);
            request.getRequestDispatcher("/Views/HoDan/QRCode.jsp").forward(request, response);
            return;
        }

        // Tạo scan URL để test (đăng nhập tổ trưởng rồi mở link này)
        String token = service.getQRToken(hoDan.getHoDanID());
        String scanUrl = baseUrl + "/scan?token=" + token;

        request.setAttribute("currentUser", user);
        request.setAttribute("hoDan", hoDan);
        request.setAttribute("qrBase64", qrBase64);
        request.setAttribute("scanUrl", scanUrl);
        request.getRequestDispatcher("/Views/HoDan/QRCode.jsp").forward(request, response);
    }

    // Xử lý reset QR token
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        String action = request.getParameter("action");

        if ("reset".equals(action)) {
            HoDan hoDan = service.getHoDanCuaUser(user.getNguoiDungID());
            if (hoDan != null) {
                service.resetQRToken(hoDan.getHoDanID());
            }
        }

        response.sendRedirect(request.getContextPath() + "/hodan/qr");
    }
}