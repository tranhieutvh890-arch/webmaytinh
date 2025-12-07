# 📋 BÁO CÁO CHI TIẾT CÁC CHỨC NĂNG THÊM, SỬA, XÓA, TÌM KIẾM
## Dự án: Laptop4Study - Cửa hàng bán máy tính

---

## 📌 PHẦN 1: TỔNG QUAN CẤU TRÚC HỆ THỐNG

### 1.1 Kiến trúc MVC (Model-View-Controller)

Dự án sử dụng kiến trúc MVC với 3 tầng:

```
┌─────────────────────────────────────────────────────┐
│              TẦNG PRESENTATION (View)                │
│  - JSP files: products.jsp, trangchumaytinh.jsp     │
│  - Static files: CSS, JavaScript, Images           │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────┴──────────────────────────────────┐
│      TẦNG LOGIC (Controller - Servlet)              │
│  - AdminProductServlet.java                         │
│  - ProductServlet.java                              │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────┴──────────────────────────────────┐
│    TẦNG DỮ LIỆU (Model & DAO)                      │
│  - Product.java (Model)                             │
│  - ProductDAO.java (Data Access Object)             │
│  - DBHelper.java (Kết nối CSDL)                     │
└─────────────────────────────────────────────────────┘
```

### 1.2 Công nghệ sử dụng

| Thành phần | Công nghệ | Chi tiết |
|-----------|-----------|---------|
| **Backend** | Java Servlet | Xử lý HTTP request/response |
| **Frontend** | JSP, JavaScript, CSS | Giao diện người dùng |
| **Database** | MySQL | Lưu trữ dữ liệu |
| **Connection** | JDBC, MySQL Driver | Kết nối với database |
| **JSON** | Gson | Chuyển đổi dữ liệu sang JSON |

---

## 📌 PHẦN 2: MỘT CHI TIẾT CÁC CHỨC NĂNG CRUD

### 2.1 CHỨC NĂNG THÊM (CREATE)

#### **A. Flow hoạt động của chức năng THÊM**

```
┌─────────────────────────────────────────────────────┐
│  1. Người dùng click nút "Thêm mới" trên trang       │
│     admin (/views/admin/products.jsp)               │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  2. Mở form modal để nhập thông tin sản phẩm        │
│     - ID tự động generated (Auto Increment)        │
│     - Nhập các trường: Tên, giá, số lượng, v.v      │
│     - Upload hình ảnh (nếu có)                      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  3. Submit form → Gửi POST request đến:            │
│     URL: /admin/products (AdminProductServlet)    │
│     Parameters:                                      │
│     - action = "create"                             │
│     - tenSanPham, maDanhMuc, gia, ... (dữ liệu)    │
│     - image file (từ upload)                        │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  4. Servlet nhận request & xử lý:                  │
│     AdminProductServlet.doPost()                    │
│     → handleCreate()                                │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  5. Lưu file ảnh:                                  │
│     saveImageIfUploaded()                           │
│     → File → /static/images/ + timestamp_filename   │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  6. Tạo object Product với dữ liệu từ form         │
│     p = new Product()                               │
│     p.setTenSanPham(), p.setGia(), ... (gán dữ)    │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  7. Gọi DAO để lưu vào database:                   │
│     ProductDAO.create(p)                            │
│     → INSERT INTO SanPham (...)                     │
│     → Trả về ID sản phẩm vừa tạo                   │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  8. Kết quả:                                        │
│     ✓ Thành công → Redirect về danh sách            │
│     ✓ Hiển thị message "Thêm thành công"           │
│     ✗ Thất bại → Thông báo lỗi                      │
└─────────────────────────────────────────────────────┘
```

#### **B. Chi tiết các file liên quan**

| **File** | **Vị trí** | **Chức năng** |
|---------|-----------|-------------|
| `products.jsp` | `/views/admin/` | Giao diện form thêm/sửa sản phẩm |
| `AdminProductServlet.java` | `/controller/` | Xử lý logic thêm (handleCreate) |
| `ProductDAO.java` | `/dao/` | Hàm `create()` thực thi SQL INSERT |
| `Product.java` | `/model/` | Class model chứa dữ liệu sản phẩm |
| `DBHelper.java` | `/dao/` | Hàm `getConnection()` kết nối DB |

#### **C. Mã code chi tiết**

**1) File: `AdminProductServlet.java` - Phương thức `handleCreate()`**

