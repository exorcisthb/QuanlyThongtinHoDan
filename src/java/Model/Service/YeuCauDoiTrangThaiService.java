package Model.Service;

import Model.Common.VaiTroConst;
import Model.DAO.NguoiDungDAO;
import Model.DAO.YeuCauDoiTrangThaiDAO;
import Model.DAO.ThongBaoDAO;
import Model.Entity.NguoiDung;
import Model.Entity.YeuCauDoiTrangThai;

import java.util.*;

public class YeuCauDoiTrangThaiService {

    private final YeuCauDoiTrangThaiDAO yeuCauDAO = new YeuCauDoiTrangThaiDAO();
    private final ThongBaoDAO thongBaoDAO = new ThongBaoDAO();
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    // ------------------------------------------------------------------ //
    //  GIỮ NGUYÊN: TẠO YÊU CẦU ĐỔI TRẠNG THÁI (loại 1 - tổ trưởng)
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

        boolean ok = yeuCauDAO.taoYeuCau(hoDanID, trangThaiCuID, trangThaiMoiID,
                nguoiYeuCauID, lyDo.trim());
        if (ok) {
            thongBaoDAO.guiThongBaoTheoVaiTro(
                    "Yêu cầu đổi trạng thái hộ khẩu mới",
                    "Tổ trưởng vừa gửi yêu cầu đổi trạng thái cho hộ dân. Vui lòng kiểm tra và xử lý.",
                    nguoiYeuCauID,
                    VaiTroConst.CAN_BO_PHUONG
            );
            result.put("success", true);
            result.put("message", "Gửi yêu cầu thành công, đang chờ cán bộ phường xét duyệt.");
        } else {
            result.put("success", false);
            result.put("message", "Gửi yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  THÊM MỚI: TẠO YÊU CẦU CẬP NHẬT THÔNG TIN (loại 2 - hộ dân)
    // ------------------------------------------------------------------ //
     public Map<String, Object> taoYeuCauCapNhat(int nguoiDungID,
            YeuCauDoiTrangThai thongTinMoi, String lyDo) {
        Map<String, Object> result = new HashMap<>();
 
        // ── 1. Validate lý do ──
        if (lyDo == null || lyDo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Vui lòng nhập lý do cập nhật.");
            return result;
        }
 
        // ── 2. Chặn trùng: đang có yêu cầu loại 2 chờ duyệt ──
        if (yeuCauDAO.dangCoYeuCauCapNhatChoDuyet(nguoiDungID)) {
            result.put("success", false);
            result.put("message", "Bạn đang có yêu cầu cập nhật chờ duyệt. "
                    + "Vui lòng chờ cán bộ phường xử lý hoặc huỷ yêu cầu cũ trước.");
            return result;
        }
 
        // ── 3. Lấy thông tin hiện tại để snapshot thông tin cũ ──
        NguoiDung cu = nguoiDungDAO.layTheoID(nguoiDungID);
        if (cu == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy thông tin người dùng.");
            return result;
        }
 
        // ── 4. Gán snapshot thông tin cũ ──
        thongTinMoi.setLyDoYeuCau(lyDo.trim());
        thongTinMoi.setHo_Cu(cu.getHo());
        thongTinMoi.setTen_Cu(cu.getTen());
        thongTinMoi.setNgaySinh_Cu(cu.getNgaySinh());
        thongTinMoi.setGioiTinh_Cu(cu.getGioiTinh());
        thongTinMoi.setEmail_Cu(cu.getEmail());
        thongTinMoi.setSDT_Cu(cu.getSoDienThoai());
        thongTinMoi.setCCCD_Cu(cu.getCccd());
        thongTinMoi.setAvatar_Cu(cu.getAvatarPath());
 
        // ── 5. CCCD_Moi và NgaySinh_Moi luôn null — không cho phép sửa ──
        thongTinMoi.setCCCD_Moi(null);
        thongTinMoi.setNgaySinh_Moi(null);
 
        // ── 6. Lưu DB ──
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
    //  GIỮ NGUYÊN + MỞ RỘNG: DUYỆT YÊU CẦU (cán bộ phường - cả 2 loại)
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
            result.put("success", true);
            // Trả về message theo loại để hiển thị đúng trên UI
            int loai = (int) yeuCau.get("loaiYeuCau");
            result.put("message", loai == 1
                    ? "Duyệt yêu cầu đổi trạng thái thành công."
                    : "Duyệt yêu cầu cập nhật thông tin thành công.");
        } else {
            result.put("success", false);
            result.put("message", "Duyệt yêu cầu thất bại, vui lòng thử lại.");
        }
        return result;
    }

    // ------------------------------------------------------------------ //
    //  GIỮ NGUYÊN + MỞ RỘNG: TỪ CHỐI YÊU CẦU (cán bộ phường - cả 2 loại)
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
    //  GIỮ NGUYÊN: HUỶ YÊU CẦU (tổ trưởng / hộ dân tự huỷ)
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
    //  GIỮ NGUYÊN: CÁC METHOD QUERY
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

    // ------------------------------------------------------------------ //
    //  THÊM MỚI: QUERY CHO LOẠI 2
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachCapNhatChoDuyet() {
        return yeuCauDAO.layDanhSachCapNhatChoDuyet();
    }

    public List<Map<String, Object>> layDanhSachCapNhatCuaNguoiDung(int nguoiDungID) {
        return yeuCauDAO.layDanhSachCapNhatCuaNguoiDung(nguoiDungID);
    }
    // ------------------------------------------------------------------ //
//  THÊM MỚI: TẠO YÊU CẦU ĐỔI TRẠNG THÁI TỪNG NHÂN KHẨU (loại 3)
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
    // ✅ THÊM: chặn tạo trùng
    if (yeuCauDAO.dangCoYeuCauNhanKhauChoDuyet(nhanKhauID)) {
        result.put("success", false);
        result.put("message", "Nhân khẩu này đang có yêu cầu chờ duyệt, không thể tạo thêm.");
        return result;
    }
    // ✅ Query snapshot thông tin hiện tại của nhân khẩu
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
    boolean ok = yeuCauDAO.taoYeuCauNhanKhau(nhanKhauID, trangThaiCuID,
            trangThaiMoiID, nguoiYeuCauID, lyDo.trim(), snapshot);
    if (ok) {
        thongBaoDAO.guiThongBaoTheoVaiTro(
                "Yêu cầu đổi trạng thái nhân khẩu mới",
                "Tổ trưởng vừa gửi yêu cầu đổi trạng thái cho nhân khẩu. Vui lòng kiểm tra và xử lý.",
                nguoiYeuCauID,
                VaiTroConst.CAN_BO_PHUONG
        );
        result.put("success", true);
        result.put("message", "Gửi yêu cầu thành công, đang chờ cán bộ phường xét duyệt.");
    } else {
        result.put("success", false);
        result.put("message", "Gửi yêu cầu thất bại, vui lòng thử lại.");
    }
    return result;
}

}
