package Model.DAO;

import Model.Entity.LoaiPhanAnh;

import java.sql.*;
import java.util.*;

public class PhanAnhDAO {

    // ==================== HELPER ====================

    private Map<String, Object> mapRowDanhSach(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("phanAnhID",    rs.getInt("PhanAnhID"));
        row.put("tieuDe",       rs.getString("TieuDe"));
        row.put("noiDung",      rs.getString("NoiDung"));
        row.put("loaiID",       rs.getInt("LoaiID"));
        row.put("tenLoai",      rs.getString("TenLoai"));
        row.put("mucDoUuTien",  rs.getInt("MucDoID"));
        row.put("tenMucDo",     tenMucDo(rs.getInt("MucDoID")));
        row.put("trangThaiID",  rs.getInt("TrangThaiID"));
        row.put("tenTrangThai", rs.getString("TenTrangThai"));
        row.put("toDanPhoID",   rs.getInt("ToDanPhoID"));
        row.put("tenToDanPho",  rs.getString("TenToDanPho"));
        row.put("tenNguoiGui",  rs.getString("TenNguoiGui"));
        row.put("nguoiGuiID",   rs.getInt("NguoiGuiID"));
        row.put("daChuyenCap",  rs.getBoolean("DaChuyenCap"));
        try { row.put("isSpam", rs.getBoolean("IsSpam")); }
        catch (SQLException ignored) { row.put("isSpam", false); }
        row.put("ngayTao",      rs.getTimestamp("NgayTao"));
        row.put("ngayCapNhat",  rs.getTimestamp("NgayCapNhat"));
        return row;
    }

    private Map<String, Object> mapRowChiTiet(ResultSet rs) throws SQLException {
        Map<String, Object> row = mapRowDanhSach(rs);
        // Thêm các field chỉ cần khi xem chi tiết
        int nguoiXuLyID = rs.getInt("NguoiXuLyID");
        row.put("nguoiXuLyID",   rs.wasNull() ? null : nguoiXuLyID);
        row.put("tenNguoiXuLy",  rs.getString("TenNguoiXuLy"));
        row.put("lyDoTuChoiHuy", rs.getString("LyDoTuChoiHuy"));
        return row;
    }

    private String tenMucDo(int mucDo) {
        return switch (mucDo) {
            case 1 -> "Thấp";
            case 2 -> "Trung bình";
            case 3 -> "Cao";
            default -> "Không xác định";
        };
    }

