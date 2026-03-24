//package Model.DAO;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;
//
///**
// *
// * @author ADMIN
// */
//public class DBContext {
//    private static DBContext instance;
//    private Connection connection;
//
//    private DBContext() {
//        // Không khởi tạo kết nối ngay, chỉ khi cần
//    }
//
//    public static synchronized DBContext getInstance() {
//        if (instance == null) {
//            instance = new DBContext();
//        }
//        return instance;
//    }
//
//    public Connection getConnection() throws SQLException {
//        if (connection == null || connection.isClosed()) {
//            try {
//                String user = "sa";
//                String password = "123456";
//                String url = "jdbc:sqlserver://localhost:1433;databaseName=QuanLyHoDan;encrypt=true;trustServerCertificate=true";
//                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
//                connection = DriverManager.getConnection(url, user, password);
//                System.out.println("DBContext: Đã tạo kết nối mới thành công.");
//            } catch (ClassNotFoundException e) {
//                System.err.println("DBContext: Lỗi tải driver JDBC: " + e.getMessage());
//                e.printStackTrace();
//                throw new SQLException("Không thể tải driver JDBC", e);
//            } catch (SQLException e) {
//                System.err.println("DBContext: Lỗi kết nối database: " + e.getMessage());
//                e.printStackTrace();
//                throw e; // Ném ngoại lệ để xử lý ở cấp cao hơn
//            }
//        }
//        return connection;
//    }
//
//    public void closeConnection() throws SQLException {
//        if (connection != null && !connection.isClosed()) {
//            connection.close();
//            System.out.println("DBContext: Đã đóng kết nối.");
//        }
//    }
//
//    public static void main(String[] args) {
//        try {
//            Connection conn = DBContext.getInstance().getConnection();
//            System.out.println("Kết nối thành công: " + conn);
//            conn.close();
//        } catch (SQLException e) {
//            System.err.println("Lỗi khi kiểm tra kết nối: " + e.getMessage());
//            e.printStackTrace();
//        }
//    }
//}

package Model.DAO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String URL = "jdbc:postgresql://ep-super-cell-a15cus9i-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require";
    private static final String USER = "neondb_owner";
    private static final String PASSWORD = "npg_zV1Hqr0UjCxb";

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Không thể tải driver JDBC", e);
        }
    }

    // Mỗi lần gọi tạo connection MỚI — không dùng singleton connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Giữ getInstance() để không phải sửa các DAO cũ
    public static DBContext getInstance() {
        return new DBContext();
    }
}