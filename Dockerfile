# Multi-stage Dockerfile for Railway deployment

# Stage 1: Build
FROM maven:3.8-openjdk-11 as builder

WORKDIR /app

# Copy pom.xml và download dependencies
COPY pom.xml .
RUN mvn dependency:resolve

# Copy source code
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM tomcat:9-jre11

WORKDIR /usr/local/tomcat

# Remove default ROOT application
RUN rm -rf webapps/ROOT

# Copy built WAR to Tomcat
COPY --from=builder /app/target/ROOT.war webapps/

# Set environment
ENV PORT 8080
ENV JAVA_OPTS "-Xmx512m -Xms256m"

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
