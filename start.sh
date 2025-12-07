#!/bin/bash

# Railway Startup Script for Tomcat
# This script runs the Java Tomcat server on Railway

set -e

echo "🚀 Starting Laptop4Study Application..."
echo "=================================="

# Log environment info
echo "Java version:"
java -version
echo ""

# Build with Maven if needed
if [ ! -d "target" ]; then
    echo "📦 Building application with Maven..."
    mvn clean package -DskipTests
fi

# Find the WAR file
WAR_FILE=$(find target -name "*.war" -type f | head -1)

if [ -z "$WAR_FILE" ]; then
    echo "❌ Error: WAR file not found in target directory"
    exit 1
fi

echo "✅ Found WAR file: $WAR_FILE"

# Download and extract Tomcat if not already done
TOMCAT_VERSION="9.0.82"
TOMCAT_DIR="apache-tomcat-${TOMCAT_VERSION}"

if [ ! -d "$TOMCAT_DIR" ]; then
    echo "📥 Downloading Tomcat ${TOMCAT_VERSION}..."
    wget -q "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -O tomcat.tar.gz
    tar -xzf tomcat.tar.gz
    rm tomcat.tar.gz
fi

# Copy WAR to Tomcat webapps
echo "📋 Deploying WAR to Tomcat..."
cp "$WAR_FILE" "$TOMCAT_DIR/webapps/ROOT.war"

# Set CATALINA_HOME
export CATALINA_HOME=$(pwd)/$TOMCAT_DIR

# Get PORT from environment or use default
PORT=${PORT:-8080}

# Start Tomcat
echo "🎯 Starting Tomcat on port $PORT..."
"$TOMCAT_DIR/bin/catalina.sh" run
