package Controller.Common;

import Model.DAO.ThongBaoDAO;
import Model.Entity.NguoiDung;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet("/thong-bao")
public class ThongBaoServlet extends HttpServlet {

    private final ThongBaoDAO thongBaoDAO = new ThongBaoDAO();
    private final Gson gson = new Gson();

    // ------------------------------------------------------------------ //
    //  GET
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isLoggedIn(session)) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                     Map.of("success", false, "message", "Chưa đăng nhập."));
            return;
        }

        int nguoiDungID = getNguoiDungID(session);
        if (nguoiDungID == 0) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                     Map.of("success", false, "message", "Không xác định được người dùng."));
            return;
        }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "list" -> {
                List<Map<String, Object>> danhSach =
                        thongBaoDAO.layThongBaoCuaNguoiDung(nguoiDungID);
                int chuaDoc = (int) danhSach.stream()
                        .filter(n -> Boolean.FALSE.equals(n.get("daDoc")))
                        .count();

                Map<String, Object> result = new LinkedHashMap<>();
                result.put("success",  true);
                result.put("danhSach", danhSach);
                result.put("chuaDoc",  chuaDoc);
                sendJson(resp, HttpServletResponse.SC_OK, result);
            }

            case "demChuaDoc" -> {
                int chuaDoc = thongBaoDAO.demChuaDoc(nguoiDungID);
                sendJson(resp, HttpServletResponse.SC_OK,
                         Map.of("success", true, "chuaDoc", chuaDoc));
            }

            default -> sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                                Map.of("success", false, "message", "Action không hợp lệ."));
        }
    }

    // ------------------------------------------------------------------ //
    //  POST
    // ------------------------------------------------------------------ //
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (!isLoggedIn(session)) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                     Map.of("success", false, "message", "Chưa đăng nhập."));
            return;
        }

        int nguoiDungID = getNguoiDungID(session);
        if (nguoiDungID == 0) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                     Map.of("success", false, "message", "Không xác định được người dùng."));
            return;
        }

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "doc" -> {
                int thongBaoID = parseInt(req.getParameter("id"), 0);
                if (thongBaoID == 0) {
                    sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                             Map.of("success", false, "message", "Thiếu ID thông báo."));
                    return;
                }
                boolean ok = thongBaoDAO.danhDauDaDoc(thongBaoID, nguoiDungID);
                sendJson(resp, HttpServletResponse.SC_OK,
                         Map.of("success", ok,
                                "message", ok ? "Đã đánh dấu đã đọc." : "Không tìm thấy thông báo."));
            }

            case "docTatCa" -> {
                boolean ok = thongBaoDAO.danhDauDocTatCa(nguoiDungID);
                sendJson(resp, HttpServletResponse.SC_OK,
                         Map.of("success", ok,
                                "message", ok ? "Đã đọc tất cả." : "Không có thông báo nào chưa đọc."));
            }

            default -> sendJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                                Map.of("success", false, "message", "Action không hợp lệ."));
        }
    }

    // ------------------------------------------------------------------ //
    //  HELPERS
    // ------------------------------------------------------------------ //

    /**
     * Chấp nhận cả 2 cách lưu session:
     *   1. session.setAttribute("nguoiDungID", 18)
     *   2. session.setAttribute("nguoiDung", nguoiDungObj)
     */
    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("nguoiDungID") != null
            || session.getAttribute("nguoiDung")   != null;
    }

    /**
     * Lấy NguoiDungID an toàn — thử cả 2 key trong session.
     */
    private int getNguoiDungID(HttpSession session) {
        if (session == null) return 0;

        // Cách 1: key "nguoiDungID" lưu dạng Integer hoặc String
        Object idObj = session.getAttribute("nguoiDungID");
        if (idObj instanceof Integer) return (Integer) idObj;
        if (idObj != null) {
            try { return Integer.parseInt(idObj.toString()); }
            catch (NumberFormatException ignored) {}
        }

        // Cách 2: key "nguoiDung" lưu dạng object NguoiDung
        Object ndObj = session.getAttribute("nguoiDung");
        if (ndObj instanceof NguoiDung) {
            return ((NguoiDung) ndObj).getNguoiDungID();
        }

        return 0;
    }

    private int parseInt(String value, int defaultVal) {
        try { return Integer.parseInt(value); }
        catch (Exception e) { return defaultVal; }
    }

    private void sendJson(HttpServletResponse resp, int statusCode,
                          Object data) throws IOException {
        resp.setStatus(statusCode);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }
}
