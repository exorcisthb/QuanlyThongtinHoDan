package Model.Service;

import Model.DAO.LichHopDAO;
import Model.Entity.LichHop;
import Model.Entity.LichSuSuaLichHop;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class LichHopService {

    private final LichHopDAO lichHopDAO = new LichHopDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    // ==================== TIMEZONE VN ====================

    private static final ZoneId ZONE_VN = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter FMT_THONGBAO =
            DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

    // ==================== LỊCH HỌP ====================

    public boolean taoLichHop(LichHop lh, int nguoiTaoID) {
        String loi = validateLichHop(lh, true); // true = bắt buộc phải trong tương lai
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

        // FIX #2: khi sửa cũng validate đầy đủ (bao gồm kiểm tra năm hợp lệ),
        // nhưng KHÔNG bắt buộc phải trong tương lai (cho phép giữ nguyên giờ cũ)
        String loi = validateLichHop(lhMoi, false);
        if (loi != null) throw new IllegalArgumentException(loi);

        lhMoi.setTrangThai(1);

        boolean ok = lichHopDAO.suaLichHop(lhMoi);
        if (!ok) return false;

        String snapshot = buildSnapshot(truoc, toMap(lhMoi));
        LichSuSuaLichHop ls = new LichSuSuaLichHop();
        ls.setLichHopID(lhMoi.getLichHopID());
        ls.setNguoiSuaID(nguoiSuaID);
        ls.setThoiGianSua(LocalDateTime.now(ZONE_VN)); // FIX #1: timezone VN
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

    // ==================== DÀNH CHO NGƯỜI DÂN ====================

    public List<Map<String, Object>> getLichHopNguoiDan(int toDanPhoID,
                                                         String trangThaiStr,
                                                         String tuNgayStr,
                                                         String denNgayStr) {
        if (toDanPhoID <= 0) throw new IllegalArgumentException("Tổ dân phố không hợp lệ.");

        Integer   trangThai = parseIntSafe(trangThaiStr);   // FIX #5: validate trangThai
        Timestamp tuNgay    = parseNgayBatDau(tuNgayStr);   // FIX #3: ném lỗi nếu sai định dạng
        Timestamp denNgay   = parseNgayKetThuc(denNgayStr); // FIX #3: ném lỗi nếu sai định dạng

        if (tuNgay != null && denNgay != null && tuNgay.after(denNgay))
            throw new IllegalArgumentException("Ngày bắt đầu phải trước ngày kết thúc.");

        return lichHopDAO.getLichHopNguoiDan(toDanPhoID, trangThai, tuNgay, denNgay);
    }

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

    /**
     * Validate nội dung cơ bản — dùng cho cả tạo lẫn sửa.
     * Bao gồm kiểm tra năm hợp lệ (2000–2100) để tránh nhập nhầm năm 20000.
     */
    private String validateNoiDung(LichHop lh) {
        if (lh.getTieuDe() == null || lh.getTieuDe().trim().isEmpty())
            return "Tiêu đề không được để trống.";
        if (lh.getDiaDiem() == null || lh.getDiaDiem().trim().isEmpty())
            return "Địa điểm không được để trống.";
        if (lh.getThoiGianBatDau() == null)
            return "Thời gian bắt đầu không được để trống.";

        // FIX #2: kiểm tra năm hợp lệ — tránh nhập năm 20000, 1800, v.v.
        int namBatDau = lh.getThoiGianBatDau().getYear();
        if (namBatDau < 2000 || namBatDau > 2100)
            return "Thời gian bắt đầu không hợp lệ (năm phải từ 2000 đến 2100).";

        if (lh.getThoiGianKetThuc() != null) {
            if (!lh.getThoiGianKetThuc().isAfter(lh.getThoiGianBatDau()))
                return "Thời gian kết thúc phải sau thời gian bắt đầu.";
            int namKetThuc = lh.getThoiGianKetThuc().getYear();
            if (namKetThuc < 2000 || namKetThuc > 2100)
                return "Thời gian kết thúc không hợp lệ (năm phải từ 2000 đến 2100).";
        }

        if (lh.getToDanPhoID() <= 0)
            return "Tổ dân phố không hợp lệ.";
        if (lh.getMucDo() < 1 || lh.getMucDo() > 3)
            return "Mức độ quan trọng không hợp lệ.";
        if (lh.getDoiTuong() == null || lh.getDoiTuong().trim().isEmpty())
            return "Vui lòng chọn đối tượng tham gia.";
        return null;
    }

    /**
     * FIX #1 + #2: dùng timezone VN, và tách biệt rõ khi nào cần check tương lai.
     *
     * @param checkTuongLai true khi tạo mới (bắt buộc phải sau hiện tại),
     *                      false khi sửa (chỉ cần năm hợp lệ)
     */
    private String validateLichHop(LichHop lh, boolean checkTuongLai) {
        String loi = validateNoiDung(lh);
        if (loi != null) return loi;

        if (checkTuongLai) {
            // FIX #1: dùng ZoneId VN thay vì LocalDateTime.now() không có timezone
            LocalDateTime nowVN = LocalDateTime.now(ZONE_VN);
            if (!lh.getThoiGianBatDau().isAfter(nowVN))
                return "Thời gian bắt đầu phải sau thời điểm hiện tại.";
        }

        return null;
    }

    /**
     * FIX #4: format thời gian đẹp (HH:mm dd/MM/yyyy) thay vì in LocalDateTime thô.
     */
    private String buildNoiDungThongBao(LichHop lh, boolean laCauNhat) {
        String[] mucDoLabel = {"", "Bình thường", "Quan trọng", "Khẩn cấp"};
        String mucDo = (lh.getMucDo() >= 1 && lh.getMucDo() <= 3)
                ? mucDoLabel[lh.getMucDo()] : "";
        String prefix = laCauNhat ? "Lịch họp đã được cập nhật:\n" : "Lịch họp mới:\n";

        // FIX #4: format thời gian cho người dân dễ đọc
        String thoiGianBD = lh.getThoiGianBatDau() != null
                ? lh.getThoiGianBatDau().format(FMT_THONGBAO) : "—";
        String thoiGianKT = lh.getThoiGianKetThuc() != null
                ? " → " + lh.getThoiGianKetThuc().format(FMT_THONGBAO) : "";

        return prefix +
               "• Tiêu đề  : " + lh.getTieuDe() + "\n" +
               "• Địa điểm : " + lh.getDiaDiem() + "\n" +
               "• Thời gian: " + thoiGianBD + thoiGianKT + "\n" +
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

    /**
     * FIX #5: validate trangThai phải là 1–4, không nuốt giá trị rác im lặng.
     */
    private Integer parseIntSafe(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            int val = Integer.parseInt(s.trim());
            if (val < 1 || val > 4)
                throw new IllegalArgumentException(
                    "Trạng thái không hợp lệ, giá trị phải từ 1 đến 4.");
            return val;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Trạng thái phải là số nguyên.");
        }
    }

    /**
     * FIX #3: ném lỗi rõ ràng nếu định dạng ngày sai, không nuốt im lặng trả null.
     */
    private Timestamp parseNgayBatDau(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            return Timestamp.valueOf(LocalDate.parse(s.trim()).atStartOfDay());
        } catch (Exception e) {
            throw new IllegalArgumentException(
                "Định dạng ngày bắt đầu không hợp lệ, dùng yyyy-MM-dd (ví dụ: 2026-03-29).");
        }
    }

    /**
     * FIX #3: ném lỗi rõ ràng nếu định dạng ngày sai, không nuốt im lặng trả null.
     */
    private Timestamp parseNgayKetThuc(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            return Timestamp.valueOf(LocalDate.parse(s.trim()).atTime(23, 59, 59));
        } catch (Exception e) {
            throw new IllegalArgumentException(
                "Định dạng ngày kết thúc không hợp lệ, dùng yyyy-MM-dd (ví dụ: 2026-03-29).");
        }
    }
}