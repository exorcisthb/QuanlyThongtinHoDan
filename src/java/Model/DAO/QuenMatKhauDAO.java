package Model.DAO;

import Model.Entity.NguoiDung;
import Model.Entity.TokenResetMatKhau;
import java.sql.*;

public class QuenMatKhauDAO {

    // ==================== NGUOI DUNG ====================

    public NguoiDung timNguoiDungTheoEmail(String email) {
        // PostgreSQL: IsActivated = 1 → TRUE
        String sql =
            "SELECT NguoiDungID, CCCD, Ho, Ten, NgaySinh, GioiTinh, " +
            "       Email, SoDienThoai, MatKhauHash, VaiTroID, ToDanPhoID, " +
            "       IsActivated, NgayTao " +
            "FROM NguoiDung " +
            "WHERE Email = ? AND IsActivated = TRUE";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setNguoiDungID(rs.getInt("NguoiDungID"));
                nd.setCccd(rs.getString("CCCD"));
                nd.setHo(rs.getString("Ho"));
                nd.setTen(rs.getString("Ten"));
                nd.setNgaySinh(rs.getDate("NgaySinh"));
                nd.setGioiTinh(rs.getString("GioiTinh"));
                nd.setEmail(rs.getString("Email"));
                nd.setSoDienThoai(rs.getString("SoDienThoai"));
                nd.setMatKhauHash(rs.getString("MatKhauHash"));
                nd.setVaiTroID(rs.getInt("VaiTroID"));
                nd.setToDanPhoID(rs.getInt("ToDanPhoID"));
                nd.setIsActivated(rs.getBoolean("IsActivated"));
                nd.setNgayTao(rs.getDate("NgayTao"));
                return nd;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public NguoiDung timNguoiDungTheoCCCDvaSoDienThoai(String cccd, String soDienThoai) {
        String sql =
            "SELECT NguoiDungID, CCCD, Ho, Ten, NgaySinh, GioiTinh, " +
            "       Email, SoDienThoai, MatKhauHash, VaiTroID, ToDanPhoID, " +
            "       IsActivated, NgayTao " +
            "FROM NguoiDung " +
            "WHERE CCCD = ? AND SoDienThoai = ? AND IsActivated = TRUE";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cccd.trim());
            ps.setString(2, soDienThoai.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setNguoiDungID(rs.getInt("NguoiDungID"));
                nd.setCccd(rs.getString("CCCD"));
                nd.setHo(rs.getString("Ho"));
                nd.setTen(rs.getString("Ten"));
                nd.setNgaySinh(rs.getDate("NgaySinh"));
                nd.setGioiTinh(rs.getString("GioiTinh"));
                nd.setEmail(rs.getString("Email"));
                nd.setSoDienThoai(rs.getString("SoDienThoai"));
                nd.setMatKhauHash(rs.getString("MatKhauHash"));
                nd.setVaiTroID(rs.getInt("VaiTroID"));
                nd.setToDanPhoID(rs.getInt("ToDanPhoID"));
                nd.setIsActivated(rs.getBoolean("IsActivated"));
                nd.setNgayTao(rs.getDate("NgayTao"));
                return nd;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean capNhatMatKhau(int nguoiDungID, String matKhauHashMoi) {
        String sql = "UPDATE NguoiDung SET MatKhauHash = ? WHERE NguoiDungID = ?";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, matKhauHashMoi);
            ps.setInt(2, nguoiDungID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean kiemTraCCCDTonTai(String cccd) {
        String sql = "SELECT 1 FROM NguoiDung WHERE CCCD = ? AND IsActivated = TRUE";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cccd.trim());
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==================== TOKEN ====================

    public boolean luuToken(int nguoiDungID, String token, Timestamp ngayHetHan) {
        xoaTokenTheoNguoiDung(nguoiDungID);

        String sql =
            "INSERT INTO TokenResetMatKhau (NguoiDungID, Token, NgayHetHan) " +
            "VALUES (?, ?, ?)";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nguoiDungID);
            ps.setString(2, token);
            ps.setTimestamp(3, ngayHetHan);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public TokenResetMatKhau timTheoToken(String token) {
        String sql =
            "SELECT TokenID, NguoiDungID, Token, NgayHetHan " +
            "FROM TokenResetMatKhau WHERE Token = ?";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                TokenResetMatKhau t = new TokenResetMatKhau();
                t.setTokenID(rs.getInt("TokenID"));
                t.setNguoiDungID(rs.getInt("NguoiDungID"));
                t.setToken(rs.getString("Token"));
                t.setNgayHetHan(rs.getDate("NgayHetHan"));
                return t;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean kiemTraTokenHopLe(String token) {
        // PostgreSQL: NOW() → NOW()
        String sql =
            "SELECT 1 FROM TokenResetMatKhau " +
            "WHERE Token = ? AND NgayHetHan > NOW()";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean xoaToken(String token) {
        String sql = "DELETE FROM TokenResetMatKhau WHERE Token = ?";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void xoaTokenTheoNguoiDung(int nguoiDungID) {
        String sql = "DELETE FROM TokenResetMatKhau WHERE NguoiDungID = ?";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nguoiDungID);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void xoaTokenHetHan() {
        // PostgreSQL: NOW() → NOW()
        String sql = "DELETE FROM TokenResetMatKhau WHERE NgayHetHan <= NOW()";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}