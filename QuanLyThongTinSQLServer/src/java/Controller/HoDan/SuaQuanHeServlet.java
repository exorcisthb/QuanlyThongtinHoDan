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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/hodan/sua-quan-he")
public class SuaQuanHeServlet extends HttpServlet {

    private final HoDanService hoDanService = new HoDanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/hodan/ho-dan");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung currentUser = (NguoiDung) session.getAttribute("nguoiDung");

        try {
            int nguoiDungID = Integer.parseInt(request.getParameter("nguoiDungID"));
            int hoDanID     = Integer.parseInt(request.getParameter("hoDanID"));
            int quanHeID    = Integer.parseInt(request.getParameter("quanHeID"));

            HoDan hoDan = hoDanService.getHoDanCuaUser(currentUser.getNguoiDungID());

            if (hoDan == null || hoDan.getHoDanID() != hoDanID) {
                redirect(response, request.getContextPath()
                        + "/hodan/ho-dan", null, "Bạn không có quyền thực hiện thao tác này");
                return;
            }

            if (hoDan.getChuHoID() == null
                    || hoDan.getChuHoID() != currentUser.getNguoiDungID()) {
                redirect(response, request.getContextPath()
                        + "/hodan/ho-dan", null, "Chỉ chủ hộ mới được sửa quan hệ thành viên");
                return;
            }

            if (nguoiDungID == currentUser.getNguoiDungID()) {
                redirect(response, request.getContextPath()
                        + "/hodan/ho-dan", null, "Không thể sửa quan hệ của chính mình");
                return;
            }

            boolean ok = hoDanService.capNhatQuanHe(hoDanID, nguoiDungID, quanHeID);

            if (ok) {
                redirect(response, request.getContextPath()
                        + "/hodan/ho-dan", "Cập nhật quan hệ thành công", null);
            } else {
                redirect(response, request.getContextPath()
                        + "/hodan/ho-dan", null, "Cập nhật thất bại, vui lòng thử lại");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirect(response, request.getContextPath()
                    + "/hodan/ho-dan", null, "Có lỗi xảy ra");
        }
    }

    // ✅ Helper encode tiếng Việt đúng chuẩn
    private void redirect(HttpServletResponse response, String base,
                          String success, String error) throws IOException {
        StringBuilder url = new StringBuilder(base);
        if (success != null) {
            url.append("?success=")
               .append(URLEncoder.encode(success, StandardCharsets.UTF_8));
        } else if (error != null) {
            url.append("?error=")
               .append(URLEncoder.encode(error, StandardCharsets.UTF_8));
        }
        response.sendRedirect(url.toString());
    }
}