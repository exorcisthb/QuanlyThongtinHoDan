package Model.DAO;

import Model.Entity.LichHop;
import Model.Entity.LichSuSuaLichHop;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class LichHopDAO {

    // ==================== HELPER ====================

    private int tinhTrangThai(Timestamp batDau, Timestamp ketThuc, int trangThaiHienTai) {
        if (trangThaiHienTai == 4) return 4;
        if (batDau == null) return 1;
        LocalDateTime now   = LocalDateTime.now();
        LocalDateTime bdLdt = batDau.toLocalDateTime();
        LocalDateTime ktLdt = ketThuc != null ? ketThuc.toLocalDateTime() : null;
        if (now.isBefore(bdLdt))                  return 1;
        if (ktLdt == null || now.isBefore(ktLdt)) return 2;
        return 3;
    }

    private Map<String, Object> mapRowDanhSach(ResultSet rs) throws SQLException {
        Timestamp batDau    = rs.getTimestamp("ThoiGianBatDau");
        Timestamp ketThuc   = rs.getTimestamp("ThoiGianKetThuc");
        int       ttHienTai = rs.getInt("TrangThai");
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("lichHopID",       rs.getInt("LichHopID"));
        row.put("tieuDe",          rs.getString("TieuDe"));
        row.put("noiDung",         rs.getString("NoiDung"));
        row.put("diaDiem",         rs.getString("DiaDiem"));
        row.put("thoiGianBatDau",  batDau);
        row.put("thoiGianKetThuc", ketThuc);
        row.put("trangThai",       tinhTrangThai(batDau, ketThuc, ttHienTai));
        row.put("ngayTao",         rs.getTimestamp("NgayTao"));
        row.put("mucDo",           rs.getInt("MucDo"));
        row.put("doiTuong",        rs.getString("DoiTuong"));
        row.put("nguoiTao",        rs.getString("NguoiTao"));
        return row;
    }

    // ==================== LỊCH HỌP ====================

    public int taoLichHop(LichHop lh) {
        // PostgreSQL: dùng RETURNING thay cho Statement.RETURN_GENERATED_KEYS
        String sql =
            "INSERT INTO LichHop (TieuDe, NoiDung, DiaDiem, ThoiGianBatDau, " +
            "ThoiGianKetThuc, ToDanPhoID, NguoiTaoID, TrangThai, MucDo, DoiTuong) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?) RETURNING LichHopID";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lh.getTieuDe());
            ps.setString(2, lh.getNoiDung());
            ps.setString(3, lh.getDiaDiem());
            ps.setTimestamp(4, Timestamp.valueOf(lh.getThoiGianBatDau()));
            ps.setTimestamp(5, lh.getThoiGianKetThuc() != null
                    ? Timestamp.valueOf(lh.getThoiGianKetThuc()) : null);
            ps.setInt(6, lh.getToDanPhoID());
            ps.setInt(7, lh.getNguoiTaoID());
            ps.setInt(8, lh.getMucDo());
            ps.setString(9, lh.getDoiTuong());
            // PostgreSQL RETURNING được đọc qua executeQuery()
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean suaLichHop(LichHop lh) {
        String sql =
            "UPDATE LichHop SET TieuDe = ?, NoiDung = ?, DiaDiem = ?, " +
            "ThoiGianBatDau = ?, ThoiGianKetThuc = ?, TrangThai = ?, " +
            "MucDo = ?, DoiTuong = ? " +
            "WHERE LichHopID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lh.getTieuDe());
            ps.setString(2, lh.getNoiDung());
            ps.setString(3, lh.getDiaDiem());
            ps.setTimestamp(4, Timestamp.valueOf(lh.getThoiGianBatDau()));
            ps.setTimestamp(5, lh.getThoiGianKetThuc() != null
                    ? Timestamp.valueOf(lh.getThoiGianKetThuc()) : null);
            ps.setInt(6, lh.getTrangThai());
            ps.setInt(7, lh.getMucDo());
            ps.setString(8, lh.getDoiTuong());
            ps.setInt(9, lh.getLichHopID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getLichHopByToDanPho(int toDanPhoID) {
        List<Map<String, Object>> list = new ArrayList<>();
        // PostgreSQL: dùng || thay cho + để nối chuỗi
        String sql =
            "SELECT lh.LichHopID, lh.TieuDe, lh.NoiDung, lh.DiaDiem, " +
            "       lh.ThoiGianBatDau, lh.ThoiGianKetThuc, lh.TrangThai, lh.NgayTao, " +
            "       lh.MucDo, lh.DoiTuong, " +
            "       nd.Ho || ' ' || nd.Ten AS NguoiTao " +
            "FROM LichHop lh " +
            "JOIN NguoiDung nd ON lh.NguoiTaoID = nd.NguoiDungID " +
            "WHERE lh.ToDanPhoID = ? " +
            "ORDER BY lh.ThoiGianBatDau DESC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, toDanPhoID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowDanhSach(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getLichHopByID(int lichHopID) {
        String sql =
            "SELECT lh.LichHopID, lh.TieuDe, lh.NoiDung, lh.DiaDiem, " +
            "       lh.ThoiGianBatDau, lh.ThoiGianKetThuc, lh.TrangThai, lh.NgayTao, " +
            "       lh.ToDanPhoID, lh.NguoiTaoID, lh.MucDo, lh.DoiTuong, " +
            "       nd.Ho || ' ' || nd.Ten AS NguoiTao, " +
            "       td.TenTo " +
            "FROM LichHop lh " +
            "JOIN NguoiDung nd ON lh.NguoiTaoID = nd.NguoiDungID " +
            "JOIN ToDanPho  td ON lh.ToDanPhoID  = td.ToDanPhoID " +
            "WHERE lh.LichHopID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lichHopID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Timestamp batDau  = rs.getTimestamp("ThoiGianBatDau");
                Timestamp ketThuc = rs.getTimestamp("ThoiGianKetThuc");
                int ttHienTai     = rs.getInt("TrangThai");
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("lichHopID",       rs.getInt("LichHopID"));
                row.put("tieuDe",          rs.getString("TieuDe"));
                row.put("noiDung",         rs.getString("NoiDung"));
                row.put("diaDiem",         rs.getString("DiaDiem"));
                row.put("thoiGianBatDau",  batDau);
                row.put("thoiGianKetThuc", ketThuc);
                row.put("trangThai",       tinhTrangThai(batDau, ketThuc, ttHienTai));
                row.put("ngayTao",         rs.getTimestamp("NgayTao"));
                row.put("toDanPhoID",      rs.getInt("ToDanPhoID"));
                row.put("nguoiTaoID",      rs.getInt("NguoiTaoID"));
                row.put("mucDo",           rs.getInt("MucDo"));
                row.put("doiTuong",        rs.getString("DoiTuong"));
                row.put("nguoiTao",        rs.getString("NguoiTao"));
                row.put("tenTo",           rs.getString("TenTo"));
                return row;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== DÀNH CHO NGƯỜI DÂN ====================

    public List<Map<String, Object>> getLichHopNguoiDan(int toDanPhoID,
                                                         Integer trangThai,
                                                         Timestamp tuNgay,
                                                         Timestamp denNgay) {
        List<Map<String, Object>> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT lh.LichHopID, lh.TieuDe, lh.NoiDung, lh.DiaDiem, " +
            "       lh.ThoiGianBatDau, lh.ThoiGianKetThuc, lh.TrangThai, lh.NgayTao, " +
            "       lh.MucDo, lh.DoiTuong, " +
            "       nd.Ho || ' ' || nd.Ten AS NguoiTao " +
            "FROM LichHop lh " +
            "JOIN NguoiDung nd ON lh.NguoiTaoID = nd.NguoiDungID " +
            "WHERE lh.ToDanPhoID = ? "
        );

        if (trangThai != null) sql.append("AND lh.TrangThai = ? ");
        if (tuNgay    != null) sql.append("AND lh.ThoiGianBatDau >= ? ");
        if (denNgay   != null) sql.append("AND lh.ThoiGianBatDau <= ? ");
        sql.append("ORDER BY lh.ThoiGianBatDau DESC");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setInt(idx++, toDanPhoID);
            if (trangThai != null) ps.setInt(idx++, trangThai);
            if (tuNgay    != null) ps.setTimestamp(idx++, tuNgay);
            if (denNgay   != null) ps.setTimestamp(idx++, denNgay);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowDanhSach(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getLichHopChiTietNguoiDan(int lichHopID, int toDanPhoID) {
        String sql =
            "SELECT lh.LichHopID, lh.TieuDe, lh.NoiDung, lh.DiaDiem, " +
            "       lh.ThoiGianBatDau, lh.ThoiGianKetThuc, lh.TrangThai, lh.NgayTao, " +
            "       lh.ToDanPhoID, lh.MucDo, lh.DoiTuong, " +
            "       nd.Ho || ' ' || nd.Ten AS NguoiTao, " +
            "       td.TenTo " +
            "FROM LichHop lh " +
            "JOIN NguoiDung nd ON lh.NguoiTaoID = nd.NguoiDungID " +
            "JOIN ToDanPho  td ON lh.ToDanPhoID  = td.ToDanPhoID " +
            "WHERE lh.LichHopID = ? AND lh.ToDanPhoID = ?";

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lichHopID);
            ps.setInt(2, toDanPhoID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Timestamp batDau  = rs.getTimestamp("ThoiGianBatDau");
                Timestamp ketThuc = rs.getTimestamp("ThoiGianKetThuc");
                int ttHienTai     = rs.getInt("TrangThai");
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("lichHopID",       rs.getInt("LichHopID"));
                row.put("tieuDe",          rs.getString("TieuDe"));
                row.put("noiDung",         rs.getString("NoiDung"));
                row.put("diaDiem",         rs.getString("DiaDiem"));
                row.put("thoiGianBatDau",  batDau);
                row.put("thoiGianKetThuc", ketThuc);
                row.put("trangThai",       tinhTrangThai(batDau, ketThuc, ttHienTai));
                row.put("ngayTao",         rs.getTimestamp("NgayTao"));
                row.put("toDanPhoID",      rs.getInt("ToDanPhoID"));
                row.put("mucDo",           rs.getInt("MucDo"));
                row.put("doiTuong",        rs.getString("DoiTuong"));
                row.put("nguoiTao",        rs.getString("NguoiTao"));
                row.put("tenTo",           rs.getString("TenTo"));
                return row;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== LỊCH SỬ SỬA ====================

    public boolean ghiLichSuSua(LichSuSuaLichHop ls) {
        String sql =
            "INSERT INTO LichSuSuaLichHop (LichHopID, NguoiSuaID, NoiDungThayDoi, LyDoSua) " +
            "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ls.getLichHopID());
            ps.setInt(2, ls.getNguoiSuaID());
            ps.setString(3, ls.getNoiDungThayDoi());
            ps.setString(4, ls.getLyDoSua());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getLichSuSuaByLichHopID(int lichHopID) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql =
            "SELECT ls.SuaID, ls.ThoiGianSua, ls.NoiDungThayDoi, ls.LyDoSua, " +
            "       nd.Ho || ' ' || nd.Ten AS NguoiSua " +
            "FROM LichSuSuaLichHop ls " +
            "JOIN NguoiDung nd ON ls.NguoiSuaID = nd.NguoiDungID " +
            "WHERE ls.LichHopID = ? " +
            "ORDER BY ls.ThoiGianSua DESC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lichHopID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("suaID",          rs.getInt("SuaID"));
                row.put("nguoiSua",       rs.getString("NguoiSua"));
                row.put("thoiGianSua",    rs.getTimestamp("ThoiGianSua"));
                row.put("noiDungThayDoi", rs.getString("NoiDungThayDoi"));
                row.put("lyDoSua",        rs.getString("LyDoSua"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== THÔNG BÁO ====================

    public boolean guiThongBaoDenChuHo(int lichHopID, int toDanPhoID,
                                        int nguoiGuiID, String tieuDe,
                                        String noiDung) {
        // PostgreSQL: dùng RETURNING để lấy ID vừa insert
        String sqlThongBao =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, ToDanPhoID, LichHopID) " +
            "VALUES (?, ?, ?, ?, ?) RETURNING ThongBaoID";
        String sqlNguoiNhan =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) " +
            "SELECT ?, hd.ChuHoID " +
            "FROM HoDan hd " +
            "WHERE hd.ToDanPhoID = ? AND hd.TrangThaiID = 1";
        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            int thongBaoID = -1;
            try (PreparedStatement ps = conn.prepareStatement(sqlThongBao)) {
                ps.setString(1, tieuDe);
                ps.setString(2, noiDung);
                ps.setInt(3, nguoiGuiID);
                ps.setInt(4, toDanPhoID);
                ps.setInt(5, lichHopID);
                // PostgreSQL RETURNING đọc qua executeQuery()
                ResultSet rs = ps.executeQuery();
                if (rs.next()) thongBaoID = rs.getInt(1);
            }
            if (thongBaoID == -1) { conn.rollback(); return false; }
            try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                ps.setInt(1, thongBaoID);
                ps.setInt(2, toDanPhoID);
                ps.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getTrangThaiDocThongBao(int lichHopID) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql =
            "SELECT nd.Ho || ' ' || nd.Ten AS ChuHo, nd.SoDienThoai, " +
            "       nnt.DaDoc, nnt.ThoiGianDoc " +
            "FROM ThongBao tb " +
            "JOIN NguoiNhanThongBao nnt ON tb.ThongBaoID = nnt.ThongBaoID " +
            "JOIN NguoiDung nd          ON nnt.NguoiDungID = nd.NguoiDungID " +
            "WHERE tb.LichHopID = ? " +
            "ORDER BY nnt.DaDoc ASC, nd.Ho ASC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lichHopID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("chuHo",       rs.getString("ChuHo"));
                row.put("soDienThoai", rs.getString("SoDienThoai"));
                row.put("daDoc",       rs.getBoolean("DaDoc"));
                row.put("thoiGianDoc", rs.getTimestamp("ThoiGianDoc"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}