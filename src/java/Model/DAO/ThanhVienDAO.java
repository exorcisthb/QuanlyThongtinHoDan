package Model.DAO;

import java.sql.*;
import java.util.*;

public class ThanhVienDAO {

    public List<Map<String, Object>> getThanhVienByHoDanID(int hoDanID) {
        List<Map<String, Object>> list = new ArrayList<>();
        // PostgreSQL:
        //   DATEDIFF(YEAR, ..., NOW()) → DATE_PART('year', AGE(nd.NgaySinh))
        //   Không cần thay đổi gì khác (JOIN, WHERE, ORDER BY đều chuẩn SQL)
        String sql =
            "SELECT tv.ThanhVienID, tv.NgayVao, " +
            "       nd.NguoiDungID, nd.Ho, nd.Ten, nd.CCCD, " +
            "       nd.NgaySinh, nd.GioiTinh, nd.SoDienThoai, nd.Email, " +
            "       DATE_PART('year', AGE(nd.NgaySinh))::int AS Tuoi, " +
            "       qh.TenQuanHe " +
            "FROM ThanhVienHo tv " +
            "JOIN NguoiDung nd ON tv.NguoiDungID = nd.NguoiDungID " +
            "LEFT JOIN QuanHeHoGia qh ON tv.QuanHeID = qh.QuanHeID " +
            "WHERE tv.HoDanID = ? AND tv.NgayRa IS NULL " +
            "ORDER BY tv.NgayVao";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hoDanID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("thanhVienID",  rs.getInt("ThanhVienID"));
                row.put("hoTen",        rs.getString("Ho") + " " + rs.getString("Ten"));
                row.put("cccd",         rs.getString("CCCD"));
                row.put("ngaySinh",     rs.getString("NgaySinh"));
                row.put("tuoi",         rs.getInt("Tuoi"));
                row.put("gioiTinh",     rs.getString("GioiTinh"));
                row.put("soDienThoai",  rs.getString("SoDienThoai"));
                row.put("email",        rs.getString("Email"));
                row.put("quanHe",       rs.getString("TenQuanHe"));
                row.put("ngayVao",      rs.getString("NgayVao"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}