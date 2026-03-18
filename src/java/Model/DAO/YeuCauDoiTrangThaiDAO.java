package Model.DAO;

import Model.Entity.YeuCauDoiTrangThai;
import java.sql.*;
import java.util.*;

public class YeuCauDoiTrangThaiDAO {

    private static final String BASE_SELECT
            = "SELECT "
            + "    yc.YeuCauID, yc.LoaiYeuCau, "
            + "    yc.HoDanID, yc.TrangThaiCuID, yc.TrangThaiMoiID, "
            + "    yc.NguoiYeuCauID, yc.LyDoYeuCau, yc.TrangThaiYeuCauID, "
            + "    yc.NguoiDuyetID, yc.NgayDuyet, yc.GhiChuDuyet, yc.NgayTao, "
            + "    hd.MaHoKhau, hd.DiaChi AS DiaChiHo, "
            + "    (nd_chu.Ho + ' ' + nd_chu.Ten) AS TenChuHo, "
            + "    tt_cu.TenTrangThai              AS TenTrangThaiCu, "
            + "    tt_moi.TenTrangThai             AS TenTrangThaiMoi, "
            + "    tdp.TenTo, "
            + "    (nd_yc.Ho + ' ' + nd_yc.Ten)   AS TenNguoiYeuCau, "
            + "    (nd_dt.Ho  + ' ' + nd_dt.Ten)   AS TenNguoiDuyet, "
            + "    ttyc.TenTrangThai               AS TenTrangThaiYeuCau, "
            + "    yc.NguoiDungCapNhatID, "
            + "    yc.Ho_Cu,  yc.Ten_Cu,  yc.NgaySinh_Cu,  yc.GioiTinh_Cu, "
            + "    yc.Email_Cu,  yc.SDT_Cu,  yc.CCCD_Cu,  yc.Avatar_Cu, "
            + "    yc.Ho_Moi, yc.Ten_Moi, yc.NgaySinh_Moi, yc.GioiTinh_Moi, "
            + "    yc.Email_Moi, yc.SDT_Moi, yc.CCCD_Moi, yc.Avatar_Moi "
            + "FROM YeuCauDoiTrangThai yc "
            + "JOIN  NguoiDung       nd_yc   ON nd_yc.NguoiDungID  = yc.NguoiYeuCauID "
            + "JOIN  TrangThaiYeuCau ttyc    ON ttyc.TrangThaiID   = yc.TrangThaiYeuCauID "
            + "LEFT JOIN HoDan           hd      ON hd.HoDanID         = yc.HoDanID "
            + "LEFT JOIN TrangThaiHoKhau tt_cu   ON tt_cu.TrangThaiID  = yc.TrangThaiCuID "
            + "LEFT JOIN TrangThaiHoKhau tt_moi  ON tt_moi.TrangThaiID = yc.TrangThaiMoiID "
            + "LEFT JOIN ToDanPho        tdp     ON tdp.ToDanPhoID      = hd.ToDanPhoID "
            + "LEFT JOIN NguoiDung       nd_chu  ON nd_chu.NguoiDungID = hd.ChuHoID "
            + "LEFT JOIN NguoiDung       nd_dt   ON nd_dt.NguoiDungID  = yc.NguoiDuyetID ";

    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("yeuCauID",           rs.getInt("YeuCauID"));
        row.put("loaiYeuCau",         rs.getInt("LoaiYeuCau"));
        row.put("hoDanID",            rs.getInt("HoDanID"));
        row.put("trangThaiCuID",      rs.getInt("TrangThaiCuID"));
        row.put("trangThaiMoiID",     rs.getInt("TrangThaiMoiID"));
        row.put("nguoiYeuCauID",      rs.getInt("NguoiYeuCauID"));
        row.put("lyDoYeuCau",         rs.getString("LyDoYeuCau"));
        row.put("trangThaiYeuCauID",  rs.getInt("TrangThaiYeuCauID"));
        int nguoiDuyetID = rs.getInt("NguoiDuyetID");
        row.put("nguoiDuyetID",       rs.wasNull() ? null : nguoiDuyetID);
        row.put("ngayDuyet",          rs.getString("NgayDuyet"));
        row.put("ghiChuDuyet",        rs.getString("GhiChuDuyet"));
        row.put("ngayTao",            rs.getString("NgayTao"));
        row.put("maHoKhau",           rs.getString("MaHoKhau"));
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
        row.put("ho_Cu",         rs.getString("Ho_Cu"));
        row.put("ten_Cu",        rs.getString("Ten_Cu"));
        row.put("ngaySinh_Cu",   rs.getString("NgaySinh_Cu"));
        row.put("gioiTinh_Cu",   rs.getString("GioiTinh_Cu"));
        row.put("email_Cu",      rs.getString("Email_Cu"));
        row.put("sDT_Cu",        rs.getString("SDT_Cu"));
        row.put("cCCD_Cu",       rs.getString("CCCD_Cu"));
        row.put("avatar_Cu",     rs.getString("Avatar_Cu"));
        row.put("ho_Moi",        rs.getString("Ho_Moi"));
        row.put("ten_Moi",       rs.getString("Ten_Moi"));
        row.put("ngaySinh_Moi",  rs.getString("NgaySinh_Moi"));
        row.put("gioiTinh_Moi",  rs.getString("GioiTinh_Moi"));
        row.put("email_Moi",     rs.getString("Email_Moi"));
        row.put("sDT_Moi",       rs.getString("SDT_Moi"));
        row.put("cCCD_Moi",      rs.getString("CCCD_Moi"));
        row.put("avatar_Moi",    rs.getString("Avatar_Moi"));
        return row;
    }

    // ------------------------------------------------------------------ //
    //  GIỮ NGUYÊN: TẠO YÊU CẦU ĐỔI TRẠNG THÁI (loại 1)
    // ------------------------------------------------------------------ //
    public boolean taoYeuCau(int hoDanID, int trangThaiCuID, int trangThaiMoiID,
            int nguoiYeuCauID, String lyDo) {
        String sql
                = "INSERT INTO YeuCauDoiTrangThai "
                + "    (LoaiYeuCau, HoDanID, TrangThaiCuID, TrangThaiMoiID, NguoiYeuCauID, LyDoYeuCau, TrangThaiYeuCauID) "
                + "VALUES (1, ?, ?, ?, ?, ?, 1)";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
    //  THÊM MỚI: HUỶ YÊU CẦU CŨ CÙNG TRƯỜNG (tránh trùng lặp)
    // ------------------------------------------------------------------ //
    private void huyYeuCauCungTruong(int nguoiDungID, YeuCauDoiTrangThai yc,
            Connection conn) throws SQLException {
        String sqlLayDS
                = "SELECT YeuCauID, Ho_Moi, Ten_Moi, NgaySinh_Moi, GioiTinh_Moi, "
                + "       Email_Moi, SDT_Moi, CCCD_Moi "
                + "FROM YeuCauDoiTrangThai "
                + "WHERE LoaiYeuCau = 2 AND NguoiDungCapNhatID = ? AND TrangThaiYeuCauID = 1";
        String sqlHuy
                = "UPDATE YeuCauDoiTrangThai SET TrangThaiYeuCauID = 4 WHERE YeuCauID = ?";

        try (PreparedStatement psLayDS = conn.prepareStatement(sqlLayDS)) {
            psLayDS.setInt(1, nguoiDungID);
            ResultSet rs = psLayDS.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("YeuCauID");
                boolean trung = false;

                if (yc.getHo_Moi()       != null && rs.getString("Ho_Moi")       != null) trung = true;
                if (yc.getTen_Moi()      != null && rs.getString("Ten_Moi")      != null) trung = true;
                if (yc.getNgaySinh_Moi() != null && rs.getString("NgaySinh_Moi") != null) trung = true;
                if (yc.getGioiTinh_Moi() != null && rs.getString("GioiTinh_Moi") != null) trung = true;
                if (yc.getEmail_Moi()    != null && rs.getString("Email_Moi")    != null) trung = true;
                if (yc.getSDT_Moi()      != null && rs.getString("SDT_Moi")      != null) trung = true;
                if (yc.getCCCD_Moi()     != null && rs.getString("CCCD_Moi")     != null) trung = true;

                if (trung) {
                    try (PreparedStatement psHuy = conn.prepareStatement(sqlHuy)) {
                        psHuy.setInt(1, id);
                        psHuy.executeUpdate();
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------------ //
    //  THÊM MỚI: TẠO YÊU CẦU CẬP NHẬT THÔNG TIN (loại 2)
    // ------------------------------------------------------------------ //
    public boolean taoYeuCauCapNhat(int nguoiDungID, YeuCauDoiTrangThai yc,
            ThongBaoDAO thongBaoDAO) {
        String sql
                = "INSERT INTO YeuCauDoiTrangThai "
                + "    (LoaiYeuCau, NguoiYeuCauID, LyDoYeuCau, TrangThaiYeuCauID, "
                + "     NguoiDungCapNhatID, "
                + "     Ho_Cu, Ten_Cu, NgaySinh_Cu, GioiTinh_Cu, Email_Cu, SDT_Cu, CCCD_Cu, Avatar_Cu, "
                + "     Ho_Moi, Ten_Moi, NgaySinh_Moi, GioiTinh_Moi, Email_Moi, SDT_Moi, CCCD_Moi, Avatar_Moi) "
                + "VALUES (2, ?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            huyYeuCauCungTruong(nguoiDungID, yc, conn);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, nguoiDungID);
                ps.setString(2, yc.getLyDoYeuCau());
                ps.setInt(3, nguoiDungID);
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

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            thongBaoDAO.guiThongBaoTheoVaiTro(
                "Yêu cầu cập nhật thông tin cá nhân mới",
                "Hộ dân " + yc.getHo_Cu() + " " + yc.getTen_Cu()
                    + " vừa gửi yêu cầu cập nhật thông tin cá nhân. Vui lòng kiểm tra và xử lý.",
                nguoiDungID, "CanBoPhuong", conn
            );

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
    //  GIỮ NGUYÊN: KIỂM TRA hộ đang có yêu cầu đổi trạng thái chờ duyệt
    // ------------------------------------------------------------------ //
    public boolean dangCoYeuCauChoDuyet(int hoDanID) {
        String sql
                = "SELECT COUNT(1) FROM YeuCauDoiTrangThai "
                + "WHERE HoDanID = ? AND LoaiYeuCau = 1 AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  GIỮ NGUYÊN: KIỂM TRA người dùng đang có yêu cầu cập nhật chờ duyệt
    // ------------------------------------------------------------------ //
    public boolean dangCoYeuCauCapNhatChoDuyet(int nguoiDungID) {
        String sql
                = "SELECT COUNT(1) FROM YeuCauDoiTrangThai "
                + "WHERE NguoiDungCapNhatID = ? AND LoaiYeuCau = 2 AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  LẤY THEO ID - dùng connection riêng (public, gọi từ bên ngoài)
    // ------------------------------------------------------------------ //
    public Map<String, Object> layTheoID(int yeuCauID) {
        String sql = BASE_SELECT + "WHERE yc.YeuCauID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  LẤY THEO ID - dùng connection có sẵn (dùng trong transaction)
    // ------------------------------------------------------------------ //
    private Map<String, Object> layTheoID(int yeuCauID, Connection conn) throws SQLException {
        String sql = BASE_SELECT + "WHERE yc.YeuCauID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  GIỮ NGUYÊN: LẤY DANH SÁCH THEO TỔ
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachTheoTo(int toDanPhoID) {
        String sql = BASE_SELECT + "WHERE hd.ToDanPhoID = ? ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
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
    //  GIỮ NGUYÊN: LẤY DANH SÁCH CHỜ DUYỆT (tất cả loại)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachChoDuyet() {
        String sql = BASE_SELECT + "WHERE yc.TrangThaiYeuCauID = 1 ORDER BY yc.NgayTao ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  THÊM MỚI: LẤY DANH SÁCH YÊU CẦU CẬP NHẬT CHỜ DUYỆT (loại 2)
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layDanhSachCapNhatChoDuyet() {
        String sql = BASE_SELECT
                + "WHERE yc.LoaiYeuCau = 2 AND yc.TrangThaiYeuCauID = 1 "
                + "ORDER BY yc.NgayTao ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  GIỮ NGUYÊN: LẤY TẤT CẢ
    // ------------------------------------------------------------------ //
    public List<Map<String, Object>> layTatCa() {
        String sql = BASE_SELECT + "ORDER BY yc.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  DUYỆT yêu cầu (cả 2 loại)
    //  FIX: dùng layTheoID(id, conn) cùng transaction thay vì connection riêng
    // ------------------------------------------------------------------ //
    public boolean duyetYeuCau(int yeuCauID, int nguoiDuyetID, String ghiChu,
            ThongBaoDAO thongBaoDAO) {
        String sqlYC
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 2, NguoiDuyetID = ?, NgayDuyet = GETDATE(), GhiChuDuyet = ? "
                + "WHERE YeuCauID = ? AND TrangThaiYeuCauID = 1";
        String sqlHD
                = "UPDATE hd SET hd.TrangThaiID = yc.TrangThaiMoiID "
                + "FROM HoDan hd "
                + "JOIN YeuCauDoiTrangThai yc ON yc.HoDanID = hd.HoDanID "
                + "WHERE yc.YeuCauID = ? AND yc.LoaiYeuCau = 1";
        String sqlND
                = "UPDATE nd "
                + "SET nd.Ho           = COALESCE(yc.Ho_Moi,       nd.Ho), "
                + "    nd.Ten          = COALESCE(yc.Ten_Moi,      nd.Ten), "
                + "    nd.NgaySinh     = COALESCE(yc.NgaySinh_Moi, nd.NgaySinh), "
                + "    nd.GioiTinh     = COALESCE(yc.GioiTinh_Moi, nd.GioiTinh), "
                + "    nd.Email        = COALESCE(yc.Email_Moi,     nd.Email), "
                + "    nd.SoDienThoai  = COALESCE(yc.SDT_Moi,      nd.SoDienThoai), "
                + "    nd.CCCD         = COALESCE(yc.CCCD_Moi,     nd.CCCD), "
                + "    nd.AvatarPath   = COALESCE(yc.Avatar_Moi,   nd.AvatarPath) "
                + "FROM NguoiDung nd "
                + "JOIN YeuCauDoiTrangThai yc ON yc.NguoiDungCapNhatID = nd.NguoiDungID "
                + "WHERE yc.YeuCauID = ? AND yc.LoaiYeuCau = 2";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            // ✅ FIX: dùng overload cùng connection để nằm trong transaction
            Map<String, Object> yc = layTheoID(yeuCauID, conn);
            if (yc == null) {
                System.err.println("[duyetYeuCau] Không tìm thấy yeuCauID=" + yeuCauID);
                conn.rollback();
                return false;
            }
            int loai          = (int) yc.get("loaiYeuCau");
            int nguoiYeuCauID = (int) yc.get("nguoiYeuCauID");

            // Cập nhật trạng thái yêu cầu → 2 (đã duyệt)
            try (PreparedStatement ps = conn.prepareStatement(sqlYC)) {
                ps.setInt(1, nguoiDuyetID);
                ps.setString(2, ghiChu);
                ps.setInt(3, yeuCauID);
                int rows = ps.executeUpdate();
                System.out.println("[duyetYeuCau] UPDATE TrangThaiYeuCauID rows=" + rows);
                if (rows == 0) { conn.rollback(); return false; }
            }

            if (loai == 1) {
                // Cập nhật trạng thái hộ dân
                try (PreparedStatement ps = conn.prepareStatement(sqlHD)) {
                    ps.setInt(1, yeuCauID);
                    int rows = ps.executeUpdate();
                    System.out.println("[duyetYeuCau] UPDATE HoDan rows=" + rows);
                }
            } else if (loai == 2) {
                // ✅ FIX: câu UPDATE sqlND chạy SAU khi sqlYC đã commit TrangThaiYeuCauID=2
                // nên JOIN vẫn tìm được bản ghi (YeuCauID match, LoaiYeuCau=2 vẫn đúng)
                try (PreparedStatement ps = conn.prepareStatement(sqlND)) {
                    ps.setInt(1, yeuCauID);
                    int rows = ps.executeUpdate();
                    System.out.println("[duyetYeuCau] UPDATE NguoiDung rows=" + rows);
                    if (rows == 0) {
                        System.err.println("[duyetYeuCau] CẢNH BÁO: Không update được NguoiDung, "
                                + "kiểm tra NguoiDungCapNhatID trong bản ghi yeuCauID=" + yeuCauID);
                        conn.rollback();
                        return false;
                    }
                }
            }

            thongBaoDAO.guiThongBaoCaNhan(
                "Yêu cầu của bạn đã được duyệt",
                loai == 1
                    ? "Yêu cầu đổi trạng thái hộ khẩu của bạn đã được cán bộ phường chấp thuận."
                    : "Yêu cầu cập nhật thông tin cá nhân của bạn đã được cán bộ phường chấp thuận. "
                    + "Vui lòng đăng xuất và đăng nhập lại để cập nhật thông tin mới.",
                nguoiDuyetID, nguoiYeuCauID, conn
            );

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
    //  TỪ CHỐI yêu cầu
    //  FIX: dùng layTheoID(id, conn) cùng transaction thay vì connection riêng
    // ------------------------------------------------------------------ //
    public boolean tuChoiYeuCau(int yeuCauID, int nguoiDuyetID, String lyDoTuChoi,
            ThongBaoDAO thongBaoDAO) {
        String sql
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 3, NguoiDuyetID = ?, NgayDuyet = GETDATE(), GhiChuDuyet = ? "
                + "WHERE YeuCauID = ? AND TrangThaiYeuCauID = 1";

        Connection conn = null;
        try {
            conn = DBContext.getInstance().getConnection();
            conn.setAutoCommit(false);

            // ✅ FIX: dùng overload cùng connection
            Map<String, Object> yc = layTheoID(yeuCauID, conn);
            if (yc == null) {
                System.err.println("[tuChoiYeuCau] Không tìm thấy yeuCauID=" + yeuCauID);
                conn.rollback();
                return false;
            }
            int loai          = (int) yc.get("loaiYeuCau");
            int nguoiYeuCauID = (int) yc.get("nguoiYeuCauID");

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, nguoiDuyetID);
                ps.setString(2, lyDoTuChoi);
                ps.setInt(3, yeuCauID);
                int rows = ps.executeUpdate();
                System.out.println("[tuChoiYeuCau] UPDATE rows=" + rows);
                if (rows == 0) { conn.rollback(); return false; }
            }

            thongBaoDAO.guiThongBaoCaNhan(
                "Yêu cầu của bạn bị từ chối",
                (loai == 1 ? "Yêu cầu đổi trạng thái hộ khẩu"
                           : "Yêu cầu cập nhật thông tin cá nhân")
                    + " bị từ chối. Lý do: " + lyDoTuChoi,
                nguoiDuyetID, nguoiYeuCauID, conn
            );

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
    //  HUỶ yêu cầu
    // ------------------------------------------------------------------ //
    public boolean huyYeuCau(int yeuCauID, int nguoiYeuCauID) {
        String sql
                = "UPDATE YeuCauDoiTrangThai "
                + "SET TrangThaiYeuCauID = 4 "
                + "WHERE YeuCauID = ? AND NguoiYeuCauID = ? AND TrangThaiYeuCauID = 1";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, yeuCauID);
            ps.setInt(2, nguoiYeuCauID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ //
    //  LẤY CHI TIẾT THEO THÔNG BÁO
    // ------------------------------------------------------------------ //
    public Map<String, Object> layChiTietTheoThongBao(int thongBaoID) {
        String sql = BASE_SELECT
                + "WHERE yc.TrangThaiYeuCauID = 1 "
                + "AND yc.NgayTao <= (SELECT TOP 1 NgayGui FROM ThongBao WHERE ThongBaoID = ?) "
                + "ORDER BY yc.NgayTao DESC";
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
    //  LẤY DANH SÁCH YÊU CẦU CẬP NHẬT CỦA 1 NGƯỜI DÙNG
    // ------------------------------------------------------------------ //
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}