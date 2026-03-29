package Model.Service;

import Model.DAO.NguoiDungDAO;
import org.mindrot.jbcrypt.BCrypt;
import Model.Entity.NguoiDung;
import java.util.List;

public class NguoiDungService {

    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    private static final int VAI_TRO_TO_TRUONG      = 3;
    private static final int VAI_TRO_CAN_BO_PHUONG  = 5;

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    public boolean changePassword(int nguoiDungID, String currentPw, String newPw, String confirmPw) {
        if (newPw == null || !newPw.equals(confirmPw)) return false;
        if (!nguoiDungDAO.checkCurrentPassword(nguoiDungID, currentPw)) return false;
        if (nguoiDungDAO.checkCurrentPassword(nguoiDungID, newPw)) return false;
        return nguoiDungDAO.updatePassword(nguoiDungID, newPw);
    }

    // ✅ MỚI: cập nhật avatar
    public boolean updateAvatar(int nguoiDungID, String avatarPath) {
        if (nguoiDungID <= 0 || isBlank(avatarPath)) return false;
        return nguoiDungDAO.updateAvatar(nguoiDungID, avatarPath);
    }

    public String taoToTruong(String cccd, String ho, String ten,
            String ngaySinhStr, String gioiTinh,
            String email, String soDienThoai,
            String matKhau, String tenTo) {
 
        if (isBlank(cccd) || isBlank(ho) || isBlank(ten)
                || isBlank(ngaySinhStr) || isBlank(gioiTinh)
                || isBlank(email) || isBlank(soDienThoai)
                || isBlank(matKhau) || isBlank(tenTo)) {
            return "Vui lòng điền đầy đủ tất cả các trường.";
        }
        if (!cccd.matches("\\d{12}")) {
            return "CCCD phải gồm đúng 12 chữ số.";
        }
        if (!soDienThoai.matches("0\\d{9,10}")) {
            return "Số điện thoại không hợp lệ.";
        }
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "Email không hợp lệ.";
        }
        if (matKhau.length() < 8
                || !matKhau.matches(".*[A-Z].*")
                || !matKhau.matches(".*[0-9].*")
                || !matKhau.matches(".*[^A-Za-z0-9].*")) {
            return "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 số, 1 ký tự đặc biệt.";
        }
        if (nguoiDungDAO.isCccdExist(cccd.trim())) {
            return "CCCD này đã tồn tại trong hệ thống.";
        }
        if (nguoiDungDAO.isEmailExist(email.trim())) {
            return "Email này đã tồn tại trong hệ thống.";
        }
 
        java.sql.Date ngaySinh;
        try {
            ngaySinh = java.sql.Date.valueOf(ngaySinhStr);
        } catch (IllegalArgumentException e) {
            return "Ngày sinh không hợp lệ.";
        }
 
        // ✅ RULE 1: Lấy hoặc tạo tổ dân phố, sau đó kiểm tra xung đột
        Integer toDanPhoID = nguoiDungDAO.getOrCreateToDanPhoByTen(tenTo.trim());
        if (toDanPhoID == null) {
            return "Không thể xác định tổ dân phố, vui lòng thử lại.";
        }
 
        // Chặn nếu tổ đã có tổ trưởng đang công tác (trangThaiNhanSu = 1)
        if (nguoiDungDAO.coToTruongDangCongTac(toDanPhoID)) {
            return "Tổ \"" + tenTo.trim() + "\" đã có Tổ trưởng đang công tác. "
                 + "Vui lòng chuyển trạng thái Tổ trưởng cũ sang "
                 + "\"Không còn tại vị\" hoặc \"Đã mất / Nghỉ hưu\" trước khi tạo mới.";
        }
 
        String matKhauHash = BCrypt.hashpw(matKhau, BCrypt.gensalt(12));
 
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

    public List<NguoiDung> getDanhSachToTruong(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return nguoiDungDAO.getDanhSachToTruong();
        }
        return nguoiDungDAO.searchToTruong(keyword.trim());
    }

    public boolean toggleKhoaTaiKhoan(int nguoiDungID, boolean khoaHayMo) {
        return nguoiDungDAO.setActivated(nguoiDungID, khoaHayMo);
    }

   public String updateTrangThaiNhanSu(int nguoiDungID, int trangThaiMoi) {
        if (trangThaiMoi < 1 || trangThaiMoi > 3) {
            return "Trạng thái không hợp lệ.";
        }
 
        // ✅ RULE 2: Lấy trạng thái hiện tại, chặn revert từ trạng thái 3
        int trangThaiHienTai = nguoiDungDAO.getTrangThaiNhanSu(nguoiDungID);
        if (trangThaiHienTai == -1) {
            return "Không tìm thấy người dùng.";
        }
        if (trangThaiHienTai == 3) {
            return "Tài khoản đã ở trạng thái \"Đã mất / Nghỉ hưu\" và không thể thay đổi.";
        }
 
        boolean ok = nguoiDungDAO.updateTrangThaiNhanSu(nguoiDungID, trangThaiMoi);
        return ok ? null : "Cập nhật trạng thái thất bại, vui lòng thử lại.";
    }

    public String taoCanBoPhuong(String ho, String ten,
            String ngaySinhStr, String gioiTinh,
            String email, String soDienThoai, String matKhau) {

        if (isBlank(ho) || isBlank(ten) || isBlank(ngaySinhStr)
                || isBlank(gioiTinh) || isBlank(email)
                || isBlank(soDienThoai) || isBlank(matKhau)) {
            return "Vui lòng điền đầy đủ tất cả các trường.";
        }
        if (!soDienThoai.matches("0\\d{9,10}")) {
            return "Số điện thoại không hợp lệ.";
        }
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "Email không hợp lệ.";
        }
        if (matKhau.length() < 8
                || !matKhau.matches(".*[A-Z].*")
                || !matKhau.matches(".*[0-9].*")
                || !matKhau.matches(".*[^A-Za-z0-9].*")) {
            return "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 số, 1 ký tự đặc biệt.";
        }
        if (nguoiDungDAO.isEmailExist(email.trim())) {
            return "Email này đã tồn tại trong hệ thống.";
        }

        java.sql.Date ngaySinh;
        try {
            ngaySinh = java.sql.Date.valueOf(ngaySinhStr);
        } catch (IllegalArgumentException e) {
            return "Ngày sinh không hợp lệ.";
        }

        String matKhauHash = BCrypt.hashpw(matKhau, BCrypt.gensalt(12));

        NguoiDung nd = new NguoiDung();
        nd.setHo(ho.trim());
        nd.setTen(ten.trim());
        nd.setNgaySinh(ngaySinh);
        nd.setGioiTinh(gioiTinh.trim());
        nd.setEmail(email.trim().toLowerCase());
        nd.setSoDienThoai(soDienThoai.trim());
        nd.setMatKhauHash(matKhauHash);
        nd.setVaiTroID(VAI_TRO_CAN_BO_PHUONG);
        nd.setToDanPhoID(null);
        nd.setIsActivated(true);

        boolean ok = nguoiDungDAO.taoCanBoPhuong(nd);
        return ok ? null : "Tạo tài khoản thất bại, vui lòng thử lại.";
    }

    public List<NguoiDung> getDanhSachCanBoPhuong(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return nguoiDungDAO.getDanhSachCanBoPhuong();
        }
        return nguoiDungDAO.searchCanBoPhuong(keyword.trim());
    }
}