```java
private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    // Bước 1: Tạo object Product mới
    Product p = new Product();
    
    // Bước 2: Lấy dữ liệu từ form request
    p.setMaDanhMuc(parseIntOrNull(req.getParameter("maDanhMuc")));
    p.setMaThuongHieu(parseIntOrNull(req.getParameter("maThuongHieu")));
    p.setTenSanPham(Optional.ofNullable(req.getParameter("tenSanPham"))
                           .orElse("").trim());
    p.setMoTaNgan(req.getParameter("moTaNgan"));
    p.setMoTaChiTiet(req.getParameter("moTaChiTiet"));
    p.setGia(parseDecimalOrNull(req.getParameter("gia")));
    p.setGiaCu(parseDecimalOrNull(req.getParameter("giaCu")));
    p.setSoLuongTon(Optional.ofNullable(parseIntOrNull(req.getParameter("soLuongTon")))
                           .orElse(0));
    p.setBaoHanhThang(parseIntOrNull(req.getParameter("baoHanhThang")));
    p.setSanPhamCu("on".equals(req.getParameter("sanPhamCu")));
    
    // Bước 3: Xử lý upload ảnh
    String imgPath = saveImageIfUploaded(req);
    String anhText = req.getParameter("anhDaiDien");
    p.setAnhDaiDien(imgPath != null ? imgPath : anhText);
    
    // Bước 4: Gọi DAO để lưu vào database
    int newId = dao.create(p);
    
    // Bước 5: Xử lý kết quả
    if (newId > 0) {
        req.getSession().setAttribute("message", "Thêm sản phẩm thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
    } else {
        throw new Exception("Không thể tạo sản phẩm");
    }
}
```

**2) File: `ProductDAO.java` - Phương thức `create()`**

```java
public int create(Product p) throws Exception {
    // Bước 1: Chuẩn bị câu lệnh SQL INSERT
    String sql = """
            INSERT INTO SanPham
            (MaDanhMuc, MaThuongHieu, TenSanPham, MoTaNgan, MoTaChiTiet,
             Gia, GiaCu, SoLuongTon, BaoHanhThang, SanPhamCu, AnhDaiDien)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
    
    // Bước 2: Mở kết nối với database
    try (Connection c = DBHelper.getConnection();
         PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        // Bước 3: Gán các tham số vào prepared statement
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
        
        // Xử lý đường dẫn ảnh
        String path = p.getAnhDaiDien();
        if (path == null || path.trim().isEmpty()) {
            ps.setNull(11, Types.NVARCHAR);
        } else {
            path = path.trim().replace("\\", "/");
            if (!path.contains("/")) {
                path = "/static/images/" + path;
            }
            ps.setString(11, path);
        }
        
        // Bước 4: Thực thi câu lệnh SQL
        int affected = ps.executeUpdate();
        if (affected == 0) return -1;
        
        // Bước 5: Lấy ID được generate (Auto Increment)
        try (ResultSet keys = ps.getGeneratedKeys()) {
            if (keys.next()) return keys.getInt(1);
        }
        return -1;
    }
}
```

**3) File: `products.jsp` - Form nhập dữ liệu**

```html
<!-- Form gửi POST request đến AdminProductServlet -->
<form action="${pageContext.request.contextPath}/admin/products"
      method="post"
      enctype="multipart/form-data">

    <input type="hidden" name="action" value="create"/>

    <!-- Tên sản phẩm -->
    <div class="form-row">
        <label for="tenSanPham">Tên sản phẩm *</label>
        <input type="text" id="tenSanPham" name="tenSanPham" required/>
    </div>

    <!-- Mô tả ngắn -->
    <div class="form-row">
        <label for="moTaNgan">Mô tả ngắn</label>
        <textarea id="moTaNgan" name="moTaNgan" rows="2"></textarea>
    </div>

    <!-- Giá tiền -->
    <div class="form-row">
        <label for="gia">Giá bán *</label>
        <input type="number" id="gia" name="gia" step="0.01" required/>
    </div>

    <!-- Upload ảnh -->
    <div class="form-row">
        <label for="image">Ảnh đại diện</label>
        <input type="file" id="image" name="image" accept="image/*"/>
    </div>

    <!-- Nút submit -->
    <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
</form>
```

#### **D. Bảng dữ liệu SanPham trong database**

```sql
CREATE TABLE SanPham (
    MaSanPham INT PRIMARY KEY AUTO_INCREMENT,
    MaDanhMuc INT,
    MaThuongHieu INT,
    TenSanPham NVARCHAR(255) NOT NULL,
    MoTaNgan NVARCHAR(500),
    MoTaChiTiet NVARCHAR(MAX),
    Gia DECIMAL(10,2),
    GiaCu DECIMAL(10,2),
    SoLuongTon INT DEFAULT 0,
    BaoHanhThang INT,
    SanPhamCu BIT DEFAULT 0,
    AnhDaiDien NVARCHAR(500),
    NgayTao DATETIME DEFAULT NOW(),
    NgayCapNhat DATETIME,
    TrangThai BIT DEFAULT 1
);
```

