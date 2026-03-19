package Model.DAO;

import Model.Entity.ThiepMoi;
import java.sql.*;
import java.util.*;

public class ThiepMoiDAO {

    // !! KHÔNG ĐỔI — phải khớp với TrangThaiThiepMoi trong DB !!
    public static final int TRANG_THAI_SAP_DIEN_RA = 5;
    public static final int TRANG_THAI_TAM_HOAN    = 8;

    private static final String BASE_SELECT =
        "SELECT tm.ThiepMoiID, tm.TieuDe, tm.NoiDung, tm.DiaDiem, " +
        "       tm.ThoiGianBatDau, tm.ThoiGianKetThuc, " +
        "       tm.ToDanPhoID, tm.NguoiTaoID, tm.TrangThaiID, " +
        "       tm.DaIn, tm.ThoiGianIn, tm.NguoiInID, tm.LichHopID, tm.NgayTao, tm.GhiChuHoan, " +
        "       tt.TenTrangThai, " +
        "       tdp.TenTo, " +
        "       (nd.Ho + N' ' + nd.Ten) AS TenNguoiTao " +
        "FROM ThiepMoi tm " +
        "JOIN TrangThaiThiepMoi tt ON tm.TrangThaiID = tt.TrangThaiID " +
        "JOIN ToDanPho tdp          ON tm.ToDanPhoID  = tdp.ToDanPhoID " +
        "JOIN NguoiDung nd          ON tm.NguoiTaoID  = nd.NguoiDungID ";


