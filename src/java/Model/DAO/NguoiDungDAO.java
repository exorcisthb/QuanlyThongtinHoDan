package Model.DAO;

import Model.Common.VaiTroConst;
import Model.Entity.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public class NguoiDungDAO {

    public NguoiDung dangNhap(String email, String matKhau) throws Exception {
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
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
                return mapRow(rs);
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
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
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
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Integer getOrCreateToDanPhoByTen(String tenTo) {
        String sqlFind = "SELECT ToDanPhoID FROM ToDanPho WHERE TenTo = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlFind)) {
            // PostgreSQL: dùng setString thay setNString (không có kiểu NVARCHAR)
            ps.setString(1, tenTo.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        // PostgreSQL: dùng RETURNING thay Statement.RETURN_GENERATED_KEYS
        String sqlInsert = "INSERT INTO ToDanPho (TenTo) VALUES (?) RETURNING ToDanPhoID";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
            ps.setString(1, tenTo.trim());
            ResultSet keys = ps.executeQuery();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean taoToTruong(NguoiDung nd) {
        // PostgreSQL: NOW() → NOW(), N'...' literal → dùng tham số thường
        String sql = "INSERT INTO NguoiDung "
                + "(CCCD, Ho, Ten, NgaySinh, GioiTinh, Email, SoDienThoai, "
                + " MatKhauHash, VaiTroID, ToDanPhoID, IsActivated, NgayTao) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, "
                + "(SELECT VaiTroID FROM VaiTro WHERE TenVaiTro = '" + VaiTroConst.TO_TRUONG + "'), "
                + "?, TRUE, NOW())";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getCccd());
            ps.setString(2, nd.getHo());
            ps.setString(3, nd.getTen());
            ps.setDate(4, nd.getNgaySinh());
            ps.setString(5, nd.getGioiTinh());
            ps.setString(6, nd.getEmail());
            ps.setString(7, nd.getSoDienThoai());
            ps.setString(8, nd.getMatKhauHash());
            if (nd.getToDanPhoID() != null) {
                ps.setInt(9, nd.getToDanPhoID());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<NguoiDung> getDanhSachToTruong() {
        List<NguoiDung> list = new ArrayList<>();
        // PostgreSQL: bỏ tiền tố N'' — chuỗi UTF-8 mặc định
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
                + "WHERE vt.TenVaiTro = '" + VaiTroConst.TO_TRUONG + "' "
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

    public List<NguoiDung> searchToTruong(String keyword) {
        List<NguoiDung> list = new ArrayList<>();
        // PostgreSQL: || thay +, bỏ N''
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
                + "WHERE vt.TenVaiTro = '" + VaiTroConst.TO_TRUONG + "' AND ("
                + "  nd.Ho || ' ' || nd.Ten LIKE ? OR "
                + "  nd.Email               LIKE ? OR "
                + "  nd.SoDienThoai         LIKE ? OR "
                + "  nd.CCCD                LIKE ?) "
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

    public boolean updateTrangThaiNhanSu(int nguoiDungID, int trangThaiNhanSu) {
        // PostgreSQL: CASE WHEN dùng TRUE/FALSE thay 1/0 cho cột boolean
        String sql = "UPDATE NguoiDung "
                + "SET TrangThaiNhanSu = ?, "
                + "    IsActivated = CASE WHEN ? = 1 THEN TRUE ELSE FALSE END "
                + "WHERE NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trangThaiNhanSu);
            ps.setInt(2, trangThaiNhanSu);
            ps.setInt(3, nguoiDungID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatar(int nguoiDungID, String avatarPath) {
        String sql = "UPDATE NguoiDung SET AvatarPath = ? WHERE NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarPath);
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
        nd.setTrangThaiNhanSu(rs.getInt("TrangThaiNhanSu"));
        nd.setAvatarPath(rs.getString("AvatarPath"));
        nd.setTenTo(rs.getString("TenTo"));
        return nd;
    }

    public boolean taoCanBoPhuong(NguoiDung nd) {
        // PostgreSQL: NOW() → NOW(), bỏ N'', literal 1 → TRUE
        String sql = "INSERT INTO NguoiDung "
                + "(Ho, Ten, NgaySinh, GioiTinh, Email, SoDienThoai, "
                + " MatKhauHash, VaiTroID, ToDanPhoID, IsActivated, NgayTao) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, "
                + "(SELECT VaiTroID FROM VaiTro WHERE TenVaiTro = '" + VaiTroConst.CAN_BO_PHUONG + "'), "
                + "NULL, TRUE, NOW())";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getHo());
            ps.setString(2, nd.getTen());
            ps.setDate(3, nd.getNgaySinh());
            ps.setString(4, nd.getGioiTinh());
            ps.setString(5, nd.getEmail());
            ps.setString(6, nd.getSoDienThoai());
            ps.setString(7, nd.getMatKhauHash());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<NguoiDung> getDanhSachCanBoPhuong() {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
                + "WHERE vt.TenVaiTro = '" + VaiTroConst.CAN_BO_PHUONG + "' "
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

    public List<NguoiDung> searchCanBoPhuong(String keyword) {
        List<NguoiDung> list = new ArrayList<>();
        // PostgreSQL: || thay +, bỏ N''
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
                + "WHERE vt.TenVaiTro = '" + VaiTroConst.CAN_BO_PHUONG + "' AND ("
                + "  nd.Ho || ' ' || nd.Ten LIKE ? OR "
                + "  nd.Email               LIKE ? OR "
                + "  nd.SoDienThoai         LIKE ?) "
                + "ORDER BY nd.NgayTao DESC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public NguoiDung findChuaKichHoatByCCCD(String cccd) {
        // PostgreSQL: IsActivated = FALSE thay = 0
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "LEFT JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
                + "WHERE nd.CCCD = ? AND nd.IsActivated = FALSE";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cccd.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean kichHoatTaiKhoan(int nguoiDungID, String email, String matKhauHash) {
        // PostgreSQL: IsActivated = TRUE thay = 1
        String sql = "UPDATE NguoiDung "
                + "SET Email = ?, MatKhauHash = ?, IsActivated = TRUE "
                + "WHERE NguoiDungID = ? AND IsActivated = FALSE";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, matKhauHash);
            ps.setInt(3, nguoiDungID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public NguoiDung layTheoID(int nguoiDungID) {
        String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
                + "FROM NguoiDung nd "
                + "LEFT JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
                + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
                + "WHERE nd.NguoiDungID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public NguoiDung layTheoThanhVienID(int thanhVienID) {
    String sql = "SELECT nd.*, vt.TenVaiTro, tdp.TenTo "
            + "FROM NguoiDung nd "
            + "LEFT JOIN VaiTro vt ON nd.VaiTroID = vt.VaiTroID "
            + "LEFT JOIN ToDanPho tdp ON nd.ToDanPhoID = tdp.ToDanPhoID "
            + "JOIN ThanhVienHo tv ON tv.NguoiDungID = nd.NguoiDungID "
            + "WHERE tv.ThanhVienID = ?";
    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, thanhVienID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return mapRow(rs);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
}