---

### 2.2 CHỨC NĂNG SỬA (UPDATE)

#### **A. Flow hoạt động của chức năng SỬA**

```
┌─────────────────────────────────────────────────────┐
│  1. Người dùng click nút "Sửa" trong danh sách       │
│     → Href: /admin/products?action=edit&maSanPham=X │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  2. Servlet nhận GET request:                       │
│     AdminProductServlet.doGet()                     │
│     action = "edit", maSanPham = X                  │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  3. Gọi DAO để lấy dữ liệu sản phẩm cũ:            │
│     ProductDAO.findById(X)                          │
│     SELECT * FROM SanPham WHERE MaSanPham = X       │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  4. Forward sang products.jsp với dữ liệu cũ        │
│     req.setAttribute("product", p)                  │
│     Form hiển thị với giá trị cũ được pre-fill      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  5. Người dùng chỉnh sửa thông tin → Submit form    │
│     POST request → action = "update"                │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  6. Servlet xử lý update:                          │
│     AdminProductServlet.doPost()                    │
│     → handleUpdate()                                │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  7. Lấy dữ liệu sản phẩm cũ (để so sánh)           │
│     ProductDAO.findById(id)                         │
│     Nếu không có dữ liệu mới → giữ dữ liệu cũ      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  8. Cập nhật ảnh (nếu có upload ảnh mới):         │
│     saveImageIfUploaded()                           │
│     → Lưu ảnh mới vào /static/images/               │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  9. Gọi DAO để cập nhật database:                  │
│     ProductDAO.update(p)                            │
│     UPDATE SanPham SET ... WHERE MaSanPham = X      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  10. Kết quả:                                       │
│      ✓ Thành công → Redirect & hiển thị message    │
│      ✗ Thất bại → Thông báo lỗi                    │
└─────────────────────────────────────────────────────┘
```

#### **B. Chi tiết mã code**

**1) AdminProductServlet.java - Phương thức `handleUpdate()`**

```java
private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    // Bước 1: Lấy ID sản phẩm cần sửa
    Integer id = parseIntOrNull(req.getParameter("maSanPham"));
    if (id == null) throw new Exception("Thiếu maSanPham");
    
    // Bước 2: Lấy dữ liệu sản phẩm cũ từ database
    Product old = dao.findById(id);
    if (old == null) throw new Exception("Không tìm thấy sản phẩm");
    
    // Bước 3: Tạo object Product mới với dữ liệu sửa
    Product p = new Product();
    p.setMaSanPham(id);
    
    // Nếu có dữ liệu mới → dùng dữ liệu mới, không thì giữ dữ liệu cũ
    p.setMaDanhMuc(Optional.ofNullable(parseIntOrNull(req.getParameter("maDanhMuc")))
                          .orElse(old.getMaDanhMuc()));
    p.setMaThuongHieu(Optional.ofNullable(parseIntOrNull(req.getParameter("maThuongHieu")))
                             .orElse(old.getMaThuongHieu()));
    p.setTenSanPham(Optional.ofNullable(req.getParameter("tenSanPham"))
                           .orElse(old.getTenSanPham()));
    p.setMoTaNgan(Optional.ofNullable(req.getParameter("moTaNgan"))
                         .orElse(old.getMoTaNgan()));
    p.setMoTaChiTiet(Optional.ofNullable(req.getParameter("moTaChiTiet"))
                            .orElse(old.getMoTaChiTiet()));
    p.setGia(Optional.ofNullable(parseDecimalOrNull(req.getParameter("gia")))
                    .orElse(old.getGia()));
    p.setGiaCu(Optional.ofNullable(parseDecimalOrNull(req.getParameter("giaCu")))
                      .orElse(old.getGiaCu()));
    p.setSoLuongTon(Optional.ofNullable(parseIntOrNull(req.getParameter("soLuongTon")))
                           .orElse(old.getSoLuongTon()));
    p.setBaoHanhThang(Optional.ofNullable(parseIntOrNull(req.getParameter("baoHanhThang")))
                             .orElse(old.getBaoHanhThang()));
    p.setSanPhamCu("on".equals(req.getParameter("sanPhamCu")));
    
    // Bước 4: Xử lý ảnh
    String img = saveImageIfUploaded(req);
    p.setAnhDaiDien(img != null ? img : old.getAnhDaiDien());
    
    // Bước 5: Gọi DAO để cập nhật database
    boolean updated = dao.update(p);
    
    // Bước 6: Xử lý kết quả
    if (updated) {
        req.getSession().setAttribute("message", "Cập nhật sản phẩm thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
    } else {
        throw new Exception("Cập nhật thất bại");
    }
}
```

