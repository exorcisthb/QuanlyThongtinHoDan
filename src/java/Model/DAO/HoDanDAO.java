package Model.DAO;

import Model.Entity.HoDan;
import Model.Entity.NguoiDung;
import java.sql.*;
import java.util.*;

public class HoDanDAO {

    public List<HoDan> getDanhSachHoDan(int toDanPhoID, String keyword) {
        List<HoDan> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, "
                + "       h.ChuHoID, h.TrangThaiID, h.NgayTao, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd.Ho || ' ' || nd.Ten, 'Chưa có') AS TenChuHo, "
                + "       nd.CCCD, nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, "
                + "       nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS TuoiChuHo, "
                + "       (SELECT COUNT(*) FROM ThanhVienHo tv WHERE tv.HoDanID = h.HoDanID AND tv.NgayRa IS NULL) AS SoThanhVien "
                + "FROM HoDan h "
                + "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON h.ToDanPhoID = tdp.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID "
                + "WHERE h.ToDanPhoID = ? "
        );
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? "
                    + "OR nd.Ho || ' ' || nd.Ten LIKE ? "
                    + "OR nd.CCCD LIKE ?) ");
        }
        sql.append("ORDER BY h.DiaChi");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, toDanPhoID);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(2, kw);
                ps.setString(3, kw);
                ps.setString(4, kw);
                ps.setString(5, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<HoDan> getDanhSachTatCaHoDan(String keyword) {
        List<HoDan> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, "
                + "       h.ChuHoID, h.TrangThaiID, h.NgayTao, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd.Ho || ' ' || nd.Ten, 'Chưa có') AS TenChuHo, "
                + "       nd.CCCD, nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, "
                + "       nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS TuoiChuHo, "
                + "       (SELECT COUNT(*) FROM ThanhVienHo tv WHERE tv.HoDanID = h.HoDanID AND tv.NgayRa IS NULL) AS SoThanhVien "
                + "FROM HoDan h "
                + "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON h.ToDanPhoID = tdp.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID "
        );
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("WHERE (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? "
                    + "OR nd.Ho || ' ' || nd.Ten LIKE ? "
                    + "OR nd.CCCD LIKE ? "
                    + "OR tdp.TenTo LIKE ?) ");
        }
        sql.append("ORDER BY tdp.TenTo, h.DiaChi");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw); ps.setString(2, kw);
                ps.setString(3, kw); ps.setString(4, kw); ps.setString(5, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private HoDan mapRow(ResultSet rs) throws Exception {
        HoDan h = new HoDan();
        h.setHoDanID(rs.getInt("HoDanID"));
        h.setMaHoKhau(rs.getString("MaHoKhau"));
        h.setDiaChi(rs.getString("DiaChi"));
        h.setToDanPhoID(rs.getInt("ToDanPhoID"));
        h.setChuHoID(rs.getObject("ChuHoID") != null ? rs.getInt("ChuHoID") : null);
        h.setTrangThaiID(rs.getInt("TrangThaiID"));
        h.setNgayTao(rs.getDate("NgayTao"));
        h.setTenTrangThai(rs.getString("TenTrangThai"));
        h.setTenTo(rs.getString("TenTo"));
        h.setTenChuHo(rs.getString("TenChuHo"));
        h.setSoThanhVien(rs.getInt("SoThanhVien"));
        h.setTenDuong(h.extractTenDuong());
        h.setCccdChuHo(rs.getString("CCCD"));
        h.setNgaySinhChuHo(rs.getDate("NgaySinh"));
        h.setGioiTinhChuHo(rs.getString("GioiTinh"));
        h.setSoDienThoaiChuHo(rs.getString("SoDienThoai"));
        h.setEmailChuHo(rs.getString("Email"));
        h.setTuoiChuHo(rs.getInt("TuoiChuHo"));
        h.setDaKichHoat(rs.getObject("IsActivated") != null && rs.getBoolean("IsActivated"));
        return h;
    }

  private int getOrCreateToDanPhoID(Connection conn, String diaChi) throws Exception {
    if (diaChi == null || diaChi.isEmpty()) return 0;

    String tenTo = null;
    String upper = diaChi.toUpperCase();

    int idx = upper.indexOf("TỔ DÂN PHỐ ");
    if (idx >= 0) tenTo = diaChi.substring(idx + 11).trim();

    if (tenTo == null) { idx = upper.indexOf("TO DAN PHO "); if (idx >= 0) tenTo = diaChi.substring(idx + 11).trim(); }
    if (tenTo == null) { idx = upper.indexOf("TDP ");        if (idx >= 0) tenTo = diaChi.substring(idx + 4).trim(); }

    if (tenTo != null && tenTo.contains(",")) tenTo = tenTo.substring(0, tenTo.indexOf(",")).trim();
    if (tenTo == null || tenTo.isEmpty()) return 0;

    // ✅ Proper case thay vì UPPERCASE
    tenTo = toProperCase(tenTo);

    try (PreparedStatement ps = conn.prepareStatement(
            "SELECT ToDanPhoID FROM ToDanPho WHERE LOWER(TenTo) = LOWER(?)")) {
        ps.setString(1, tenTo);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    }

    try (PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO ToDanPho (TenTo) VALUES (?) RETURNING ToDanPhoID")) {
        ps.setString(1, tenTo);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    }

    return 0;
}

// ✅ Thêm hàm helper này vào cùng class
private String toProperCase(String str) {
    if (str == null || str.isEmpty()) return str;
    StringBuilder result = new StringBuilder();
    boolean nextUpper = true;
    for (char c : str.toCharArray()) {
        if (Character.isWhitespace(c)) {
            result.append(c);
            nextUpper = true;
        } else if (nextUpper) {
            result.append(Character.toUpperCase(c));
            nextUpper = false;
        } else {
            result.append(Character.toLowerCase(c));
        }
    }
    return result.toString();
}

    public HoDan getHoDanByNguoiDungID(int nguoiDungID) throws Exception {
        String sql = "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, "
                + "       h.ChuHoID, h.TrangThaiID, h.NgayTao, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd.Ho || ' ' || nd.Ten, 'Chưa có') AS TenChuHo, "
                + "       nd.CCCD, nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, "
                + "       nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS TuoiChuHo, "
                + "       (SELECT COUNT(*) FROM ThanhVienHo tv2 WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL) AS SoThanhVien "
                + "FROM ThanhVienHo tv "
                + "JOIN HoDan h ON h.HoDanID = tv.HoDanID "
                + "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON h.ToDanPhoID = tdp.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID "
                + "WHERE tv.NguoiDungID = ? AND tv.NgayRa IS NULL";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nguoiDungID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public String getOrCreateQRToken(int hoDanID) throws Exception {
        String selectSql = "SELECT Token FROM MaQRHoDan WHERE HoDanID = ? AND IsActive = true";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("Token");
        }
        String token = UUID.randomUUID().toString().replace("-", "");
        String insertSql = "INSERT INTO MaQRHoDan (HoDanID, Token) VALUES (?, ?)";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, hoDanID);
            ps.setString(2, token);
            ps.executeUpdate();
        }
        return token;
    }

    public HoDan getHoDanByToken(String token) throws Exception {
        String sql = "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, "
                + "       h.ChuHoID, h.TrangThaiID, h.NgayTao, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd.Ho || ' ' || nd.Ten, 'Chưa có') AS TenChuHo, "
                + "       nd.CCCD, nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, "
                + "       nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS TuoiChuHo, "
                + "       (SELECT COUNT(*) FROM ThanhVienHo tv WHERE tv.HoDanID = h.HoDanID AND tv.NgayRa IS NULL) AS SoThanhVien "
                + "FROM MaQRHoDan q "
                + "JOIN HoDan h ON h.HoDanID = q.HoDanID "
                + "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON h.ToDanPhoID = tdp.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID "
                + "WHERE q.Token = ? AND q.IsActive = true";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<NguoiDung> getThanhVienByHoDanID(int hoDanID) throws Exception {
        String sql = "SELECT nd.NguoiDungID, nd.Ho, nd.Ten, nd.NgaySinh, "
                + "       nd.GioiTinh, nd.SoDienThoai, nd.Email, nd.CCCD, "
                + "       qh.TenQuanHe, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS Tuoi "
                + "FROM ThanhVienHo tv "
                + "JOIN NguoiDung nd ON nd.NguoiDungID = tv.NguoiDungID "
                + "JOIN QuanHeHoGia qh ON qh.QuanHeID = tv.QuanHeID "
                + "WHERE tv.HoDanID = ? AND tv.NgayRa IS NULL "
                + "ORDER BY tv.NgayVao";
        List<NguoiDung> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setNguoiDungID(rs.getInt("NguoiDungID"));
                nd.setHo(rs.getString("Ho"));
                nd.setTen(rs.getString("Ten"));
                nd.setNgaySinh(rs.getDate("NgaySinh"));
                nd.setGioiTinh(rs.getString("GioiTinh"));
                nd.setSoDienThoai(rs.getString("SoDienThoai"));
                nd.setEmail(rs.getString("Email"));
                nd.setCccd(rs.getString("CCCD"));
                nd.setTenQuanHe(rs.getString("TenQuanHe"));
                nd.setTuoi(rs.getInt("Tuoi"));
                list.add(nd);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public String resetQRToken(int hoDanID) throws Exception {
        String deactivateSql = "UPDATE MaQRHoDan SET IsActive = false WHERE HoDanID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(deactivateSql)) {
            ps.setInt(1, hoDanID);
            ps.executeUpdate();
        }
        return getOrCreateQRToken(hoDanID);
    }

    public List<String> importHoDanVaNguoiDung(List<Map<String, Object>> danhSach, int toDanPhoID) {
    List<String> errors = new ArrayList<>();
    String checkHoSql = "SELECT COUNT(*) FROM HoDan WHERE MaHoKhau = ?";
    String checkCccdSql = "SELECT COUNT(*) FROM NguoiDung WHERE CCCD = ?";
    String insertHoDanSql = "INSERT INTO HoDan (MaHoKhau,DiaChi,ToDanPhoID,TrangThaiID,NgayTao) VALUES (?,?,?,1,NOW()) RETURNING HoDanID";
    String insertNguoiDungSql = "INSERT INTO NguoiDung (CCCD,Ho,Ten,NgaySinh,GioiTinh,SoDienThoai,Email,VaiTroID,ToDanPhoID,IsActivated,NgayTao) "
            + "VALUES (?,?,?,?,?,?,?,(SELECT VaiTroID FROM VaiTro WHERE TenVaiTro='HoDan'),?,false,NOW()) RETURNING NguoiDungID";
    String setChuHoSql = "UPDATE HoDan SET ChuHoID=? WHERE HoDanID=?";
    String getQuanHeSql = "SELECT QuanHeID FROM QuanHeHoGia WHERE TenQuanHe = ?";
    String insertQuanHeSql = "INSERT INTO QuanHeHoGia (TenQuanHe) VALUES (?) RETURNING QuanHeID";
    String insertThanhVienSql = "INSERT INTO ThanhVienHo (HoDanID,NguoiDungID,QuanHeID,NgayVao) VALUES (?,?,?,NOW())";

    Map<String, List<Map<String, Object>>> grouped = new LinkedHashMap<>();
    for (Map<String, Object> row : danhSach) {
        String key = (String) row.get("tenHoDan");
        grouped.computeIfAbsent(key, k -> new ArrayList<>()).add(row);
    }

    try (Connection conn = DBContext.getInstance().getConnection()) {
        conn.setAutoCommit(false);
        try {
            for (Map.Entry<String, List<Map<String, Object>>> entry : grouped.entrySet()) {
                List<Map<String, Object>> members = entry.getValue();
                Map<String, Object> firstRow = members.get(0);
                String tenHoDan = (String) firstRow.get("tenHoDan");
                String diaChi = (String) firstRow.get("diaChi");
                int rowNum = (int) firstRow.get("rowNum");

                try (PreparedStatement ps = conn.prepareStatement(checkHoSql)) {
                    ps.setString(1, tenHoDan);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        errors.add("Dòng " + rowNum + ": Mã hộ '" + tenHoDan + "' đã tồn tại");
                        continue;
                    }
                }

                int hoID = getOrCreateToDanPhoID(conn, diaChi);
                int hoDanID = 0;
                try (PreparedStatement ps = conn.prepareStatement(insertHoDanSql)) {
                    ps.setString(1, tenHoDan);
                    ps.setString(2, diaChi);
                    if (hoID == 0) ps.setNull(3, Types.INTEGER);
                    else ps.setInt(3, hoID);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) hoDanID = rs.getInt(1);
                } catch (Exception e) {
                    System.err.println("=== LỖI INSERT HODAN dòng " + rowNum + " ===");
                    System.err.println("tenHoDan=" + tenHoDan + " | diaChi=" + diaChi + " | hoID=" + hoID);
                    System.err.println("Message: " + e.getMessage());
                    e.printStackTrace(System.err);
                    errors.add("Dòng " + rowNum + ": Lỗi tạo hộ - " + e.getMessage());
                    continue;
                }

                if (hoDanID == 0) { errors.add("Dòng " + rowNum + ": Không lấy được HoDanID"); continue; }

                for (Map<String, Object> member : members) {
                    int mRowNum = (int) member.get("rowNum");
                    String cccd = (String) member.get("cccd");
                    String ho = (String) member.get("ho");
                    String ten = (String) member.get("ten");
                    java.sql.Date ngaySinh = (java.sql.Date) member.get("ngaySinh");
                    String gioiTinh = (String) member.get("gioiTinh");
                    String sdt = (String) member.get("soDienThoai");
                    String email = (String) member.get("email");
                    String quanHeTen = (String) member.get("quanHe");

                    if (cccd == null || !cccd.matches("\\d{12}")) { errors.add("Dòng " + mRowNum + ": CCCD không hợp lệ"); continue; }
                    if (ho == null || ho.isEmpty()) { errors.add("Dòng " + mRowNum + ": Họ không được trống"); continue; }
                    if (ten == null || ten.isEmpty()) { errors.add("Dòng " + mRowNum + ": Tên không được trống"); continue; }
                    if (ngaySinh == null) { errors.add("Dòng " + mRowNum + ": Ngày sinh không được trống"); continue; }
                    if (gioiTinh == null || (!gioiTinh.equals("Nam") && !gioiTinh.equals("Nữ") && !gioiTinh.equals("Khác"))) { errors.add("Dòng " + mRowNum + ": Giới tính phải là Nam/Nữ/Khác"); continue; }
                    if (sdt == null || sdt.isEmpty()) { errors.add("Dòng " + mRowNum + ": SĐT không được trống"); continue; }
                    if (quanHeTen == null || quanHeTen.isEmpty()) { errors.add("Dòng " + mRowNum + ": Quan hệ không được trống"); continue; }

                    try (PreparedStatement ps = conn.prepareStatement(checkCccdSql)) {
                        ps.setString(1, cccd);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) { errors.add("Dòng " + mRowNum + ": CCCD '" + cccd + "' đã tồn tại"); continue; }
                    }

                    int nguoiDungID = 0;
                    try (PreparedStatement ps = conn.prepareStatement(insertNguoiDungSql)) {
                        ps.setString(1, cccd); ps.setString(2, ho); ps.setString(3, ten);
                        ps.setDate(4, ngaySinh); ps.setString(5, gioiTinh); ps.setString(6, sdt);
                        ps.setString(7, email != null && !email.isEmpty() ? email : null);
                        if (hoID == 0) ps.setNull(8, Types.INTEGER); else ps.setInt(8, hoID);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) nguoiDungID = rs.getInt(1);
                    } catch (Exception e) {
                        System.err.println("=== LỖI INSERT NGUOIDUNG dòng " + mRowNum + " ===");
                        System.err.println("cccd=" + cccd + " | ho=" + ho + " | ten=" + ten);
                        System.err.println("Message: " + e.getMessage());
                        e.printStackTrace(System.err);
                        errors.add("Dòng " + mRowNum + ": Lỗi lưu người dùng - " + e.getMessage());
                        continue;
                    }

                    if (nguoiDungID == 0) { errors.add("Dòng " + mRowNum + ": Không lấy được NguoiDungID"); continue; }

                    if (quanHeTen.equalsIgnoreCase("Chủ hộ") || quanHeTen.equalsIgnoreCase("Chu ho")) {
                        try (PreparedStatement ps = conn.prepareStatement(setChuHoSql)) {
                            ps.setInt(1, nguoiDungID); ps.setInt(2, hoDanID); ps.executeUpdate();
                        }
                    }

                    int quanHeID = 0;
                    try (PreparedStatement ps = conn.prepareStatement(getQuanHeSql)) {
                        ps.setString(1, quanHeTen);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) { quanHeID = rs.getInt(1); }
                        else {
                            try (PreparedStatement ins = conn.prepareStatement(insertQuanHeSql)) {
                                ins.setString(1, quanHeTen);
                                ResultSet gen = ins.executeQuery();
                                if (gen.next()) quanHeID = gen.getInt(1);
                            }
                        }
                    }

                    try (PreparedStatement ps = conn.prepareStatement(insertThanhVienSql)) {
                        ps.setInt(1, hoDanID); ps.setInt(2, nguoiDungID); ps.setInt(3, quanHeID);
                        ps.executeUpdate();
                    } catch (Exception e) {
                        System.err.println("=== LỖI INSERT THANHVIENHO dòng " + mRowNum + " ===");
                        System.err.println("Message: " + e.getMessage());
                        e.printStackTrace(System.err);
                        errors.add("Dòng " + mRowNum + ": Lỗi lưu thành viên - " + e.getMessage());
                    }
                }
            }
            conn.commit();
        } catch (Exception e) {
            System.err.println("=== LỖI TRANSACTION ===");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace(System.err);
            conn.rollback();
            errors.add("Lỗi transaction: " + e.getMessage());
        } finally { conn.setAutoCommit(true); }
    } catch (Exception e) {
        System.err.println("=== LỖI KẾT NỐI ===");
        e.printStackTrace(System.err);
        errors.add("Lỗi kết nối: " + e.getMessage());
    }
    return errors;
}

    public List<HoDan> getDanhSachHoDan(int toDanPhoID, String keyword,
            Integer tuoiMin, Integer tuoiMax, String vung,
            Boolean coChuHo, Boolean daKichHoat, Integer trangThaiID) {
        List<HoDan> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, "
                + "       h.ChuHoID, h.TrangThaiID, h.NgayTao, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd.Ho || ' ' || nd.Ten, 'Chưa có') AS TenChuHo, "
                + "       nd.CCCD, nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, "
                + "       nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS TuoiChuHo, "
                + "       (SELECT COUNT(*) FROM ThanhVienHo tv WHERE tv.HoDanID = h.HoDanID AND tv.NgayRa IS NULL) AS SoThanhVien "
                + "FROM HoDan h "
                + "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON h.ToDanPhoID = tdp.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID "
                + "WHERE h.ToDanPhoID = ? ");
        params.add(toDanPhoID);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? OR nd.Ho || ' ' || nd.Ten LIKE ? OR nd.CCCD LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (tuoiMin != null && tuoiMax != null) {
            sql.append("AND EXISTS (SELECT 1 FROM ThanhVienHo tv2 JOIN NguoiDung nd2 ON nd2.NguoiDungID = tv2.NguoiDungID WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL AND DATE_PART('year', AGE(nd2.NgaySinh)) BETWEEN ? AND ?) ");
            params.add(tuoiMin); params.add(tuoiMax);
        } else if (tuoiMin != null) {
            sql.append("AND EXISTS (SELECT 1 FROM ThanhVienHo tv2 JOIN NguoiDung nd2 ON nd2.NguoiDungID = tv2.NguoiDungID WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL AND DATE_PART('year', AGE(nd2.NgaySinh)) >= ?) ");
            params.add(tuoiMin);
        } else if (tuoiMax != null) {
            sql.append("AND EXISTS (SELECT 1 FROM ThanhVienHo tv2 JOIN NguoiDung nd2 ON nd2.NguoiDungID = tv2.NguoiDungID WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL AND DATE_PART('year', AGE(nd2.NgaySinh)) <= ?) ");
            params.add(tuoiMax);
        }
        if (vung != null && !vung.trim().isEmpty()) { sql.append("AND h.DiaChi LIKE ? "); params.add("%" + vung.trim() + "%"); }
        if (coChuHo != null) { sql.append(coChuHo ? "AND h.ChuHoID IS NOT NULL " : "AND h.ChuHoID IS NULL "); }
        if (daKichHoat != null) { sql.append("AND nd.IsActivated = ? "); params.add(daKichHoat); }
        if (trangThaiID != null) { sql.append("AND h.TrangThaiID = ? "); params.add(trangThaiID); }
        sql.append("ORDER BY h.DiaChi");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else if (p instanceof Boolean) ps.setBoolean(i + 1, (Boolean) p);
                else ps.setString(i + 1, (String) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getDanhSachCaNhanTheoFilter(int toDanPhoID, String keyword,
            Integer tuoiMin, Integer tuoiMax, String vung,
            Boolean coChuHo, Boolean daKichHoat, Integer trangThaiID) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT nd.NguoiDungID, nd.Ho, nd.Ten, nd.CCCD, nd.NgaySinh, "
                + "       nd.GioiTinh, nd.SoDienThoai, nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS Tuoi, "
                + "       qh.TenQuanHe, tv.NgayVao, "
                + "       h.HoDanID, h.MaHoKhau, h.DiaChi, h.TrangThaiID, "
                + "       tt.TenTrangThai, "
                + "       COALESCE(nd2.Ho || ' ' || nd2.Ten, 'Chưa có') AS TenChuHo "
                + "FROM ThanhVienHo tv "
                + "JOIN NguoiDung nd ON nd.NguoiDungID = tv.NguoiDungID "
                + "JOIN HoDan h ON h.HoDanID = tv.HoDanID "
                + "JOIN QuanHeHoGia qh ON qh.QuanHeID = tv.QuanHeID "
                + "LEFT JOIN TrangThaiHoKhau tt ON tt.TrangThaiID = h.TrangThaiID "
                + "LEFT JOIN NguoiDung nd2 ON nd2.NguoiDungID = h.ChuHoID "
                + "WHERE tv.NgayRa IS NULL AND h.ToDanPhoID = ? ");
        params.add(toDanPhoID);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? OR nd.Ho || ' ' || nd.Ten LIKE ? OR nd.CCCD LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (tuoiMin != null && tuoiMax != null) { sql.append("AND DATE_PART('year', AGE(nd.NgaySinh)) BETWEEN ? AND ? "); params.add(tuoiMin); params.add(tuoiMax); }
        else if (tuoiMin != null) { sql.append("AND DATE_PART('year', AGE(nd.NgaySinh)) >= ? "); params.add(tuoiMin); }
        else if (tuoiMax != null) { sql.append("AND DATE_PART('year', AGE(nd.NgaySinh)) <= ? "); params.add(tuoiMax); }
        if (vung != null && !vung.trim().isEmpty()) { sql.append("AND h.DiaChi LIKE ? "); params.add("%" + vung.trim() + "%"); }
        if (coChuHo != null) { sql.append(coChuHo ? "AND h.ChuHoID IS NOT NULL " : "AND h.ChuHoID IS NULL "); }
        if (daKichHoat != null) { sql.append("AND nd.IsActivated = ? "); params.add(daKichHoat); }
        if (trangThaiID != null) { sql.append("AND h.TrangThaiID = ? "); params.add(trangThaiID); }
        sql.append("ORDER BY h.DiaChi, nd.Ho, nd.Ten");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else if (p instanceof Boolean) ps.setBoolean(i + 1, (Boolean) p);
                else ps.setString(i + 1, (String) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("nguoiDungID", rs.getInt("NguoiDungID"));
                row.put("hoTen", rs.getString("Ho") + " " + rs.getString("Ten"));
                row.put("cccd", rs.getString("CCCD"));
                row.put("ngaySinh", rs.getString("NgaySinh"));
                row.put("tuoi", rs.getInt("Tuoi"));
                row.put("gioiTinh", rs.getString("GioiTinh"));
                row.put("soDienThoai", rs.getString("SoDienThoai"));
                row.put("email", rs.getString("Email"));
                row.put("isActivated", rs.getBoolean("IsActivated"));
                row.put("quanHe", rs.getString("TenQuanHe"));
                row.put("ngayVao", rs.getString("NgayVao"));
                row.put("hoDanID", rs.getInt("HoDanID"));
                row.put("maHoKhau", rs.getString("MaHoKhau"));
                row.put("diaChi", rs.getString("DiaChi"));
                row.put("trangThaiID", rs.getInt("TrangThaiID"));
                row.put("tenTrangThai", rs.getString("TenTrangThai"));
                row.put("tenChuHo", rs.getString("TenChuHo"));
                row.put("tenDuong", extractTenDuong(rs.getString("DiaChi")));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private String extractTenDuong(String diaChi) {
        if (diaChi == null || diaChi.trim().isEmpty()) return "Không rõ";
        String upper = diaChi.toUpperCase();
        int idx = upper.indexOf("ĐƯỜNG ");
        if (idx < 0) idx = upper.indexOf("DUONG ");
        if (idx >= 0) {
            String after = diaChi.substring(idx + 6).trim();
            int tdp = after.toUpperCase().indexOf(" TDP ");
            if (tdp >= 0) return after.substring(0, tdp).trim();
            return after.trim();
        }
        return diaChi.trim();
    }

    public List<HoDan> getDanhSachTatCaHoDanCoFilter(String keyword,
            Integer tuoiMin, Integer tuoiMax, Boolean daKichHoat, Integer trangThaiID) {
        List<HoDan> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, "
                + "       h.ChuHoID, h.TrangThaiID, h.NgayTao, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd.Ho || ' ' || nd.Ten, 'Chưa có') AS TenChuHo, "
                + "       nd.CCCD, nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, "
                + "       nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS TuoiChuHo, "
                + "       (SELECT COUNT(*) FROM ThanhVienHo tv WHERE tv.HoDanID = h.HoDanID AND tv.NgayRa IS NULL) AS SoThanhVien "
                + "FROM HoDan h "
                + "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON h.ToDanPhoID = tdp.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID "
                + "WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? OR nd.Ho || ' ' || nd.Ten LIKE ? OR nd.CCCD LIKE ? OR tdp.TenTo LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (tuoiMin != null && tuoiMax != null) {
            sql.append("AND EXISTS (SELECT 1 FROM ThanhVienHo tv2 JOIN NguoiDung nd2 ON nd2.NguoiDungID = tv2.NguoiDungID WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL AND DATE_PART('year', AGE(nd2.NgaySinh)) BETWEEN ? AND ?) ");
            params.add(tuoiMin); params.add(tuoiMax);
        } else if (tuoiMin != null) {
            sql.append("AND EXISTS (SELECT 1 FROM ThanhVienHo tv2 JOIN NguoiDung nd2 ON nd2.NguoiDungID = tv2.NguoiDungID WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL AND DATE_PART('year', AGE(nd2.NgaySinh)) >= ?) ");
            params.add(tuoiMin);
        } else if (tuoiMax != null) {
            sql.append("AND EXISTS (SELECT 1 FROM ThanhVienHo tv2 JOIN NguoiDung nd2 ON nd2.NguoiDungID = tv2.NguoiDungID WHERE tv2.HoDanID = h.HoDanID AND tv2.NgayRa IS NULL AND DATE_PART('year', AGE(nd2.NgaySinh)) <= ?) ");
            params.add(tuoiMax);
        }
        if (daKichHoat != null) { sql.append("AND nd.IsActivated = ? "); params.add(daKichHoat); }
        if (trangThaiID != null) { sql.append("AND h.TrangThaiID = ? "); params.add(trangThaiID); }
        sql.append("ORDER BY tdp.TenTo, h.DiaChi");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else if (p instanceof Boolean) ps.setBoolean(i + 1, (Boolean) p);
                else ps.setString(i + 1, (String) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getDanhSachCaNhanTheoFilterCBP(String keyword,
            Integer tuoiMin, Integer tuoiMax, Boolean daKichHoat, Integer trangThaiID) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT nd.NguoiDungID, nd.Ho, nd.Ten, nd.CCCD, nd.NgaySinh, "
                + "       nd.GioiTinh, nd.SoDienThoai, nd.Email, nd.IsActivated, "
                + "       DATE_PART('year', AGE(nd.NgaySinh)) AS Tuoi, "
                + "       qh.TenQuanHe, tv.NgayVao, "
                + "       h.HoDanID, h.MaHoKhau, h.DiaChi, h.TrangThaiID, "
                + "       tt.TenTrangThai, tdp.TenTo, "
                + "       COALESCE(nd2.Ho || ' ' || nd2.Ten, 'Chưa có') AS TenChuHo "
                + "FROM ThanhVienHo tv "
                + "JOIN NguoiDung nd ON nd.NguoiDungID = tv.NguoiDungID "
                + "JOIN HoDan h ON h.HoDanID = tv.HoDanID "
                + "JOIN QuanHeHoGia qh ON qh.QuanHeID = tv.QuanHeID "
                + "LEFT JOIN TrangThaiHoKhau tt ON tt.TrangThaiID = h.TrangThaiID "
                + "LEFT JOIN ToDanPho tdp ON tdp.ToDanPhoID = h.ToDanPhoID "
                + "LEFT JOIN NguoiDung nd2 ON nd2.NguoiDungID = h.ChuHoID "
                + "WHERE tv.NgayRa IS NULL ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? OR nd.Ho || ' ' || nd.Ten LIKE ? OR nd.CCCD LIKE ? OR tdp.TenTo LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (tuoiMin != null && tuoiMax != null) { sql.append("AND DATE_PART('year', AGE(nd.NgaySinh)) BETWEEN ? AND ? "); params.add(tuoiMin); params.add(tuoiMax); }
        else if (tuoiMin != null) { sql.append("AND DATE_PART('year', AGE(nd.NgaySinh)) >= ? "); params.add(tuoiMin); }
        else if (tuoiMax != null) { sql.append("AND DATE_PART('year', AGE(nd.NgaySinh)) <= ? "); params.add(tuoiMax); }
        if (daKichHoat != null) { sql.append("AND nd.IsActivated = ? "); params.add(daKichHoat); }
        if (trangThaiID != null) { sql.append("AND h.TrangThaiID = ? "); params.add(trangThaiID); }
        sql.append("ORDER BY tdp.TenTo, h.DiaChi, nd.Ho, nd.Ten");

        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else if (p instanceof Boolean) ps.setBoolean(i + 1, (Boolean) p);
                else ps.setString(i + 1, (String) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("nguoiDungID", rs.getInt("NguoiDungID"));
                row.put("hoTen", rs.getString("Ho") + " " + rs.getString("Ten"));
                row.put("cccd", rs.getString("CCCD"));
                row.put("ngaySinh", rs.getString("NgaySinh"));
                row.put("tuoi", rs.getInt("Tuoi"));
                row.put("gioiTinh", rs.getString("GioiTinh"));
                row.put("soDienThoai", rs.getString("SoDienThoai"));
                row.put("email", rs.getString("Email"));
                row.put("isActivated", rs.getBoolean("IsActivated"));
                row.put("quanHe", rs.getString("TenQuanHe"));
                row.put("ngayVao", rs.getString("NgayVao"));
                row.put("hoDanID", rs.getInt("HoDanID"));
                row.put("maHoKhau", rs.getString("MaHoKhau"));
                row.put("diaChi", rs.getString("DiaChi"));
                row.put("trangThaiID", rs.getInt("TrangThaiID"));
                row.put("tenTrangThai", rs.getString("TenTrangThai"));
                row.put("tenTo", rs.getString("TenTo"));
                row.put("tenChuHo", rs.getString("TenChuHo"));
                row.put("tenDuong", extractTenDuong(rs.getString("DiaChi")));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getDanhSachQuanHe() throws Exception {
        String sql = "SELECT QuanHeID, TenQuanHe FROM QuanHeHoGia ORDER BY TenQuanHe";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("quanHeID", rs.getInt("QuanHeID"));
                row.put("tenQuanHe", rs.getString("TenQuanHe"));
                list.add(row);
            }
        }
        return list;
    }

    public void capNhatQuanHe(int hoDanID, int nguoiDungID, int quanHeID) throws Exception {
        String sql = "UPDATE ThanhVienHo SET QuanHeID = ? WHERE HoDanID = ? AND NguoiDungID = ? AND NgayRa IS NULL";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quanHeID); ps.setInt(2, hoDanID); ps.setInt(3, nguoiDungID);
            ps.executeUpdate();
        }
    }
    public boolean isCCCDExists(String cccd) {
    String sql = "SELECT COUNT(*) FROM nguoidung WHERE cccd = ?";
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

public boolean isSDTExists(String sdt) {
    String sql = "SELECT COUNT(*) FROM nguoidung WHERE sodienthoai = ?";
    try (Connection conn = DBContext.getInstance().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, sdt);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1) > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
}