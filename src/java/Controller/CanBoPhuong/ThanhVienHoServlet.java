package Controller.CanBoPhuong;

import Model.Service.ThanhVienService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/canbophuong/thanh-vien-ho")
public class ThanhVienHoServlet extends HttpServlet {

   private final ThanhVienService thanhvienService = new ThanhVienService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.setStatus(401);
            resp.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");

        String hoDanIDStr = req.getParameter("hoDanID");
        if (hoDanIDStr == null || hoDanIDStr.isEmpty()) {
            resp.getWriter().write("[]");
            return;
        }

        try {
            int hoDanID = Integer.parseInt(hoDanIDStr);
            List<Map<String, Object>> list = thanhvienService.getThanhVienByHoDanID(hoDanID);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Map<String, Object> m = list.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"hoTen\":")       .append(q(m.get("hoTen")))       .append(",")
                    .append("\"cccd\":")         .append(q(m.get("cccd")))         .append(",")
                    .append("\"ngaySinh\":")     .append(q(m.get("ngaySinh")))     .append(",")
                    .append("\"tuoi\":")         .append(m.get("tuoi"))            .append(",")
                    .append("\"gioiTinh\":")     .append(q(m.get("gioiTinh")))     .append(",")
                    .append("\"soDienThoai\":") .append(q(m.get("soDienThoai"))) .append(",")
                    .append("\"email\":")        .append(q(m.get("email")))        .append(",")
                    .append("\"quanHe\":")       .append(q(m.get("quanHe")))
                    .append("}");
            }
            json.append("]");
            resp.getWriter().write(json.toString());

        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private String q(Object val) {
        if (val == null) return "\"\"";
        return "\"" + val.toString().replace("\"", "\\\"") .replace("\n", "") + "\"";
    }
}