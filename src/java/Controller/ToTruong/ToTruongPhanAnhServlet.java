package Controller.ToTruong;

import Model.Entity.NguoiDung;
import Model.Service.PhanAnhService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/totruong/phan-anh")
public class ToTruongPhanAnhServlet extends HttpServlet {

    private final PhanAnhService service = new PhanAnhService();

    private NguoiDung getToTruong(HttpServletRequest req, HttpServletResponse resp)
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
        NguoiDung toTruong = getToTruong(req, resp);
        if (toTruong == null) return;

        int toDanPhoID = toTruong.getToDanPhoID();
        String keyword    = req.getParameter("keyword");
        String ttParam    = req.getParameter("trangThai");
        String mucDoParam = req.getParameter("mucDo");

        List<Map<String, Object>> goc      = service.getDanhSachTheoTo(toDanPhoID);
        List<Map<String, Object>> danhSach = service.getDanhSachTheoTo(toDanPhoID);

        // Thống kê từ danh sách gốc (trước filter)
        long soChoXuLy   = goc.stream().filter(p -> (int)p.get("trangThaiID") == 1).count();
        long soDangXuLy  = goc.stream().filter(p -> (int)p.get("trangThaiID") == 2).count();
        long soChuyenCap = goc.stream().filter(p -> (int)p.get("trangThaiID") == 3).count();
        long soGiaiQuyet = goc.stream().filter(p -> (int)p.get("trangThaiID") == 4).count();
        long soTuChoi    = goc.stream().filter(p -> (int)p.get("trangThaiID") == 5).count();
        long soSpam      = goc.stream().filter(p -> Boolean.TRUE.equals(p.get("isSpam"))).count();

        // Filter ở tầng Java
        if (ttParam != null && !ttParam.isBlank()) {
            int ttFilter = Integer.parseInt(ttParam);
            danhSach.removeIf(p -> (int) p.get("trangThaiID") != ttFilter);
        }
        if (mucDoParam != null && !mucDoParam.isBlank()) {
            int mdFilter = Integer.parseInt(mucDoParam);
            danhSach.removeIf(p -> (int) p.get("mucDoUuTien") != mdFilter);
        }
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            danhSach.removeIf(p -> {
                String td = p.get("tieuDe")      != null ? p.get("tieuDe").toString().toLowerCase()      : "";
                String ng = p.get("tenNguoiGui") != null ? p.get("tenNguoiGui").toString().toLowerCase() : "";
                return !td.contains(kw) && !ng.contains(kw);
            });
        }

        req.setAttribute("nguoiDung",       toTruong);
        req.setAttribute("danhSachPhanAnh", danhSach);
        req.setAttribute("total",           danhSach.size());
        req.setAttribute("keyword",         keyword);
        req.setAttribute("trangThaiFilter", ttParam);
        req.setAttribute("mucDoFilter",     mucDoParam);
        req.setAttribute("soChoXuLy",       soChoXuLy);
        req.setAttribute("soDangXuLy",      soDangXuLy);
        req.setAttribute("soChuyenCap",     soChuyenCap);
        req.setAttribute("soGiaiQuyet",     soGiaiQuyet);
        req.setAttribute("soTuChoi",        soTuChoi);
        req.setAttribute("soSpam",          soSpam);

        req.getRequestDispatcher("/Views/ToTruong/DanhSachPhanAnh.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        NguoiDung toTruong = getToTruong(req, resp);
        if (toTruong == null) return;

        String action  = req.getParameter("action");
        String idParam = req.getParameter("phanAnhID");
        int    nguoiID = toTruong.getNguoiDungID();

        if (idParam == null || !idParam.matches("\\d+")) {
            setFlash(req, "Yêu cầu không hợp lệ.", true);
            redirect(req, resp); return;
        }
        int phanAnhID = Integer.parseInt(idParam);

        Map<String, Object> result = switch (action == null ? "" : action) {

            case "tiepNhan" -> service.tiepNhan(phanAnhID, nguoiID, null);

            case "giaiQuyet" -> {
                String ketQua = req.getParameter("ketQua");
                yield service.giaiQuyetToTruong(phanAnhID, nguoiID, ketQua);
            }

            case "tuChoi" -> {
                String lyDo = req.getParameter("lyDo");
                yield service.tuChoi(phanAnhID, nguoiID, lyDo);
            }

            case "danhDauSpam" -> {
                String ghiChu = req.getParameter("ghiChu");
                yield service.danhDauSpam(phanAnhID, nguoiID, ghiChu);
            }

            case "chuyenCap" -> {
                String ghiChu = req.getParameter("ghiChu");
                yield service.chuyenCapCanBo(phanAnhID, nguoiID, ghiChu);
            }

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
        StringBuilder url = new StringBuilder(req.getContextPath() + "/totruong/phan-anh?");
        appendParam(url, "keyword",   req.getParameter("keyword"));
        appendParam(url, "trangThai", req.getParameter("trangThai"));
        appendParam(url, "mucDo",     req.getParameter("mucDo"));
        resp.sendRedirect(url.toString());
    }

    private void appendParam(StringBuilder sb, String key, String val) {
        if (val != null && !val.isBlank())
            sb.append(key).append("=").append(val).append("&");
    }
}