**2) ProductDAO.java - Phương thức `update()`**

```java
public boolean update(Product p) throws Exception {
    // Bước 1: Chuẩn bị câu lệnh SQL UPDATE
    String sql = """
            UPDATE SanPham
            SET MaDanhMuc=?, MaThuongHieu=?, TenSanPham=?, MoTaNgan=?, MoTaChiTiet=?,
                Gia=?, GiaCu=?, SoLuongTon=?, BaoHanhThang=?, SanPhamCu=?,
                AnhDaiDien=?, NgayCapNhat = NOW()
            WHERE MaSanPham = ?
            """;
    
    // Bước 2: Mở kết nối và chuẩn bị statement
    try (Connection c = DBHelper.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        
        // Bước 3: Gán các tham số
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
        
        // Xử lý đường dẫn ảnh
        String path = p.getAnhDaiDien();
        if (path == null || path.trim().isEmpty()) {
            ps.setNull(11, Types.VARCHAR);
        } else {
            path = path.trim().replace("\\", "/");
            if (!path.contains("/")) {
                path = "/static/images/" + path;
            }
            ps.setString(11, path);
        }
        
        ps.setInt(12, p.getMaSanPham());
        
        // Bước 4: Thực thi câu lệnh
        return ps.executeUpdate() > 0;
    }
}
```

---

### 2.3 CHỨC NĂNG XÓA (DELETE)

#### **A. Flow hoạt động của chức năng XÓA**

```
┌─────────────────────────────────────────────────────┐
│  1. Người dùng click nút "Xóa" trong danh sách       │
│     → Form method=post action="/admin/products"      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  2. JavaScript xác nhận: confirm('Xóa sản phẩm?')   │
│     - Nếu OK → Gửi form                             │
│     - Nếu Cancel → Hủy yêu cầu                      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  3. POST request đến AdminProductServlet:           │
│     - action = "delete"                             │
│     - maSanPham = ID sản phẩm cần xóa               │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  4. Servlet xử lý delete:                          │
│     AdminProductServlet.doPost()                    │
│     → handleDelete()                                │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  5. Gọi DAO để xóa khỏi database:                  │
│     ProductDAO.delete(id)                           │
│     DELETE FROM SanPham WHERE MaSanPham = ?         │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  6. Kết quả:                                        │
│      ✓ Thành công → Redirect & hiển thị message    │
│      ✗ Thất bại → Thông báo lỗi                    │
└─────────────────────────────────────────────────────┘
```

#### **B. Chi tiết mã code**

**1) AdminProductServlet.java - Phương thức `handleDelete()`**

```java
private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    // Bước 1: Lấy ID sản phẩm cần xóa
    Integer id = parseIntOrNull(req.getParameter("maSanPham"));
    if (id == null) throw new Exception("Thiếu maSanPham để xóa");
    
    // Bước 2: Gọi DAO để xóa
    boolean deleted = dao.delete(id);
    
    // Bước 3: Xử lý kết quả
    if (deleted) {
        req.getSession().setAttribute("message", "Xóa sản phẩm thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
    } else {
        throw new Exception("Không tìm thấy sản phẩm để xóa");
    }
}
```

**2) ProductDAO.java - Phương thức `delete()`**

```java
public boolean delete(int maSanPham) throws Exception {
    // Bước 1: Chuẩn bị câu lệnh SQL DELETE
    String sql = "DELETE FROM SanPham WHERE MaSanPham = ?";
    
    // Bước 2: Mở kết nối và chuẩn bị statement
    try (Connection c = DBHelper.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        
        // Bước 3: Gán tham số ID
        ps.setInt(1, maSanPham);
        
        // Bước 4: Thực thi câu lệnh
        // executeUpdate() trả về số lượng dòng bị ảnh hưởng
        // > 0 nghĩa là xóa thành công
        return ps.executeUpdate() > 0;
    }
}
```

**3) products.jsp - Form xóa**

