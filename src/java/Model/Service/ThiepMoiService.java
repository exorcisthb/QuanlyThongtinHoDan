package Model.Service;

import Model.DAO.ThiepMoiDAO;
import Model.Entity.ThiepMoi;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

public class ThiepMoiService {

    private final ThiepMoiDAO dao = new ThiepMoiDAO();

    private static final ZoneId ZONE_VN = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final int NAM_MIN = 2000;
    private static final int NAM_MAX = 2100;

    // ── HELPER ──────────────────────────────────────────────────────

    /**
     * Validate Timestamp: năm hợp lệ (2000–2100) và tuỳ chọn phải sau hiện tại (VN).
     * getThoiGianBatDau/KetThuc trong ThiepMoi entity là java.sql.Timestamp.
     */
    private String validateThoiGian(Timestamp ts, String tenTruong, boolean checkTuongLai) {
        if (ts == null) return tenTruong + " không được để trống.";

        // Chuyển sang LocalDateTime theo giờ VN để kiểm tra năm
        LocalDateTime ldt = ts.toInstant().atZone(ZONE_VN).toLocalDateTime();

        // FIX: chặn năm rác (20000, 1800, v.v.)
        if (ldt.getYear() < NAM_MIN || ldt.getYear() > NAM_MAX)
            return tenTruong + " không hợp lệ (năm phải từ " + NAM_MIN + " đến " + NAM_MAX + ").";

        // FIX: dùng timezone VN thay vì System.currentTimeMillis() thuần tuý
        if (checkTuongLai && !ldt.isAfter(LocalDateTime.now(ZONE_VN)))
            return tenTruong + " phải sau thời điểm hiện tại.";

        return null;
    }

    // ── CRUD & nghiệp vụ ────────────────────────────────────────────

    public List<ThiepMoi> getDanhSach(String keyword, int toDanPhoID, int trangThaiID) {
        if (keyword != null && !keyword.trim().isEmpty()) return dao.search(keyword.trim());
        if (toDanPhoID > 0)  return dao.getByTo(toDanPhoID);
        if (trangThaiID > 0) return dao.getByTrangThai(trangThaiID);
        return dao.getAll();
    }

    public ThiepMoi getChiTiet(int id) {
        return dao.getByID(id);
    }

    public boolean taoThiepMoi(ThiepMoi t, int nguoiTaoID) {
        if (t.getTieuDe() == null || t.getTieuDe().trim().isEmpty())
            throw new IllegalArgumentException("Tiêu đề không được để trống.");
        if (t.getToDanPhoID() <= 0)
            throw new IllegalArgumentException("Tổ dân phố không hợp lệ.");

        // FIX: getThoiGianBatDau() là Timestamp — KHÔNG dùng Timestamp.valueOf()
        String loiBatDau = validateThoiGian(t.getThoiGianBatDau(), "Thời gian bắt đầu", true);
        if (loiBatDau != null) throw new IllegalArgumentException(loiBatDau);

        if (t.getThoiGianKetThuc() != null) {
            String loiKetThuc = validateThoiGian(t.getThoiGianKetThuc(), "Thời gian kết thúc", false);
            if (loiKetThuc != null) throw new IllegalArgumentException(loiKetThuc);
            // FIX: Timestamp dùng .after() thay vì .isAfter()
            if (!t.getThoiGianKetThuc().after(t.getThoiGianBatDau()))
                throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
        }

        return dao.taoThiepMoi(t, nguoiTaoID);
    }

    public boolean suaThiepMoi(ThiepMoi t, int nguoiSuaID) {
        if (t.getTieuDe() == null || t.getTieuDe().trim().isEmpty())
            throw new IllegalArgumentException("Tiêu đề không được để trống.");

        // FIX: khi sửa chỉ check năm hợp lệ, KHÔNG bắt phải trong tương lai
        String loiBatDau = validateThoiGian(t.getThoiGianBatDau(), "Thời gian bắt đầu", false);
        if (loiBatDau != null) throw new IllegalArgumentException(loiBatDau);

        if (t.getThoiGianKetThuc() != null) {
            String loiKetThuc = validateThoiGian(t.getThoiGianKetThuc(), "Thời gian kết thúc", false);
            if (loiKetThuc != null) throw new IllegalArgumentException(loiKetThuc);
            if (!t.getThoiGianKetThuc().after(t.getThoiGianBatDau()))
                throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
        }

        ThiepMoi hienTai = dao.getByID(t.getThiepMoiID());
        if (hienTai == null) return false;
        if (hienTai.isDaIn()) return false;

        return dao.suaThiepMoi(t, nguoiSuaID);
    }

    public boolean xoaThiepMoi(int thiepMoiID, int nguoiXoaID) {
        return dao.xoaThiepMoi(thiepMoiID, nguoiXoaID);
    }

    public boolean inThiepMoi(int thiepMoiID, int nguoiInID) {
        return dao.inThiepMoi(thiepMoiID, nguoiInID);
    }

    public boolean tamHoanThiepMoi(int thiepMoiID, int nguoiThucHienID, String ghiChuHoan) {
        if (ghiChuHoan == null || ghiChuHoan.trim().isEmpty())
            throw new IllegalArgumentException("Vui lòng nhập ghi chú hoãn.");
        return dao.tamHoanThiepMoi(thiepMoiID, nguoiThucHienID, ghiChuHoan.trim());
    }

    public boolean moLaiThiepMoi(int thiepMoiID, int nguoiThucHienID,
                                  Timestamp thoiGianBatDau,
                                  Timestamp thoiGianKetThuc,
                                  String noiDung, String diaDiem) {
        if (diaDiem == null || diaDiem.trim().isEmpty())
            throw new IllegalArgumentException("Địa điểm không được để trống.");

        // FIX: validate Timestamp trực tiếp — năm hợp lệ + phải trong tương lai (VN)
        String loiBatDau = validateThoiGian(thoiGianBatDau, "Thời gian bắt đầu", true);
        if (loiBatDau != null) throw new IllegalArgumentException(loiBatDau);

        if (thoiGianKetThuc != null) {
            String loiKetThuc = validateThoiGian(thoiGianKetThuc, "Thời gian kết thúc", false);
            if (loiKetThuc != null) throw new IllegalArgumentException(loiKetThuc);
            // FIX: bản gốc thiếu check này hoàn toàn
            if (!thoiGianKetThuc.after(thoiGianBatDau))
                throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
        }

        return dao.moLaiThiepMoi(thiepMoiID, nguoiThucHienID,
                                  thoiGianBatDau, thoiGianKetThuc,
                                  noiDung, diaDiem.trim());
    }
}