    /** Ghi log lịch sử xử lý — dùng chung Connection để đảm bảo transaction */
    private void ghiLog(Connection conn, int phanAnhID, int nguoiThucHienID,
                        String hanhDong, Integer trangThaiCu, Integer trangThaiMoi,
                        String ghiChu) throws SQLException {
        String sql =
            "INSERT INTO LichSuXuLyPhanAnh " +
            "    (PhanAnhID, NguoiThucHienID, HanhDong, TrangThaiCu, TrangThaiMoi, GhiChu, ThoiGian) " +
            "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, phanAnhID);
            ps.setInt(2, nguoiThucHienID);
            ps.setString(3, hanhDong);
            if (trangThaiCu  != null) ps.setInt(4, trangThaiCu);  else ps.setNull(4, Types.INTEGER);
            if (trangThaiMoi != null) ps.setInt(5, trangThaiMoi); else ps.setNull(5, Types.INTEGER);
            ps.setString(6, ghiChu);
            ps.executeUpdate();
        }
    }

    /** Lưu ảnh đính kèm — dùng chung Connection */
    private void luuAnh(Connection conn, int phanAnhID,
                        List<String> duongDanAnh) throws SQLException {
        if (duongDanAnh == null || duongDanAnh.isEmpty()) return;
        String sql =
            "INSERT INTO FileDinhKemPhanAnh (PhanAnhID, DuongDan, NgayUpload) " +
            "VALUES (?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String path : duongDanAnh) {
                ps.setInt(1, phanAnhID);
                ps.setString(2, path);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /** Đếm số ảnh hiện tại của 1 phản ánh */
    private int demAnh(Connection conn, int phanAnhID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM FileDinhKemPhanAnh WHERE PhanAnhID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, phanAnhID);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Gửi thông báo đến 1 người dùng cụ thể */
    private void guiThongBao(Connection conn, int nguoiGuiID, int nguoiNhanID,
                              String tieuDe, String noiDung) throws SQLException {
        String sqlTB =
            "INSERT INTO ThongBao (TieuDe, NoiDung, NguoiGuiID, NgayGui) " +
            "VALUES (?, ?, ?, NOW())";
        String sqlNN =
            "INSERT INTO NguoiNhanThongBao (ThongBaoID, NguoiDungID) VALUES (?, ?)";
        try (PreparedStatement psTB = conn.prepareStatement(
                sqlTB, Statement.RETURN_GENERATED_KEYS)) {
            psTB.setString(1, tieuDe);
            psTB.setString(2, noiDung);
            psTB.setInt(3, nguoiGuiID);
            psTB.executeUpdate();
            ResultSet keys = psTB.getGeneratedKeys();
            if (keys.next()) {
                int tbID = keys.getInt(1);
                try (PreparedStatement psNN = conn.prepareStatement(sqlNN)) {
                    psNN.setInt(1, tbID);
                    psNN.setInt(2, nguoiNhanID);
                    psNN.executeUpdate();
                }
            }
        }
    }

    // ==================== HỘ DÂN — GỬI PHẢN ÁNH ====================

    /**
     * Hộ dân gửi phản ánh mới.
     * Tối đa 3 ảnh. Tự ghi log TIEP_NHAN.
     * Gửi thông báo đến tổ trưởng của tổ.
     * @return PhanAnhID vừa tạo, -1 nếu thất bại.
     */
    public int guiPhanAnh(int nguoiGuiID, int toDanPhoID, int loaiID,
                           int mucDoUuTien, String tieuDe, String noiDung,
                           List<String> duongDanAnh) {
        String sqlPA =
            "INSERT INTO PhanAnh " +
            "    (TieuDe, NoiDung, LoaiID, MucDoID, NguoiGuiID, ToDanPhoID, " +
            "     TrangThaiID, DaChuyenCap, NgayTao) " +
            "VALUES (?, ?, ?, ?, ?, ?, 1, 0, NOW())";
        // Tìm tổ trưởng của tổ để gửi thông báo
        String sqlToTruong =
            "SELECT NguoiDungID FROM NguoiDung " +
            "WHERE ToDanPhoID = ? AND VaiTroID = 3 AND IsActivated = 1";
        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            int phanAnhID = -1;
            try {
                // 1. INSERT phản ánh chính
                try (PreparedStatement ps = conn.prepareStatement(
                        sqlPA, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, tieuDe);
                    ps.setString(2, noiDung);
                    ps.setInt(3, loaiID);
                    ps.setInt(4, mucDoUuTien);
                    ps.setInt(5, nguoiGuiID);
                    ps.setInt(6, toDanPhoID);
                    ps.executeUpdate();
                    ResultSet keys = ps.getGeneratedKeys();
                    if (!keys.next()) throw new SQLException("Không lấy được PhanAnhID.");
                    phanAnhID = keys.getInt(1);
                }
                // 2. Lưu ảnh — bỏ qua nếu lỗi, không ảnh hưởng commit chính
                if (duongDanAnh != null && !duongDanAnh.isEmpty()) {
                    try {
                        luuAnh(conn, phanAnhID,
                                duongDanAnh.subList(0, Math.min(3, duongDanAnh.size())));
                    } catch (Exception eAnh) {
                        System.err.println("[PhanAnhDAO] Lỗi lưu ảnh: " + eAnh.getMessage());
                    }
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return -1;
            }

            // 3. Ghi log & thông báo (connection riêng — không block kết quả chính)
            try (Connection conn2 = DBContext.getInstance().getConnection()) {
                conn2.setAutoCommit(false);
                try {
                    ghiLog(conn2, phanAnhID, nguoiGuiID,
                            "TIEP_NHAN", null, 1, "Hộ dân gửi phản ánh mới.");
                    try (PreparedStatement ps = conn2.prepareStatement(sqlToTruong)) {
                        ps.setInt(1, toDanPhoID);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            guiThongBao(conn2, nguoiGuiID, rs.getInt("NguoiDungID"),
                                    "[Phản ánh mới] " + tieuDe,
                                    "Hộ dân vừa gửi phản ánh mới. Vui lòng kiểm tra và xử lý.");
                        }
                    }
                    conn2.commit();
                } catch (Exception eLog) {
                    conn2.rollback();
                    System.err.println("[PhanAnhDAO] Lỗi ghi log/TB: " + eLog.getMessage());
                }
            } catch (Exception e2) {
                System.err.println("[PhanAnhDAO] Lỗi conn2: " + e2.getMessage());
            }

            return phanAnhID;

        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ==================== HỘ DÂN — SỬA PHẢN ÁNH ====================

    /**
     * Hộ dân sửa phản ánh.
     * Không được sửa khi: Đã giải quyết (4), Từ chối (5), Spam (6), Đã hủy (7).
     * Nếu đã chuyển cấp (3) → thông báo thẳng cán bộ.
     * Ngược lại → thông báo tổ trưởng.
     * @return true nếu thành công.
     */
    public boolean suaPhanAnh(int phanAnhID, int nguoiGuiID, int loaiID,
                               int mucDoUuTien, String tieuDe, String noiDung,
                               List<String> duongDanAnhMoi, List<Integer> fileIDXoa) {
        // Kiểm tra trạng thái hiện tại
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int ttHienTai    = (int) hien.get("trangThaiID");
        int toDanPhoID   = (int) hien.get("toDanPhoID");
        boolean daChuyenCap = (boolean) hien.get("daChuyenCap");
        // Không cho sửa khi đã kết thúc
        if (ttHienTai == 4 || ttHienTai == 5 || ttHienTai == 6 || ttHienTai == 7) return false;

        String sqlUpdate =
            "UPDATE PhanAnh " +
            "   SET TieuDe = ?, NoiDung = ?, LoaiID = ?, MucDoID = ?, NgayCapNhat = NOW() " +
            " WHERE PhanAnhID = ? AND NguoiGuiID = ?";
        String sqlXoaAnh =
            "DELETE FROM FileDinhKemPhanAnh WHERE FileID = ? AND PhanAnhID = ?";
        // Tìm người nhận thông báo
        String sqlNguoiNhan = daChuyenCap
            // Đã chuyển cấp → tìm cán bộ phường (VaiTroID = 5)
            ? "SELECT NguoiDungID FROM NguoiDung WHERE VaiTroID = 5 AND IsActivated = 1"
            // Chưa chuyển cấp → tổ trưởng của tổ
            : "SELECT NguoiDungID FROM NguoiDung WHERE ToDanPhoID = ? AND VaiTroID = 3 AND IsActivated = 1";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Cập nhật thông tin
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setString(1, tieuDe);
                    ps.setString(2, noiDung);
                    ps.setInt(3, loaiID);
                    ps.setInt(4, mucDoUuTien);
                    ps.setInt(5, phanAnhID);
                    ps.setInt(6, nguoiGuiID);
                    ps.executeUpdate();
                }
                // 2. Xóa ảnh được chọn xóa
                if (fileIDXoa != null && !fileIDXoa.isEmpty()) {
                    try (PreparedStatement ps = conn.prepareStatement(sqlXoaAnh)) {
                        for (int fid : fileIDXoa) {
                            ps.setInt(1, fid);
                            ps.setInt(2, phanAnhID);
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }
                // 3. Thêm ảnh mới (không vượt tổng 3 ảnh)
                if (duongDanAnhMoi != null && !duongDanAnhMoi.isEmpty()) {
                    int conLai = 3 - demAnh(conn, phanAnhID);
                    if (conLai > 0) {
                        luuAnh(conn, phanAnhID,
                                duongDanAnhMoi.subList(0, Math.min(conLai, duongDanAnhMoi.size())));
                    }
                }
                // 4. Ghi log
                ghiLog(conn, phanAnhID, nguoiGuiID,
                        "CHINH_SUA", ttHienTai, ttHienTai, "Hộ dân chỉnh sửa phản ánh.");
                // 5. Thông báo đến người xử lý
                try (PreparedStatement ps = conn.prepareStatement(sqlNguoiNhan)) {
                    if (!daChuyenCap) ps.setInt(1, toDanPhoID);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        guiThongBao(conn, nguoiGuiID, rs.getInt("NguoiDungID"),
                                "[Cập nhật phản ánh] " + tieuDe,
                                "Hộ dân vừa chỉnh sửa nội dung phản ánh. Vui lòng xem lại.");
                    }
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== HỘ DÂN — HỦY PHẢN ÁNH ====================

    /**
     * Hộ dân hủy phản ánh.
     * KHÔNG được hủy khi đã chuyển cấp (3) hoặc đã kết thúc (4,5,6,7).
     * Thông báo đến tổ trưởng khi hủy.
     */
    public boolean huyPhanAnh(int phanAnhID, int nguoiGuiID, String lyDo) {
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int ttHienTai  = (int) hien.get("trangThaiID");
        int toDanPhoID = (int) hien.get("toDanPhoID");
        String tieuDe  = (String) hien.get("tieuDe");
        if (ttHienTai == 3 || ttHienTai == 4 || ttHienTai == 5
                || ttHienTai == 6 || ttHienTai == 7) return false;

        String sqlUpdate =
            "UPDATE PhanAnh " +
            "   SET TrangThaiID = 7, NgayCapNhat = NOW(), LyDoTuChoiHuy = ? " +
            " WHERE PhanAnhID = ? AND NguoiGuiID = ?";
        String sqlToTruong =
            "SELECT NguoiDungID FROM NguoiDung " +
            "WHERE ToDanPhoID = ? AND VaiTroID = 3 AND IsActivated = 1";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setString(1, lyDo);
                    ps.setInt(2, phanAnhID);
                    ps.setInt(3, nguoiGuiID);
                    if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
                }
                ghiLog(conn, phanAnhID, nguoiGuiID, "HUY", ttHienTai, 7, lyDo);
                // Thông báo tổ trưởng
                try (PreparedStatement ps = conn.prepareStatement(sqlToTruong)) {
                    ps.setInt(1, toDanPhoID);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        guiThongBao(conn, nguoiGuiID, rs.getInt("NguoiDungID"),
                                "[Hủy phản ánh] " + tieuDe,
                                "Hộ dân đã hủy phản ánh. Lý do: " + lyDo);
                    }
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== TỔ TRƯỞNG — TIẾP NHẬN ====================

    /** Tổ trưởng tiếp nhận phản ánh → TrangThaiID = 2 (Đang xử lý) */
    public boolean tiepNhan(int phanAnhID, int toTruongID, String ghiChu) {
        String sql =
            "UPDATE PhanAnh SET TrangThaiID = 2, NguoiXuLyID = ?, NgayCapNhat = NOW() " +
            " WHERE PhanAnhID = ? AND TrangThaiID = 1";
        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int rows;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, toTruongID);
                    ps.setInt(2, phanAnhID);
                    rows = ps.executeUpdate();
                }
                if (rows == 0) { conn.rollback(); return false; }
                ghiLog(conn, phanAnhID, toTruongID, "TIEP_NHAN", 1, 2, ghiChu);
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== TỔ TRƯỞNG — TỪ CHỐI ====================

    /** Tổ trưởng từ chối phản ánh → TrangThaiID = 5 */
    public boolean tuChoi(int phanAnhID, int toTruongID, String lyDo) {
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int ttHienTai  = (int) hien.get("trangThaiID");
        int nguoiGuiID = (int) hien.get("nguoiGuiID");
        String tieuDe  = (String) hien.get("tieuDe");

        String sql =
            "UPDATE PhanAnh " +
            "   SET TrangThaiID = 5, NgayCapNhat = NOW(), LyDoTuChoiHuy = ? " +
            " WHERE PhanAnhID = ? AND TrangThaiID IN (1, 2)";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int rows;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, lyDo);
                    ps.setInt(2, phanAnhID);
                    rows = ps.executeUpdate();
                }
                if (rows == 0) { conn.rollback(); return false; }
                ghiLog(conn, phanAnhID, toTruongID, "TU_CHOI", ttHienTai, 5, lyDo);
                // Thông báo lại hộ dân
                guiThongBao(conn, toTruongID, nguoiGuiID,
                        "[Từ chối phản ánh] " + tieuDe,
                        "Phản ánh của bạn đã bị từ chối. Lý do: " + lyDo);
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== TỔ TRƯỞNG — ĐÁNH DẤU SPAM ====================

    /** Tổ trưởng đánh dấu spam → TrangThaiID = 6, IsSpam = 1 */
    public boolean danhDauSpam(int phanAnhID, int toTruongID, String ghiChu) {
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int ttHienTai  = (int) hien.get("trangThaiID");
        int nguoiGuiID = (int) hien.get("nguoiGuiID");
        String tieuDe  = (String) hien.get("tieuDe");

        String sql =
            "UPDATE PhanAnh " +
            "   SET TrangThaiID = 6, IsSpam = 1, NgayCapNhat = NOW() " +
            " WHERE PhanAnhID = ? AND TrangThaiID IN (1, 2)";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int rows;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, phanAnhID);
                    rows = ps.executeUpdate();
                }
                if (rows == 0) { conn.rollback(); return false; }
                ghiLog(conn, phanAnhID, toTruongID, "SPAM", ttHienTai, 6, ghiChu);
                // Thông báo hộ dân
                guiThongBao(conn, toTruongID, nguoiGuiID,
                        "[Spam] " + tieuDe,
                        "Phản ánh của bạn đã bị đánh dấu spam. Lý do: " + ghiChu);
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== TỔ TRƯỞNG — CHUYỂN CẤP ====================

    /** Tổ trưởng chuyển phản ánh lên cán bộ phường → TrangThaiID = 3, DaChuyenCap = 1 */
    public boolean chuyenCapCanBo(int phanAnhID, int toTruongID, String ghiChu) {
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int nguoiGuiID = (int) hien.get("nguoiGuiID");
        String tieuDe  = (String) hien.get("tieuDe");

        String sql =
            "UPDATE PhanAnh " +
            "   SET TrangThaiID = 3, DaChuyenCap = 1, NgayCapNhat = NOW() " +
            " WHERE PhanAnhID = ? AND TrangThaiID = 1";  // ← SỬA: 2 → 1
        String sqlCanBo =
            "SELECT NguoiDungID FROM NguoiDung WHERE VaiTroID = 5 AND IsActivated = 1";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int rows;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, phanAnhID);
                    rows = ps.executeUpdate();
                }
                if (rows == 0) { conn.rollback(); return false; }
                ghiLog(conn, phanAnhID, toTruongID, "CHUYEN_CAP", 1, 3, ghiChu);  // ← SỬA: 2 → 1
                // Thông báo hộ dân
                guiThongBao(conn, toTruongID, nguoiGuiID,
                        "[Chuyển cấp] " + tieuDe,
                        "Phản ánh của bạn đã được chuyển lên cán bộ phường xử lý.");
                // Thông báo cán bộ phường
                try (PreparedStatement ps = conn.prepareStatement(sqlCanBo)) {
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        guiThongBao(conn, toTruongID, rs.getInt("NguoiDungID"),
                                "[Phản ánh chuyển cấp] " + tieuDe,
                                "Tổ trưởng đã chuyển phản ánh lên để xử lý. Ghi chú: " + ghiChu);
                    }
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== CÁN BỘ PHƯỜNG — GIẢI QUYẾT ====================

    /**
     * Cán bộ phường giải quyết phản ánh → TrangThaiID = 4.
     * Ghi chú kết quả và thông báo lại hộ dân.
     */
    public boolean giaiquyetPhanAnh(int phanAnhID, int canBoID, String ketQua) {
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int nguoiGuiID = (int) hien.get("nguoiGuiID");
        String tieuDe  = (String) hien.get("tieuDe");

        String sql =
            "UPDATE PhanAnh " +
            "   SET TrangThaiID = 4, NguoiXuLyID = ?, NgayCapNhat = NOW() " +
            " WHERE PhanAnhID = ? AND TrangThaiID = 3";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int rows;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, canBoID);
                    ps.setInt(2, phanAnhID);
                    rows = ps.executeUpdate();
                }
                if (rows == 0) { conn.rollback(); return false; }
                ghiLog(conn, phanAnhID, canBoID, "GIAI_QUYET", 3, 4, ketQua);
                // Thông báo hộ dân kết quả xử lý
                guiThongBao(conn, canBoID, nguoiGuiID,
                        "[Đã giải quyết] " + tieuDe,
                        "Phản ánh của bạn đã được giải quyết. Kết quả: " + ketQua);
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== QUERY ====================

    /** Lấy chi tiết 1 phản ánh theo ID */
    public Map<String, Object> getPhanAnhByID(int phanAnhID) {
        String sql =
            "SELECT pa.*, " +
            "       lp.TenLoai, " +
            "       tt.TenTrangThai, " +
            "       ng.Ho + ' ' + ng.Ten  AS TenNguoiGui, " +
            "       nx.Ho + ' ' + nx.Ten  AS TenNguoiXuLy, " +
            "       tdp.TenTo             AS TenToDanPho " +
            "  FROM PhanAnh pa " +
            "  JOIN LoaiPhanAnh       lp  ON pa.LoaiID      = lp.LoaiID " +
            "  JOIN TrangThaiPhanAnh  tt  ON pa.TrangThaiID = tt.TrangThaiID " +
            "  JOIN NguoiDung         ng  ON pa.NguoiGuiID  = ng.NguoiDungID " +
            " LEFT JOIN NguoiDung     nx  ON pa.NguoiXuLyID = nx.NguoiDungID " +
            "  JOIN ToDanPho          tdp ON pa.ToDanPhoID  = tdp.ToDanPhoID " +
            " WHERE pa.PhanAnhID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, phanAnhID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowChiTiet(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Lấy danh sách phản ánh của hộ dân */
    public List<Map<String, Object>> getPhanAnhCuaHoDan(int nguoiGuiID) {
        String sql =
            "SELECT pa.*, lp.TenLoai, tt.TenTrangThai, " +
            "       ng.Ho + ' ' + ng.Ten AS TenNguoiGui, " +
            "       nx.Ho + ' ' + nx.Ten AS TenNguoiXuLy, " +
            "       tdp.TenTo            AS TenToDanPho " +
            "  FROM PhanAnh pa " +
            "  JOIN LoaiPhanAnh       lp  ON pa.LoaiID      = lp.LoaiID " +
            "  JOIN TrangThaiPhanAnh  tt  ON pa.TrangThaiID = tt.TrangThaiID " +
            "  JOIN NguoiDung         ng  ON pa.NguoiGuiID  = ng.NguoiDungID " +
            " LEFT JOIN NguoiDung     nx  ON pa.NguoiXuLyID = nx.NguoiDungID " +
            "  JOIN ToDanPho          tdp ON pa.ToDanPhoID  = tdp.ToDanPhoID " +
            " WHERE pa.NguoiGuiID = ? " +
            " ORDER BY pa.NgayTao DESC";
        return queryList(sql, nguoiGuiID);
    }

    /** Lấy danh sách phản ánh theo tổ — dành cho tổ trưởng */
    public List<Map<String, Object>> getPhanAnhTheoTo(int toDanPhoID) {
        String sql =
            "SELECT pa.*, lp.TenLoai, tt.TenTrangThai, " +
            "       ng.Ho + ' ' + ng.Ten AS TenNguoiGui, " +
            "       nx.Ho + ' ' + nx.Ten AS TenNguoiXuLy, " +
            "       tdp.TenTo            AS TenToDanPho " +
            "  FROM PhanAnh pa " +
            "  JOIN LoaiPhanAnh       lp  ON pa.LoaiID      = lp.LoaiID " +
            "  JOIN TrangThaiPhanAnh  tt  ON pa.TrangThaiID = tt.TrangThaiID " +
            "  JOIN NguoiDung         ng  ON pa.NguoiGuiID  = ng.NguoiDungID " +
            " LEFT JOIN NguoiDung     nx  ON pa.NguoiXuLyID = nx.NguoiDungID " +
            "  JOIN ToDanPho          tdp ON pa.ToDanPhoID  = tdp.ToDanPhoID " +
            " WHERE pa.ToDanPhoID = ? AND pa.TrangThaiID NOT IN (6, 7) " +
            " ORDER BY pa.MucDoID DESC, pa.NgayTao DESC";
        return queryList(sql, toDanPhoID);
    }

    /** Lấy danh sách phản ánh đã chuyển cấp — dành cho cán bộ phường */
    public List<Map<String, Object>> getPhanAnhDaChuyenCap() {
        String sql =
            "SELECT pa.*, lp.TenLoai, tt.TenTrangThai, " +
            "       ng.Ho + ' ' + ng.Ten AS TenNguoiGui, " +
            "       nx.Ho + ' ' + nx.Ten AS TenNguoiXuLy, " +
            "       tdp.TenTo            AS TenToDanPho " +
            "  FROM PhanAnh pa " +
            "  JOIN LoaiPhanAnh       lp  ON pa.LoaiID      = lp.LoaiID " +
            "  JOIN TrangThaiPhanAnh  tt  ON pa.TrangThaiID = tt.TrangThaiID " +
            "  JOIN NguoiDung         ng  ON pa.NguoiGuiID  = ng.NguoiDungID " +
            " LEFT JOIN NguoiDung     nx  ON pa.NguoiXuLyID = nx.NguoiDungID " +
            "  JOIN ToDanPho          tdp ON pa.ToDanPhoID  = tdp.ToDanPhoID " +
            " WHERE pa.DaChuyenCap = 1 AND pa.TrangThaiID IN (3, 4) " +
            " ORDER BY pa.MucDoID DESC, pa.NgayTao DESC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowDanhSach(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy ảnh đính kèm của 1 phản ánh */
    public List<Map<String, Object>> getAnhDinhKem(int phanAnhID) {
        String sql =
            "SELECT FileID, DuongDan, NgayUpload " +
            "  FROM FileDinhKemPhanAnh " +
            " WHERE PhanAnhID = ? " +
            " ORDER BY NgayUpload ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, phanAnhID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("fileID",     rs.getInt("FileID"));
                row.put("duongDan",   rs.getString("DuongDan"));
                row.put("ngayUpload", rs.getTimestamp("NgayUpload"));
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy lịch sử xử lý của 1 phản ánh */
    public List<Map<String, Object>> getLichSuXuLy(int phanAnhID) {
        String sql =
            "SELECT ls.LogID, ls.HanhDong, ls.GhiChu, ls.ThoiGian, " +
            "       nd.Ho + ' ' + nd.Ten  AS TenNguoiThucHien, " +
            "       tcu.TenTrangThai      AS TenTrangThaiCu, " +
            "       tmoi.TenTrangThai     AS TenTrangThaiMoi " +
            "  FROM LichSuXuLyPhanAnh ls " +
            "  JOIN NguoiDung              nd   ON ls.NguoiThucHienID = nd.NguoiDungID " +
            " LEFT JOIN TrangThaiPhanAnh   tcu  ON ls.TrangThaiCu     = tcu.TrangThaiID " +
            " LEFT JOIN TrangThaiPhanAnh   tmoi ON ls.TrangThaiMoi    = tmoi.TrangThaiID " +
            " WHERE ls.PhanAnhID = ? " +
            " ORDER BY ls.ThoiGian ASC";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, phanAnhID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("logID",              rs.getInt("LogID"));
                row.put("hanhDong",           rs.getString("HanhDong"));
                row.put("ghiChu",             rs.getString("GhiChu"));
                row.put("thoiGian",           rs.getTimestamp("ThoiGian"));
                row.put("tenNguoiThucHien",   rs.getString("TenNguoiThucHien"));
                row.put("tenTrangThaiCu",     rs.getString("TenTrangThaiCu"));
                row.put("tenTrangThaiMoi",    rs.getString("TenTrangThaiMoi"));
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy danh sách loại phản ánh */
    public List<LoaiPhanAnh> getDanhSachLoai() {
        String sql = "SELECT LoaiID, TenLoai FROM LoaiPhanAnh ORDER BY LoaiID";
        List<LoaiPhanAnh> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                LoaiPhanAnh l = new LoaiPhanAnh();
                l.setLoaiID(rs.getInt("LoaiID"));
                l.setTenLoai(rs.getString("TenLoai"));
                list.add(l);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==================== PRIVATE HELPER ====================

    private List<Map<String, Object>> queryList(String sql, int param) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowDanhSach(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean giaiQuyetToTruong(int phanAnhID, int toTruongID, String ketQua) {
        Map<String, Object> hien = getPhanAnhByID(phanAnhID);
        if (hien == null) return false;
        int nguoiGuiID = (int) hien.get("nguoiGuiID");
        String tieuDe  = (String) hien.get("tieuDe");

        String sql =
            "UPDATE PhanAnh " +
            "   SET TrangThaiID = 4, NguoiXuLyID = ?, NgayCapNhat = NOW() " +
            " WHERE PhanAnhID = ? AND TrangThaiID = 2";

        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                int rows;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, toTruongID);
                    ps.setInt(2, phanAnhID);
                    rows = ps.executeUpdate();
                }
                if (rows == 0) { conn.rollback(); return false; }
                ghiLog(conn, phanAnhID, toTruongID, "GIAI_QUYET", 2, 4, ketQua);
                guiThongBao(conn, toTruongID, nguoiGuiID,
                        "[Đã giải quyết] " + tieuDe,
                        "Phản ánh của bạn đã được tổ trưởng giải quyết. Kết quả: " + ketQua);
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean guiPhanHoiToTruong(int phanAnhID, int toTruongID,
                                       int nguoiNhanID, String tieuDe, String noiDung) {
        try (Connection conn = DBContext.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                ghiLog(conn, phanAnhID, toTruongID, "BINH_LUAN", null, null, noiDung);
                guiThongBao(conn, toTruongID, nguoiNhanID, tieuDe, noiDung);
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}