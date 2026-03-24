package Controller.ToTruong;

import Model.Entity.NguoiDung;
import Model.Service.LichHopService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/danh-sach-lich-hop")
public class DanhSachLichHopServlet extends HttpServlet {

    private final LichHopService lichHopService = new LichHopService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isToTruong(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        int toDanPhoID = nguoiDung.getToDanPhoID();

        // Lấy params lọc
        String keyword   = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");
        String thang     = request.getParameter("thang");   // format: yyyy-MM

        // Lấy toàn bộ lịch họp của tổ
        List<Map<String, Object>> danhSach = lichHopService.getLichHopByToDanPho(toDanPhoID);

        // Lọc keyword (tiêu đề hoặc địa điểm)
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            danhSach = danhSach.stream()
                .filter(lh -> {
                    String tieuDe  = lh.get("tieuDe")  != null ? lh.get("tieuDe").toString().toLowerCase()  : "";
                    String diaDiem = lh.get("diaDiem") != null ? lh.get("diaDiem").toString().toLowerCase() : "";
                    return tieuDe.contains(kw) || diaDiem.contains(kw);
                })
                .collect(Collectors.toList());
        }

        // Lọc trạng thái
        if (trangThai != null && !trangThai.isEmpty()) {
            int tt = Integer.parseInt(trangThai);
            danhSach = danhSach.stream()
                .filter(lh -> lh.get("trangThai") != null
                           && Integer.parseInt(lh.get("trangThai").toString()) == tt)
                .collect(Collectors.toList());
        }

        // Lọc theo tháng (yyyy-MM)
        if (thang != null && !thang.isEmpty()) {
            danhSach = danhSach.stream()
                .filter(lh -> {
                    Object tgbd = lh.get("thoiGianBatDau");
                    if (tgbd == null) return false;
                    // Timestamp.toString() → "yyyy-MM-dd hh:mm:ss.S"
                    return tgbd.toString().startsWith(thang);
                })
                .collect(Collectors.toList());
        }

        request.setAttribute("danhSachLichHop", danhSach);
        request.getRequestDispatcher("/Views/ToTruong/DanhSachLichHop.jsp")
               .forward(request, response);
    }

    private boolean isToTruong(HttpSession session) {
        if (session == null || session.getAttribute("nguoiDung") == null) return false;
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        return "ToTruong".equals(nguoiDung.getTenVaiTro());
    }
}