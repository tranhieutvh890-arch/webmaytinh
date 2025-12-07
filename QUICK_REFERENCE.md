# 🚀 RAILWAY DEPLOYMENT - QUICK REFERENCE

## ⚡ 5 Minute Quick Start

### 1. Push Code to GitHub

```bash
cd d:\java\webmaytinh
git add .
git commit -m "Prepare for Railway deployment"
git push origin main
```

### 2. Create Railway Project

1. Go to https://railway.app → Click "Deploy"
2. Select "Deploy from GitHub"
3. Choose `webmaytinh` repository
4. Click "Create"

**Wait 3-5 minutes for build** ⏳

### 3. Add MySQL Database

1. Click **"+"** in Railway Dashboard
2. Select **"Database"** → **"MySQL"**
3. Copy connection info from MySQL plugin

### 4. Set Environment Variables

Add to Railway Project → Variables:

```
DB_HOST=mysql.railway.internal
DB_PORT=3306
DB_NAME=railway
DB_USER=root
DB_PASS=<from-mysql-plugin>
PORT=8080
```

Click "Save" and wait for redeploy ⏳

### 5. Import Database Schema

```bash
# Option 1: Using mysql client
mysql -h mysql.railway.internal -u root -p<password> railway < src/main/webapp/database.sql

# Option 2: Using Railway CLI
railway login
railway link
railway database:shell
# Paste content of database.sql
```

### 6. Test Application

Your app is now live at:
```
https://<your-project>.up.railway.app/
```

✅ Visit and test!

---

## 📋 File Changes Summary

### ✅ Created Files (No changes needed)

```
pom.xml                      # Maven build config
Procfile                     # Railway startup
railway.json                 # Railway config
.railway                     # Railway builder
Dockerfile                   # Docker image
docker-compose.yml          # Docker compose
start.sh / start.bat        # Startup scripts
system.properties           # Java version
.env.example                # Env template
.github/workflows/maven.yml # GitHub Actions
RAILWAY_DEPLOYMENT.md       # Full guide
RAILWAY_STEP_BY_STEP.md    # Detailed steps
DEPLOYMENT_CHECKLIST.md     # Checklist
DEPLOYMENT_SUMMARY.md       # Summary
```

### ✏️ Modified Files

```
src/main/java/dao/DBHelper.java
  - Changed from hardcoded DB credentials
  - Now uses environment variables
  - Falls back to defaults for local development
```

---

## 🔍 Key Changes Explained

### Before (❌ Won't work on Railway)
```java
String URL = "jdbc:mysql://localhost:3306/laptop4study";
String USER = "root";
String PASS = "12052002";
```

### After (✅ Works everywhere)
```java
String DB_HOST = getEnv("DB_HOST", "localhost");
String DB_USER = getEnv("DB_USER", "root");
String DB_PASS = getEnv("DB_PASS", "12052002");
// Now reads from environment variables!
```

---

## ✅ Verification Checklist

- [ ] Code pushed to GitHub
- [ ] Railway project created
- [ ] MySQL plugin added
- [ ] Environment variables set
- [ ] Build successful (no red 🔴)
- [ ] Database schema imported
- [ ] Homepage loads (no 404 errors)
- [ ] Products display correctly
- [ ] Search works
- [ ] No error messages in logs

---

## 🐛 Common Issues & Quick Fixes

| Problem | Solution |
|---------|----------|
| "Connection refused" | Check MySQL status + env vars |
| "Build failed" | Run `mvn clean package` locally |
| "Static files 404" | Files must be in `src/main/webapp/static/` |
| "Table doesn't exist" | Import `database.sql` to Railway |
| "Out of memory" | Increase `JAVA_OPTS=-Xmx1024m` |

---

## 📊 Monitoring

```bash
# View logs (real-time)
railway logs --follow

# View specific service
railway logs --service app --follow
railway logs --service mysql --follow

# Stop following
Ctrl + C
```

---

## 🔄 Update & Redeploy

When you modify code:

```bash
# 1. Commit & push
git add .
git commit -m "Your change"
git push origin main

# 2. Railway auto-deploys
# (monitor via dashboard or: railway logs --follow)

# That's it! ✨
```

---

## 📝 Important Notes

- 🔐 **Never commit passwords!** Use environment variables
- 📁 **Static files location:** `src/main/webapp/static/`
- 🗄️ **Database:** MySQL on Railway
- 🌐 **URL format:** `https://<project-name>.up.railway.app/`
- 🔌 **Default port:** 8080 (handled by Railway)
- ☁️ **Auto HTTPS:** Railway provides SSL cert

---

## 📚 Need More Help?

- **Full Guide:** Read `RAILWAY_STEP_BY_STEP.md`
- **Checklist:** Use `DEPLOYMENT_CHECKLIST.md`
- **Summary:** See `DEPLOYMENT_SUMMARY.md`
- **Project Docs:** Read `README.md`
- **CRUD Functions:** See `BAO_CAO_CHUC_NANG_CRUD.md`

---

## 🎯 Deploy in 3 Commands

```bash
# 1. Commit
git add . && git commit -m "Deploy" && git push origin main

# 2. Railway auto-deploys (wait 3-5 min)

# 3. Import database (first time only)
railway login && railway link && railway database:shell
# Then: source database.sql (or paste SQL)
```

**Done! 🎉**

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Ready for Railway Deployment
