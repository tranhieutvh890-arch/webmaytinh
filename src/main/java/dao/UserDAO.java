package dao;
import model.User;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
public class UserDAO {
    /* =====================================================
       Láº¤Y USER THEO TÃŠN ÄÄ‚NG NHáº¬P (PHá»¤ TRá»¢ CHO LOGIN)
       ===================================================== */
    public User findByUsername(String tenDangNhap) throws Exception {
        String sql = """
                SELECT 
                    nd.MaNguoiDung,
                    nd.TenDangNhap,
                    nd.MatKhau,
                    nd.HoTen,
                    nd.Email,
                    nd.SoDienThoai,
                    nd.MaQuyen,
                    nd.NgayTao,
                    nd.TrangThai,
                    q.TenQuyen
                FROM NguoiDung nd
                JOIN Quyen q ON nd.MaQuyen = q.MaQuyen
                WHERE nd.TenDangNhap = ?
                """;
        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                    u.setTenDangNhap(rs.getString("TenDangNhap"));
                    u.setMatKhau(rs.getString("MatKhau"));
                    u.setHoTen(rs.getString("HoTen"));
                    u.setEmail(rs.getString("Email"));
                    u.setSoDienThoai(rs.getString("SoDienThoai"));
                    u.setMaQuyen(rs.getInt("MaQuyen"));
                    Timestamp ts = rs.getTimestamp("NgayTao");
                    u.setNgayTao(ts != null ? ts.toLocalDateTime() : null);
                    u.setTrangThai(rs.getBoolean("TrangThai"));
                    u.setTenQuyen(rs.getString("TenQuyen"));
                    return u;
                }
            }
        }
        return null;
    }
    /* =====================================================
       KIá»‚M TRA USERNAME Tá»’N Táº I (REGISTER)
       ===================================================== */
    public boolean exists(String tenDangNhap) throws Exception {
        String sql = "SELECT 1 FROM NguoiDung WHERE TenDangNhap = ?";
        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    /* =====================================================
       Táº O USER Má»šI (ÄÄ‚NG KÃ)
       máº·c Ä‘á»‹nh: MaQuyen = 2 (CUSTOMER)
       ===================================================== */
    public boolean createUser(User u) throws Exception {
        String sql = """
                INSERT INTO NguoiDung
                (TenDangNhap, MatKhau, HoTen, Email, SoDienThoai, MaQuyen, TrangThai)
                VALUES (?, ?, ?, ?, ?, ?, 1)
                """;
        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String hashedPassword = u.getMatKhau();
            if (hashedPassword != null && !hashedPassword.startsWith("$2a$")) {
                hashedPassword = BCrypt.hashpw(hashedPassword, BCrypt.gensalt(12));
            }
            ps.setString(1, u.getTenDangNhap());
            ps.setString(2, hashedPassword);
            ps.setString(3, u.getHoTen());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getSoDienThoai());
            ps.setInt(6, u.getMaQuyen());
            return ps.executeUpdate() > 0;
        }
    }
    /* =====================================================
       LOGIN: TRáº¢ Vá»€ Äá»I TÆ¯á»¢NG USER (DÃ™NG CHO LoginServlet)
       tráº£ vá» null náº¿u sai máº­t kháº©u / tÃ i khoáº£n bá»‹ khÃ³a
       ===================================================== */
    public User login(String tenDangNhap, String plainPassword) throws Exception {
        User u = findByUsername(tenDangNhap);
        if (u == null) return null;
        if (!u.isTrangThai()) return null;
        String hashedOrPlain = u.getMatKhau();
        if (hashedOrPlain == null) return null;
        boolean match;
        if (hashedOrPlain.startsWith("$2a$")) {
            match = BCrypt.checkpw(plainPassword, hashedOrPlain);
        } else {
            match = plainPassword.equals(hashedOrPlain);
        }
        return match ? u : null;
    }
    /* =====================================================
       HÃ€M CÅ¨: XÃC THá»°C ÄÄ‚NG NHáº¬P (TRUE/FALSE)
       (váº«n giá»¯ cho nhá»¯ng chá»— khÃ¡c trong project Ä‘ang dÃ¹ng)
       ===================================================== */
    public boolean validateLogin(String tenDangNhap, String plainPassword) throws Exception {
        return login(tenDangNhap, plainPassword) != null;
    }
    /* =====================================================
    Láº¤Y USER THEO ID
    ===================================================== */
 public User findById(int id) throws Exception {
     String sql = """
             SELECT 
                 nd.MaNguoiDung,
                 nd.TenDangNhap,
                 nd.MatKhau,
                 nd.HoTen,
                 nd.Email,
                 nd.SoDienThoai,
                 nd.MaQuyen,
                 nd.NgayTao,
                 nd.TrangThai,
                 q.TenQuyen
             FROM NguoiDung nd
             JOIN Quyen q ON nd.MaQuyen = q.MaQuyen
             WHERE nd.MaNguoiDung = ?
             """;
     try (Connection c = DBHelper.getConnection();
          PreparedStatement ps = c.prepareStatement(sql)) {
         ps.setInt(1, id);
         try (ResultSet rs = ps.executeQuery()) {
             if (rs.next()) {
                 User u = new User();
                 u.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                 u.setTenDangNhap(rs.getString("TenDangNhap"));
                 u.setMatKhau(rs.getString("MatKhau"));
                 u.setHoTen(rs.getString("HoTen"));
                 u.setEmail(rs.getString("Email"));
                 u.setSoDienThoai(rs.getString("SoDienThoai"));
                 u.setMaQuyen(rs.getInt("MaQuyen"));
                 Timestamp ts = rs.getTimestamp("NgayTao");
                 u.setNgayTao(ts != null ? ts.toLocalDateTime() : null);
                 u.setTrangThai(rs.getBoolean("TrangThai"));
                 u.setTenQuyen(rs.getString("TenQuyen"));
                 return u;
             }
         }
     }
     return null;
 }
 /* =====================================================
    PHÃ‚N TRANG: Äáº¾M Tá»”NG Sá» USER
    ===================================================== */
 public int countAll() throws Exception {
     String sql = "SELECT COUNT(*) FROM NguoiDung";
     try (Connection c = DBHelper.getConnection();
          PreparedStatement ps = c.prepareStatement(sql);
          ResultSet rs = ps.executeQuery()) {
         if (rs.next()) {
             return rs.getInt(1);
         }
     }
     return 0;
 }
 /* =====================================================
 PHÃ‚N TRANG: Láº¤Y DANH SÃCH USER
 (offset = (page-1)*pageSize)
 ===================================================== */
