package Model.DAO;

import Model.Entity.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;

public class NguoiDungDAO {

    public NguoiDung dangNhap(String email, String matKhau) throws Exception {
        String sql = "SELECT nd.*, vt.TenVaiTro " +
                     "FROM NguoiDung nd " +
                     "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID " +
                     "WHERE nd.Email = ?";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashTrongDB = rs.getString("MatKhauHash");

                // Kiểm tra mật khẩu bằng BCrypt
                if (!BCrypt.checkpw(matKhau, hashTrongDB)) {
                    return null; // Sai mật khẩu
                }

                NguoiDung nd = new NguoiDung();
                nd.setNguoiDungID(rs.getInt("NguoiDungID"));
                nd.setCccd(rs.getString("CCCD"));
                nd.setHo(rs.getString("Ho"));
                nd.setTen(rs.getString("Ten"));
                nd.setEmail(rs.getString("Email"));
                nd.setSoDienThoai(rs.getString("SoDienThoai"));
                nd.setVaiTroID(rs.getInt("VaiTroID"));
                nd.setTenVaiTro(rs.getString("TenVaiTro"));
                nd.setIsActivated(rs.getBoolean("IsActivated"));
                return nd;
            }
        }
        return null; // Không tìm thấy email
    }
    public boolean checkCurrentPassword(int nguoiDungID, String currentRawPassword) {
        String sql = "SELECT MatKhauHash FROM NguoiDung WHERE NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hash = rs.getString("MatKhauHash");
                return BCrypt.checkpw(currentRawPassword, hash);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật mật khẩu mới (đã hash)
     * @return true nếu cập nhật thành công
     */
    public boolean updatePassword(int nguoiDungID, String newRawPassword) {
        String hashed = BCrypt.hashpw(newRawPassword, BCrypt.gensalt(12));
        String sql = "UPDATE NguoiDung SET MatKhauHash = ? WHERE NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashed);
            ps.setInt(2, nguoiDungID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}