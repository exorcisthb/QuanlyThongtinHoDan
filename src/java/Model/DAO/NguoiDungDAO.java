package Model.DAO;

import Model.Entity.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.Statement;

public class NguoiDungDAO {

 public NguoiDung dangNhap(String email, String matKhau) throws Exception {
    String sql = "SELECT nd.*, vt.TenVaiTro "
            + "FROM NguoiDung nd "
            + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
            + "WHERE nd.Email = ?";
    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String hashTrongDB = rs.getString("MatKhauHash");
            if (!BCrypt.checkpw(matKhau, hashTrongDB)) {
                return null;
            }
            return mapRow(rs); // ✅ thay toàn bộ phần map thủ công
        }
    }
    return null;
}

    public boolean checkCurrentPassword(int nguoiDungID, String currentRawPassword) {
        String sql = "SELECT MatKhauHash FROM NguoiDung WHERE NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return BCrypt.checkpw(currentRawPassword, rs.getString("MatKhauHash"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

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

    public boolean isCccdExist(String cccd) {
        String sql = "SELECT COUNT(*) FROM NguoiDung WHERE CCCD = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cccd);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExist(String email) {
        String sql = "SELECT COUNT(*) FROM NguoiDung WHERE Email = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Integer getOrCreateToDanPhoByTen(String tenTo) {
        String sqlFind = "SELECT ToDanPhoID FROM ToDanPho WHERE TenTo = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlFind)) {
            ps.setNString(1, tenTo.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        String sqlInsert = "INSERT INTO ToDanPho (TenTo) VALUES (?)";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
            ps.setNString(1, tenTo.trim());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean taoToTruong(NguoiDung nd) {
        String sql = "INSERT INTO NguoiDung "
                + "(CCCD, Ho, Ten, NgaySinh, GioiTinh, Email, SoDienThoai, "
                + " MatKhauHash, VaiTroID, ToDanPhoID, IsActivated, NgayTao) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, GETDATE())";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getCccd());
            ps.setNString(2, nd.getHo());
            ps.setNString(3, nd.getTen());
            ps.setDate(4, nd.getNgaySinh());
            ps.setNString(5, nd.getGioiTinh());
            ps.setString(6, nd.getEmail());
            ps.setString(7, nd.getSoDienThoai());
            ps.setString(8, nd.getMatKhauHash());
            ps.setInt(9, nd.getVaiTroID());
            if (nd.getToDanPhoID() != null) {
                ps.setInt(10, nd.getToDanPhoID());
            } else {
                ps.setNull(10, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ SỬA: dùng VaiTroID = 3 thay vì so sánh TenVaiTro (tránh lỗi encoding)
    public List<NguoiDung> getDanhSachToTruong() {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT nd.*, vt.TenVaiTro "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "WHERE nd.VaiTroID = 3 "
                + "ORDER BY nd.NgayTao DESC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ SỬA: dùng VaiTroID = 3 thay vì so sánh TenVaiTro (tránh lỗi encoding)
    public List<NguoiDung> searchToTruong(String keyword) {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT nd.*, vt.TenVaiTro "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "WHERE nd.VaiTroID = 3 AND ("
                + "  nd.Ho + ' ' + nd.Ten LIKE ? OR "
                + "  nd.Email             LIKE ? OR "
                + "  nd.SoDienThoai       LIKE ? OR "
                + "  nd.CCCD              LIKE ?) "
                + "ORDER BY nd.NgayTao DESC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean setActivated(int nguoiDungID, boolean activated) {
        String sql = "UPDATE NguoiDung SET IsActivated = ? WHERE NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, activated);
            ps.setInt(2, nguoiDungID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private NguoiDung mapRow(ResultSet rs) throws Exception {
        NguoiDung nd = new NguoiDung();
        nd.setNguoiDungID(rs.getInt("NguoiDungID"));
        nd.setCccd(rs.getString("CCCD"));
        nd.setHo(rs.getString("Ho"));
        nd.setTen(rs.getString("Ten"));
        nd.setNgaySinh(rs.getDate("NgaySinh"));
        nd.setGioiTinh(rs.getString("GioiTinh"));
        nd.setEmail(rs.getString("Email"));
        nd.setSoDienThoai(rs.getString("SoDienThoai"));
        nd.setVaiTroID(rs.getInt("VaiTroID"));
        nd.setToDanPhoID((Integer) rs.getObject("ToDanPhoID"));
        nd.setIsActivated(rs.getBoolean("IsActivated"));
        nd.setNgayTao(rs.getDate("NgayTao"));
        nd.setTenVaiTro(rs.getString("TenVaiTro"));
        return nd;
    }
}