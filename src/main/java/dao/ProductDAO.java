package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    /* ================= MAP ResultSet -> Product ================= */
    private Product map(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setMaSanPham(rs.getInt("MaSanPham"));
        p.setMaDanhMuc(rs.getInt("MaDanhMuc"));
        p.setMaThuongHieu((Integer) rs.getObject("MaThuongHieu"));
        p.setTenSanPham(rs.getString("TenSanPham"));
        p.setMoTaNgan(rs.getString("MoTaNgan"));
        p.setMoTaChiTiet(rs.getString("MoTaChiTiet"));
        p.setGia(rs.getBigDecimal("Gia"));
        p.setGiaCu(rs.getBigDecimal("GiaCu"));
        p.setSoLuongTon(rs.getInt("SoLuongTon"));
        p.setBaoHanhThang((Integer) rs.getObject("BaoHanhThang"));
        p.setSanPhamCu(rs.getBoolean("SanPhamCu"));
        p.setAnhDaiDien(rs.getString("AnhDaiDien"));
        p.setNgayTao(rs.getTimestamp("NgayTao") != null ? rs.getTimestamp("NgayTao").toLocalDateTime() : null);
        p.setNgayCapNhat(rs.getTimestamp("NgayCapNhat") != null ? rs.getTimestamp("NgayCapNhat").toLocalDateTime() : null);
        p.setTrangThai(rs.getBoolean("TrangThai"));

        try { p.setTenDanhMuc(rs.getString("TenDanhMuc")); } catch (Exception ignored) {}
        try { p.setTenThuongHieu(rs.getString("TenThuongHieu")); } catch (Exception ignored) {}

        return p;
    }

    /* ================= INSERT SẢN PHẨM ================= */
    public int create(Product p) throws Exception {
        String sql = """
                INSERT INTO SanPham
                (MaDanhMuc, MaThuongHieu, TenSanPham, MoTaNgan, MoTaChiTiet,
                 Gia, GiaCu, SoLuongTon, BaoHanhThang, SanPhamCu, AnhDaiDien)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, p.getMaDanhMuc());

            if (p.getMaThuongHieu() == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, p.getMaThuongHieu());

            ps.setString(3, p.getTenSanPham());
            ps.setString(4, p.getMoTaNgan());
            ps.setString(5, p.getMoTaChiTiet());
            ps.setBigDecimal(6, p.getGia());

            if (p.getGiaCu() == null) ps.setNull(7, Types.DECIMAL);
            else ps.setBigDecimal(7, p.getGiaCu());

            ps.setInt(8, p.getSoLuongTon());

            if (p.getBaoHanhThang() == null) ps.setNull(9, Types.INTEGER);
            else ps.setInt(9, p.getBaoHanhThang());

            ps.setBoolean(10, p.isSanPhamCu());

            // ====== LƯU NGUYÊN ĐƯỜNG DẪN ẢNH ======
            String path = p.getAnhDaiDien();
            if (path == null || path.trim().isEmpty()) {
                ps.setNull(11, Types.NVARCHAR);
            } else {
                path = path.trim().replace("\\", "/");
                // nếu chỉ nhập tên file → tự thêm /static/images/
                if (!path.contains("/")) {
                    path = "/static/images/" + path;
                }
                ps.setString(11, path);
            }
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return -1;
        }
    }

    /* ================= UPDATE SẢN PHẨM ================= */
    public boolean update(Product p) throws Exception {
        String sql = """
                UPDATE SanPham
                SET MaDanhMuc=?, MaThuongHieu=?, TenSanPham=?, MoTaNgan=?, MoTaChiTiet=?,
                    Gia=?, GiaCu=?, SoLuongTon=?, BaoHanhThang=?, SanPhamCu=?,
                    AnhDaiDien=?, NgayCapNhat = NOW()
                WHERE MaSanPham = ?
                """;

        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, p.getMaDanhMuc());

            if (p.getMaThuongHieu() == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, p.getMaThuongHieu());

            ps.setString(3, p.getTenSanPham());
            ps.setString(4, p.getMoTaNgan());
            ps.setString(5, p.getMoTaChiTiet());
            ps.setBigDecimal(6, p.getGia());

            if (p.getGiaCu() == null) ps.setNull(7, Types.DECIMAL);
            else ps.setBigDecimal(7, p.getGiaCu());

            ps.setInt(8, p.getSoLuongTon());

            if (p.getBaoHanhThang() == null) ps.setNull(9, Types.INTEGER);
            else ps.setInt(9, p.getBaoHanhThang());

            ps.setBoolean(10, p.isSanPhamCu());

            // ====== LƯU GIỐNG HÀM create(): FULL PATH /static/images/... ======
            String path = p.getAnhDaiDien();
            if (path == null || path.trim().isEmpty()) {
                ps.setNull(11, Types.VARCHAR);
            } else {
                path = path.trim().replace("\\", "/");
                // nếu chỉ là tên file → tự thêm /static/images/
                if (!path.contains("/")) {
                    path = "/static/images/" + path;
                }
                ps.setString(11, path);
            }

            ps.setInt(12, p.getMaSanPham());

            return ps.executeUpdate() > 0;
        }
    }

    /* ================= DELETE ================= */
    public boolean delete(int maSanPham) throws Exception {
        String sql = "DELETE FROM SanPham WHERE MaSanPham = ?";
        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);
            return ps.executeUpdate() > 0;
        }
    }

    /* ================= FIND ALL ================= */
    public List<Product> findAll() throws Exception {
        List<Product> list = new ArrayList<>();

        String sql = """
                SELECT
                    sp.MaSanPham, sp.MaDanhMuc, sp.MaThuongHieu, sp.TenSanPham, sp.MoTaNgan,
                    sp.MoTaChiTiet, sp.Gia, sp.GiaCu, sp.SoLuongTon, sp.BaoHanhThang,
                    sp.SanPhamCu, sp.AnhDaiDien, sp.NgayTao, sp.NgayCapNhat, sp.TrangThai,
                    dm.TenDanhMuc, th.TenThuongHieu
                FROM SanPham sp
                LEFT JOIN DanhMuc dm ON dm.MaDanhMuc = sp.MaDanhMuc
                LEFT JOIN ThuongHieu th ON th.MaThuongHieu = sp.MaThuongHieu
                ORDER BY sp.MaSanPham DESC
                """;

        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(map(rs));
        }

        return list;
    }

    /* ================= FIND BY ID ================= */
    public Product findById(int maSanPham) throws Exception {
        String sql = """
                SELECT
                    sp.MaSanPham, sp.MaDanhMuc, sp.MaThuongHieu, sp.TenSanPham, sp.MoTaNgan,
                    sp.MoTaChiTiet, sp.Gia, sp.GiaCu, sp.SoLuongTon, sp.BaoHanhThang,
                    sp.SanPhamCu, sp.AnhDaiDien, sp.NgayTao, sp.NgayCapNhat, sp.TrangThai,
                    dm.TenDanhMuc, th.TenThuongHieu
                FROM SanPham sp
                LEFT JOIN DanhMuc dm ON dm.MaDanhMuc = sp.MaDanhMuc
                LEFT JOIN ThuongHieu th ON th.MaThuongHieu = sp.MaThuongHieu
                WHERE sp.MaSanPham = ?
                """;

        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }
}
