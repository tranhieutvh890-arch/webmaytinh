package model;
import java.math.BigDecimal;
import java.time.LocalDateTime;
public class Product {
    private int maSanPham;
    private int maDanhMuc;
    private Integer maThuongHieu;
    private String tenSanPham;
    private String moTaNgan;
    private String moTaChiTiet;
    private BigDecimal gia;
    private BigDecimal giaCu;
    private int soLuongTon;
    private Integer baoHanhThang;
    private boolean sanPhamCu;
    private String anhDaiDien;
    private LocalDateTime ngayTao;
    private LocalDateTime ngayCapNhat;
    private boolean trangThai;
    private String tenDanhMuc;
    private String tenThuongHieu;
    public Product() {
    }
    public Product(int maSanPham,
                   int maDanhMuc,
                   Integer maThuongHieu,
                   String tenSanPham,
                   String moTaNgan,
                   String moTaChiTiet,
                   BigDecimal gia,
                   BigDecimal giaCu,
                   int soLuongTon,
                   Integer baoHanhThang,
                   boolean sanPhamCu,
                   String anhDaiDien,
                   LocalDateTime ngayTao,
                   LocalDateTime ngayCapNhat,
                   boolean trangThai,
                   String tenDanhMuc,
                   String tenThuongHieu) {
        this.maSanPham = maSanPham;
        this.maDanhMuc = maDanhMuc;
        this.maThuongHieu = maThuongHieu;
        this.tenSanPham = tenSanPham;
        this.moTaNgan = moTaNgan;
        this.moTaChiTiet = moTaChiTiet;
        this.gia = gia;
        this.giaCu = giaCu;
        this.soLuongTon = soLuongTon;
        this.baoHanhThang = baoHanhThang;
        this.sanPhamCu = sanPhamCu;
        this.anhDaiDien = anhDaiDien;
        this.ngayTao = ngayTao;
        this.ngayCapNhat = ngayCapNhat;
        this.trangThai = trangThai;
        this.tenDanhMuc = tenDanhMuc;
        this.tenThuongHieu = tenThuongHieu;
    }
    public int getMaSanPham() {
        return maSanPham;
    }
    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }
    public int getMaDanhMuc() {
        return maDanhMuc;
    }
    public void setMaDanhMuc(int maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }
    public Integer getMaThuongHieu() {
        return maThuongHieu;
    }
    public void setMaThuongHieu(Integer maThuongHieu) {
        this.maThuongHieu = maThuongHieu;
    }
    public String getTenSanPham() {
        return tenSanPham;
    }
    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }
    public String getMoTaNgan() {
        return moTaNgan;
    }
    public void setMoTaNgan(String moTaNgan) {
        this.moTaNgan = moTaNgan;
    }
    public String getMoTaChiTiet() {
        return moTaChiTiet;
    }
    public void setMoTaChiTiet(String moTaChiTiet) {
        this.moTaChiTiet = moTaChiTiet;
    }
    public BigDecimal getGia() {
        return gia;
    }
    public void setGia(BigDecimal gia) {
        this.gia = gia;
    }
    public BigDecimal getGiaCu() {
        return giaCu;
    }
    public void setGiaCu(BigDecimal giaCu) {
        this.giaCu = giaCu;
    }
    public int getSoLuongTon() {
        return soLuongTon;
    }
    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }
    public Integer getBaoHanhThang() {
        return baoHanhThang;
    }
    public void setBaoHanhThang(Integer baoHanhThang) {
        this.baoHanhThang = baoHanhThang;
    }
    public boolean isSanPhamCu() {
        return sanPhamCu;
    }
    public void setSanPhamCu(boolean sanPhamCu) {
        this.sanPhamCu = sanPhamCu;
    }
    public String getAnhDaiDien() {
        return anhDaiDien;
    }
    public void setAnhDaiDien(String anhDaiDien) {
        this.anhDaiDien = anhDaiDien;
    }
    public LocalDateTime getNgayTao() {
        return ngayTao;
    }
    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }
    public LocalDateTime getNgayCapNhat() {
        return ngayCapNhat;
    }
    public void setNgayCapNhat(LocalDateTime ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }
    public boolean isTrangThai() {
        return trangThai;
    }
    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }
    public String getTenDanhMuc() {
        return tenDanhMuc;
    }
    public void setTenDanhMuc(String tenDanhMuc) {
        this.tenDanhMuc = tenDanhMuc;
    }
    public String getTenThuongHieu() {
        return tenThuongHieu;
    }
    public void setTenThuongHieu(String tenThuongHieu) {
        this.tenThuongHieu = tenThuongHieu;
    }
}
