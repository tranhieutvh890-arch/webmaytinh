# ✅ RAILWAY DEPLOYMENT CHECKLIST

## 📋 Chuẩn bị Code

- [ ] **Git Repository**
  - [ ] Code đã push lên GitHub
  - [ ] Branch `main` có phiên bản mới nhất
  - [ ] Commit message rõ ràng

- [ ] **Configuration Files**
  - [ ] ✅ `pom.xml` - Maven build config
  - [ ] ✅ `Procfile` - Railway startup command
  - [ ] ✅ `railway.json` - Railway config
  - [ ] ✅ `system.properties` - Java version
  - [ ] ✅ `.env.example` - Environment template
  - [ ] ✅ `DBHelper.java` - Environment variables support

- [ ] **Source Code**
  - [ ] Không có syntax errors
  - [ ] Không có hardcoded passwords/credentials
  - [ ] JSP paths sử dụng `<c:url>`
  - [ ] Database queries sử dụng PreparedStatement

---

## 🔧 Railway Setup

### Step 1: Create Railway Project

- [ ] Tạo Railway account (https://railway.app)
- [ ] Connect GitHub repository
- [ ] Chọn repository `webmaytinh`
- [ ] Railway tạo project & auto-build

### Step 2: Add MySQL Database

- [ ] Click **"+"** trong Railway Dashboard
- [ ] Chọn **Database** → **MySQL**
- [ ] MySQL instance được tạo
- [ ] Copy connection variables:
  - [ ] `MYSQL_HOST`
  - [ ] `MYSQL_PORT`
  - [ ] `MYSQL_DATABASE`
  - [ ] `MYSQL_USER`
  - [ ] `MYSQL_PASSWORD`

### Step 3: Configure Environment Variables

- [ ] Vào **Project Settings** → **Variables**
- [ ] Thêm các biến sau:

```
DB_HOST=mysql.railway.internal
DB_PORT=3306
DB_NAME=railway
DB_USER=root
DB_PASS=<from-mysql-plugin>
PORT=8080
JAVA_OPTS=-Xmx512m -Xms256m
```

- [ ] Click **"Save"**
- [ ] Chờ redeploy hoàn tất

---

## 🗄️ Database Setup

### Step 4: Import Database Schema

**Choose one method:**

#### Method A: Using MySQL Client

```bash
mysql -h mysql.railway.internal \
       -P 3306 \
       -u root \
       -p<password> \
       railway < src/main/webapp/database.sql
```

- [ ] MySQL client installed (`mysql` command)
- [ ] Schema imported successfully
- [ ] No SQL errors

#### Method B: Using Railway CLI

```bash
railway login
railway link
railway database:shell
# Paste content of src/main/webapp/database.sql
```

- [ ] Railway CLI installed
- [ ] Connected to Railway project
- [ ] Schema imported successfully

#### Method C: Using Database GUI (DBeaver/Workbench)

- [ ] Download DBeaver or MySQL Workbench
- [ ] Create connection:
  - Host: `mysql.railway.internal`
  - Port: `3306`
  - User: `root`
  - Password: (from variables)
  - Database: `railway`
- [ ] Import SQL file
- [ ] Verify tables created

### Step 5: Verify Database

- [ ] Connect to MySQL on Railway
- [ ] Run: `SHOW TABLES;`
- [ ] Expected tables:
  - [ ] `SanPham` (Products)
  - [ ] `DanhMuc` (Categories)
  - [ ] `ThuongHieu` (Brands)
  - [ ] `User` (Users)
  - [ ] `DonHang` (Orders) - if applicable

---

## 🚀 Application Verification

### Step 6: Check Build Status

- [ ] Vào **Deployments** tab
- [ ] Status is **"Success"** (🟢)
- [ ] No build errors in logs:
  ```bash
  railway logs --follow
  ```

### Step 7: Test Application

Railway provides domain: `https://<project-name>.up.railway.app/`

**Test each feature:**

- [ ] **Homepage** - Loads without errors
  - [ ] Check console for JS errors
  - [ ] Images load correctly
  
- [ ] **Products Display** - Data from database
  - [ ] List products shows
  - [ ] Product details correct
  - [ ] Prices display
  
- [ ] **Search** - Find products
  - [ ] Search by product name works
  - [ ] Results display correctly
  
- [ ] **Login/Register** - User authentication
  - [ ] Login page loads
  - [ ] Registration works
  - [ ] Can login with test account
  
- [ ] **Admin Panel** - (if admin account exists)
  - [ ] Access `/admin/products`
  - [ ] View product list
  - [ ] Create new product works
  - [ ] Edit product works
  - [ ] Delete product works
  - [ ] Upload image works

---

## 📊 Monitoring

### Step 8: Setup Monitoring

- [ ] **View Logs:**
  ```bash
  railway logs --follow
  ```
  
- [ ] **Check Metrics:**
  - Dashboard → Deployments → Metrics
  - CPU usage normal (< 50%)
  - Memory usage normal (< 70%)
  - Uptime > 99%

- [ ] **No Error Messages:**
  - [ ] No `SQLException` in logs
  - [ ] No `ClassNotFoundException` in logs
  - [ ] No `OutOfMemoryError` in logs

---

## 🔐 Security

- [ ] **No Hardcoded Passwords**
  - [ ] All DB credentials from env vars
  - [ ] No credentials in logs
  
- [ ] **HTTPS Enabled**
  - [ ] Railway auto-provides SSL
  - [ ] HTTP redirects to HTTPS
  
- [ ] **Database Security**
  - [ ] MySQL only accessible from Railway services
  - [ ] Strong password set
  - [ ] No public access to DB

---

## 📝 Documentation

- [ ] **README.md** updated with:
  - [ ] Quick start instructions
  - [ ] Local development setup
  - [ ] Railway deployment link
  
- [ ] **RAILWAY_DEPLOYMENT.md** created with:
  - [ ] Step-by-step setup
  - [ ] Troubleshooting guide
  - [ ] Environment variable reference

---

## 🔄 Continuous Deployment

- [ ] **GitHub Integration**
  - [ ] Railway connected to GitHub
  - [ ] Auto-deploy on push to `main`
  - [ ] Build workflow configured

- [ ] **GitHub Actions**
  - [ ] `.github/workflows/maven.yml` exists
  - [ ] Build triggers on push
  - [ ] Tests run automatically

---

## 🆘 Troubleshooting

### If Build Fails

- [ ] Check build logs:
  ```bash
  railway logs --service app --follow
  ```
- [ ] Verify `pom.xml` syntax
- [ ] Test build locally:
  ```bash
  mvn clean package -DskipTests
  ```

### If Connection Fails

- [ ] Check MySQL plugin status (should be "Running")
- [ ] Verify environment variables match exactly
- [ ] Test connection:
  ```bash
  railway database:shell
  ```

### If Pages Return 404

- [ ] Check JSP paths in code
- [ ] Verify `web.xml` servlet mappings
- [ ] Check logs for any errors

### If Images Don't Load

- [ ] Verify image files in `src/main/webapp/static/images/`
- [ ] Check JSP image paths use `<c:url>`
- [ ] Build includes all static files

---

## 🎉 Final Checklist

Before marking as DONE:

- [ ] All build errors resolved
- [ ] Database schema imported
- [ ] Environment variables configured
- [ ] Application accessible via Railway domain
- [ ] All CRUD operations working
- [ ] No 404 or 500 errors in logs
- [ ] Performance acceptable (response < 2s)
- [ ] Can login/register successfully
- [ ] Admin panel accessible (if applicable)

---

## 📞 Support Resources

If you encounter issues:

1. **Check Logs First:**
   ```bash
   railway logs --follow --service app
   railway logs --follow --service mysql
   ```

2. **Read Documentation:**
   - RAILWAY_DEPLOYMENT.md
   - RAILWAY_STEP_BY_STEP.md
   - README.md

3. **Common Errors:**
   - See RAILWAY_STEP_BY_STEP.md → Troubleshooting section

4. **Get Help:**
   - Railway Docs: https://docs.railway.app
   - Railway Discord: https://discord.gg/railway
   - GitHub Issues: https://github.com/tranhieutvh890-arch/webmaytinh/issues

---

**Status:** ☐ NOT STARTED | ☐ IN PROGRESS | ☐ COMPLETED ✅

Last Updated: 2025-12-07
