package Model.Service;

import Model.DAO.LichHopDAO;
import Model.Entity.LichHop;
import Model.Entity.LichSuSuaLichHop;
import com.fasterxml.jackson.databind.ObjectMapper;
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

   // Thay toàn bộ suaLichHop trong LichHopService
public boolean suaLichHop(LichHop lhMoi, int nguoiSuaID, String lyDoSua) {

    if (lyDoSua == null || lyDoSua.trim().isEmpty())
        throw new IllegalArgumentException("Vui lòng nhập lý do chỉnh sửa.");

    // Lấy dữ liệu cũ
    Map<String, Object> truoc = lichHopDAO.getLichHopByID(lhMoi.getLichHopID());
    if (truoc == null) throw new IllegalArgumentException("Lịch họp không tồn tại.");

    // Chỉ cho sửa khi trạng thái = 1 (Sắp diễn ra)
    int trangThaiHienTai = (int) truoc.get("trangThai");
    if (trangThaiHienTai != 1)
        throw new IllegalArgumentException(
            "Không thể chỉnh sửa lịch họp đã bắt đầu hoặc kết thúc.");

    // Validate nội dung (không validate thời gian quá khứ vì tổ trưởng chỉ sửa trước giờ họp)
    String loi = validateNoiDung(lhMoi);
    if (loi != null) throw new IllegalArgumentException(loi);

    // Giữ nguyên trangThai = 1, không cho set từ ngoài vào
    lhMoi.setTrangThai(1);

    boolean ok = lichHopDAO.suaLichHop(lhMoi);
    if (!ok) return false;

    // Ghi lịch sử
    String snapshot = buildSnapshot(truoc, toMap(lhMoi));
    LichSuSuaLichHop ls = new LichSuSuaLichHop();
    ls.setLichHopID(lhMoi.getLichHopID());
    ls.setNguoiSuaID(nguoiSuaID);
    ls.setThoiGianSua(LocalDateTime.now());
    ls.setNoiDungThayDoi(snapshot);
    ls.setLyDoSua(lyDoSua.trim());
    lichHopDAO.ghiLichSuSua(ls);

    // Gửi thông báo cập nhật
    String tieuDe  = "[Cập nhật lịch họp] " + lhMoi.getTieuDe();
    String noiDung = buildNoiDungThongBao(lhMoi, true)
                   + "\nLý do thay đổi: " + lyDoSua.trim();
    lichHopDAO.guiThongBaoDenChuHo(lhMoi.getLichHopID(), lhMoi.getToDanPhoID(),
            nguoiSuaID, tieuDe, noiDung);

    return true;
}

// Tách validate nội dung riêng — dùng cho cả tạo lẫn sửa
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

// validateLichHop dùng riêng cho tạo — thêm check thời gian tương lai
private String validateLichHop(LichHop lh) {
    String loi = validateNoiDung(lh);
    if (loi != null) return loi;
    if (!lh.getThoiGianBatDau().isAfter(LocalDateTime.now()))
        return "Thời gian bắt đầu phải sau thời điểm hiện tại.";
    return null;
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
}