```html
<!-- Form xóa sản phẩm -->
<form class="inline"
      action="${pageContext.request.contextPath}/admin/products"
      method="post"
      onsubmit="return confirm('Xóa sản phẩm này?');">
    
    <!-- Xác định action = delete -->
    <input type="hidden" name="action" value="delete"/>
    
    <!-- Gửi ID sản phẩm -->
    <input type="hidden" name="maSanPham" value="${p.maSanPham}"/>
    
    <!-- Nút submit -->
    <button type="submit" class="btn btn-danger">Xóa</button>
</form>
```

---

### 2.4 CHỨC NĂNG TÌM KIẾM (SEARCH)

#### **A. Flow hoạt động của chức năng TÌM KIẾM**

Dự án có **2 loại tìm kiếm**:

**🔍 LOẠI 1: TÌM KIẾM PHÍA ADMIN** (Tìm kiếm sản phẩm theo tên)

```
┌─────────────────────────────────────────────────────┐
│  1. Người dùng nhập từ khóa vào search box           │
│     Trang: /admin/products                           │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  2. Click nút "🔍" hoặc Enter → Submit form          │
│     POST request đến: /admin/products                │
│     Parameters:                                      │
│     - action = "search"                             │
│     - keyword = "từ khóa tìm kiếm"                   │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  3. Servlet nhận request:                           │
│     AdminProductServlet.doPost()                     │
│     (Lưu ý: chương trình hiện chỉ có 3 action:    │
│      create, update, delete. Search chưa implement) │
└────────────────────┬────────────────────────────────┘
```

**🔍 LOẠI 2: TÌM KIẾM PHÍA CLIENT** (Tìm kiếm JavaScript trực tiếp)

```
┌─────────────────────────────────────────────────────┐
│  1. Người dùng nhập từ khóa vào search box           │
│     Trang: /views/pages/trangchumaytinh.jsp, v.v    │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  2. Submit form → Gọi hàm JavaScript:               │
│     handleSearch(event)                             │
│     [File: /static/js/search.js]                    │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  3. JavaScript xử lý:                               │
│     - Lấy giá trị search input                      │
│     - Convert thành lowercase                       │
│     - So sánh với tên sản phẩm trên trang           │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  4. Ẩn/hiện các sản phẩm:                          │
│     - Nếu khớp keyword → display = ''               │
│     - Nếu không khớp → display = 'none'             │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  5. Hiển thị kết quả tìm kiếm:                     │
│     "Found X products for 'keyword'"                │
│     Gợi ý danh mục khớp                             │
└─────────────────────────────────────────────────────┘
```

#### **B. Chi tiết mã code - Search.js**

**File: `/static/js/search.js`**

```javascript
function handleSearch(event) {
  try {
    // Bước 1: Ngăn chặn form submit mặc định
    if (event && event.preventDefault) event.preventDefault();
    
    // Bước 2: Lấy giá trị từ input search
    var searchInput = document.getElementById('searchInput') || {};
    var raw = searchInput.value || '';
    var searchTerm = raw.trim().toLowerCase(); // Chuyển thành chữ thường
    
    // Bước 3: Kiểm tra input rỗng
    if (!searchTerm) return false;

    console.log('Search term:', searchTerm);

    // Bước 4: Lấy tất cả các sản phẩm trên trang
    var products = document.querySelectorAll('article.card, .product-item');
    var productMatches = 0;

    // Bước 5: Loop qua từng sản phẩm
    for (var k = 0; k < products.length; k++) {
      var product = products[k];
      
      // Lấy tên sản phẩm từ HTML
      var titleEl = product.querySelector('a.card__title, .card__title, .product-name');
      var productName = '';
      
      if (titleEl && titleEl.textContent) {
        productName = titleEl.textContent
          .trim()
          .replace(/\s+/g, ' ')
          .toLowerCase();
      }
      
      // Lấy danh mục từ HTML
      var catEl = document.querySelector('.product-category');
      var productCategory = '';
      if (catEl && catEl.textContent) {
        productCategory = catEl.textContent
          .trim()
          .replace(/\s+/g, ' ')
          .toLowerCase();
      }

      // Bước 6: So sánh tên sản phẩm hoặc danh mục với từ khóa
      if (productName.indexOf(searchTerm) >= 0 || 
          productCategory.indexOf(searchTerm) >= 0) {
        // Khớp → Hiển thị sản phẩm
        product.style.display = '';
        productMatches++;
      } else {
        // Không khớp → Ẩn sản phẩm
        product.style.display = 'none';
      }
    }

    console.log('Found:', productMatches, 'products');

    // Bước 7: Tìm danh mục khớp
    var catLinks = document.querySelectorAll('.catbar a.cat');
    var matchedCats = [];
    
    for (var i = 0; i < catLinks.length; i++) {
      var a = catLinks[i];
      var text = (a.textContent || '')
        .trim()
        .replace(/\s+/g, ' ')
        .toLowerCase();
      if (text.indexOf(searchTerm) >= 0) {
        matchedCats.push(a);
      }
    }

    // Bước 8: Hiển thị kết quả tìm kiếm
    var resultsEl = document.getElementById('searchResults') || createSearchResults();
    var catsEl = document.getElementById('categoryMatches') || createCategoryResults();

    if (productMatches > 0) {
      resultsEl.textContent = 'Found ' + productMatches + ' products for "' + raw + '"';
      resultsEl.style.display = 'block';
    } else {
      resultsEl.textContent = 'No products found for "' + raw + '"';
      resultsEl.style.display = 'block';
    }

    // Bước 9: Hiển thị danh mục gợi ý
    catsEl.innerHTML = '';
    if (matchedCats.length > 0) {
      var heading = document.createElement('div');
      heading.textContent = 'Matching categories:';
      heading.style.fontWeight = '600';
      heading.style.marginBottom = '6px';
      catsEl.appendChild(heading);

      for (var j = 0; j < matchedCats.length; j++) {
        var catLink = matchedCats[j];
        var link = document.createElement('a');
        link.href = catLink.href || catLink.getAttribute('href');
        link.textContent = catLink.textContent.trim();
        link.style.display = 'inline-block';
        link.style.margin = '4px 8px 4px 0';
        link.className = 'cat-match-link';
        catsEl.appendChild(link);
      }
      catsEl.style.display = 'block';
    } else {
      catsEl.style.display = 'none';
    }

    // Bước 10: Tự động redirect nếu có 1 danh mục khớp duy nhất
    if (productMatches === 0 && matchedCats.length === 1) {
      var href = matchedCats[0].getAttribute('href');
      if (href) {
        console.log('Redirecting to:', href);
        window.location.href = href;
        return false;
      }
    }

    return false;
  } catch (err) {
    console.error('Search error:', err);
    var r = document.getElementById('searchResults') || createSearchResults();
    r.textContent = 'Search error: ' + (err && err.message ? err.message : String(err));
    r.style.display = 'block';
    return false;
  }
}
```

