# 🚀 HƯỚNG DẪN DEPLOY LAPTOP4STUDY LÊN RAILWAY

## 📋 Yêu cầu trước khi deploy

- ✅ Tài khoản Railway (https://railway.app)
- ✅ Git installed
- ✅ MySQL database (trên Railway hoặc dịch vụ khác)
- ✅ Dự án được commit lên GitHub

---

## 🔧 BƯỚC 1: CẤU HÌNH DATABASE TRÊN RAILWAY

### 1.1 Tạo MySQL Plugin trên Railway:

1. Vào Dashboard Railway → New
2. Chọn **Databases** → **MySQL**
3. Nhấn "Add"
4. Chờ MySQL khởi chạy (~2-3 phút)

### 1.2 Lấy thông tin kết nối:

Trong MySQL plugin của Railway, xem **Variables**:
- `MYSQL_HOST` - Hostname
- `MYSQL_PORT` - Port (thường 3306)
- `MYSQL_DATABASE` - Tên database
- `MYSQL_USER` - Username
- `MYSQL_PASSWORD` - Password

**Ví dụ:**
```
MYSQL_HOST=mysql.railway.internal
MYSQL_PORT=3306
MYSQL_DATABASE=railway
MYSQL_USER=root
MYSQL_PASSWORD=xxxxxxxxxxxxx
```

---

## 🌐 BƯỚC 2: SETUP PROJECT TRÊN RAILWAY

### 2.1 Tạo Railway Project:

1. Vào https://railway.app/new
2. Chọn **Deploy from GitHub**
3. Authorize Railway với GitHub
4. Chọn repository `webmaytinh`

### 2.2 Cấu hình Environment Variables:

Trong **Variables** của Railway project, thêm:

```
# Database
DB_HOST=mysql.railway.internal
DB_PORT=3306
DB_NAME=railway
DB_USER=root
DB_PASS=<your-mysql-password>

# Java
JAVA_OPTS=-Xmx512m -Xms256m
PORT=8080
```

### 2.3 Kết nối MySQL Plugin:

1. Vào **Plugins** trong Railway project
2. Thêm MySQL database (hoặc link từ database existing)
3. Các variables sẽ tự động được thêm vào project

---

## 📦 BƯỚC 3: BUILD & DEPLOY

### 3.1 Build Configuration:

Railway sẽ tự động detect `pom.xml` và build với Maven:

```bash
mvn clean package -DskipTests
```

Kết quả: `target/ROOT.war`

### 3.2 Start Command:

Railway chạy ứng dụng qua Tomcat. Ensure `Procfile` có:

```
web: java $JAVA_OPTS -cp target/classes:target/dependency/* -Dcom.sun.jndi.ldap.connect.pool=false org.apache.catalina.startup.Bootstrap -Dcatalina.base=target -Dcatalina.home=target start
```

### 3.3 Deploy:

Railway tự động deploy khi push code lên GitHub:

```bash
git add .
git commit -m "Prepare for Railway deployment"
git push origin main
```

Kiểm tra logs trong Railway Dashboard:

```
📋 Build logs → Deployment logs → Live logs
```

---

## ✅ BƯỚC 4: KIỂM TRA VÀ SETUP DATABASE

### 4.1 Truy cập ứng dụng:

Sau deploy thành công, Railway cung cấp URL:

```
https://webmaytinh-production.up.railway.app/
```

### 4.2 Import Database Schema:

Kết nối MySQL trên Railway và chạy SQL:

**File: `src/main/webapp/database.sql`**

Có 2 cách:

**Cách 1: Dùng Railway CLI**
```bash
railway database:shell
```

Rồi paste nội dung từ `database.sql`

**Cách 2: Dùng MySQL Client**
```bash
mysql -h <MYSQL_HOST> -u <MYSQL_USER> -p <MYSQL_DATABASE>
```

Rồi `source database.sql`

---

## 🐛 TROUBLESHOOTING

### ❌ Error: "Connection refused"

**Nguyên nhân:** Database chưa được kết nối

**Giải pháp:**
1. Kiểm tra MySQL plugin đã started chưa
2. Kiểm tra environment variables: `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`
3. Xem logs: `railway logs --service mysql`

### ❌ Error: "database.sql not found"

**Giải pháp:** Chạy SQL schema trước khi sử dụng

```bash
railway database:shell < src/main/webapp/database.sql
```

### ❌ Error: "Port already in use"

**Giải pháp:** Railway sẽ tự động assign PORT từ environment

Chắc chắn web.xml không hard-code port

### ❌ Error: "Out of memory"

**Giải pháp:** Tăng Java memory trong Variables:

```
JAVA_OPTS=-Xmx512m -Xms256m
```

### ❌ Error: "Build failed"

**Giải pháp:**
1. Chắc chắn `pom.xml` chuẩn
2. Xem build logs chi tiết
3. Test locally trước: `mvn clean package -DskipTests`

---

## 📝 PRODUCTION CHECKLIST

Trước khi go live:

- [ ] Database schema đã được import
- [ ] Environment variables đã được set
- [ ] MySQL database đã được kết nối
- [ ] Ứng dụng chạy thành công (access home page)
- [ ] Tính năng CRUD hoạt động
- [ ] Upload file hoạt động
- [ ] Search hoạt động
- [ ] Login/Register hoạt động

---

## 🔐 BẢO MẬT

### Mật khẩu Database:

❌ **KHÔNG** commit password vào code

✅ **SỬ DỤNG** Environment Variables

### HTTPS:

Railway tự động cấp SSL certificate:

- Tất cả requests sẽ redirect từ HTTP → HTTPS

### Firewall:

MySQL trên Railway chỉ cho phép kết nối từ:
- Railway services (internal)
- Không cho phép external connections

---

## 📊 MONITORING

### Xem logs real-time:

```bash
railway logs --follow
```

### Xem resource usage:

- Railway Dashboard → Deployments → Metrics

### Database monitoring:

```bash
railway logs --service mysql
```

---

## 🔄 UPDATE & REDEPLOY

Khi cần update:

```bash
# 1. Commit & push code
git add .
git commit -m "Update feature"
git push origin main

# 2. Railway tự động deploy
# 3. Xem logs để verify
railway logs --follow
```

---

## 📞 HỖ TRỢ

- Railway Docs: https://docs.railway.app
- Railway Community: https://discord.gg/railway
- Dự án GitHub: https://github.com/tranhieutvh890-arch/webmaytinh

---

**Cuối cùng:** 🎉 Chúc mừng bạn đã deploy thành công!

Nếu gặp lỗi, kiểm tra logs chi tiết trong Railway Dashboard.
