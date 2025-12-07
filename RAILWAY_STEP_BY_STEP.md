# 🚀 HƯỚNG DẪN DEPLOY RAILWAY - CHI TIẾT TỪNG BƯỚC

## 📌 MỤC LỤC
1. [Chuẩn bị](#chuẩn-bị)
2. [Setup Project](#setup-project)
3. [Cấu hình Database](#cấu-hình-database)
4. [Deploy & Monitor](#deploy--monitor)
5. [Troubleshooting](#troubleshooting)

---

## 🔧 Chuẩn bị

### Bước 1: Commit & Push Code lên GitHub

```bash
# Thêm các file cấu hình mới
git add .
git commit -m "Prepare for Railway deployment"
git push origin main
```

**Kiểm tra:** Tất cả file sau đây đã được push:
- ✅ `pom.xml` (Maven configuration)
- ✅ `Procfile` (Startup command)
- ✅ `railway.json` (Railway config)
- ✅ `DBHelper.java` (Updated with env vars)
- ✅ `src/main/webapp/database.sql` (Schema)

---

## 🌐 Setup Project

### Bước 2: Tạo Railway Project

1. Vào https://railway.app
2. Đăng nhập hoặc tạo tài khoản
3. Click **"New Project"** → **"Deploy from GitHub"**
4. Chọn repository `webmaytinh`
5. Click **"Create"**

Railway sẽ tự động:
- Detect `pom.xml`
- Build dự án với Maven
- Deploy ứng dụng

**Thời gian:** ~3-5 phút cho build đầu tiên

---

## 🗄️ Cấu hình Database

### Bước 3: Thêm MySQL Plugin

1. Trong Railway Dashboard, click **"+"** (Add Service)
2. Chọn **"Database"** → **"MySQL"**
3. Railway sẽ tạo MySQL instance mới
4. Chờ ~2-3 phút MySQL khởi chạy

### Bước 4: Lấy Database Connection Info

1. Vào **MySQL Plugin** → Tab **"Variables"**
2. Ghi lại các biến sau:

```
MYSQL_HOST = mysql.railway.internal (hoặc hostname khác)
MYSQL_PORT = 3306
MYSQL_DATABASE = railway (hoặc tên DB)
MYSQL_USER = root
MYSQL_PASSWORD = xxxxxxxxxxxxx (password dài)
MYSQL_URL = mysql://root:xxxxx@mysql.railway.internal:3306/railway
```

### Bước 5: Thêm Environment Variables vào Project

1. Vào **Project Settings** → **"Variables"**
2. Thêm các variable sau:

```env
# Database (copy từ MySQL plugin)
DB_HOST=mysql.railway.internal
DB_PORT=3306
DB_NAME=railway
DB_USER=root
DB_PASS=<paste-password-từ-mysql-plugin>

# Java Configuration
PORT=8080
JAVA_OPTS=-Xmx512m -Xms256m
```

3. Click **"Save Changes"**

**Kết quả:** Railway sẽ redeploy ứng dụng với variables mới

---

## 📦 Deploy & Monitor

### Bước 6: Chờ Deploy

1. Vào **Deployments** tab
2. Thấy deployment mới đang build:
   - 🟡 `Building` (1-2 phút)
   - 🟡 `Deploying` (30-60 giây)
   - 🟢 `Success` (ứng dụng live!)

**View logs:**
```bash
# Live logs (real-time)
railway logs --follow

# Specific service
railway logs --service app --follow
railway logs --service mysql --follow
```

### Bước 7: Import Database Schema

Sau khi deploy thành công, import schema:

**Option A: Dùng MySQL Client**
```bash
# Kết nối MySQL trên Railway
mysql -h mysql.railway.internal \
       -P 3306 \
       -u root \
       -p<password> \
       railway < src/main/webapp/database.sql
```

**Option B: Dùng Railway CLI**
```bash
railway database:shell
# Rồi paste nội dung từ database.sql
```

**Option C: Dùng DBeaver hoặc MySQL Workbench**
- Host: `mysql.railway.internal`
- Port: `3306`
- User: `root`
- Password: (từ variables)
- Database: `railway`

Rồi import file `database.sql`

### Bước 8: Kiểm Tra Ứng Dụng

1. Vào tab **"Deployments"**
2. Tìm **"Domains"** → Click link

**Ví dụ:** `https://webmaytinh-production.up.railway.app/`

3. Test các tính năng:
   - ✅ Home page load không lỗi
   - ✅ View products
   - ✅ Search products
   - ✅ Login page mở
   - ✅ Admin page (nếu có admin account)

---

## 🐛 Troubleshooting

### Error: "Connection Refused"

```
ERROR: java.sql.SQLException: Connection refused
```

**Nguyên nhân:** Database chưa kết nối hoặc environment variables sai

**Giải pháp:**

1. Kiểm tra MySQL plugin đã started:
```bash
railway logs --service mysql
```

Nên thấy: `ready for connections`

2. Kiểm tra environment variables:
```bash
railway variables
```

Kiểm tra: `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS` có đúng không

3. Test connection:
```bash
railway database:shell
# Nếu kết nối được → OK
```

### Error: "Table doesn't exist"

```
ERROR: Table 'railway.SanPham' doesn't exist
```

**Nguyên nhân:** Schema chưa được import

**Giải pháp:**
```bash
# Import schema
railway database:shell < src/main/webapp/database.sql

# Verify
railway database:shell
> SHOW TABLES;
```

### Error: "Build Failed"

```
BUILD FAILURE
```

**Kiểm tra logs:**
```bash
railway logs --service app
```

**Các lỗi thường gặp:**

1. **Maven compile error**
   - Kiểm tra syntax Java
   - Run local: `mvn clean package`

2. **Missing dependency**
   - Kiểm tra pom.xml
   - Tất cả jar phải có trong `<dependency>`

3. **Java version mismatch**
   - Kiểm tra `system.properties`:
   ```
   java.runtime.version=11
   ```

### Error: "Out of Memory"

```
java.lang.OutOfMemoryError: Java heap space
```

**Giải pháp:**
1. Tăng JAVA_OPTS trong Variables:
```env
JAVA_OPTS=-Xmx1024m -Xms512m
```

2. Hoặc upgrade Railway plan để có nhiều RAM hơn

### Error: "Port is already in use"

**Giải pháp:** Railway tự động assign port từ `PORT` variable. Không cần fix.

### Error: "Static files not found (404)"

```
GET /static/css/styles.css → 404
```

**Kiểm tra:**
1. File có tồn tại: `src/main/webapp/static/css/styles.css`
2. Path trong JSP có đúng:
   ```jsp
   <link rel="stylesheet" href="<c:url value='/static/css/styles.css'/>">
   ```

---

## ✅ Production Checklist

Trước khi go live, kiểm tra:

- [ ] **Build**
  - [ ] `mvn clean package -DskipTests` thành công
  - [ ] `target/ROOT.war` được tạo

- [ ] **Database**
  - [ ] MySQL plugin đang chạy
  - [ ] Schema được import
  - [ ] Có test data (nếu cần)

- [ ] **Environment**
  - [ ] `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS` đã set
  - [ ] `PORT=8080` đã set
  - [ ] Redeploy thành công

- [ ] **Application**
  - [ ] Home page load không lỗi
  - [ ] Database query thành công
  - [ ] CRUD operations hoạt động
  - [ ] Search hoạt động
  - [ ] Login/Register hoạt động (nếu có)
  - [ ] Upload files hoạt động

- [ ] **Monitoring**
  - [ ] Logs không có error
  - [ ] CPU/Memory sử dụng bình thường
  - [ ] Response time acceptable

---

## 📊 Monitoring & Maintenance

### View Real-time Logs

```bash
# Tất cả logs
railway logs --follow

# Specific service
railway logs --service app --follow

# Last N lines
railway logs --tail 50
```

### View Metrics

Railway Dashboard → **Deployments** → **Metrics**:
- 📊 CPU Usage
- 🔋 Memory Usage
- 🌐 Network In/Out
- 📈 Uptime

### Restart Application

```bash
# Restart app service
railway redeploy --service app

# Hoặc từ Dashboard: Click deployment → "Redeploy"
```

### Scale Application

Mặc định: 1 replica

Để tăng performance:
```bash
railway variables
# Thêm: REPLICAS=2

railway redeploy
```

---

## 🔄 Update & Redeploy

Khi cần update code:

```bash
# 1. Commit & push
git add .
git commit -m "Update feature XYZ"
git push origin main

# 2. Railway tự động deploy
# Monitor: railway logs --follow

# 3. Verify: test ứng dụng trên production
```

---

## 🆘 Cần Giúp?

### Resources

- 📚 Railway Docs: https://docs.railway.app
- 🔗 Railway GitHub: https://github.com/railwayapp
- 💬 Railway Community: https://discord.gg/railway

### Kiểm tra Logs Trước Khi Hỏi

```bash
# Save logs để debug
railway logs --follow > app.log 2>&1

# Share logs khi hỏi giúp
```

---

**Chúc mừng! 🎉 Ứng dụng của bạn đã sẵn sàng trên Railway!**
