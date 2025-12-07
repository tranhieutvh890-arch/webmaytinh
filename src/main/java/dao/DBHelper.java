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
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("âœ… MySQL JDBC Driver Loaded!");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("âŒ KhÃ´ng load Ä‘Æ°á»£c MySQL Driver!", e);
        }
    }
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.out.println("âŒ Lá»—i káº¿t ná»‘i MySQL: " + e.getMessage());
            return null;
        }
    }
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("âœ… Káº¿t ná»‘i thÃ nh cÃ´ng MySQL!");
        } else {
            System.out.println("âŒ Káº¿t ná»‘i tháº¥t báº¡i!");
        }
    }
}
