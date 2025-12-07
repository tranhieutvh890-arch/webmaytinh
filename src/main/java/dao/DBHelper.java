package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBHelper {

    private static final String URL =
            "jdbc:mysql://localhost:3306/laptop4study"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&useUnicode=true"
            + "&characterEncoding=UTF-8";

    private static final String USER = "root";       
    private static final String PASS = "12052002";   

    static {
        try {
            // Nạp driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL JDBC Driver Loaded!");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("❌ Không load được MySQL Driver!", e);
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.out.println("❌ Lỗi kết nối MySQL: " + e.getMessage());
            return null;
        }
    }

    // Test nhanh trong Eclipse
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("✅ Kết nối thành công MySQL!");
        } else {
            System.out.println("❌ Kết nối thất bại!");
        }
    }
}
