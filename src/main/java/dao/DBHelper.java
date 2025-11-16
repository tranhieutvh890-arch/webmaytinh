package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

public class DBHelper {
    private static String url;
    private static String user;
    private static String pass;
    private static String driver;

    static {
        try {
            Properties props = new Properties();
            InputStream input = DBHelper.class.getClassLoader()
                                              .getResourceAsStream("db.properties");
            if (input == null) {
                throw new RuntimeException("Không tìm thấy file db.properties trong classpath!");
            }
            props.load(input);

            url    = props.getProperty("db.url");
            user   = props.getProperty("db.user");      // có thể null
            pass   = props.getProperty("db.password");  // có thể null
            driver = props.getProperty("db.driver");

            Class.forName(driver);
            System.out.println("✅ Loaded JDBC Driver: " + driver);
            System.out.println("✅ DB URL: " + url);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Hàm lấy Connection
    public static Connection getConnection() throws SQLException {
        // Nếu không khai báo user/pass -> dùng integratedSecurity
        if ((user == null || user.isBlank()) && (pass == null || pass.isBlank())) {
            System.out.println("🔗 Using integratedSecurity (Windows Authentication)");
            return DriverManager.getConnection(url);
        } else {
            System.out.println("🔗 Using SQL login: " + user);
            return DriverManager.getConnection(url, user, pass);
        }
    }

    // Test nhanh kết nối (chạy như Java Application)
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Kết nối SQL Server thành công!");
            } else {
                System.out.println("❌ Connection null");
            }
        } catch (Exception e) {
            System.out.println("❌ Kết nối thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
