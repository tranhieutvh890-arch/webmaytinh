package dao;

import model.User;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    /* =====================================================
       LẤY USER THEO TÊN ĐĂNG NHẬP (PHỤ TRỢ CHO LOGIN)
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
       KIỂM TRA USERNAME TỒN TẠI (REGISTER)
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
       TẠO USER MỚI (ĐĂNG KÝ)
       mặc định: MaQuyen = 2 (CUSTOMER)
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

            // 🔐 Nếu chưa hash, thì hash BCrypt:
            if (hashedPassword != null && !hashedPassword.startsWith("$2a$")) {
                hashedPassword = BCrypt.hashpw(hashedPassword, BCrypt.gensalt(12));
            }

            ps.setString(1, u.getTenDangNhap());
            ps.setString(2, hashedPassword);
            ps.setString(3, u.getHoTen());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getSoDienThoai());
            ps.setInt(6, u.getMaQuyen()); // 1 = Admin, 2 = Customer

            return ps.executeUpdate() > 0;
        }
    }

    /* =====================================================
       LOGIN: TRẢ VỀ ĐỐI TƯỢNG USER (DÙNG CHO LoginServlet)
       trả về null nếu sai mật khẩu / tài khoản bị khóa
       ===================================================== */
    public User login(String tenDangNhap, String plainPassword) throws Exception {
        User u = findByUsername(tenDangNhap);
        if (u == null) return null;           // không tồn tại
        if (!u.isTrangThai()) return null;    // tài khoản bị khóa

        String hashedOrPlain = u.getMatKhau();
        if (hashedOrPlain == null) return null;

        boolean match;

        // Nếu là mật khẩu đã hash BCrypt
        if (hashedOrPlain.startsWith("$2a$")) {
            match = BCrypt.checkpw(plainPassword, hashedOrPlain);
        } else {
            // Trường hợp (hiếm) DB đang lưu plain text
            match = plainPassword.equals(hashedOrPlain);
        }

        return match ? u : null;
    }

    /* =====================================================
       HÀM CŨ: XÁC THỰC ĐĂNG NHẬP (TRUE/FALSE)
       (vẫn giữ cho những chỗ khác trong project đang dùng)
       ===================================================== */
    public boolean validateLogin(String tenDangNhap, String plainPassword) throws Exception {
        return login(tenDangNhap, plainPassword) != null;
    }
    /* =====================================================
    LẤY USER THEO ID
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
    PHÂN TRANG: ĐẾM TỔNG SỐ USER
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
 PHÂN TRANG: LẤY DANH SÁCH USER
 (offset = (page-1)*pageSize)
 ===================================================== */
public java.util.List<User> findAll(int offset, int limit) throws Exception {
  java.util.List<User> list = new java.util.ArrayList<>();

  // ✅ DÙNG CÚ PHÁP MySQL: LIMIT offset, count
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

      // offset = bỏ qua bao nhiêu dòng, limit = lấy bao nhiêu dòng
      ps.setInt(1, offset);   // ví dụ (page-1)*pageSize
      ps.setInt(2, limit);    // ví dụ pageSize

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
    CẬP NHẬT THÔNG TIN USER (KHÔNG ĐỔI MẬT KHẨU)
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
    XÓA USER
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