    private int tinhTrangThai(Timestamp batDau, Timestamp ketThuc, int trangThaiHienTai) {
        // Giữ nguyên các trạng thái đặc biệt — không tính lại theo thời gian
        if (trangThaiHienTai == 4                    // Đã hủy
         || trangThaiHienTai == TRANG_THAI_TAM_HOAN) // Tạm hoãn
            return trangThaiHienTai;

        if (batDau == null) return TRANG_THAI_SAP_DIEN_RA;
        long now = System.currentTimeMillis();
        if (now < batDau.getTime())                      return TRANG_THAI_SAP_DIEN_RA; // 5
        if (ketThuc == null || now <= ketThuc.getTime()) return 6;                       // Đang diễn ra
        return 7;                                                                         // Đã kết thúc
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

    // ------------------------------------------------------------------ //
    //  LẤY TẤT CẢ THIỆP MỜI
    // ------------------------------------------------------------------ //
    public List<ThiepMoi> getAll() {
        String sql = BASE_SELECT + "ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  LẤY THEO TỔ DÂN PHỐ
    // ------------------------------------------------------------------ //
    public List<ThiepMoi> getByTo(int toDanPhoID) {
        String sql = BASE_SELECT + "WHERE tm.ToDanPhoID = ? ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, toDanPhoID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  LẤY THEO TRẠNG THÁI
    // ------------------------------------------------------------------ //
    public List<ThiepMoi> getByTrangThai(int trangThaiID) {
        String sql = BASE_SELECT + "WHERE tm.TrangThaiID = ? ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trangThaiID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  TÌM KIẾM THEO TIÊU ĐỀ
    // ------------------------------------------------------------------ //
    public List<ThiepMoi> search(String keyword) {
        String sql = BASE_SELECT + "WHERE tm.TieuDe LIKE ? ORDER BY tm.NgayTao DESC";
        List<ThiepMoi> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  LẤY 1 THIỆP THEO ID
    // ------------------------------------------------------------------ //
    public ThiepMoi getByID(int id) {
        String sql = BASE_SELECT + "WHERE tm.ThiepMoiID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  TẠO THIỆP MỚI + GHI LOG + GỬI THÔNG BÁO (1 transaction)
    // ------------------------------------------------------------------ //
    public boolean taoThiepMoi(ThiepMoi t, int nguoiTaoID) {
        String sqlThiep =
            "INSERT INTO ThiepMoi (TieuDe, NoiDung, DiaDiem, ThoiGianBatDau, ThoiGianKetThuc, " +
            "                      ToDanPhoID, NguoiTaoID, TrangThaiID, LichHopID) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, 2, ?)";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, NoiDungMoi, GhiChu) " +
            "VALUES (?, ?, N'TAO_MOI', ?, N'Tạo thiệp mới')";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) VALUES (?, ?, ?, ?)";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND IsActivated = 1 AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int thiepMoiID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThiep, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, t.getTieuDe());
                ps.setString(2, t.getNoiDung());
                ps.setString(3, t.getDiaDiem());
                ps.setTimestamp(4, t.getThoiGianBatDau());
                ps.setTimestamp(5, t.getThoiGianKetThuc());
                ps.setInt(6, t.getToDanPhoID());
                ps.setInt(7, nguoiTaoID);
                if (t.getLichHopID() != null) ps.setInt(8, t.getLichHopID());
                else ps.setNull(8, Types.INTEGER);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) { conn.rollback(); return false; }
                thiepMoiID = keys.getInt(1);
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID);
                ps.setInt(2, nguoiTaoID);
                ps.setString(3, buildJsonSnapshot(t));
                ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "Thông báo họp: " + t.getTieuDe());
                ps.setString(2, "Kính mời quý hộ dân tham dự: " + t.getTieuDe()
                        + ". Địa điểm: " + t.getDiaDiem());
                ps.setInt(3, nguoiTaoID);
                ps.setInt(4, t.getToDanPhoID());
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
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
                    for (int nguoiNhanID : nguoiNhans) {
                        ps.setInt(1, thongBaoID);
                        ps.setInt(2, nguoiNhanID);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();
            return true;
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
    //  SỬA THIỆP + GHI LOG + GỬI THÔNG BÁO CẬP NHẬT
    // ------------------------------------------------------------------ //
    public boolean suaThiepMoi(ThiepMoi t, int nguoiSuaID) {
        String sqlCheck   = "SELECT DaIn, ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlOldSnap = "SELECT TieuDe, NoiDung, DiaDiem, ThoiGianBatDau FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlUpdate  =
            "UPDATE ThiepMoi SET TieuDe=?, NoiDung=?, DiaDiem=?, " +
            "ThoiGianBatDau=?, ThoiGianKetThuc=? " +
            "WHERE ThiepMoiID=? AND DaIn=0 " +
            "AND ThoiGianBatDau > SYSDATETIME()";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, NoiDungCu, NoiDungMoi, GhiChu) " +
            "VALUES (?, ?, N'CHINH_SUA', ?, ?, N'Chỉnh sửa thiệp mời')";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) VALUES (?, ?, ?, ?)";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND IsActivated = 1 AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            boolean daIn;
            int toDanPhoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, t.getThiepMoiID());
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                daIn       = rs.getBoolean("DaIn");
                toDanPhoID = rs.getInt("ToDanPhoID");
            }
            if (daIn) return false;