public java.util.List<User> findAll(int offset, int limit) throws Exception {
  java.util.List<User> list = new java.util.ArrayList<>();
  String sql = """
          SELECT 
              nd.MaNguoiDung,
              nd.TenDangNhap,
              nd.MatKhau,
              nd.HoTen,
              nd.Email,
              nd.SoDienThoai,
              nd.MaQuyen,
              nd.NgayTao,
              nd.TrangThai,
              q.TenQuyen
          FROM NguoiDung nd
          JOIN Quyen q ON nd.MaQuyen = q.MaQuyen
          ORDER BY nd.MaNguoiDung DESC
          LIMIT ?, ?
          """;
  try (Connection c = DBHelper.getConnection();
       PreparedStatement ps = c.prepareStatement(sql)) {
      ps.setInt(1, offset);
      ps.setInt(2, limit);
      try (ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
              User u = new User();
              u.setMaNguoiDung(rs.getInt("MaNguoiDung"));
              u.setTenDangNhap(rs.getString("TenDangNhap"));
              u.setMatKhau(rs.getString("MatKhau"));
              u.setHoTen(rs.getString("HoTen"));
              u.setEmail(rs.getString("Email"));
              u.setSoDienThoai(rs.getString("SoDienThoai"));
              u.setMaQuyen(rs.getInt("MaQuyen"));
              Timestamp ts = rs.getTimestamp("NgayTao");
              u.setNgayTao(ts != null ? ts.toLocalDateTime() : null);
              u.setTrangThai(rs.getBoolean("TrangThai"));
              u.setTenQuyen(rs.getString("TenQuyen"));
              list.add(u);
          }
      }
  }
  return list;
}
 /* =====================================================
    Cáº¬P NHáº¬T THÃ”NG TIN USER (KHÃ”NG Äá»”I Máº¬T KHáº¨U)
    ===================================================== */
 public boolean updateUser(User u) throws Exception {
     String sql = """
             UPDATE NguoiDung
             SET HoTen = ?, Email = ?, SoDienThoai = ?, MaQuyen = ?, TrangThai = ?
             WHERE MaNguoiDung = ?
             """;
     try (Connection c = DBHelper.getConnection();
          PreparedStatement ps = c.prepareStatement(sql)) {
         ps.setString(1, u.getHoTen());
         ps.setString(2, u.getEmail());
         ps.setString(3, u.getSoDienThoai());
         ps.setInt(4, u.getMaQuyen());
         ps.setBoolean(5, u.isTrangThai());
         ps.setInt(6, u.getMaNguoiDung());
         return ps.executeUpdate() > 0;
     }
 }
 /* =====================================================
    XÃ“A USER
    ===================================================== */
 public boolean deleteUser(int id) throws Exception {
     String sql = "DELETE FROM NguoiDung WHERE MaNguoiDung = ?";
     try (Connection c = DBHelper.getConnection();
          PreparedStatement ps = c.prepareStatement(sql)) {
         ps.setInt(1, id);
         return ps.executeUpdate() > 0;
     }
 }
}
