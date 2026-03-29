package Model.DAO;

import Model.Entity.YeuCauDoiTrangThai;
import java.sql.*;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class YeuCauDoiTrangThaiDAO {

    // ==================== FORMAT TIMEZONE VN ====================
    private static final DateTimeFormatter FMT_VN =
        DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                         .withZone(ZoneId.of("Asia/Ho_Chi_Minh"));

    private String fmtVN(Timestamp ts) {
        if (ts == null) return "—";
        return FMT_VN.format(ts.toInstant());
    }

    private static final String BASE_SELECT
            = "SELECT "
            + "    yc.YeuCauID, yc.LoaiYeuCau, yc.NhanKhauID, "
            + "    yc.HoDanID, yc.TrangThaiCuID, yc.TrangThaiMoiID, "
            + "    yc.NguoiYeuCauID, yc.LyDoYeuCau, yc.TrangThaiYeuCauID, "
            + "    yc.NguoiDuyetID, yc.NgayDuyet, yc.GhiChuDuyet, yc.NgayTao, "
            + "    hd.MaHoKhau, hd.DiaChi AS DiaChiHo, "
            + "    (nd_chu.Ho || ' ' || nd_chu.Ten) AS TenChuHo, "
            + "    tt_cu.TenTrangThai  AS TenTrangThaiCu, "
            + "    tt_moi.TenTrangThai AS TenTrangThaiMoi, "
            + "    COALESCE(tdp_hd.TenTo, tdp_nk.TenTo, tdp_l2.TenTo) AS TenTo, "
            + "    (nd_yc.Ho || ' ' || nd_yc.Ten) AS TenNguoiYeuCau, "
            + "    (nd_dt.Ho  || ' ' || nd_dt.Ten) AS TenNguoiDuyet, "
            + "    ttyc.TenTrangThai AS TenTrangThaiYeuCau, "
            + "    yc.NguoiDungCapNhatID, "
            + "    COALESCE(hd_nk.MaHoKhau, hd_l2.MaHoKhau) AS MaNhanKhau, "
            + "    COALESCE(qhg_nk.TenQuanHe, qhg_l2.TenQuanHe) AS QuanHeVoiChuHo, "
            + "    yc.Ho_Cu,  yc.Ten_Cu,  yc.NgaySinh_Cu,  yc.GioiTinh_Cu, "
            + "    yc.Email_Cu,  yc.SDT_Cu,  yc.CCCD_Cu,  yc.Avatar_Cu, "
            + "    yc.Ho_Moi, yc.Ten_Moi, yc.NgaySinh_Moi, yc.GioiTinh_Moi, "
            + "    yc.Email_Moi, yc.SDT_Moi, yc.CCCD_Moi, yc.Avatar_Moi "
            + "FROM YeuCauDoiTrangThai yc "
            + "JOIN  NguoiDung       nd_yc    ON nd_yc.NguoiDungID   = yc.NguoiYeuCauID "
            + "JOIN  TrangThaiYeuCau ttyc     ON ttyc.TrangThaiID    = yc.TrangThaiYeuCauID "
            + "LEFT JOIN HoDan           hd       ON hd.HoDanID          = yc.HoDanID "
            + "LEFT JOIN TrangThaiHoKhau tt_cu    ON tt_cu.TrangThaiID   = yc.TrangThaiCuID "
            + "LEFT JOIN TrangThaiHoKhau tt_moi   ON tt_moi.TrangThaiID  = yc.TrangThaiMoiID "
            + "LEFT JOIN ToDanPho        tdp_hd   ON tdp_hd.ToDanPhoID   = hd.ToDanPhoID "
            + "LEFT JOIN NguoiDung       nd_chu   ON nd_chu.NguoiDungID  = hd.ChuHoID "
            + "LEFT JOIN NguoiDung       nd_dt    ON nd_dt.NguoiDungID   = yc.NguoiDuyetID "
            + "LEFT JOIN NguoiDung       nd_nk    ON nd_nk.NguoiDungID   = yc.NhanKhauID "
            + "LEFT JOIN ToDanPho        tdp_nk   ON tdp_nk.ToDanPhoID   = nd_nk.ToDanPhoID "
            + "LEFT JOIN ThanhVienHo     tvh_nk   ON tvh_nk.NguoiDungID  = yc.NhanKhauID "
            + "                                   AND tvh_nk.NgayRa IS NULL "
            + "LEFT JOIN HoDan           hd_nk    ON hd_nk.HoDanID       = tvh_nk.HoDanID "
            + "LEFT JOIN QuanHeHoGia     qhg_nk   ON qhg_nk.QuanHeID     = tvh_nk.QuanHeID "
            + "LEFT JOIN NguoiDung       nd_l2    ON nd_l2.NguoiDungID   = yc.NguoiDungCapNhatID "
            + "LEFT JOIN ToDanPho        tdp_l2   ON tdp_l2.ToDanPhoID   = nd_l2.ToDanPhoID "
            + "LEFT JOIN ThanhVienHo     tvh_l2   ON tvh_l2.NguoiDungID  = yc.NguoiDungCapNhatID "
            + "                                   AND tvh_l2.NgayRa IS NULL "
            + "LEFT JOIN HoDan           hd_l2    ON hd_l2.HoDanID       = tvh_l2.HoDanID "
            + "LEFT JOIN QuanHeHoGia     qhg_l2   ON qhg_l2.QuanHeID     = tvh_l2.QuanHeID ";

    // ------------------------------------------------------------------ //
    //  mapRow
    // ------------------------------------------------------------------ //
    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("yeuCauID",           rs.getInt("YeuCauID"));
        row.put("loaiYeuCau",         rs.getInt("LoaiYeuCau"));
        row.put("nhanKhauID",         rs.getInt("NhanKhauID"));
        row.put("hoDanID",            rs.getInt("HoDanID"));
        row.put("trangThaiCuID",      rs.getInt("TrangThaiCuID"));
        row.put("trangThaiMoiID",     rs.getInt("TrangThaiMoiID"));
        row.put("nguoiYeuCauID",      rs.getInt("NguoiYeuCauID"));
        row.put("lyDoYeuCau",         rs.getString("LyDoYeuCau"));
        row.put("trangThaiYeuCauID",  rs.getInt("TrangThaiYeuCauID"));
        int nguoiDuyetID = rs.getInt("NguoiDuyetID");
        row.put("nguoiDuyetID",       rs.wasNull() ? null : nguoiDuyetID);
        // FIX: dùng getTimestamp + fmtVN thay vì getString để đảm bảo đúng giờ VN
        row.put("ngayDuyet",          fmtVN(rs.getTimestamp("NgayDuyet")));
        row.put("ghiChuDuyet",        rs.getString("GhiChuDuyet"));
        row.put("ngayTao",            fmtVN(rs.getTimestamp("NgayTao")));
        row.put("maHoKhau",           rs.getString("MaHoKhau"));
        row.put("maNhanKhau",         rs.getString("MaNhanKhau"));
        row.put("diaChiHo",           rs.getString("DiaChiHo"));
        row.put("tenChuHo",           rs.getString("TenChuHo"));
        row.put("tenTrangThaiCu",     rs.getString("TenTrangThaiCu"));
        row.put("tenTrangThaiMoi",    rs.getString("TenTrangThaiMoi"));
        row.put("tenNguoiYeuCau",     rs.getString("TenNguoiYeuCau"));
        row.put("tenNguoiDuyet",      rs.getString("TenNguoiDuyet"));
        row.put("tenTrangThaiYeuCau", rs.getString("TenTrangThaiYeuCau"));
        row.put("tenTo",              rs.getString("TenTo"));
        int ndCapNhat = rs.getInt("NguoiDungCapNhatID");
        row.put("nguoiDungCapNhatID", rs.wasNull() ? null : ndCapNhat);
        row.put("quanHeVoiChuHo",     rs.getString("QuanHeVoiChuHo"));
        row.put("ho_Cu",              rs.getString("Ho_Cu"));
        row.put("ten_Cu",             rs.getString("Ten_Cu"));
        row.put("ngaySinh_Cu",        rs.getString("NgaySinh_Cu"));
        row.put("gioiTinh_Cu",        rs.getString("GioiTinh_Cu"));
        row.put("email_Cu",           rs.getString("Email_Cu"));
        row.put("sDT_Cu",             rs.getString("SDT_Cu"));
        row.put("cCCD_Cu",            rs.getString("CCCD_Cu"));
        row.put("avatar_Cu",          rs.getString("Avatar_Cu"));
        row.put("ho_Moi",             rs.getString("Ho_Moi"));
        row.put("ten_Moi",            rs.getString("Ten_Moi"));
        row.put("ngaySinh_Moi",       rs.getString("NgaySinh_Moi"));
        row.put("gioiTinh_Moi",       rs.getString("GioiTinh_Moi"));
        row.put("email_Moi",          rs.getString("Email_Moi"));
        row.put("sDT_Moi",            rs.getString("SDT_Moi"));
        row.put("cCCD_Moi",           rs.getString("CCCD_Moi"));
        row.put("avatar_Moi",         rs.getString("Avatar_Moi"));

        String ho  = rs.getString("Ho_Cu");
        String ten = rs.getString("Ten_Cu");
        if (ho != null && ten != null) {
            row.put("tenNhanKhau", ho.trim() + " " + ten.trim());
        } else {
            row.put("tenNhanKhau", rs.getString("TenNguoiYeuCau"));
        }

        return row;
    }

    // ------------------------------------------------------------------ //
    //  TẠO YÊU CẦU LOẠI 1
    // ------------------------------------------------------------------ //
    public boolean taoYeuCau(int hoDanID, int trangThaiCuID, int trangThaiMoiID,
                              int nguoiYeuCauID, String lyDo) {
        String sqlInsert
                = "INSERT INTO YeuCauDoiTrangThai "
                + "    (LoaiYeuCau, HoDanID, TrangThaiCuID, TrangThaiMoiID, NguoiYeuCauID, LyDoYeuCau, TrangThaiYeuCauID) "
                + "VALUES (1, ?, ?, ?, ?, ?, 1) RETURNING YeuCauID";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int yeuCauID;
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                ps.setInt(1, hoDanID);
                ps.setInt(2, trangThaiCuID);
                ps.setInt(3, trangThaiMoiID);
                ps.setInt(4, nguoiYeuCauID);
                ps.setString(5, lyDo);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                yeuCauID = rs.getInt(1);
            }

            List<Integer> cbpList = layCBPhuong(conn);
            ThongBaoDAO tbDAO = new ThongBaoDAO();
            for (int cbpID : cbpList) {
                tbDAO.guiThongBaoCaNhan(
                        "Yêu cầu đổi trạng thái hộ khẩu mới",
                        "Tổ trưởng vừa gửi yêu cầu đổi trạng thái cho hộ dân. Vui lòng kiểm tra và xử lý.",
                        nguoiYeuCauID, cbpID,
                        yeuCauID, 1,
                        conn
                );
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            closeConn(conn);
        }
    }

    // ------------------------------------------------------------------ //
    //  TẠO YÊU CẦU LOẠI 3
    // ------------------------------------------------------------------ //
    public boolean taoYeuCauNhanKhau(int nhanKhauID, int trangThaiCuID, int trangThaiMoiID,
                                      int nguoiYeuCauID, String lyDo,
                                      YeuCauDoiTrangThai snapshot) {
        String sqlInsert
                = "INSERT INTO YeuCauDoiTrangThai "
                + "    (LoaiYeuCau, NhanKhauID, TrangThaiCuID, TrangThaiMoiID, NguoiYeuCauID, LyDoYeuCau, TrangThaiYeuCauID, "
                + "     Ho_Cu, Ten_Cu, NgaySinh_Cu, GioiTinh_Cu, Email_Cu, SDT_Cu, CCCD_Cu, Avatar_Cu) "
                + "VALUES (3, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING YeuCauID";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            int yeuCauID;
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                ps.setInt(1, nhanKhauID);
                ps.setInt(2, trangThaiCuID);
                ps.setInt(3, trangThaiMoiID);
                ps.setInt(4, nguoiYeuCauID);
                ps.setString(5, lyDo);
                ps.setString(6, snapshot.getHo_Cu());
                ps.setString(7, snapshot.getTen_Cu());
                ps.setDate(8,   snapshot.getNgaySinh_Cu());
                ps.setString(9, snapshot.getGioiTinh_Cu());
                ps.setString(10, snapshot.getEmail_Cu());
                ps.setString(11, snapshot.getSDT_Cu());
                ps.setString(12, snapshot.getCCCD_Cu());
                ps.setString(13, snapshot.getAvatar_Cu());
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                yeuCauID = rs.getInt(1);
            }

            List<Integer> cbpList = layCBPhuong(conn);
            ThongBaoDAO tbDAO = new ThongBaoDAO();
            for (int cbpID : cbpList) {
                tbDAO.guiThongBaoCaNhan(
                        "Yêu cầu đổi trạng thái nhân khẩu mới",
                        "Tổ trưởng vừa gửi yêu cầu đổi trạng thái cho nhân khẩu. Vui lòng kiểm tra và xử lý.",
                        nguoiYeuCauID, cbpID,
                        yeuCauID, 3,
                        conn
                );
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            closeConn(conn);
        }
    }

    // ------------------------------------------------------------------ //
    //  TẠO YÊU CẦU LOẠI 2
    // ------------------------------------------------------------------ //
    public boolean taoYeuCauCapNhat(int nguoiDungID, YeuCauDoiTrangThai yc,
                                     ThongBaoDAO thongBaoDAO) {
        String sql
                = "INSERT INTO YeuCauDoiTrangThai "
                + "    (LoaiYeuCau, NguoiYeuCauID, LyDoYeuCau, TrangThaiYeuCauID, "
                + "     NguoiDungCapNhatID, "
                + "     Ho_Cu, Ten_Cu, NgaySinh_Cu, GioiTinh_Cu, Email_Cu, SDT_Cu, CCCD_Cu, Avatar_Cu, "
                + "     Ho_Moi, Ten_Moi, NgaySinh_Moi, GioiTinh_Moi, Email_Moi, SDT_Moi, CCCD_Moi, Avatar_Moi) "
                + "VALUES (2, ?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING YeuCauID";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            huyYeuCauCungTruong(nguoiDungID, yc, conn);

            int yeuCauID;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1,     nguoiDungID);
                ps.setString(2,  yc.getLyDoYeuCau());
                ps.setInt(3,     nguoiDungID);
                ps.setString(4,  yc.getHo_Cu());
                ps.setString(5,  yc.getTen_Cu());
                ps.setDate(6,    yc.getNgaySinh_Cu());
                ps.setString(7,  yc.getGioiTinh_Cu());
                ps.setString(8,  yc.getEmail_Cu());
                ps.setString(9,  yc.getSDT_Cu());
                ps.setString(10, yc.getCCCD_Cu());
                ps.setString(11, yc.getAvatar_Cu());
                ps.setString(12, yc.getHo_Moi());
                ps.setString(13, yc.getTen_Moi());
                ps.setDate(14,   yc.getNgaySinh_Moi());
                ps.setString(15, yc.getGioiTinh_Moi());
                ps.setString(16, yc.getEmail_Moi());
                ps.setString(17, yc.getSDT_Moi());
                ps.setString(18, yc.getCCCD_Moi());
                ps.setString(19, yc.getAvatar_Moi());
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                yeuCauID = rs.getInt(1);
            }

            List<Integer> cbpList = layCBPhuong(conn);
            for (int cbpID : cbpList) {
                thongBaoDAO.guiThongBaoCaNhan(
                        "Yêu cầu cập nhật thông tin cá nhân mới",
                        "Hộ dân " + yc.getHo_Cu() + " " + yc.getTen_Cu()
                                + " vừa gửi yêu cầu cập nhật thông tin cá nhân. Vui lòng kiểm tra và xử lý.",
                        nguoiDungID, cbpID,
                        yeuCauID, 2,
                        conn
                );
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            closeConn(conn);
        }
    }

    // ------------------------------------------------------------------ //
    //  layChiTietTheoThongBao
    // ------------------------------------------------------------------ //
    public Map<String, Object> layChiTietTheoThongBao(int thongBaoID) {
        String sql = BASE_SELECT
                + "JOIN ThongBao tb ON ("
                + "    tb.YeuCauDoiTrangThaiID = yc.YeuCauID "
                + "    OR tb.YeuCauCapNhatID   = yc.YeuCauID "
                + ") "
                + "WHERE tb.ThongBaoID = ? "
                + "ORDER BY yc.NgayTao DESC "
                + "LIMIT 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, thongBaoID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  Helper: lấy danh sách NguoiDungID của tất cả cán bộ phường
    // ------------------------------------------------------------------ //
    private List<Integer> layCBPhuong(Connection conn) throws SQLException {
        String sql = "SELECT nd.NguoiDungID FROM NguoiDung nd "
                   + "JOIN VaiTro vt ON vt.VaiTroID = nd.VaiTroID "
                   + "WHERE vt.TenVaiTro = 'CanBoPhuong' "
                   + "  AND nd.IsActivated = TRUE AND nd.TrangThaiNhanSu = 1";
        List<Integer> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rs.getInt(1));
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  Helper: đóng connection
    // ------------------------------------------------------------------ //
    private void closeConn(Connection conn) {
        try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
        try { if (conn != null) conn.close();             } catch (Exception ignored) {}
    }

    // ------------------------------------------------------------------ //
    //  huyYeuCauCungTruong
    // ------------------------------------------------------------------ //
    private void huyYeuCauCungTruong(int nguoiDungID, YeuCauDoiTrangThai yc,
            Connection conn) throws SQLException {
        String sqlLayDS
                = "SELECT YeuCauID, Ho_Moi, Ten_Moi, NgaySinh_Moi, GioiTinh_Moi, "
                + "       Email_Moi, SDT_Moi, CCCD_Moi "
                + "FROM YeuCauDoiTrangThai "
                + "WHERE LoaiYeuCau = 2 AND NguoiDungCapNhatID = ? AND TrangThaiYeuCauID = 1";
        String sqlHuy = "UPDATE YeuCauDoiTrangThai SET TrangThaiYeuCauID = 4 WHERE YeuCauID = ?";
        try (PreparedStatement psLayDS = conn.prepareStatement(sqlLayDS)) {
            psLayDS.setInt(1, nguoiDungID);
            ResultSet rs = psLayDS.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("YeuCauID");
                boolean trung = false;
                if (yc.getHo_Moi()       != null && rs.getString("Ho_Moi")       != null) trung = true;
                if (yc.getTen_Moi()      != null && rs.getString("Ten_Moi")       != null) trung = true;
                if (yc.getNgaySinh_Moi() != null && rs.getString("NgaySinh_Moi")  != null) trung = true;
                if (yc.getGioiTinh_Moi() != null && rs.getString("GioiTinh_Moi")  != null) trung = true;
                if (yc.getEmail_Moi()    != null && rs.getString("Email_Moi")      != null) trung = true;
                if (yc.getSDT_Moi()      != null && rs.getString("SDT_Moi")        != null) trung = true;
                if (yc.getCCCD_Moi()     != null && rs.getString("CCCD_Moi")       != null) trung = true;
                if (trung) {
                    try (PreparedStatement psHuy = conn.prepareStatement(sqlHuy)) {
                        psHuy.setInt(1, id);
                        psHuy.executeUpdate();
                    }
                }
            }
        }
    }

    private Map<String, Object> layTheoID(int yeuCauID, Connection conn) throws SQLException {
        String sql = BASE_SELECT + "WHERE yc.YeuCauID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public Map<String, Object> layTheoID(int yeuCauID) {
        String sql = BASE_SELECT + "WHERE yc.YeuCauID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean dangCoYeuCauChoDuyet(int hoDanID) {
        String sql = "SELECT COUNT(1) FROM YeuCauDoiTrangThai "
                   + "WHERE HoDanID = ? AND LoaiYeuCau = 1 AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean dangCoYeuCauCapNhatChoDuyet(int nguoiDungID) {
        String sql = "SELECT COUNT(1) FROM YeuCauDoiTrangThai "
                   + "WHERE NguoiDungCapNhatID = ? AND LoaiYeuCau = 2 AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean dangCoYeuCauNhanKhauChoDuyet(int nhanKhauID) {
        String sql = "SELECT COUNT(1) FROM YeuCauDoiTrangThai "
                   + "WHERE NhanKhauID = ? AND LoaiYeuCau = 3 AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nhanKhauID);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, Object>> layDanhSachTheoTo(int toDanPhoID) {
        String sql = BASE_SELECT
                + "WHERE (tdp_hd.ToDanPhoID = ? OR tdp_nk.ToDanPhoID = ? OR tdp_l2.ToDanPhoID = ?) "
                + "ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, toDanPhoID);
            ps.setInt(2, toDanPhoID);
            ps.setInt(3, toDanPhoID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> layDanhSachChoDuyet() {
        String sql = BASE_SELECT + "WHERE yc.TrangThaiYeuCauID = 1 ORDER BY yc.NgayTao ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> layDanhSachCapNhatChoDuyet() {
        String sql = BASE_SELECT
                + "WHERE yc.LoaiYeuCau = 2 AND yc.TrangThaiYeuCauID = 1 "
                + "ORDER BY yc.NgayTao ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> layTatCa() {
        String sql = BASE_SELECT + "ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> layDanhSachCapNhatCuaNguoiDung(int nguoiDungID) {
        String sql = BASE_SELECT
                + "WHERE yc.LoaiYeuCau = 2 AND yc.NguoiDungCapNhatID = ? "
                + "ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean duyetYeuCau(int yeuCauID, int nguoiDuyetID, String ghiChu,
                                 ThongBaoDAO thongBaoDAO) {
        String sqlYC
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 2, NguoiDuyetID = ?, NgayDuyet = NOW(), GhiChuDuyet = ? "
                + "WHERE YeuCauID = ? AND TrangThaiYeuCauID = 1";
        String sqlHD
                = "UPDATE HoDan hd SET TrangThaiID = yc.TrangThaiMoiID "
                + "FROM YeuCauDoiTrangThai yc "
                + "WHERE yc.HoDanID = hd.HoDanID AND yc.YeuCauID = ? AND yc.LoaiYeuCau = 1";
        String sqlND
                = "UPDATE NguoiDung nd "
                + "SET Ho          = COALESCE(yc.Ho_Moi,       nd.Ho), "
                + "    Ten         = COALESCE(yc.Ten_Moi,      nd.Ten), "
                + "    NgaySinh    = COALESCE(yc.NgaySinh_Moi, nd.NgaySinh), "
                + "    GioiTinh    = COALESCE(yc.GioiTinh_Moi, nd.GioiTinh), "
                + "    Email       = COALESCE(yc.Email_Moi,    nd.Email), "
                + "    SoDienThoai = COALESCE(yc.SDT_Moi,      nd.SoDienThoai), "
                + "    CCCD        = COALESCE(yc.CCCD_Moi,     nd.CCCD), "
                + "    AvatarPath  = COALESCE(yc.Avatar_Moi,   nd.AvatarPath) "
                + "FROM YeuCauDoiTrangThai yc "
                + "WHERE yc.NguoiDungCapNhatID = nd.NguoiDungID AND yc.YeuCauID = ? AND yc.LoaiYeuCau = 2";
        String sqlNK
                = "UPDATE NguoiDung nd "
                + "SET TrangThaiNhanSu = yc.TrangThaiMoiID "
                + "FROM YeuCauDoiTrangThai yc "
                + "WHERE yc.NhanKhauID = nd.NguoiDungID AND yc.YeuCauID = ? AND yc.LoaiYeuCau = 3";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            Map<String, Object> yc = layTheoID(yeuCauID, conn);
            if (yc == null) { conn.rollback(); return false; }
            int loai          = (int) yc.get("loaiYeuCau");
            int nguoiYeuCauID = (int) yc.get("nguoiYeuCauID");

            try (PreparedStatement ps = conn.prepareStatement(sqlYC)) {
                ps.setInt(1, nguoiDuyetID);
                ps.setString(2, ghiChu);
                ps.setInt(3, yeuCauID);
                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
            }

            if (loai == 1) {
                try (PreparedStatement ps = conn.prepareStatement(sqlHD)) {
                    ps.setInt(1, yeuCauID); ps.executeUpdate();
                }
            } else if (loai == 2) {
                try (PreparedStatement ps = conn.prepareStatement(sqlND)) {
                    ps.setInt(1, yeuCauID);
                    if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
                }
            } else if (loai == 3) {
                try (PreparedStatement ps = conn.prepareStatement(sqlNK)) {
                    ps.setInt(1, yeuCauID);
                    if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
                }
            }

            thongBaoDAO.guiThongBaoCaNhan(
                    "Yêu cầu của bạn đã được duyệt",
                    loai == 1 ? "Yêu cầu đổi trạng thái hộ khẩu của bạn đã được cán bộ phường chấp thuận."
                    : loai == 2 ? "Yêu cầu cập nhật thông tin cá nhân của bạn đã được chấp thuận. Vui lòng đăng xuất và đăng nhập lại."
                    : "Yêu cầu đổi trạng thái nhân khẩu của bạn đã được cán bộ phường chấp thuận.",
                    nguoiDuyetID, nguoiYeuCauID,
                    yeuCauID, loai,
                    conn
            );

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            closeConn(conn);
        }
    }

    public boolean tuChoiYeuCau(int yeuCauID, int nguoiDuyetID, String lyDoTuChoi,
                                  ThongBaoDAO thongBaoDAO) {
        String sql
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 3, NguoiDuyetID = ?, NgayDuyet = NOW(), GhiChuDuyet = ? "
                + "WHERE YeuCauID = ? AND TrangThaiYeuCauID = 1";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            Map<String, Object> yc = layTheoID(yeuCauID, conn);
            if (yc == null) { conn.rollback(); return false; }
            int loai          = (int) yc.get("loaiYeuCau");
            int nguoiYeuCauID = (int) yc.get("nguoiYeuCauID");

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, nguoiDuyetID);
                ps.setString(2, lyDoTuChoi);
                ps.setInt(3, yeuCauID);
                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
            }

            thongBaoDAO.guiThongBaoCaNhan(
                    "Yêu cầu của bạn bị từ chối",
                    (loai == 1 ? "Yêu cầu đổi trạng thái hộ khẩu"
                     : loai == 2 ? "Yêu cầu cập nhật thông tin cá nhân"
                     : "Yêu cầu đổi trạng thái nhân khẩu")
                    + " bị từ chối. Lý do: " + lyDoTuChoi,
                    nguoiDuyetID, nguoiYeuCauID,
                    yeuCauID, loai,
                    conn
            );

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            closeConn(conn);
        }
    }

    public boolean huyYeuCau(int yeuCauID, int nguoiYeuCauID) {
        String sql = "UPDATE YeuCauDoiTrangThai SET TrangThaiYeuCauID = 4 "
                   + "WHERE YeuCauID = ? AND NguoiYeuCauID = ? AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ps.setInt(2, nguoiYeuCauID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}