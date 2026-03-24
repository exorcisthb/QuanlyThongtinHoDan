package Model.DAO;

import java.sql.*;
import java.util.*;

public class ThongBaoDAO {

    // ------------------------------------------------------------------ //
    //  GỬI THÔNG BÁO CÁ NHÂN
    // ------------------------------------------------------------------ //
    public boolean guiThongBaoCaNhan(String tieuDe, String noiDung,
            int nguoiGuiID, int nguoiNhanID) {
        String sqlThongBao
                = "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) "
                + "VALUES (?, ?, ?, NULL) RETURNING ThongBaoID";
        String sqlNguoiNhan
                = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) "
                + "VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int thongBaoID;
            // PostgreSQL: RETURNING thay RETURN_GENERATED_KEYS + executeQuery thay executeUpdate
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, tieuDe);
                ps.setString(2, noiDung);
                ps.setInt(3, nguoiGuiID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                ps.setInt(1, thongBaoID);
                ps.setInt(2, nguoiNhanID);
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
    //  GỬI THÔNG BÁO THEO VAI TRÒ
    // ------------------------------------------------------------------ //
    public boolean guiThongBaoTheoVaiTro(String tieuDe, String noiDung,
            int nguoiGuiID, String tenVaiTro) {
        String sqlThongBao
                = "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) "
                + "VALUES (?, ?, ?, NULL) RETURNING ThongBaoID";
        String sqlLayNguoiNhan
                = "SELECT nd.NguoiDungID FROM NguoiDung nd "
                + "JOIN VaiTro vt ON vt.VaiTroID = nd.VaiTroID "
                + "WHERE vt.TenVaiTro = ? AND nd.IsActivated = TRUE AND nd.TrangThaiNhanSu = 1";
        String sqlNguoiNhan
                = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, tieuDe);
                ps.setString(2, noiDung);
                ps.setInt(3, nguoiGuiID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> danhSachNguoiNhan = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setString(1, tenVaiTro);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) danhSachNguoiNhan.add(rs.getInt("NguoiDungID"));
            }

            if (danhSachNguoiNhan.isEmpty()) { conn.rollback(); return false; }

            try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                for (int nguoiNhanID : danhSachNguoiNhan) {
                    ps.setInt(1, thongBaoID);
                    ps.setInt(2, nguoiNhanID);
                    ps.addBatch();
                }
                ps.executeBatch();
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
    //  GỬI THÔNG BÁO THEO TỔ DÂN PHỐ
    // ------------------------------------------------------------------ //
    public boolean guiThongBaoTheoTo(String tieuDe, String noiDung,
            int nguoiGuiID, int toDanPhoID) {
        String sqlThongBao
                = "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) "
                + "VALUES (?, ?, ?, ?) RETURNING ThongBaoID";
        String sqlLayNguoiNhan
                = "SELECT NguoiDungID FROM NguoiDung "
                + "WHERE ToDanPhoID = ? AND IsActivated = TRUE AND TrangThaiNhanSu = 1";
        String sqlNguoiNhan
                = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int thongBaoID;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, tieuDe);
                ps.setString(2, noiDung);
                ps.setInt(3, nguoiGuiID);
                ps.setInt(4, toDanPhoID);
                ResultSet keys = ps.executeQuery();
                if (!keys.next()) { conn.rollback(); return false; }
                thongBaoID = keys.getInt(1);
            }

            List<Integer> danhSachNguoiNhan = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
                ps.setInt(1, toDanPhoID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) danhSachNguoiNhan.add(rs.getInt("NguoiDungID"));
            }

            if (danhSachNguoiNhan.isEmpty()) { conn.rollback(); return false; }

            try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                for (int nguoiNhanID : danhSachNguoiNhan) {
                    ps.setInt(1, thongBaoID);
                    ps.setInt(2, nguoiNhanID);
                    ps.addBatch();
                }
                ps.executeBatch();
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
    //  LẤY THÔNG BÁO CỦA 1 NGƯỜI DÙNG
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layThongBaoCuaNguoiDung(int nguoiDungID) {
        // PostgreSQL: || thay +
        String sql
                = "SELECT tb.ThongBaoID, tb.TieuDe, tb.NoiDung, tb.NgayGui, "
                + "       tb.LichHopID, tb.ThiepMoiID, "
                + "       nntb.DaDoc, nntb.ThoiGianDoc, "
                + "       (nd.Ho || ' ' || nd.Ten) AS TenNguoiGui "
                + "FROM NguoiNhanThongBao nntb "
                + "JOIN ThongBao  tb ON tb.ThongBaoID   = nntb.ThongBaoID "
                + "JOIN NguoiDung nd ON nd.NguoiDungID  = tb.NguoiGuiID "
                + "WHERE nntb.NguoiDungID = ? "
                + "ORDER BY tb.NgayGui DESC";

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("thongBaoID", rs.getInt("ThongBaoID"));
                row.put("tieuDe", rs.getString("TieuDe"));
                row.put("noiDung", rs.getString("NoiDung"));
                row.put("ngayGui", rs.getString("NgayGui"));
                row.put("lichHopID", rs.getObject("LichHopID"));
                row.put("thiepMoiID", rs.getObject("ThiepMoiID"));
                row.put("daDoc", rs.getBoolean("DaDoc"));
                row.put("thoiGianDoc", rs.getString("ThoiGianDoc"));
                row.put("tenNguoiGui", rs.getString("TenNguoiGui"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  ĐẾM CHƯA ĐỌC
    // ------------------------------------------------------------------ //
    public int demChuaDoc(int nguoiDungID) {
        // PostgreSQL: DaDoc = 0 → FALSE
        String sql = "SELECT COUNT(1) FROM NguoiNhanThongBao WHERE NguoiDungID = ? AND DaDoc = FALSE";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ------------------------------------------------------------------ //
    //  ĐÁNH DẤU ĐÃ ĐỌC 1
    // ------------------------------------------------------------------ //
    public boolean danhDauDaDoc(int thongBaoID, int nguoiDungID) {
        // PostgreSQL: GETDATE() → NOW(), DaDoc = 1/0 → TRUE/FALSE
        String sql = "UPDATE NguoiNhanThongBao SET DaDoc = TRUE, ThoiGianDoc = NOW() "
                + "WHERE ThongBaoID = ? AND NguoiDungID = ? AND DaDoc = FALSE";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, thongBaoID);
            ps.setInt(2, nguoiDungID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  ĐÁNH DẤU ĐỌC TẤT CẢ
    // ------------------------------------------------------------------ //
    public boolean danhDauDocTatCa(int nguoiDungID) {
        String sql = "UPDATE NguoiNhanThongBao SET DaDoc = TRUE, ThoiGianDoc = NOW() "
                + "WHERE NguoiDungID = ? AND DaDoc = FALSE";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  OVERLOAD dùng Connection có sẵn (trong transaction)
    // ------------------------------------------------------------------ //
    public boolean guiThongBaoCaNhan(String tieuDe, String noiDung,
            int nguoiGuiID, int nguoiNhanID, Connection conn) throws Exception {
        String sqlThongBao = "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) "
                + "VALUES (?, ?, ?, NULL) RETURNING ThongBaoID";
        String sqlNguoiNhan = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";
        int thongBaoID;
        try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
            ps.setString(1, tieuDe);
            ps.setString(2, noiDung);
            ps.setInt(3, nguoiGuiID);
            ResultSet keys = ps.executeQuery();
            if (!keys.next()) return false;
            thongBaoID = keys.getInt(1);
        }
        try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
            ps.setInt(1, thongBaoID);
            ps.setInt(2, nguoiNhanID);
            ps.executeUpdate();
        }
        return true;
    }

    public boolean guiThongBaoTheoVaiTro(String tieuDe, String noiDung,
            int nguoiGuiID, String tenVaiTro, Connection conn) throws Exception {
        String sqlThongBao = "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID) "
                + "VALUES (?, ?, ?, NULL) RETURNING ThongBaoID";
        String sqlLayNguoiNhan = "SELECT nd.NguoiDungID FROM NguoiDung nd "
                + "JOIN VaiTro vt ON vt.VaiTroID = nd.VaiTroID "
                + "WHERE vt.TenVaiTro = ? AND nd.IsActivated = TRUE AND nd.TrangThaiNhanSu = 1";
        String sqlNguoiNhan = "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";
        int thongBaoID;
        try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
            ps.setString(1, tieuDe);
            ps.setString(2, noiDung);
            ps.setInt(3, nguoiGuiID);
            ResultSet keys = ps.executeQuery();
            if (!keys.next()) return false;
            thongBaoID = keys.getInt(1);
        }
        List<Integer> danhSach = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sqlLayNguoiNhan)) {
            ps.setString(1, tenVaiTro);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) danhSach.add(rs.getInt("NguoiDungID"));
        }
        if (danhSach.isEmpty()) return false;
        try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
            for (int id : danhSach) {
                ps.setInt(1, thongBaoID);
                ps.setInt(2, id);
                ps.addBatch();
            }
            ps.executeBatch();
        }
        return true;
    }
}