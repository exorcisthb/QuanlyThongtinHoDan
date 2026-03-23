package Controller.ToTruong;

import Model.Entity.NguoiDung;
import Model.Service.HoDanService;
import Model.Service.PhanAnhService;
import Model.Service.ThiepMoiService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Calendar;
import java.util.Map;

@WebServlet("/totruong/thong-ke")
public class ThongKeServlet extends HttpServlet {

    private final HoDanService    hoDanService    = new HoDanService();
    private final ThiepMoiService thiepMoiService = new ThiepMoiService();
    private final PhanAnhService  phanAnhService  = new PhanAnhService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Kiểm tra session ─────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        NguoiDung user = (NguoiDung) session.getAttribute("nguoiDung");
        if (!"ToTruong".equals(user.getTenVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int toDanPhoID = user.getToDanPhoID() != null ? user.getToDanPhoID() : 0;

        // ── 2. Năm được chọn (mặc định năm hiện tại) ───────────────────
        int namHienTai = Calendar.getInstance().get(Calendar.YEAR);
        int namChon    = namHienTai;
        try {
            String paramNam = request.getParameter("nam");
            if (paramNam != null && !paramNam.isEmpty()) {
                namChon = Integer.parseInt(paramNam);
            }
        } catch (NumberFormatException ignored) {}

        // ── 3. Gọi Service ──────────────────────────────────────────────
        // Hộ khẩu
        int tongSoHo     = hoDanService.getTongSoHo(toDanPhoID);
        int tongNhanKhau = hoDanService.getTongSoNhanKhau(toDanPhoID);
        Map<String, Integer> hoTheoCuTru    = hoDanService.getHoTheoCuTru(toDanPhoID);
        Map<String, Integer> nkTheoGioiTinh = hoDanService.getNhanKhauTheoGioiTinh(toDanPhoID);
        Map<String, Integer> nkTheoNhomTuoi = hoDanService.getNhanKhauTheoNhomTuoi(toDanPhoID);

        // Thiệp mời
        int tongThiepMoi = thiepMoiService.getTongThiepMoi(toDanPhoID, namChon);
        int thiepDaIn    = thiepMoiService.getThiepMoiDaIn(toDanPhoID, namChon);
        Map<String, Integer> thiepTheoThang     = thiepMoiService.getThiepMoiTheoThang(toDanPhoID, namChon);
        Map<String, Integer> thiepTheoTrangThai = thiepMoiService.getThiepMoiTheoTrangThai(toDanPhoID, namChon);

        // Phản ánh
        Map<String, Integer> tongHopPA       = phanAnhService.getTongHopPhanAnh(toDanPhoID, namChon);
        Map<String, Integer> paTheoThang     = phanAnhService.getPhanAnhTheoThang(toDanPhoID, namChon);
        Map<String, Integer> paTheoTrangThai = phanAnhService.getPhanAnhTheoTrangThai(toDanPhoID, namChon);
        Map<String, Integer> paTheoLoai      = phanAnhService.getPhanAnhTheoLoai(toDanPhoID, namChon);

        // ── 4. Set attributes ──────────────────────────────────────────
        Gson gson = new Gson();

        request.setAttribute("currentUser",  user);
        request.setAttribute("tenTo",        user.getTenTo());
        request.setAttribute("namChon",      namChon);
        request.setAttribute("namHienTai",   namHienTai);

        request.setAttribute("tongSoHo",     tongSoHo);
        request.setAttribute("tongNhanKhau", tongNhanKhau);
        request.setAttribute("hoTheoCuTruJson",    gson.toJson(hoTheoCuTru));
        request.setAttribute("nkTheoGioiTinhJson", gson.toJson(nkTheoGioiTinh));
        request.setAttribute("nkTheoNhomTuoiJson", gson.toJson(nkTheoNhomTuoi));

        request.setAttribute("tongThiepMoi", tongThiepMoi);
        request.setAttribute("thiepDaIn",    thiepDaIn);
        request.setAttribute("thiepTheoThangJson",     gson.toJson(thiepTheoThang));
        request.setAttribute("thiepTheoTrangThaiJson", gson.toJson(thiepTheoTrangThai));

        request.setAttribute("tongHopPAJson",       gson.toJson(tongHopPA));
        request.setAttribute("paTheoThangJson",     gson.toJson(paTheoThang));
        request.setAttribute("paTheoTrangThaiJson", gson.toJson(paTheoTrangThai));
        request.setAttribute("paTheoLoaiJson",      gson.toJson(paTheoLoai));

        request.getRequestDispatcher("/Views/ToTruong/ThongKe.jsp")
                .forward(request, response);
    }
}