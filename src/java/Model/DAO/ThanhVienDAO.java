package Model.DAO;
import java.sql.*;
import java.util.*;
public class ThanhVienDAO {
    public List<Map<String, Object>> getThanhVienByHoDanID(int hoDanID) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql =
            "SELECT tv.ThanhVienID, tv.NgayVao, " +
            "       nd.NguoiDungID, nd.Ho, nd.Ten, nd.CCCD, " +
            "       nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, nd.Email, " +
            "       nd.IsActivated, " +                          // ← THÊM
            "       DATE_PART('year', AGE(nd.NgaySinh))::int AS Tuoi, " +
            "       qh.TenQuanHe, " +
            "       h.TrangThaiID, tt.TenTrangThai " +           // ← THÊM
            "FROM ThanhVienHo tv " +
            "JOIN NguoiDung nd ON tv.NguoiDungID = nd.NguoiDungID " +
            "JOIN HoDan h ON tv.HoDanID = h.HoDanID " +          // ← THÊM
            "LEFT JOIN QuanHeHoGia qh ON tv.QuanHeID = qh.QuanHeID " +
            "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID " + // ← THÊM
            "WHERE tv.HoDanID = ? AND tv.NgayRa IS NULL " +
            "ORDER BY tv.NgayVao";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("nhanKhauID",   rs.getInt("ThanhVienID"));   // ← THÊM (map ThanhVienID → nhanKhauID)
                row.put("hoTen",        rs.getString("Ho") + " " + rs.getString("Ten"));
                row.put("cccd",         rs.getString("CCCD"));
                row.put("ngaySinh",     rs.getString("NgaySinh"));
                row.put("tuoi",         rs.getInt("Tuoi"));
                row.put("gioiTinh",     rs.getString("GioiTinh"));
                row.put("soDienThoai",  rs.getString("SoDienThoai"));
                row.put("email",        rs.getString("Email"));
                row.put("quanHe",       rs.getString("TenQuanHe"));
                row.put("ngayVao",      rs.getString("NgayVao"));
                row.put("daKichHoat",   rs.getBoolean("IsActivated")); // ← THÊM
                row.put("trangThaiID",  rs.getInt("TrangThaiID"));     // ← THÊM
                row.put("tenTrangThai", rs.getString("TenTrangThai")); // ← THÊM
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}