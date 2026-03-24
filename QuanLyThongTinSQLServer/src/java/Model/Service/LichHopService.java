package Model.Service;

import Model.DAO.LichHopDAO;
import Model.Entity.LichHop;
import Model.Entity.LichSuSuaLichHop;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

public class LichHopService {

    private final LichHopDAO lichHopDAO = new LichHopDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    // ==================== LỊCH HỌP ====================

    public boolean taoLichHop(LichHop lh, int nguoiTaoID) {
        String loi = validateLichHop(lh);
        if (loi != null) throw new IllegalArgumentException(loi);

        lh.setNguoiTaoID(nguoiTaoID);
        lh.setTrangThai(1);

        int lichHopID = lichHopDAO.taoLichHop(lh);
        if (lichHopID == -1) return false;

        lh.setLichHopID(lichHopID);

        String tieuDe  = "[Lịch họp mới] " + lh.getTieuDe();
        String noiDung = buildNoiDungThongBao(lh, false);
        lichHopDAO.guiThongBaoDenChuHo(lichHopID, lh.getToDanPhoID(),
                nguoiTaoID, tieuDe, noiDung);

        return true;
    }

    public boolean suaLichHop(LichHop lhMoi, int nguoiSuaID, String lyDoSua) {

        if (lyDoSua == null || lyDoSua.trim().isEmpty())
            throw new IllegalArgumentException("Vui lòng nhập lý do chỉnh sửa.");

        Map<String, Object> truoc = lichHopDAO.getLichHopByID(lhMoi.getLichHopID());
        if (truoc == null) throw new IllegalArgumentException("Lịch họp không tồn tại.");

        int trangThaiHienTai = (int) truoc.get("trangThai");
        if (trangThaiHienTai != 1)
            throw new IllegalArgumentException(
                "Không thể chỉnh sửa lịch họp đã bắt đầu hoặc kết thúc.");

        String loi = validateNoiDung(lhMoi);
        if (loi != null) throw new IllegalArgumentException(loi);

        lhMoi.setTrangThai(1);

        boolean ok = lichHopDAO.suaLichHop(lhMoi);
        if (!ok) return false;

        String snapshot = buildSnapshot(truoc, toMap(lhMoi));
        LichSuSuaLichHop ls = new LichSuSuaLichHop();
        ls.setLichHopID(lhMoi.getLichHopID());
        ls.setNguoiSuaID(nguoiSuaID);
        ls.setThoiGianSua(LocalDateTime.now());
        ls.setNoiDungThayDoi(snapshot);
        ls.setLyDoSua(lyDoSua.trim());
        lichHopDAO.ghiLichSuSua(ls);

        String tieuDe  = "[Cập nhật lịch họp] " + lhMoi.getTieuDe();
        String noiDung = buildNoiDungThongBao(lhMoi, true)
                       + "\nLý do thay đổi: " + lyDoSua.trim();
        lichHopDAO.guiThongBaoDenChuHo(lhMoi.getLichHopID(), lhMoi.getToDanPhoID(),
                nguoiSuaID, tieuDe, noiDung);

        return true;
    }

    public List<Map<String, Object>> getLichHopByToDanPho(int toDanPhoID) {
        if (toDanPhoID <= 0) throw new IllegalArgumentException("ToDanPhoID không hợp lệ.");
        return lichHopDAO.getLichHopByToDanPho(toDanPhoID);
    }

    public Map<String, Object> getLichHopByID(int lichHopID) {
        if (lichHopID <= 0) throw new IllegalArgumentException("LichHopID không hợp lệ.");
        Map<String, Object> lh = lichHopDAO.getLichHopByID(lichHopID);
        if (lh == null) throw new IllegalArgumentException("Lịch họp không tồn tại.");
        return lh;
    }

    // ==================== [MỚI] DÀNH CHO NGƯỜI DÂN ====================

    /**
     * Lấy danh sách lịch họp có lọc — dành cho người dân.
     *
     * @param toDanPhoID   lấy từ session (NguoiDung.toDanPhoID)
     * @param trangThaiStr "1"/"2"/"3"/"4" hoặc null/rỗng = tất cả
     * @param tuNgayStr    "yyyy-MM-dd" hoặc null/rỗng
     * @param denNgayStr   "yyyy-MM-dd" hoặc null/rỗng
     */
    public List<Map<String, Object>> getLichHopNguoiDan(int toDanPhoID,
                                                         String trangThaiStr,
                                                         String tuNgayStr,
                                                         String denNgayStr) {
        if (toDanPhoID <= 0) throw new IllegalArgumentException("Tổ dân phố không hợp lệ.");

        Integer   trangThai = parseIntSafe(trangThaiStr);
        Timestamp tuNgay    = parseNgayBatDau(tuNgayStr);   // 00:00:00
        Timestamp denNgay   = parseNgayKetThuc(denNgayStr); // 23:59:59

        // Validate khoảng ngày nếu cả hai đều có
        if (tuNgay != null && denNgay != null && tuNgay.after(denNgay))
            throw new IllegalArgumentException("Ngày bắt đầu phải trước ngày kết thúc.");

        return lichHopDAO.getLichHopNguoiDan(toDanPhoID, trangThai, tuNgay, denNgay);
    }

