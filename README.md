# 💻 Laptop4Study - E-Commerce Platform

Dự án cửa hàng bán máy tính online với các chức năng:
- 🏪 Hiển thị sản phẩm
- 🔍 Tìm kiếm sản phẩm
- 🛒 Giỏ hàng
- 👤 Đăng nhập/Đăng ký
- 🎛️ Quản lý sản phẩm (Admin)

---

## 🚀 Chạy Local

### Yêu cầu
- Java 11+
- Maven 3.6+
- MySQL 8.0+

### Bước 1: Chuẩn bị Database

1. Tạo database mới:
```sql
CREATE DATABASE laptop4study CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Import schema:
```bash
mysql -u root -p laptop4study < src/main/webapp/database.sql
```

3. Cập nhật `DBHelper.java`:
```java
private static final String DB_HOST = "localhost";
private static final String DB_USER = "root";
private static final String DB_PASS = "your_password";
```

### Bước 2: Build & Run

**Option 1: Dùng Maven**
```bash
mvn clean package -DskipTests
mvn tomcat7:run
```

**Option 2: Dùng script**
```bash
# Linux/Mac
./start.sh

# Windows
start.bat
```

### Bước 3: Truy cập

- 🏠 Trang chủ: http://localhost:8080
- 🎛️ Admin: http://localhost:8080/admin/products
- 📝 Login test: 
  - Email: `admin@example.com`
  - Password: `password123`

---

## 🌐 Deploy lên Railway

Chi tiết xem: [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)

Quick start:
1. Push code lên GitHub
2. Tạo Railway project từ GitHub repo
3. Thêm MySQL plugin + environment variables
4. Deploy tự động!

---

## 📁 Cấu trúc Dự án

```
webmaytinh/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/        # Servlets
│       │   ├── dao/              # Database access
│       │   └── model/            # Entity classes
│       └── webapp/
│           ├── views/            # JSP pages
│           ├── static/           # CSS, JS, Images
│           └── WEB-INF/
│               └── web.xml       # Config
├── pom.xml                        # Maven config
├── Procfile                       # Railway config
└── database.sql                   # SQL schema
```

---

## 🛠️ Các công nghệ

| Thành phần | Công nghệ |
|-----------|----------|
| Backend | Java Servlet, JSP |
| Frontend | HTML5, CSS3, JavaScript |
| Database | MySQL |
| Build | Maven |
| Deploy | Railway (Heroku-like) |

---

## 🔧 Troubleshooting

### ❌ "Database connection failed"
- Kiểm tra MySQL running
- Kiểm tra username/password trong DBHelper

### ❌ "Port 8080 already in use"
```bash
# Tìm process sử dụng port
lsof -i :8080  # Mac/Linux
netstat -ano | findstr :8080  # Windows

# Kill process
kill -9 <PID>
```

### ❌ "Cannot find WAR file"
```bash
# Clean build
mvn clean package -DskipTests
```

---

## 📚 Tài liệu

- [Báo cáo chức năng CRUD](BAO_CAO_CHUC_NANG_CRUD.md)
- [Hướng dẫn Deploy Railway](RAILWAY_DEPLOYMENT.md)

---

## 👨‍💻 Tác giả

- Tran Hieu (@tranhieutvh890-arch)

---

## 📄 License

Dự án học tập - sử dụng tự do

---

**Happy Coding! 🎉**
