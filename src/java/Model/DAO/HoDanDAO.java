package Model.DAO;

import Model.Entity.HoDan;
import java.sql.*;
import java.util.*;

public class HoDanDAO {

    // Lấy danh sách hộ dân theo tổ, có tìm kiếm
    public List<HoDan> getDanhSachHoDan(int toDanPhoID, String keyword) {
        List<HoDan> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT h.HoDanID, h.MaHoKhau, h.DiaChi, h.ToDanPhoID, " +
            "       h.ChuHoID, h.TrangThaiID, h.NgayTao, " +
            "       tt.TenTrangThai, " +
            "       ISNULL(nd.Ho + ' ' + nd.Ten, N'Chưa có') AS TenChuHo, " +
            "       (SELECT COUNT(*) FROM ThanhVienHo tv WHERE tv.HoDanID = h.HoDanID AND tv.NgayRa IS NULL) AS SoThanhVien " +
            "FROM HoDan h " +
            "LEFT JOIN TrangThaiHoKhau tt ON h.TrangThaiID = tt.TrangThaiID " +
            "LEFT JOIN NguoiDung nd ON h.ChuHoID = nd.NguoiDungID " +
            "WHERE h.ToDanPhoID = ? "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (h.MaHoKhau LIKE ? OR h.DiaChi LIKE ? " +
                       "OR nd.Ho + ' ' + nd.Ten LIKE ?) ");
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
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HoDan h = new HoDan();
                h.setHoDanID(rs.getInt("HoDanID"));
                h.setMaHoKhau(rs.getString("MaHoKhau"));
                h.setDiaChi(rs.getString("DiaChi"));
                h.setToDanPhoID(rs.getInt("ToDanPhoID"));
                h.setChuHoID(rs.getObject("ChuHoID") != null ? rs.getInt("ChuHoID") : null);
                h.setTrangThaiID(rs.getInt("TrangThaiID"));
                h.setNgayTao(rs.getDate("NgayTao"));
                h.setTenTrangThai(rs.getString("TenTrangThai"));
                h.setTenChuHo(rs.getString("TenChuHo"));
                h.setSoThanhVien(rs.getInt("SoThanhVien"));
                h.setTenDuong(h.extractTenDuong());
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}