    /**
     * Lấy chi tiết lịch họp — người dân chỉ xem được của đúng tổ mình.
     *
     * @param lichHopID         ID lịch họp muốn xem
     * @param toDanPhoCuaNguoiDan  lấy từ session
     * @throws IllegalArgumentException nếu không tìm thấy hoặc không có quyền
     */
    public Map<String, Object> getChiTietLichHopNguoiDan(int lichHopID, int toDanPhoCuaNguoiDan) {
        if (lichHopID <= 0)           throw new IllegalArgumentException("LichHopID không hợp lệ.");
        if (toDanPhoCuaNguoiDan <= 0) throw new IllegalArgumentException("Tổ dân phố không hợp lệ.");

        Map<String, Object> lh = lichHopDAO.getLichHopChiTietNguoiDan(lichHopID, toDanPhoCuaNguoiDan);
        if (lh == null)
            throw new IllegalArgumentException("Lịch họp không tồn tại hoặc bạn không có quyền xem.");

        return lh;
    }

    // ==================== LỊCH SỬ SỬA ====================

    public List<Map<String, Object>> getLichSuSua(int lichHopID) {
        if (lichHopID <= 0) throw new IllegalArgumentException("LichHopID không hợp lệ.");
        return lichHopDAO.getLichSuSuaByLichHopID(lichHopID);
    }

    // ==================== THÔNG BÁO ====================

    public List<Map<String, Object>> getTrangThaiDocThongBao(int lichHopID) {
        if (lichHopID <= 0) throw new IllegalArgumentException("LichHopID không hợp lệ.");
        return lichHopDAO.getTrangThaiDocThongBao(lichHopID);
    }

    // ==================== PRIVATE HELPERS ====================

    private String validateNoiDung(LichHop lh) {
        if (lh.getTieuDe() == null || lh.getTieuDe().trim().isEmpty())
            return "Tiêu đề không được để trống.";
        if (lh.getDiaDiem() == null || lh.getDiaDiem().trim().isEmpty())
            return "Địa điểm không được để trống.";
        if (lh.getThoiGianBatDau() == null)
            return "Thời gian bắt đầu không được để trống.";
        if (lh.getThoiGianKetThuc() != null &&
            !lh.getThoiGianKetThuc().isAfter(lh.getThoiGianBatDau()))
            return "Thời gian kết thúc phải sau thời gian bắt đầu.";
        if (lh.getToDanPhoID() <= 0)
            return "Tổ dân phố không hợp lệ.";
        if (lh.getMucDo() < 1 || lh.getMucDo() > 3)
            return "Mức độ quan trọng không hợp lệ.";
        if (lh.getDoiTuong() == null || lh.getDoiTuong().trim().isEmpty())
            return "Vui lòng chọn đối tượng tham gia.";
        return null;
    }

    private String validateLichHop(LichHop lh) {
        String loi = validateNoiDung(lh);
        if (loi != null) return loi;
        if (!lh.getThoiGianBatDau().isAfter(LocalDateTime.now()))
            return "Thời gian bắt đầu phải sau thời điểm hiện tại.";
        return null;
    }

    private String buildNoiDungThongBao(LichHop lh, boolean laCauNhat) {
        String[] mucDoLabel = {"", "Bình thường", "Quan trọng", "Khẩn cấp"};
        String mucDo = (lh.getMucDo() >= 1 && lh.getMucDo() <= 3)
                ? mucDoLabel[lh.getMucDo()] : "";
        String prefix = laCauNhat ? "Lịch họp đã được cập nhật:\n" : "Lịch họp mới:\n";
        return prefix +
               "• Tiêu đề  : " + lh.getTieuDe() + "\n" +
               "• Địa điểm : " + lh.getDiaDiem() + "\n" +
               "• Thời gian: " + lh.getThoiGianBatDau() +
               (lh.getThoiGianKetThuc() != null ? " → " + lh.getThoiGianKetThuc() : "") + "\n" +
               "• Mức độ   : " + mucDo + "\n" +
               (lh.getNoiDung() != null && !lh.getNoiDung().isEmpty()
                       ? "• Nội dung : " + lh.getNoiDung() : "");
    }

    private Map<String, Object> toMap(LichHop lh) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("tieuDe",          lh.getTieuDe());
        map.put("noiDung",         lh.getNoiDung());
        map.put("diaDiem",         lh.getDiaDiem());
        map.put("thoiGianBatDau",  String.valueOf(lh.getThoiGianBatDau()));
        map.put("thoiGianKetThuc", String.valueOf(lh.getThoiGianKetThuc()));
        map.put("trangThai",       lh.getTrangThai());
        map.put("mucDo",           lh.getMucDo());
        map.put("doiTuong",        lh.getDoiTuong());
        return map;
    }

    private String buildSnapshot(Map<String, Object> truoc, Map<String, Object> sau) {
        try {
            Map<String, Object> snapshot = new LinkedHashMap<>();
            snapshot.put("truoc", truoc);
            snapshot.put("sau",   sau);
            return objectMapper.writeValueAsString(snapshot);
        } catch (Exception e) {
            return "{\"loi\":\"Không thể tạo snapshot\"}";
        }
    }

    // Parse an toàn cho Integer
    private Integer parseIntSafe(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return Integer.parseInt(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    // Parse "yyyy-MM-dd" → Timestamp lúc 00:00:00 (dùng cho tuNgay)
    private Timestamp parseNgayBatDau(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return Timestamp.valueOf(LocalDate.parse(s.trim()).atStartOfDay()); }
        catch (Exception e) { return null; }
    }

    // Parse "yyyy-MM-dd" → Timestamp lúc 23:59:59 (dùng cho denNgay)
    private Timestamp parseNgayKetThuc(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return Timestamp.valueOf(LocalDate.parse(s.trim()).atTime(23, 59, 59)); }
        catch (Exception e) { return null; }
    }
}