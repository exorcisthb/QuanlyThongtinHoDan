package Model.Service;

import Model.DAO.NguoiDungDAO;
import org.mindrot.jbcrypt.BCrypt;
import Model.Entity.NguoiDung;
import java.util.List;

public class NguoiDungService {

    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    public boolean changePassword(int nguoiDungID, String currentPw, String newPw, String confirmPw) {
        // 1. Xác nhận mật khẩu mới khớp nhau
        if (newPw == null || !newPw.equals(confirmPw)) {
            return false;
        }

        // 2. Kiểm tra mật khẩu hiện tại đúng không
        if (!nguoiDungDAO.checkCurrentPassword(nguoiDungID, currentPw)) {
            return false;
        }

        // 3. Mật khẩu mới không được giống mật khẩu cũ  ← thêm dòng này
        if (nguoiDungDAO.checkCurrentPassword(nguoiDungID, newPw)) {
            return false;
        }

        // 4. Cập nhật
        return nguoiDungDAO.updatePassword(nguoiDungID, newPw);
    }
    // Thêm vào cuối class NguoiDungService, trước dấu }
// Đổi số này đúng với VaiTroID của "Tổ trưởng" trong DB của bạn
    private static final int VAI_TRO_TO_TRUONG = 3;


// ✅ SỬA: đổi param cuối từ toSoStr → tenTo
    public String taoToTruong(String cccd, String ho, String ten,
            String ngaySinhStr, String gioiTinh,
            String email, String soDienThoai,
            String matKhau, String tenTo) {

        // Validate rỗng
        if (isBlank(cccd) || isBlank(ho) || isBlank(ten)
                || isBlank(ngaySinhStr) || isBlank(gioiTinh)
                || isBlank(email) || isBlank(soDienThoai)
                || isBlank(matKhau) || isBlank(tenTo)) {
            return "Vui lòng điền đầy đủ tất cả các trường.";
        }
        // Validate CCCD
        if (!cccd.matches("\\d{12}")) {
            return "CCCD phải gồm đúng 12 chữ số.";
        }
        // Validate SĐT
        if (!soDienThoai.matches("0\\d{9,10}")) {
            return "Số điện thoại không hợp lệ.";
        }
        // Validate email
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "Email không hợp lệ.";
        }
        // Validate mật khẩu
        if (matKhau.length() < 8
                || !matKhau.matches(".*[A-Z].*")
                || !matKhau.matches(".*[0-9].*")
                || !matKhau.matches(".*[^A-Za-z0-9].*")) {
            return "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 số, 1 ký tự đặc biệt.";
        }
        // Kiểm tra trùng
        if (nguoiDungDAO.isCccdExist(cccd.trim())) {
            return "CCCD này đã tồn tại trong hệ thống.";
        }
        if (nguoiDungDAO.isEmailExist(email.trim())) {
            return "Email này đã tồn tại trong hệ thống.";
        }
        // Parse ngày sinh
        java.sql.Date ngaySinh;
        try {
            ngaySinh = java.sql.Date.valueOf(ngaySinhStr);
        } catch (IllegalArgumentException e) {
            return "Ngày sinh không hợp lệ.";
        }
        // ✅ SỬA: Tìm hoặc tự tạo tổ theo tên
        Integer toDanPhoID = nguoiDungDAO.getOrCreateToDanPhoByTen(tenTo);
        if (toDanPhoID == null) {
            return "Không thể xác định tổ dân phố, vui lòng thử lại.";
        }

        // Hash mật khẩu
        String matKhauHash = BCrypt.hashpw(matKhau, BCrypt.gensalt(12));

        // Tạo entity
        NguoiDung nd = new NguoiDung();
        nd.setCccd(cccd.trim());
        nd.setHo(ho.trim());
        nd.setTen(ten.trim());
        nd.setNgaySinh(ngaySinh);
        nd.setGioiTinh(gioiTinh.trim());
        nd.setEmail(email.trim().toLowerCase());
        nd.setSoDienThoai(soDienThoai.trim());
        nd.setMatKhauHash(matKhauHash);
        nd.setVaiTroID(VAI_TRO_TO_TRUONG);
        nd.setToDanPhoID(toDanPhoID);
        nd.setIsActivated(true);

        boolean ok = nguoiDungDAO.taoToTruong(nd);
        return ok ? null : "Tạo tài khoản thất bại, vui lòng thử lại.";
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    public List<NguoiDung> getDanhSachToTruong(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return nguoiDungDAO.getDanhSachToTruong();
        }
        return nguoiDungDAO.searchToTruong(keyword.trim());
    }

    public boolean toggleKhoaTaiKhoan(int nguoiDungID, boolean khoaHayMo) {
        return nguoiDungDAO.setActivated(nguoiDungID, khoaHayMo);
    }
}
