package Controller.Common;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Khởi tạo tài khoản Admin mặc định TỰ ĐỘNG khi ứng dụng web khởi động. Chỉ tạo
 * 1 lần duy nhất (nếu chưa tồn tại).
 */
@WebListener
public class AdminInitializer implements ServletContextListener {

    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=QuanLyHoDan;encrypt=true;trustServerCertificate=true";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "123456";
    private static final String ADMIN_EMAIL = "admin@quanlyhodan.vn";
    private static final String ADMIN_RAW_PASSWORD = "Admin@123456";
    private static final String ADMIN_CCCD = "000000000000";
    private static final String ADMIN_HO = "Quản trị";
    private static final String ADMIN_TEN = "Hệ thống";
    private static final String ADMIN_SDT = "0987654321";
    private static final String ADMIN_GIOITINH = "Nam";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== AdminInitializer: Bắt đầu kiểm tra tài khoản Admin ===");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("Driver JDBC load thành công.");
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy JDBC Driver: " + e.getMessage());
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

            // 1. Tạo role Admin nếu chưa có
            Integer adminRoleId = getOrCreateRole(conn, "Admin");
            if (adminRoleId == null) {
                System.err.println("Không thể tạo hoặc tìm role Admin.");
                return;
            }

            // 2. Kiểm tra admin đã tồn tại chưa (theo Email)
            if (isEmailExists(conn, ADMIN_EMAIL)) {
                System.out.println("Tài khoản Admin đã tồn tại, bỏ qua.");
                return;
            }

            // 3. Hash mật khẩu
            String hashedPassword = BCrypt.hashpw(ADMIN_RAW_PASSWORD, BCrypt.gensalt(12));

            // 4. Insert tài khoản admin
            boolean success = insertAdmin(conn, adminRoleId, hashedPassword);
            if (success) {
                System.out.println("=== TẠO THÀNH CÔNG TÀI KHOẢN ADMIN ===");
                System.out.println("  Email     : " + ADMIN_EMAIL);
                System.out.println("  Mật khẩu  : " + ADMIN_RAW_PASSWORD);
                System.out.println("  CCCD      : " + ADMIN_CCCD);
                System.out.println("  (Đổi mật khẩu ngay sau khi đăng nhập lần đầu!)");
            } else {
                System.err.println("Tạo tài khoản Admin thất bại.");
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi khởi tạo Admin: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("=== AdminInitializer: Hoàn tất ===");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }

    // Tạo hoặc lấy ID role
    private Integer getOrCreateRole(Connection conn, String roleName) throws SQLException {
        String selectSql = "SELECT VaiTroID FROM VaiTro WHERE TenVaiTro = ?";

        try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("VaiTroID");
            }
        }

        // Chưa có → tạo mới
        String insertSql = "INSERT INTO VaiTro (TenVaiTro) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setString(1, roleName);
            ps.executeUpdate();
            System.out.println("Đã tạo role: " + roleName);
        }

        // Lấy lại ID vừa tạo
        try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("VaiTroID");
            }
        }
        return null;
    }

    // Kiểm tra email đã tồn tại chưa
    private boolean isEmailExists(Connection conn, String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM NguoiDung WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Insert admin — khớp đúng với cấu trúc bảng NguoiDung hiện tại
    private boolean insertAdmin(Connection conn, int vaiTroID, String hashedPassword) throws SQLException {
        String sql = "INSERT INTO NguoiDung "
                + "(CCCD, Ho, Ten, NgaySinh, GioiTinh, Email, SoDienThoai, MatKhauHash, VaiTroID, IsActivated, NgayTao) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, GETDATE())";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ADMIN_CCCD);
            ps.setString(2, ADMIN_HO);
            ps.setString(3, ADMIN_TEN);
            ps.setDate(4, java.sql.Date.valueOf("2000-01-01"));
            ps.setString(5, ADMIN_GIOITINH);
            ps.setString(6, ADMIN_EMAIL);
            ps.setString(7, ADMIN_SDT);
            ps.setString(8, hashedPassword);
            ps.setInt(9, vaiTroID);
            return ps.executeUpdate() > 0;
        }
    }
}
