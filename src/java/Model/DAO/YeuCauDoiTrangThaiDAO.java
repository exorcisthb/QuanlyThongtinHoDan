package Model.DAO;

import java.sql.*;
import java.util.*;

public class YeuCauDoiTrangThaiDAO {

    private static final String BASE_SELECT
            = "SELECT "
            + "    yc.YeuCauID, yc.HoDanID, yc.TrangThaiCuID, yc.TrangThaiMoiID, "
            + "    yc.NguoiYeuCauID, yc.LyDoYeuCau, yc.TrangThaiYeuCauID, "
            + "    yc.NguoiDuyetID, yc.NgayDuyet, yc.GhiChuDuyet, yc.NgayTao, "
            + "    hd.MaHoKhau, hd.DiaChi AS DiaChiHo, "
            + "    (nd_chu.Ho + ' ' + nd_chu.Ten)  AS TenChuHo, "
            + "    tt_cu.TenTrangThai               AS TenTrangThaiCu, "
            + "    tt_moi.TenTrangThai              AS TenTrangThaiMoi, "
            + "    (nd_yc.Ho  + ' ' + nd_yc.Ten)   AS TenNguoiYeuCau, "
            + "    (nd_dt.Ho  + ' ' + nd_dt.Ten)   AS TenNguoiDuyet, "
            + "    ttyc.TenTrangThai                AS TenTrangThaiYeuCau, "
            + "    tdp.TenTo "
            + "FROM YeuCauDoiTrangThai yc "
            + "JOIN HoDan           hd      ON hd.HoDanID         = yc.HoDanID "
            + "JOIN TrangThaiHoKhau tt_cu   ON tt_cu.TrangThaiID  = yc.TrangThaiCuID "
            + "JOIN TrangThaiHoKhau tt_moi  ON tt_moi.TrangThaiID = yc.TrangThaiMoiID "
            + "JOIN NguoiDung       nd_yc   ON nd_yc.NguoiDungID  = yc.NguoiYeuCauID "
            + "JOIN TrangThaiYeuCau ttyc    ON ttyc.TrangThaiID   = yc.TrangThaiYeuCauID "
            + "JOIN ToDanPho        tdp     ON tdp.ToDanPhoID      = hd.ToDanPhoID "
            + "LEFT JOIN NguoiDung  nd_chu  ON nd_chu.NguoiDungID = hd.ChuHoID "
            + "LEFT JOIN NguoiDung  nd_dt   ON nd_dt.NguoiDungID  = yc.NguoiDuyetID ";

    // ------------------------------------------------------------------ //
    //  MAP ResultSet -> Map
    // ------------------------------------------------------------------ //
    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("yeuCauID", rs.getInt("YeuCauID"));
        row.put("hoDanID", rs.getInt("HoDanID"));
        row.put("trangThaiCuID", rs.getInt("TrangThaiCuID"));
        row.put("trangThaiMoiID", rs.getInt("TrangThaiMoiID"));
        row.put("nguoiYeuCauID", rs.getInt("NguoiYeuCauID"));
        row.put("lyDoYeuCau", rs.getString("LyDoYeuCau"));
        row.put("trangThaiYeuCauID", rs.getInt("TrangThaiYeuCauID"));

        int nguoiDuyetID = rs.getInt("NguoiDuyetID");
        row.put("nguoiDuyetID", rs.wasNull() ? null : nguoiDuyetID);

