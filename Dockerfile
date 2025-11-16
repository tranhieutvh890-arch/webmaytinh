# Dùng Tomcat 9 + JDK 17
FROM tomcat:9.0-jdk17-temurin

# Xóa webapp ROOT m?c ??nh
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR c?a b?n và ??i thành ROOT.war ?? ch?y ? "/"
COPY webmaytinh.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat ch?y c?ng 8080 trong container
EXPOSE 8080

# L?nh ch?y Tomcat
CMD ["catalina.sh", "run"]
