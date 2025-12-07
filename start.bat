@echo off
REM Railway Startup Script for Windows (for local testing)

echo 🚀 Starting Laptop4Study Application...
echo ==================================

REM Build with Maven
echo 📦 Building application with Maven...
call mvn clean package -DskipTests

if not exist "target" (
    echo ❌ Error: Build failed
    exit /b 1
)

REM Find WAR file
for /r target %%F in (*.war) do (
    set "WAR_FILE=%%F"
    goto found
)

:found
if not defined WAR_FILE (
    echo ❌ Error: WAR file not found
    exit /b 1
)

echo ✅ Found WAR file: %WAR_FILE%

REM Run with Tomcat Maven plugin
echo 🎯 Starting with Tomcat...
call mvn tomcat7:run

pause
