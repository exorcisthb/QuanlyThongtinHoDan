package Controller.ToTruong;
import Model.DAO.ThanhVienDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/totruong/thanh-vien-ho")
public class ThanhVienHoToTruongServlet extends HttpServlet {
    private final ThanhVienDAO dao = new ThanhVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.setStatus(401); return;
        }
        response.setContentType("application/json;charset=UTF-8");
        String idStr = request.getParameter("hoDanID");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.getWriter().write("[]"); return;
        }
        try {
            int hoDanID = Integer.parseInt(idStr.trim());
            List<Map<String, Object>> list = dao.getThanhVienByHoDanID(hoDanID);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Map<String, Object> row = list.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"hoTen\":")      .append(q(row.get("hoTen")))      .append(",")
                    .append("\"cccd\":")       .append(q(row.get("cccd")))       .append(",")
                    .append("\"ngaySinh\":")   .append(q(row.get("ngaySinh")))   .append(",")
                    .append("\"tuoi\":")       .append(row.get("tuoi"))          .append(",")
                    .append("\"gioiTinh\":")   .append(q(row.get("gioiTinh")))   .append(",")
                    .append("\"soDienThoai\":").append(q(row.get("soDienThoai"))).append(",")
                    .append("\"email\":")      .append(q(row.get("email")))      .append(",")
                    .append("\"quanHe\":")     .append(q(row.get("quanHe")))     .append(",")
                    .append("\"ngayVao\":")    .append(q(row.get("ngayVao")))
                    .append("}");
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("[]");
        }
    }

    private String q(Object val) {
        if (val == null) return "\"\"";
        return "\"" + val.toString()
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r") + "\"";
    }
}