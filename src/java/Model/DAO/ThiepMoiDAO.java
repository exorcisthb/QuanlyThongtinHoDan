package Model.DAO;

import Model.Entity.ThiepMoi;
import java.sql.*;
import java.util.*;

public class ThiepMoiDAO {

    public static final int TRANG_THAI_SAP_DIEN_RA = 5;
    public static final int TRANG_THAI_TAM_HOAN    = 8;

    // PostgreSQL: || thay +, bỏ N''
    private static final String BASE_SELECT =
        "SELECT tm.ThiepMoiID, tm.TieuDe, tm.NoiDung, tm.DiaDiem, " +
        "       tm.ThoiGianBatDau, tm.ThoiGianKetThuc, " +
        "       tm.ToDanPhoID, tm.NguoiTaoID, tm.TrangThaiID, " +
        "       tm.DaIn, tm.ThoiGianIn, tm.NguoiInID, tm.LichHopID, tm.NgayTao, tm.GhiChuHoan, " +
        "       tt.TenTrangThai, tdp.TenTo, " +
        "       (nd.Ho || ' ' || nd.Ten) AS TenNguoiTao " +
        "FROM ThiepMoi tm " +
        "JOIN TrangThaiThiepMoi tt ON tm.TrangThaiID = tt.TrangThaiID " +
        "JOIN ToDanPho tdp          ON tm.ToDanPhoID  = tdp.ToDanPhoID " +
        "JOIN NguoiDung nd          ON tm.NguoiTaoID  = nd.NguoiDungID ";

    private int tinhTrangThai(Timestamp batDau, Timestamp ketThuc, int trangThaiHienTai) {
        if (trangThaiHienTai == 4 || trangThaiHienTai == TRANG_THAI_TAM_HOAN)
            return trangThaiHienTai;
        if (batDau == null) return TRANG_THAI_SAP_DIEN_RA;
        long now = System.currentTimeMillis();
        if (now < batDau.getTime())                      return TRANG_THAI_SAP_DIEN_RA;
        if (ketThuc == null || now <= ketThuc.getTime()) return 6;
        return 7;
    }

    private ThiepMoi mapRow(ResultSet rs) throws SQLException {
        ThiepMoi t = new ThiepMoi();
        t.setThiepMoiID(rs.getInt("ThiepMoiID"));
        t.setTieuDe(rs.getString("TieuDe"));
        t.setNoiDung(rs.getString("NoiDung"));
        t.setDiaDiem(rs.getString("DiaDiem"));
        Timestamp tgbd = rs.getTimestamp("ThoiGianBatDau");
        Timestamp tgkt = rs.getTimestamp("ThoiGianKetThuc");
        t.setThoiGianBatDau(tgbd);
        t.setThoiGianKetThuc(tgkt);
        t.setToDanPhoID(rs.getInt("ToDanPhoID"));
        t.setNguoiTaoID(rs.getInt("NguoiTaoID"));
        t.setTrangThaiID(tinhTrangThai(tgbd, tgkt, rs.getInt("TrangThaiID")));
        t.setDaIn(rs.getBoolean("DaIn"));
        t.setThoiGianIn(rs.getTimestamp("ThoiGianIn"));
        int nguoiInID = rs.getInt("NguoiInID");
        if (!rs.wasNull()) t.setNguoiInID(nguoiInID);
        int lichHopID = rs.getInt("LichHopID");
        if (!rs.wasNull()) t.setLichHopID(lichHopID);
        t.setNgayTao(rs.getTimestamp("NgayTao"));
        t.setGhiChuHoan(rs.getString("GhiChuHoan"));
        t.setTenTrangThai(rs.getString("TenTrangThai"));
        t.setTenTo(rs.getString("TenTo"));
        t.setTenNguoiTao(rs.getString("TenNguoiTao"));
        return t;
    }

