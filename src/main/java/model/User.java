package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    // ========== HẰNG SỐ PHÂN QUYỀN ==========
    public static final int QUYEN_ADMIN    = 1;       // ví dụ: MaQuyen = 1 là ADMIN
    public static final int QUYEN_CUSTOMER = 2;       // MaQuyen = 2 là CUSTOMER

    // ========== Fields tương ứng với bảng NguoiDung ==========
    private int maNguoiDung;          // MaNguoiDung (PK)
    private String tenDangNhap;       // TenDangNhap
    private transient String matKhau; // MatKhau (ẩn khi serialize)
    private String hoTen;             // HoTen
    private String email;             // Email
    private String soDienThoai;       // SoDienThoai
    private int maQuyen;              // MaQuyen (FK -> Quyen)
    private LocalDateTime ngayTao;    // NgayTao
    private boolean trangThai;        // TrangThai 1 = active, 0 = banned

    // ========== Field khi JOIN bảng QUYEN ==========
    private String tenQuyen;          // Tên quyền: ADMIN / CUSTOMER

    // ========== Constructors ==========
    public User() {
    }

    public User(int maNguoiDung, String tenDangNhap, String matKhau, String hoTen, String email,
                String soDienThoai, int maQuyen, LocalDateTime ngayTao,
                boolean trangThai, String tenQuyen) {
        this.maNguoiDung = maNguoiDung;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.hoTen = hoTen;
        this.email = email;
        this.soDienThoai = soDienThoai;
        this.maQuyen = maQuyen;
        this.ngayTao = ngayTao;
        this.trangThai = trangThai;
        this.tenQuyen = tenQuyen;
    }

    // ========== GETTER - SETTER ==========
    public int getMaNguoiDung() {
        return maNguoiDung;
    }

    public void setMaNguoiDung(int maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public int getMaQuyen() {
        return maQuyen;
    }

    public void setMaQuyen(int maQuyen) {
        this.maQuyen = maQuyen;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }

    public String getTenQuyen() {
        return tenQuyen;
    }

    public void setTenQuyen(String tenQuyen) {
        this.tenQuyen = tenQuyen;
    }

    // ========== HÀM TIỆN ÍCH PHÂN QUYỀN ==========
    /** true nếu user là ADMIN (dùng cho LoginServlet, AdminFilter) */
    public boolean isAdmin() {
        if (tenQuyen != null && tenQuyen.equalsIgnoreCase("ADMIN")) {
            return true;
        }
        return maQuyen == QUYEN_ADMIN;
    }

    /** true nếu là khách hàng bình thường */
    public boolean isCustomer() {
        if (tenQuyen != null && tenQuyen.equalsIgnoreCase("CUSTOMER")) {
            return true;
        }
        return maQuyen == QUYEN_CUSTOMER;
    }

    // ========== toString() ==========
    @Override
    public String toString() {
        return "User{" +
                "maNguoiDung=" + maNguoiDung +
                ", tenDangNhap='" + tenDangNhap + '\'' +
                ", hoTen='" + hoTen + '\'' +
                ", email='" + email + '\'' +
                ", soDienThoai='" + soDienThoai + '\'' +
                ", maQuyen=" + maQuyen +
                ", tenQuyen='" + tenQuyen + '\'' +
                ", trangThai=" + trangThai +
                '}';
    }
}
