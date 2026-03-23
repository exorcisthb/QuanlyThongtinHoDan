package Controller.CanBoPhuong;

import Model.Entity.NguoiDung;
import Model.Service.PhanAnhService;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/canbophuong/phan-anh")
public class CanBoPhuongPhanAnhServlet extends HttpServlet {

    private final PhanAnhService service = new PhanAnhService();

    private NguoiDung getCanBo(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/"); return null; }
        NguoiDung u = (NguoiDung) session.getAttribute("nguoiDung");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/"); return null; }
        return u;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        NguoiDung canBo = getCanBo(req, resp);
        if (canBo == null) return;

        // Tra ve JSON so luong neu la request dem badge tu dashboard
        String format = req.getParameter("format");
        if ("count".equals(format)) {
            List<Map<String, Object>> all = service.getDanhSachDaChuyenCap();
            long soChuaXuLy = all.stream()
                    .filter(p -> (int)p.get("trangThaiID") == 3).count();
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"soChuaXuLy\":" + soChuaXuLy + "}");
            return;
        }

        String keyword   = req.getParameter("keyword");
        String ttParam   = req.getParameter("trangThai");
        String mucDoP    = req.getParameter("mucDo");
        String toParam   = req.getParameter("toDanPho");

        // Lay tat ca phan anh da chuyen cap tu moi to
        List<Map<String, Object>> goc      = service.getDanhSachDaChuyenCap();
        List<Map<String, Object>> danhSach = service.getDanhSachDaChuyenCap();

        // Thong ke goc (truoc filter)
        long soChuaXuLy  = goc.stream().filter(p -> (int)p.get("trangThaiID") == 3).count();
        long soGiaiQuyet = goc.stream().filter(p -> (int)p.get("trangThaiID") == 4).count();

        // Filter o tang Java
        if (ttParam != null && !ttParam.isBlank()) {
            int ttFilter = Integer.parseInt(ttParam);
            danhSach.removeIf(p -> (int) p.get("trangThaiID") != ttFilter);
        }
        if (mucDoP != null && !mucDoP.isBlank()) {
            int mdFilter = Integer.parseInt(mucDoP);
            danhSach.removeIf(p -> (int) p.get("mucDoUuTien") != mdFilter);
        }
        if (toParam != null && !toParam.isBlank()) {
            danhSach.removeIf(p -> !toParam.equals(
                    p.get("tenToDanPho") != null ? p.get("tenToDanPho").toString() : ""));
        }
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            danhSach.removeIf(p -> {
                String td  = p.get("tieuDe")      != null ? p.get("tieuDe").toString().toLowerCase()      : "";
                String ng  = p.get("tenNguoiGui") != null ? p.get("tenNguoiGui").toString().toLowerCase() : "";
                String ten = p.get("tenToDanPho") != null ? p.get("tenToDanPho").toString().toLowerCase() : "";
                return !td.contains(kw) && !ng.contains(kw) && !ten.contains(kw);
            });
        }

        // Danh sach to don nhat de hien filter
        List<String> danhSachTo = goc.stream()
                .map(p -> p.get("tenToDanPho") != null ? p.get("tenToDanPho").toString() : "")
                .filter(s -> !s.isBlank()).distinct().sorted().toList();

        req.setAttribute("nguoiDung",       canBo);
        req.setAttribute("danhSachPhanAnh", danhSach);
        req.setAttribute("total",           danhSach.size());
        req.setAttribute("tongTat",         goc.size());
        req.setAttribute("soChuaXuLy",      soChuaXuLy);
        req.setAttribute("soGiaiQuyet",     soGiaiQuyet);
        req.setAttribute("keyword",         keyword);
        req.setAttribute("trangThaiFilter", ttParam);
        req.setAttribute("mucDoFilter",     mucDoP);
        req.setAttribute("toDanPhoFilter",  toParam);
        req.setAttribute("danhSachTo",      danhSachTo);

        req.getRequestDispatcher("/Views/CanBoPhuong/DanhSachTatCaPhanAnh.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        NguoiDung canBo = getCanBo(req, resp);
        if (canBo == null) return;

        String action  = req.getParameter("action");
        String idParam = req.getParameter("phanAnhID");
        int    nguoiID = canBo.getNguoiDungID();

        if (idParam == null || !idParam.matches("\\d+")) {
            setFlash(req, "Yêu cầu không hợp lệ.", true);
            redirect(req, resp); return;
        }
        int phanAnhID = Integer.parseInt(idParam);

        Map<String, Object> result = switch (action == null ? "" : action) {

            // Giai quyet: TT=3 -> 4 (chi can bo phuong moi co quyen nay)
            case "giaiQuyet" -> {
                String ketQua = req.getParameter("ketQua");
                yield service.giaiquyetPhanAnh(phanAnhID, nguoiID, ketQua);
            }

            // Gui phan hoi den nguoi dan
            case "phanHoi" -> {
                String noiDung = req.getParameter("noiDungPhanHoi");
                yield service.guiPhanHoi(phanAnhID, nguoiID, noiDung);
            }

            default -> Map.of("success", false, "message", "Hành động không được hỗ trợ.");
        };

        boolean ok = Boolean.TRUE.equals(result.get("success"));
        setFlash(req, (String) result.get("message"), !ok);
        redirect(req, resp);
    }

    private void setFlash(HttpServletRequest req, String msg, boolean isError) {
        req.getSession().setAttribute(isError ? "error" : "message", msg);
    }

    private void redirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        StringBuilder url = new StringBuilder(req.getContextPath() + "/canbophuong/phan-anh?");
        appendParam(url, "keyword",   req.getParameter("keyword"));
        appendParam(url, "trangThai", req.getParameter("trangThai"));
        appendParam(url, "mucDo",     req.getParameter("mucDo"));
        appendParam(url, "toDanPho",  req.getParameter("toDanPho"));
        resp.sendRedirect(url.toString());
    }

    private void appendParam(StringBuilder sb, String key, String val) {
        if (val != null && !val.isBlank())
            sb.append(key).append("=").append(val).append("&");
    }
}