#### **C. HTML Form Search**

**File: `trangchumaytinh.jsp` (và các file tương tự)**

```html
<!-- Form tìm kiếm phía client -->
<form class="search" onsubmit="return handleSearch(event)">
    <input type="text" 
           id="searchInput" 
           name="q" 
           placeholder="Nhập sản phẩm, từ khóa…" 
           required />
    <button type="submit">Tìm kiếm</button>
</form>
```

---

## 📌 PHẦN 3: KẾT NỐI DATABASE

### 3.1 DBHelper.java - Quản lý kết nối

```java
package dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBHelper {
    // Thông tin kết nối database
    private static final String URL =
            "jdbc:mysql://localhost:3306/laptop4study"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&useUnicode=true"
            + "&characterEncoding=UTF-8";
    
    private static final String USER = "root";
    private static final String PASS = "12052002";
    
    // Load MySQL Driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found!", e);
        }
    }
    
    // Hàm tạo kết nối
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.out.println("MySQL connection error: " + e.getMessage());
            return null;
        }
    }
}
```

### 3.2 Chuỗi kết nối Chi tiết

| Tham số | Giá trị | Ý nghĩa |
|--------|--------|--------|
| **Host** | localhost | Máy chủ MySQL cục bộ |
| **Port** | 3306 | Cổng mặc định của MySQL |
| **Database** | laptop4study | Tên cơ sở dữ liệu |
| **User** | root | Tài khoản kết nối |
| **Password** | 12052002 | Mật khẩu kết nối |
| **Charset** | UTF-8 | Hỗ trợ tiếng Việt |

---

## 📌 PHẦN 4: FLOW TỔNG HỢP TÀI LIỆU

### 4.1 Sơ đồ kiến trúc ứng dụng