            String oldSnap;
            try (PreparedStatement ps = conn.prepareStatement(sqlOldSnap)) {
                ps.setInt(1, t.getThiepMoiID());
                ResultSet rs = ps.executeQuery();
                rs.next();
                oldSnap = "{\"TieuDe\":\"" + rs.getString("TieuDe") + "\"," +
                          "\"DiaDiem\":\"" + rs.getString("DiaDiem") + "\"}";
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, t.getTieuDe());
                ps.setString(2, t.getNoiDung());
                ps.setString(3, t.getDiaDiem());
                ps.setTimestamp(4, t.getThoiGianBatDau());
                ps.setTimestamp(5, t.getThoiGianKetThuc());
                ps.setInt(6, t.getThiepMoiID());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, t.getThiepMoiID());
                ps.setInt(2, nguoiSuaID);
                ps.setString(3, oldSnap);
                ps.setString(4, buildJsonSnapshot(t));
                ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "[CẬP NHẬT] " + t.getTieuDe());
                ps.setString(2, "Thông tin cuộc họp \"" + t.getTieuDe() + "\" đã được cập nhật.");
                ps.setInt(3, nguoiSuaID);
                ps.setInt(4, toDanPhoID);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, toDanPhoID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }

            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) {
                        ps.setInt(1, thongBaoID);
                        ps.setInt(2, id);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();
            return true;
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
    //  XÓA THIỆP + GHI LOG + GỬI THÔNG BÁO HỦY
    // ------------------------------------------------------------------ //
    public boolean xoaThiepMoi(int thiepMoiID, int nguoiXoaID) {
        String sqlCheck =
            "SELECT DaIn, TieuDe, ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, NoiDungCu, GhiChu) " +
            "VALUES (?, ?, N'XOA', ?, N'Xóa thiệp mời')";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) VALUES (?, ?, ?, ?)";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND IsActivated = 1 AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";
        String sqlDelete = "DELETE FROM ThiepMoi WHERE ThiepMoiID = ?";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            boolean daIn;
            String tieuDe;
            int toDanPhoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, thiepMoiID);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                daIn       = rs.getBoolean("DaIn");
                tieuDe     = rs.getString("TieuDe");
                toDanPhoID = rs.getInt("ToDanPhoID");
            }
            if (daIn) return false;

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID);
                ps.setInt(2, nguoiXoaID);
                ps.setString(3, "{\"TieuDe\":\"" + tieuDe + "\"}");
                ps.executeUpdate();
            }

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "[HỦY] " + tieuDe);
                ps.setString(2, "Cuộc họp \"" + tieuDe + "\" đã bị hủy.");
                ps.setInt(3, nguoiXoaID);
                ps.setInt(4, toDanPhoID);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, toDanPhoID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }

            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) {
                        ps.setInt(1, thongBaoID);
                        ps.setInt(2, id);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
                ps.setInt(1, thiepMoiID);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
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
    //  IN THIỆP → KHÓA SỬA/XÓA + GHI LOG
    // ------------------------------------------------------------------ //
    public boolean inThiepMoi(int thiepMoiID, int nguoiInID) {
        String sqlCheck  = "SELECT DaIn FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlUpdate =
            "UPDATE ThiepMoi SET DaIn=1, TrangThaiID=3, ThoiGianIn=GETDATE(), NguoiInID=? " +
            "WHERE ThiepMoiID=?";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, GhiChu) " +
            "VALUES (?, ?, N'IN', N'Thiệp đã in — khóa chỉnh sửa và xóa')";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, thiepMoiID);
                ResultSet rs = ps.executeQuery();
                if (!rs.next() || rs.getBoolean("DaIn")) {
                    conn.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, nguoiInID);
                ps.setInt(2, thiepMoiID);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID);
                ps.setInt(2, nguoiInID);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
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
    //  TẠM HOÃN THIỆP + GHI LOG + GỬI THÔNG BÁO (1 transaction)
    // ------------------------------------------------------------------ //
    public boolean tamHoanThiepMoi(int thiepMoiID, int nguoiThucHienID, String ghiChuHoan) {
        String sqlUpdate =
            "UPDATE ThiepMoi SET TrangThaiID = ?, GhiChuHoan = ? " +
            "WHERE ThiepMoiID = ? AND DaIn = 0";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, GhiChu, ThoiGian) " +
            "VALUES (?, ?, N'TAM_HOAN', ?, SYSDATETIME())";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) " +
            "SELECT N'[TẠM HOÃN] ' + TieuDe, " +
            "       N'Cuộc họp \"' + TieuDe + N'\" đã bị tạm hoãn. Lý do: ' + ?, " +
            "       ?, ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung " +
            "WHERE ToDanPhoID = (SELECT ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?) " +
            "  AND IsActivated = 1 AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            // 1. Update trạng thái → Tạm hoãn
            int rows;
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, TRANG_THAI_TAM_HOAN);
                ps.setString(2, ghiChuHoan);
                ps.setInt(3, thiepMoiID);
                rows = ps.executeUpdate();
            }
            if (rows == 0) { conn.rollback(); return false; }

            // 2. Ghi log TAM_HOAN
            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID);
                ps.setInt(2, nguoiThucHienID);
                ps.setString(3, ghiChuHoan);
                ps.executeUpdate();
            }

            // 3. Tạo thông báo [TẠM HOÃN]
            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, ghiChuHoan);
                ps.setInt(2, nguoiThucHienID);
                ps.setInt(3, thiepMoiID);
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            // 4. Lấy danh sách người nhận
            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, thiepMoiID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }

            // 5. Batch insert người nhận
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) {
                        ps.setInt(1, thongBaoID);
                        ps.setInt(2, id);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();
            return true;
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
    //  MỞ LẠI THIỆP (từ Tạm hoãn → Sắp diễn ra) + SỬA THỜI GIAN/NỘI DUNG
    //  + GHI LOG + GỬI THÔNG BÁO [MỞ LẠI]
    // ------------------------------------------------------------------ //
    public boolean moLaiThiepMoi(int thiepMoiID, int nguoiThucHienID,
                                  Timestamp thoiGianBatDau, Timestamp thoiGianKetThuc,
                                  String noiDung, String diaDiem) {
        // Validate thời gian phải > now — check ở đây để chắc chắn
        if (thoiGianBatDau == null || thoiGianBatDau.getTime() <= System.currentTimeMillis()) {
            return false;
        }

        String sqlUpdate =
            "UPDATE ThiepMoi SET TrangThaiID = ?, GhiChuHoan = NULL, " +
            "ThoiGianBatDau = ?, ThoiGianKetThuc = ?, NoiDung = ?, DiaDiem = ? " +
            "WHERE ThiepMoiID = ? AND TrangThaiID = ? AND DaIn = 0";
        String sqlLog =
            "INSERT INTO LichSuThiepMoi (ThiepMoiID, NguoiThucHienID, HanhDong, GhiChu, ThoiGian) " +
            "VALUES (?, ?, N'MO_LAI', N'Mở lại thiệp — đã cập nhật thời gian mới', SYSDATETIME())";
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) " +
            "SELECT N'[MỞ LẠI] ' + TieuDe, " +
            "       N'Cuộc họp \"' + TieuDe + N'\" đã được mở lại với thời gian mới.', " +
            "       ?, ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?";
        String sqlLayNguoiNhan =
            "SELECT NguoiDungID FROM NguoiDung " +
            "WHERE ToDanPhoID = (SELECT ToDanPhoID FROM ThiepMoi WHERE ThiepMoiID = ?) " +
            "  AND IsActivated = 1 AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            // 1. Update → Sắp diễn ra + xóa GhiChuHoan + cập nhật thời gian/nội dung
            int rows;
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, TRANG_THAI_SAP_DIEN_RA);
                ps.setTimestamp(2, thoiGianBatDau);
                if (thoiGianKetThuc != null) ps.setTimestamp(3, thoiGianKetThuc);
                else ps.setNull(3, Types.TIMESTAMP);
                ps.setString(4, noiDung);
                ps.setString(5, diaDiem);
                ps.setInt(6, thiepMoiID);
                ps.setInt(7, TRANG_THAI_TAM_HOAN);
                rows = ps.executeUpdate();
            }
            if (rows == 0) { conn.rollback(); return false; }

            // 2. Ghi log MO_LAI
            try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
                ps.setInt(1, thiepMoiID);
                ps.setInt(2, nguoiThucHienID);
                ps.executeUpdate();
            }

            // 3. Tạo thông báo [MỞ LẠI]
            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, nguoiThucHienID);
                ps.setInt(2, thiepMoiID);
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            // 4. Lấy danh sách người nhận
            List<Integer> nguoiNhans = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, thiepMoiID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) nguoiNhans.add(rs.getInt("NguoiDungID"));
            }

            // 5. Batch insert người nhận
            if (!nguoiNhans.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    for (int id : nguoiNhans) {
                        ps.setInt(1, thongBaoID);
                        ps.setInt(2, id);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();
            return true;
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
    //  HELPER: build JSON snapshot đơn giản
    // ------------------------------------------------------------------ //
    private String buildJsonSnapshot(ThiepMoi t) {
        return "{\"TieuDe\":\""    + t.getTieuDe()   + "\"," +
               "\"DiaDiem\":\""   + t.getDiaDiem()   + "\"," +
               "\"ThoiGianBatDau\":\"" + t.getThoiGianBatDau() + "\"}";
    }
}