package Model.Service;

import Model.DAO.NguoiDungDAO;
import Model.DAO.YeuCauDoiTrangThaiDAO;
import Model.DAO.ThongBaoDAO;
import Model.Entity.NguoiDung;
import Model.Entity.YeuCauDoiTrangThai;

import java.util.*;

public class YeuCauDoiTrangThaiService {

    private final YeuCauDoiTrangThaiDAO yeuCauDAO   = new YeuCauDoiTrangThaiDAO();
    private final ThongBaoDAO           thongBaoDAO = new ThongBaoDAO();
    private final NguoiDungDAO          nguoiDungDAO = new NguoiDungDAO();

    // ------------------------------------------------------------------ //
    //  LOẠI 1: Tạo yêu cầu đổi trạng thái HỘ (tổ trưởng)
    // ------------------------------------------------------------------ //
    public Map<String, Object> taoYeuCau(int hoDanID, int trangThaiCuID,
            int trangThaiMoiID, int nguoiYeuCauID, String lyDo) {
        Map<String, Object> result = new HashMap<>();
        if (lyDo == null || lyDo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do yêu cầu.");
            return result;
        }
        if (trangThaiCuID == trangThaiMoiID) {
            result.put("success", false);
            result.put("message", "Trạng thái mới phải khác trạng thái hiện tại.");
            return result;
        }
        if (yeuCauDAO.dangCoYeuCauChoDuyet(hoDanID)) {
            result.put("success", false);
            result.put("message", "Hộ dân này đang có yêu cầu chờ duyệt, không thể tạo thêm.");
            return result;
        }

        // ✅ DAO đã tự gửi thông báo đúng với yeuCauID bên trong transaction
        boolean ok = yeuCauDAO.taoYeuCau(hoDanID, trangThaiCuID, trangThaiMoiID,
                nguoiYeuCauID, lyDo.trim());
        if (ok) {
            result.put("success", true);
            result.put("message", "Gửi yêu cầu thành công, đang chờ cán bộ phường xét duyệt.");
        } else {
            result.put("success", false);
            result.put("message", "Gửi yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  LOẠI 2: Tạo yêu cầu cập nhật thông tin CÁ NHÂN (hộ dân)
    // ------------------------------------------------------------------ //
    public Map<String, Object> taoYeuCauCapNhat(int nguoiDungID,
            YeuCauDoiTrangThai thongTinMoi, String lyDo) {
        Map<String, Object> result = new HashMap<>();
        if (lyDo == null || lyDo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do cập nhật.");
            return result;
        }
        if (yeuCauDAO.dangCoYeuCauCapNhatChoDuyet(nguoiDungID)) {
            result.put("success", false);
            result.put("message", "Bạn đang có yêu cầu cập nhật chờ duyệt. "
                    + "Vui lòng chờ cán bộ phường xử lý hoặc huỷ yêu cầu cũ trước.");
            return result;
        }

        NguoiDung cu = nguoiDungDAO.layTheoID(nguoiDungID);
        if (cu == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy thông tin người dùng.");
            return result;
        }

        thongTinMoi.setLyDoYeuCau(lyDo.trim());
        thongTinMoi.setHo_Cu(cu.getHo());
        thongTinMoi.setTen_Cu(cu.getTen());
        thongTinMoi.setNgaySinh_Cu(cu.getNgaySinh());
        thongTinMoi.setGioiTinh_Cu(cu.getGioiTinh());
        thongTinMoi.setEmail_Cu(cu.getEmail());
        thongTinMoi.setSDT_Cu(cu.getSoDienThoai());
        thongTinMoi.setCCCD_Cu(cu.getCccd());
        thongTinMoi.setAvatar_Cu(cu.getAvatarPath());
        thongTinMoi.setCCCD_Moi(null);
        thongTinMoi.setNgaySinh_Moi(null);

        // ✅ DAO đã tự gửi thông báo đúng với yeuCauID bên trong transaction
        boolean ok = yeuCauDAO.taoYeuCauCapNhat(nguoiDungID, thongTinMoi, thongBaoDAO);
        if (ok) {
            result.put("success", true);
            result.put("message", "Gửi yêu cầu thành công, đang chờ cán bộ phường xét duyệt.");
        } else {
            result.put("success", false);
            result.put("message", "Gửi yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  LOẠI 3: Tạo yêu cầu đổi trạng thái TỪNG NHÂN KHẨU (tổ trưởng)
    // ------------------------------------------------------------------ //
    public Map<String, Object> taoYeuCauNhanKhau(int nhanKhauID, int trangThaiCuID,
            int trangThaiMoiID, int nguoiYeuCauID, String lyDo) {
        Map<String, Object> result = new HashMap<>();
        if (lyDo == null || lyDo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do yêu cầu.");
            return result;
        }
        if (trangThaiCuID == trangThaiMoiID) {
            result.put("success", false);
            result.put("message", "Trạng thái mới phải khác trạng thái hiện tại.");
            return result;
        }
        if (yeuCauDAO.dangCoYeuCauNhanKhauChoDuyet(nhanKhauID)) {
            result.put("success", false);
            result.put("message", "Nhân khẩu này đang có yêu cầu chờ duyệt, không thể tạo thêm.");
            return result;
        }

        NguoiDung cu = nguoiDungDAO.layTheoThanhVienID(nhanKhauID);
        if (cu == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy thông tin nhân khẩu.");
            return result;
        }

        YeuCauDoiTrangThai snapshot = new YeuCauDoiTrangThai();
        snapshot.setHo_Cu(cu.getHo());
        snapshot.setTen_Cu(cu.getTen());
        snapshot.setNgaySinh_Cu(cu.getNgaySinh());
        snapshot.setGioiTinh_Cu(cu.getGioiTinh());
        snapshot.setEmail_Cu(cu.getEmail());
        snapshot.setSDT_Cu(cu.getSoDienThoai());
        snapshot.setCCCD_Cu(cu.getCccd());
        snapshot.setAvatar_Cu(cu.getAvatarPath());

        // ✅ DAO đã tự gửi thông báo đúng với yeuCauID bên trong transaction
        // KHÔNG gọi thêm guiThongBaoTheoVaiTro ở đây nữa
        boolean ok = yeuCauDAO.taoYeuCauNhanKhau(nhanKhauID, trangThaiCuID,
                trangThaiMoiID, nguoiYeuCauID, lyDo.trim(), snapshot);
        if (ok) {
            result.put("success", true);
            result.put("message", "Gửi yêu cầu thành công, đang chờ cán bộ phường xét duyệt.");
        } else {
            result.put("success", false);
            result.put("message", "Gửi yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  DUYỆT yêu cầu (cán bộ phường - cả 3 loại)
    // ------------------------------------------------------------------ //
    public Map<String, Object> duyetYeuCau(int yeuCauID, int nguoiDuyetID, String ghiChu) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> yeuCau = yeuCauDAO.layTheoID(yeuCauID);
        if (yeuCau == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy yêu cầu.");
            return result;
        }
        if ((int) yeuCau.get("trangThaiYeuCauID") != 1) {
            result.put("success", false);
            result.put("message", "Yêu cầu này đã được xử lý trước đó.");
            return result;
        }

        boolean ok = yeuCauDAO.duyetYeuCau(yeuCauID, nguoiDuyetID,
                ghiChu != null ? ghiChu.trim() : "", thongBaoDAO);
        if (ok) {
            int loai = (int) yeuCau.get("loaiYeuCau");
            result.put("success", true);
            result.put("message", loai == 1 ? "Duyệt yêu cầu đổi trạng thái hộ thành công."
                    : loai == 2 ? "Duyệt yêu cầu cập nhật thông tin thành công."
                    : "Duyệt yêu cầu đổi trạng thái nhân khẩu thành công.");
        } else {
            result.put("success", false);
            result.put("message", "Duyệt yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  TỪ CHỐI yêu cầu (cán bộ phường - cả 3 loại)
    // ------------------------------------------------------------------ //
    public Map<String, Object> tuChoiYeuCau(int yeuCauID, int nguoiDuyetID, String lyDoTuChoi) {
        Map<String, Object> result = new HashMap<>();
        if (lyDoTuChoi == null || lyDoTuChoi.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do từ chối.");
            return result;
        }
        Map<String, Object> yeuCau = yeuCauDAO.layTheoID(yeuCauID);
        if (yeuCau == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy yêu cầu.");
            return result;
        }
        if ((int) yeuCau.get("trangThaiYeuCauID") != 1) {
            result.put("success", false);
            result.put("message", "Yêu cầu này đã được xử lý trước đó.");
            return result;
        }

        boolean ok = yeuCauDAO.tuChoiYeuCau(yeuCauID, nguoiDuyetID,
                lyDoTuChoi.trim(), thongBaoDAO);
        if (ok) {
            result.put("success", true);
            result.put("message", "Đã từ chối yêu cầu.");
        } else {
            result.put("success", false);
            result.put("message", "Từ chối thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  HUỶ yêu cầu (tổ trưởng / hộ dân tự huỷ)
    // ------------------------------------------------------------------ //
    public Map<String, Object> huyYeuCau(int yeuCauID, int nguoiYeuCauID) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> yeuCau = yeuCauDAO.layTheoID(yeuCauID);
        if (yeuCau == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy yêu cầu.");
            return result;
        }
        if ((int) yeuCau.get("nguoiYeuCauID") != nguoiYeuCauID) {
            result.put("success", false);
            result.put("message", "Bạn không có quyền huỷ yêu cầu này.");
            return result;
        }
        if ((int) yeuCau.get("trangThaiYeuCauID") != 1) {
            result.put("success", false);
            result.put("message", "Chỉ có thể huỷ yêu cầu đang ở trạng thái chờ duyệt.");
            return result;
        }

        boolean ok = yeuCauDAO.huyYeuCau(yeuCauID, nguoiYeuCauID);
        if (ok) {
            result.put("success", true);
            result.put("message", "Đã huỷ yêu cầu thành công.");
        } else {
            result.put("success", false);
            result.put("message", "Huỷ yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  CÁC METHOD QUERY
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachChoDuyet() {
        return yeuCauDAO.layDanhSachChoDuyet();
    }

    public List<Map<String, Object>> layDanhSachTheoTo(int toDanPhoID) {
        return yeuCauDAO.layDanhSachTheoTo(toDanPhoID);
    }

    public List<Map<String, Object>> layTatCa() {
        return yeuCauDAO.layTatCa();
    }

    public Map<String, Object> layChiTiet(int yeuCauID) {
        return yeuCauDAO.layTheoID(yeuCauID);
    }

    public Map<String, Object> layChiTietTheoThongBao(int thongBaoID) {
        return yeuCauDAO.layChiTietTheoThongBao(thongBaoID);
    }

    public List<Map<String, Object>> layDanhSachCapNhatChoDuyet() {
        return yeuCauDAO.layDanhSachCapNhatChoDuyet();
    }

    public List<Map<String, Object>> layDanhSachCapNhatCuaNguoiDung(int nguoiDungID) {
        return yeuCauDAO.layDanhSachCapNhatCuaNguoiDung(nguoiDungID);
    }
}