```
┌──────────────────────────────────────────────────────────────┐
│                    CLIENT (Người dùng)                        │
│  - Browser (Chrome, Firefox, Edge)                           │
│  - JSP Pages, HTML Forms, JavaScript                         │
└────────────────────┬─────────────────────────────────────────┘
                     │ HTTP Request/Response
┌────────────────────┴─────────────────────────────────────────┐
│              APPLICATION SERVER (Tomcat)                      │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │    SERVLET LAYER (Controller)                        │    │
│  │  - AdminProductServlet.java                         │    │
│  │  - ProductServlet.java                              │    │
│  │  - LoginServlet, RegisterServlet, ...               │    │
│  └───────────────────────┬─────────────────────────────┘    │
│                          │                                   │
│  ┌───────────────────────┴─────────────────────────────┐    │
│  │    MODEL & DAO LAYER (Business Logic)                │    │
│  │  - Product.java (Model class)                        │    │
│  │  - ProductDAO.java (CRUD operations)                 │    │
│  │  - DanhMucDAO.java, ThuongHieuDAO.java               │    │
│  │  - UserDAO.java                                      │    │
│  └───────────────────────┬─────────────────────────────┘    │
│                          │ JDBC
└────────────────────┬─────────────────────────────────────────┘
                     │
┌────────────────────┴─────────────────────────────────────────┐
│         DATABASE LAYER (MySQL Database)                      │
│                                                              │
│  - Database: laptop4study                                   │
│  - Tables: SanPham, DanhMuc, ThuongHieu, User, ...          │
│  - Storage: C:\ProgramData\MySQL\MySQL Server 8.0           │
└──────────────────────────────────────────────────────────────┘
```

### 4.2 Bảng tóm tắt các file chính

| **File** | **Vị trí** | **Mục đích** | **Chức năng** |
|---------|-----------|-----------|------------|
| **Servlet** | | | |
| `AdminProductServlet.java` | `/controller/` | Xử lý yêu cầu admin | Create, Update, Delete, List |
| `ProductServlet.java` | `/controller/` | API sản phẩm public | GET all, GET by ID |
| **Model** | | | |
| `Product.java` | `/model/` | Biểu diễn sản phẩm | Getter/Setter |
| **DAO** | | | |
| `ProductDAO.java` | `/dao/` | Truy cập DB sản phẩm | CRUD operations |
| `DBHelper.java` | `/dao/` | Kết nối CSDL | getConnection() |
| **View** | | | |
| `products.jsp` | `/views/admin/` | Giao diện admin | Form thêm/sửa/xóa |
| `trangchumaytinh.jsp` | `/views/pages/` | Trang chủ | Hiển thị sản phẩm |
| **JavaScript** | | | |
| `search.js` | `/static/js/` | Tìm kiếm phía client | handleSearch() |
| `home.js` | `/static/js/` | Xử lý logic trang chủ | addToCart(), login, register |

---

## 📌 PHẦN 5: HƯỚNG DẪN CHI TIẾT LẬP TRÌNH

### 5.1 Thêm sản phẩm mới

**Bước 1:** Truy cập trang admin: `http://localhost:8080/admin/products`

**Bước 2:** Click nút "Thêm mới"

**Bước 3:** Điền đầy đủ thông tin:
- Tên sản phẩm (bắt buộc)
- Mô tả ngắn, mô tả chi tiết
- Giá bán (bắt buộc)
- Giá cũ (nếu có khuyến mại)
- Số lượng tồn kho
- Chọn danh mục, thương hiệu
- Upload ảnh (tuỳ chọn)

**Bước 4:** Click "Thêm sản phẩm"

**Kết quả:** 
- ✅ Redirect về danh sách
- ✅ Hiển thị thông báo "Thêm sản phẩm thành công."

**Mã lệnh SQL được thực thi:**
```sql
INSERT INTO SanPham 
(MaDanhMuc, MaThuongHieu, TenSanPham, MoTaNgan, MoTaChiTiet, Gia, GiaCu, SoLuongTon, BaoHanhThang, SanPhamCu, AnhDaiDien)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

### 5.2 Sửa thông tin sản phẩm

**Bước 1:** Truy cập danh sách sản phẩm admin

**Bước 2:** Tìm sản phẩm cần sửa, click nút "Sửa"

**Bước 3:** Form sẽ tự động điền dữ liệu cũ

**Bước 4:** Chỉnh sửa các thông tin cần thay đổi

**Bước 5:** Click "Cập nhật sản phẩm"

**Kết quả:**
- ✅ Dữ liệu được cập nhật
- ✅ Thông báo "Cập nhật sản phẩm thành công."

**Mã lệnh SQL được thực thi:**
```sql
UPDATE SanPham
SET MaDanhMuc=?, MaThuongHieu=?, TenSanPham=?, MoTaNgan=?, MoTaChiTiet=?,
    Gia=?, GiaCu=?, SoLuongTon=?, BaoHanhThang=?, SanPhamCu=?,
    AnhDaiDien=?, NgayCapNhat = NOW()