        row.put("ngayDuyet", rs.getString("NgayDuyet"));
        row.put("ghiChuDuyet", rs.getString("GhiChuDuyet"));
        row.put("ngayTao", rs.getString("NgayTao"));
        row.put("maHoKhau", rs.getString("MaHoKhau"));
        row.put("diaChiHo", rs.getString("DiaChiHo"));
        row.put("tenChuHo", rs.getString("TenChuHo"));
        row.put("tenTrangThaiCu", rs.getString("TenTrangThaiCu"));
        row.put("tenTrangThaiMoi", rs.getString("TenTrangThaiMoi"));
        row.put("tenNguoiYeuCau", rs.getString("TenNguoiYeuCau"));
        row.put("tenNguoiDuyet", rs.getString("TenNguoiDuyet"));
        row.put("tenTrangThaiYeuCau", rs.getString("TenTrangThaiYeuCau"));
        row.put("tenTo", rs.getString("TenTo"));
        return row;
    }

    // ------------------------------------------------------------------ //
    //  TẠO YÊU CẦU MỚI (tổ trưởng)
    // ------------------------------------------------------------------ //
    public boolean taoYeuCau(int hoDanID, int trangThaiCuID, int trangThaiMoiID,
            int nguoiYeuCauID, String lyDo) {
        String sql
                = "INSERT INTO YeuCauDoiTrangThai "
                + "    (HoDanID, TrangThaiCuID, TrangThaiMoiID, NguoiYeuCauID, LyDoYeuCau, TrangThaiYeuCauID) "
                + "VALUES (?, ?, ?, ?, ?, 1)";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ps.setInt(2, trangThaiCuID);
            ps.setInt(3, trangThaiMoiID);
            ps.setInt(4, nguoiYeuCauID);
            ps.setString(5, lyDo);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  KIỂM TRA hộ đang có yêu cầu chờ duyệt chưa
    // ------------------------------------------------------------------ //
    public boolean dangCoYeuCauChoDuyet(int hoDanID) {
        String sql
                = "SELECT COUNT(1) FROM YeuCauDoiTrangThai "
                + "WHERE HoDanID = ? AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  LẤY THEO ID
    // ------------------------------------------------------------------ //
    public Map<String, Object> layTheoID(int yeuCauID) {
        String sql = BASE_SELECT + "WHERE yc.YeuCauID = ?";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  LẤY DANH SÁCH THEO TỔ (tổ trưởng xem yêu cầu tổ mình)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachTheoTo(int toDanPhoID) {
        String sql = BASE_SELECT + "WHERE hd.ToDanPhoID = ? ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, toDanPhoID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  LẤY DANH SÁCH CHỜ DUYỆT (cán bộ phường)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachChoDuyet() {
        String sql = BASE_SELECT + "WHERE yc.TrangThaiYeuCauID = 1 ORDER BY yc.NgayTao ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  LẤY TẤT CẢ (cán bộ phường xem lịch sử)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layTatCa() {
        String sql = BASE_SELECT + "ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  DUYỆT yêu cầu — transaction: cập nhật cả HoDan
    // ------------------------------------------------------------------ //
    public boolean duyetYeuCau(int yeuCauID, int nguoiDuyetID, String ghiChu) {
        String sqlYC
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 2, NguoiDuyetID = ?, NgayDuyet = GETDATE(), GhiChuDuyet = ? "
                + "WHERE YeuCauID = ? AND TrangThaiYeuCauID = 1";
        String sqlHD
                = "UPDATE hd SET hd.TrangThaiID = yc.TrangThaiMoiID "
                + "FROM HoDan hd "
                + "JOIN YeuCauDoiTrangThai yc ON yc.HoDanID = hd.HoDanID "
                + "WHERE yc.YeuCauID = ?";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlYC)) {
                ps1.setInt(1, nguoiDuyetID);
                ps1.setString(2, ghiChu);
                ps1.setInt(3, yeuCauID);
                if (ps1.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }
            try (PreparedStatement ps2 = conn.prepareStatement(sqlHD)) {
                ps2.setInt(1, yeuCauID);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ignored) {
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }
    }

    // ------------------------------------------------------------------ //
    //  TỪ CHỐI yêu cầu (cán bộ phường)
    // ------------------------------------------------------------------ //
    public boolean tuChoiYeuCau(int yeuCauID, int nguoiDuyetID, String lyDoTuChoi) {
        String sql
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 3, NguoiDuyetID = ?, NgayDuyet = GETDATE(), GhiChuDuyet = ? "
                + "WHERE YeuCauID = ? AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDuyetID);
            ps.setString(2, lyDoTuChoi);
            ps.setInt(3, yeuCauID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  HUỶ yêu cầu (tổ trưởng tự huỷ khi còn chờ duyệt)
    // ------------------------------------------------------------------ //
    public boolean huyYeuCau(int yeuCauID, int nguoiYeuCauID) {
        String sql
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 4 "
                + "WHERE YeuCauID = ? AND NguoiYeuCauID = ? AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ps.setInt(2, nguoiYeuCauID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }// Lấy chi tiết yêu cầu theo thongBaoID (dùng cho modal chuông)

    public Map<String, Object> layChiTietTheoThongBao(int thongBaoID) {
        String sql = BASE_SELECT
                + "WHERE yc.TrangThaiYeuCauID = 1 "
                + "AND yc.NgayTao <= ("
                + "    SELECT TOP 1 NgayGui FROM ThongBao WHERE ThongBaoID = ?"
                + ") "
                + "ORDER BY yc.NgayTao DESC";
        try (Connection conn = DBContext.getInstance().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, thongBaoID);
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