    public List<ThiepMoi> getAll() {
        String sql = BASE_SELECT + "ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<ThiepMoi> getByTo(int toDanPhoID) {
        String sql = BASE_SELECT + "WHERE tm.ToDanPhoID = ? ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, toDanPhoID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<ThiepMoi> getByTrangThai(int trangThaiID) {
        String sql = BASE_SELECT + "WHERE tm.TrangThaiID = ? ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trangThaiID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<ThiepMoi> search(String keyword) {
        String sql = BASE_SELECT + "WHERE tm.TieuDe LIKE ? ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public ThiepMoi getByID(int id) {
        String sql = BASE_SELECT + "WHERE tm.ThiepMoiID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  TẠO THIỆP MỚI
    // ------------------------------------------------------------------ //
    public boolean taoThiepMoi(ThiepMoi t, int nguoiTaoID) {
        // PostgreSQL: RETURNING thay RETURN_GENERATED_KEYS, bỏ N''
        String sqlThiep =
            "INSERT INTO ThiepMoi (TieuDe, NoiDung, DiaDiem, ThoiGianBatDau, ThoiGianKetThuc, " +
            "                      ToDanPhoID, NguoiTaoID, TrangThaiID, LichHopID) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, 2, ?) RETURNING ThiepMoiID";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, NoiDungMoi, GhiChu) " +
            "VALUES (?, ?, 'TAO_MOI', ?, 'Tạo thiệp mới')";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID, ThiepMoiID) " +
            "VALUES (?, ?, ?, ?, ?) RETURNING ThongBaoID";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND IsActivated = TRUE AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int thiepMoiID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThiep)) {
                ps.setString(1, t.getTieuDe()); ps.setString(2, t.getNoiDung());
                ps.setString(3, t.getDiaDiem()); ps.setTimestamp(4, t.getThoiGianBatDau());
                ps.setTimestamp(5, t.getThoiGianKetThuc()); ps.setInt(6, t.getToDanPhoID());
                ps.setInt(7, nguoiTaoID);
                if (t.getLichHopID() != null) ps.setInt(8, t.getLichHopID());
                else ps.setNull(8, Types.INTEGER);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thiepMoiID = keys.getInt(1);
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID); ps.setInt(2, nguoiTaoID);
                ps.setString(3, buildJsonSnapshot(t)); ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, "Thông báo họp: " + t.getTieuDe());
                ps.setString(2, "Kính mời quý hộ dân tham dự: " + t.getTieuDe() + ". Địa điểm: " + t.getDiaDiem());
                ps.setInt(3, nguoiTaoID); ps.setInt(4, t.getToDanPhoID());
                ps.setInt(5, thiepMoiID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, t.getToDanPhoID());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) { ps.setInt(1, thongBaoID); ps.setInt(2, id); ps.addBatch(); }
                    ps.executeBatch();
                }
            }

            conn.commit(); return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    // ------------------------------------------------------------------ //
    //  SỬA THIỆP
    // ------------------------------------------------------------------ //
    public boolean suaThiepMoi(ThiepMoi t, int nguoiSuaID) {
        String sqlCheck   = "SELECT DaIn, ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlOldSnap = "SELECT TieuDe, NoiDung, DiaDiem, ThoiGianBatDau FROM ThiepMoi WHERE ThiepMoiID = ?";
        // PostgreSQL: SYSDATETIME() → NOW()
        String sqlUpdate  =
            "UPDATE ThiepMoi SET TieuDe=?, NoiDung=?, DiaDiem=?, " +
            "ThoiGianBatDau=?, ThoiGianKetThuc=? " +
            "WHERE ThiepMoiID=? AND DaIn=FALSE AND ThoiGianBatDau > NOW()";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, NoiDungCu, NoiDungMoi, GhiChu) " +
            "VALUES (?, ?, 'CHINH_SUA', ?, ?, 'Chỉnh sửa thiệp mời')";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID, ThiepMoiID) " +
            "VALUES (?, ?, ?, ?, ?) RETURNING ThongBaoID";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND IsActivated = TRUE AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            boolean daIn; int toDanPhoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, t.getThiepMoiID()); ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                daIn = rs.getBoolean("DaIn"); toDanPhoID = rs.getInt("ToDanPhoID");
            }
            if (daIn) return false;

            String oldSnap;
            try (PreparedStatement ps = conn.prepareStatement(sqlOldSnap)) {
                ps.setInt(1, t.getThiepMoiID()); ResultSet rs = ps.executeQuery(); rs.next();
                oldSnap = "{\"TieuDe\":\"" + rs.getString("TieuDe") + "\",\"DiaDiem\":\"" + rs.getString("DiaDiem") + "\"}";
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, t.getTieuDe()); ps.setString(2, t.getNoiDung());
                ps.setString(3, t.getDiaDiem()); ps.setTimestamp(4, t.getThoiGianBatDau());
                ps.setTimestamp(5, t.getThoiGianKetThuc()); ps.setInt(6, t.getThiepMoiID());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, t.getThiepMoiID()); ps.setInt(2, nguoiSuaID);
                ps.setString(3, oldSnap); ps.setString(4, buildJsonSnapshot(t)); ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, "[CẬP NHẬT] " + t.getTieuDe());
                ps.setString(2, "Thông tin cuộc họp \"" + t.getTieuDe() + "\" đã được cập nhật.");
                ps.setInt(3, nguoiSuaID); ps.setInt(4, toDanPhoID);
                ps.setInt(5, t.getThiepMoiID());
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, toDanPhoID); ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) { ps.setInt(1, thongBaoID); ps.setInt(2, id); ps.addBatch(); }
                    ps.executeBatch();
                }
            }

            conn.commit(); return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    // ------------------------------------------------------------------ //
    //  XÓA THIỆP
    // ------------------------------------------------------------------ //
    public boolean xoaThiepMoi(int thiepMoiID, int nguoiXoaID) {
        String sqlCheck = "SELECT DaIn, TieuDe, ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, NoiDungCu, GhiChu) " +
            "VALUES (?, ?, 'XOA', ?, 'Xóa thiệp mời')";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) " +
            "VALUES (?, ?, ?, ?) RETURNING ThongBaoID";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND IsActivated = TRUE AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";
        String sqlDelete = "DELETE FROM ThiepMoi WHERE ThiepMoiID = ?";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            boolean daIn; String tieuDe; int toDanPhoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, thiepMoiID); ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                daIn = rs.getBoolean("DaIn"); tieuDe = rs.getString("TieuDe"); toDanPhoID = rs.getInt("ToDanPhoID");
            }
            if (daIn) return false;

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID); ps.setInt(2, nguoiXoaID);
                ps.setString(3, "{\"TieuDe\":\"" + tieuDe + "\"}"); ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, "[HỦY] " + tieuDe);
                ps.setString(2, "Cuộc họp \"" + tieuDe + "\" đã bị hủy.");
                ps.setInt(3, nguoiXoaID); ps.setInt(4, toDanPhoID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, toDanPhoID); ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) { ps.setInt(1, thongBaoID); ps.setInt(2, id); ps.addBatch(); }
                    ps.executeBatch();
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
                ps.setInt(1, thiepMoiID); ps.executeUpdate();
            }

            conn.commit(); return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    // ------------------------------------------------------------------ //
    //  IN THIỆP
    // ------------------------------------------------------------------ //
    public boolean inThiepMoi(int thiepMoiID, int nguoiInID) {
        String sqlCheck  = "SELECT DaIn FROM ThiepMoi WHERE ThiepMoiID = ?";
        // PostgreSQL: GETDATE() → NOW(), DaIn=1 → TRUE
        String sqlUpdate = "UPDATE ThiepMoi SET DaIn=TRUE, TrangThaiID=3, ThoiGianIn=NOW(), NguoiInID=? WHERE ThiepMoiID=?";
        String sqlLog    = "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, GhiChu) VALUES (?, ?, 'IN', 'Thiệp đã in — khóa chỉnh sửa và xóa')";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, thiepMoiID); ResultSet rs = ps.executeQuery();
                if (!rs.next() || rs.getBoolean("DaIn")) { conn.rollback(); return false; }
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, nguoiInID); ps.setInt(2, thiepMoiID); ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID); ps.setInt(2, nguoiInID); ps.executeUpdate();
            }
            conn.commit(); return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    // ------------------------------------------------------------------ //
    //  TẠM HOÃN
    // ------------------------------------------------------------------ //
    public boolean tamHoanThiepMoi(int thiepMoiID, int nguoiThucHienID, String ghiChuHoan) {
        // PostgreSQL: DaIn=0 → FALSE
        String sqlUpdate =
            "UPDATE ThiepMoi SET TrangThaiID = ?, GhiChuHoan = ? WHERE ThiepMoiID = ? AND DaIn = FALSE";
        // PostgreSQL: SYSDATETIME() → NOW(), bỏ N''
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, GhiChu, ThoiGian) " +
            "VALUES (?, ?, 'TAM_HOAN', ?, NOW())";
        // PostgreSQL: || thay +, bỏ N'', RETURNING thay RETURN_GENERATED_KEYS
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID, ThiepMoiID) " +
            "SELECT '[TẠM HOÃN] ' || TieuDe, " +
            "       'Cuộc họp \"' || TieuDe || '\" đã bị tạm hoãn. Lý do: ' || ?, " +
            "       ?, ToDanPhoID, ThiepMoiID FROM ThiepMoi WHERE ThiepMoiID = ? " +
            "RETURNING ThongBaoID";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung " +
            "WHERE ToDanPhoID = (SELECT ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?) " +
            "  AND IsActivated = TRUE AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int rows;
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, TRANG_THAI_TAM_HOAN); ps.setString(2, ghiChuHoan); ps.setInt(3, thiepMoiID);
                rows = ps.executeUpdate();
            }
            if (rows == 0) { conn.rollback(); return false; }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID); ps.setInt(2, nguoiThucHienID); ps.setString(3, ghiChuHoan); ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, ghiChuHoan); ps.setInt(2, nguoiThucHienID); ps.setInt(3, thiepMoiID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, thiepMoiID); ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) { ps.setInt(1, thongBaoID); ps.setInt(2, id); ps.addBatch(); }
                    ps.executeBatch();
                }
            }

            conn.commit(); return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    // ------------------------------------------------------------------ //
    //  MỞ LẠI
    // ------------------------------------------------------------------ //
    public boolean moLaiThiepMoi(int thiepMoiID, int nguoiThucHienID,
                                  Timestamp thoiGianBatDau, Timestamp thoiGianKetThuc,
                                  String noiDung, String diaDiem) {
        if (thoiGianBatDau == null || thoiGianBatDau.getTime() <= System.currentTimeMillis())
            return false;

        // PostgreSQL: DaIn=0 → FALSE
        String sqlUpdate =
            "UPDATE ThiepMoi SET TrangThaiID = ?, GhiChuHoan = NULL, " +
            "ThoiGianBatDau = ?, ThoiGianKetThuc = ?, NoiDung = ?, DiaDiem = ? " +
            "WHERE ThiepMoiID = ? AND TrangThaiID = ? AND DaIn = FALSE";
        // PostgreSQL: SYSDATETIME() → NOW(), bỏ N''
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, GhiChu, ThoiGian) " +
            "VALUES (?, ?, 'MO_LAI', 'Mở lại thiệp — đã cập nhật thời gian mới', NOW())";
        // PostgreSQL: || thay +, bỏ N'', RETURNING
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID, ThiepMoiID) " +
            "SELECT '[MỞ LẠI] ' || TieuDe, " +
            "       'Cuộc họp \"' || TieuDe || '\" đã được mở lại với thời gian mới.', " +
            "       ?, ToDanPhoID, ThiepMoiID FROM ThiepMoi WHERE ThiepMoiID = ? " +
            "RETURNING ThongBaoID";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung " +
            "WHERE ToDanPhoID = (SELECT ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?) " +
            "  AND IsActivated = TRUE AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int rows;
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, TRANG_THAI_SAP_DIEN_RA); ps.setTimestamp(2, thoiGianBatDau);
                if (thoiGianKetThuc != null) ps.setTimestamp(3, thoiGianKetThuc);
                else ps.setNull(3, Types.TIMESTAMP);
                ps.setString(4, noiDung); ps.setString(5, diaDiem);
                ps.setInt(6, thiepMoiID); ps.setInt(7, TRANG_THAI_TAM_HOAN);
                rows = ps.executeUpdate();
            }
            if (rows == 0) { conn.rollback(); return false; }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID); ps.setInt(2, nguoiThucHienID); ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setInt(1, nguoiThucHienID); ps.setInt(2, thiepMoiID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, thiepMoiID); ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) { ps.setInt(1, thongBaoID); ps.setInt(2, id); ps.addBatch(); }
                    ps.executeBatch();
                }
            }

            conn.commit(); return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    private String buildJsonSnapshot(ThiepMoi t) {
        return "{\"TieuDe\":\"" + t.getTieuDe() + "\"," +
               "\"DiaDiem\":\"" + t.getDiaDiem() + "\"," +
               "\"ThoiGianBatDau\":\"" + t.getThoiGianBatDau() + "\"}";
    }

    public Map<String, Integer> thongKe_ThiepMoiTheoThang(int toDanPhoID, int nam) {
        // PostgreSQL: MONTH() → EXTRACT(MONTH FROM ...), YEAR() → EXTRACT(YEAR FROM ...)
        String sql = "SELECT EXTRACT(MONTH FROM NgayTao)::int AS Thang, COUNT(*) AS SoLuong "
                   + "FROM ThiepMoi "
                   + "WHERE ToDanPhoID = ? AND EXTRACT(YEAR FROM NgayTao) = ? "
                   + "GROUP BY EXTRACT(MONTH FROM NgayTao) "
                   + "ORDER BY Thang";
        Map<String, Integer> result = new LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) result.put("Th." + i, 0);
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, toDanPhoID);
            ps.setInt(2, nam);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.put("Th." + rs.getInt("Thang"), rs.getInt("SoLuong"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }
}