WHERE MaSanPham = ?
```

### 5.3 Xóa sản phẩm

**Bước 1:** Truy cập danh sách sản phẩm admin

**Bước 2:** Tìm sản phẩm cần xóa, click nút "Xóa"

**Bước 3:** Xác nhận: Bấm "OK" trong hộp thoại confirm

**Kết quả:**
- ✅ Sản phẩm bị xóa khỏi database
- ✅ Thông báo "Xóa sản phẩm thành công."

**Mã lệnh SQL được thực thi:**
```sql
DELETE FROM SanPham WHERE MaSanPham = ?
```

### 5.4 Tìm kiếm sản phẩm

**Phía người dùng (Client Search):**

**Bước 1:** Nhập từ khóa vào ô search trên trang chủ

**Bước 2:** Click "Tìm kiếm" hoặc nhấn Enter

**Bước 3:** Kết quả:
- ✅ Các sản phẩm khớp được hiển thị
- ✅ Các sản phẩm không khớp bị ẩn
- ✅ Gợi ý danh mục liên quan

**JavaScript xử lý:**
```javascript
// So sánh từ khóa với tên sản phẩm
if (productName.indexOf(searchTerm) >= 0) {
    product.style.display = '';  // Hiển thị
} else {
    product.style.display = 'none';  // Ẩn
}
```

---

## 📌 PHẦN 6: CÂU HỎI THƯỜNG GẶP (FAQ)

### Q1: Làm sao để thêm trường dữ liệu mới?

**A:** 
1. Thêm cột vào bảng SanPham trong database
2. Thêm field mới trong `Product.java` + getter/setter
3. Cập nhật câu lệnh SQL trong `ProductDAO.java` (thêm trong INSERT/UPDATE/SELECT)
4. Thêm input field trong form `products.jsp`
5. Gán giá trị từ request trong `AdminProductServlet.handleCreate/Update()`

### Q2: Hình ảnh được lưu ở đâu?

**A:** 
- Thư mục: `/static/images/`
- Đường dẫn trong DB: `/static/images/timestamp_filename.jpg`
- Ví dụ: `/static/images/1702028456789_laptop.jpg`

### Q3: Làm sao để implement tìm kiếm phía server?

**A:**
```java
// Thêm vào ProductDAO.java
public List<Product> searchByName(String keyword) throws Exception {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT * FROM SanPham WHERE TenSanPham LIKE ? ORDER BY MaSanPham DESC";
    try (Connection c = DBHelper.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, "%" + keyword + "%");
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
    }
    return list;
}
```

### Q4: Nếu xóa sản phẩm, có ảnh cũ bị xóa không?

**A:** Hiện tại chưa có code tự động xóa ảnh. Cần thêm:
```java
private void deleteImageFile(String imagePath) throws IOException {
    if (imagePath != null && !imagePath.isEmpty()) {
        Path path = Paths.get(imagePath);
        Files.deleteIfExists(path);
    }
}
```

---

## 📌 PHẦN 7: TÓM TẮT CÁC HÀMHỆ THỐNG

| **Chức năng** | **Hàm chính** | **File** | **Kiểu dữ liệu trả về** |
|----------|------------|---------|----------------------|
| Thêm | `create(Product)` | ProductDAO | `int` (ID mới) |
| Sửa | `update(Product)` | ProductDAO | `boolean` |
| Xóa | `delete(int)` | ProductDAO | `boolean` |
| Lấy tất cả | `findAll()` | ProductDAO | `List<Product>` |
| Lấy by ID | `findById(int)` | ProductDAO | `Product` |
| Upload ảnh | `saveImageIfUploaded()` | AdminProductServlet | `String` (path) |
| Search (client) | `handleSearch(event)` | search.js | `void` (ẩn/hiện DOM) |

---

## 📌 KẾT LUẬN

Dự án Laptop4Study sử dụng **kiến trúc MVC chuẩn** với các thành phần:
- ✅ **Model (Model):** Lớp `Product.java` đại diện cho dữ liệu
- ✅ **View (View):** Các file JSP cung cấp giao diện người dùng
- ✅ **Controller (Servlet):** `AdminProductServlet` và `ProductServlet` xử lý logic

Các chức năng CRUD được triển khai **hoàn toàn** với:
- ✅ Thêm sản phẩm (CREATE)
- ✅ Sửa thông tin (UPDATE)
- ✅ Xóa sản phẩm (DELETE)
- ✅ Tìm kiếm (SEARCH - phía client)

Tất cả đều **kết nối chặt chẽ với MySQL database** thông qua JDBC và PreparedStatement để đảm bảo bảo mật SQL Injection.

---

**Biên soạn:** Báo cáo chức năng CRUD  
**Ngày:** 7/12/2025  
**Dự án:** Laptop4Study - Cửa hàng bán máy tính
