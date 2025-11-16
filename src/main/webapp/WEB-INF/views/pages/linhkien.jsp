<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>laptop4study.com.vn — Linh kiện</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/static/css/styles.css'/>" />
</head>
<body>
  <!-- phần trên cùng -->
  <div class="promo">Khuyến mại …</div>

  <!-- Header -->
  <header class="header">
    <div class="container header__inner">
      <h2><em><b><span class="rainbow-text">
        <span>L</span><span>a</span><span>p</span><span>t</span><span>o</span><span>p</span><span>4</span><span>S</span><span>t</span><span>u</span><span>d</span><span>y</span>
      </span><small><sub class="domain">.com.vn</sub></small></b></em></h2>

      <form class="search" onsubmit="return handleSearch(event)">
        <input type="text" id="searchInput" name="q" placeholder="Nhập sản phẩm, từ khóa…" required />
        <button type="submit">Tìm kiếm</button>
      </form>

      <nav class="actions">
        <a href="<c:url value='/page/giohang'/>" class="cart">🛒 Giỏ hàng
          <span class="cart-badge" id="cartCount" style="display:none;">0</span>
        </a>

        <!-- 👇 Hiển thị khác nhau nếu đã đăng nhập -->
        <c:choose>
          <c:when test="${not empty sessionScope.username}">
            <span>Xin chào 🫡 ${sessionScope.hoTen}</span>
            <a href="<c:url value='/logout'/>" class="logout">Đăng xuất</a>
          </c:when>
          <c:otherwise>
            <a href="#" class="account login-trigger">👤 Tài khoản</a>
          </c:otherwise>
        </c:choose>
      </nav>
    </div>
  </header>

  <!-- Phần danh mục -->
  <div class="catbar">
    <div class="container catbar__inner">
      <a class="cat" href="<c:url value='/home'/>"><span>🏠</span>Trang chủ</a>
      <a class="cat" href="<c:url value='/page/laptop'/>"><span>🧑‍💻</span>Laptop</a>
      <a class="cat" href="<c:url value='/page/pc'/>"><span>🖥️</span>PC </a>
      <a class="cat" href="<c:url value='/page/manhinh'/>"><span>📺</span>Màn hình</a>
      <a class="cat" href="<c:url value='/page/tablet'/>"><span>📱</span>Tablet</a>
      <a class="cat" href="<c:url value='/page/maycu'/>"><span>🧰</span>Máy cũ,Thu cũ</a>
      <a class="cat" href="<c:url value='/page/phukien'/>"><span>🎧</span>Phụ kiện</a>
      <a class="cat" href="<c:url value='/page/linhkien'/>"><span>🧩</span>Linh kiện</a>
      <a class="cat" href="<c:url value='/page/dichvu'/>"><span>🌐</span>Dịch vụ tiện ích</a>
    </div>
  </div>

  <!-- phần nội dung chính -->
  <main class="container">
    <section class="section">
      <div class="section__head">
        <h2>Linh kiện</h2>
        <a href="<c:url value='/page/linhkien'/>" class="link">Xem tất cả</a>
      </div>

      <div class="grid">
        
<%-- ✅ SẢN PHẨM LẤY TỪ DATABASE --%>
        <c:if test="${not empty products}">
          <c:forEach var="p" items="${products}">
            <%-- chỉ hiển thị những sp thuộc danh mục Laptop nếu bạn muốn --%>
            <c:if test="${p.maDanhMuc == 4}"><%-- 1 = Laptop trong bảng DanhMuc --%>

              <c:url var="detailUrl" value="/page/chitietsanpham">
                <c:param name="id" value="${p.maSanPham}"/>
              </c:url>
              <c:url var="imgUrl" value='${empty p.anhDaiDien ? "/static/images/no-image.png" : p.anhDaiDien}'/>

              <article class="card">
                <a class="card__thumb" href="${detailUrl}">
                  <img src="${imgUrl}" alt="${p.tenSanPham}" />
                </a>

                <a class="card__title" href="${detailUrl}">
                  ${p.tenSanPham}
                </a>

                <div class="card__price">
                  <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/>₫
                  <c:if test="${p.giaCu ne null}">
                    <span class="card__price--old">
                      <fmt:formatNumber value="${p.giaCu}" type="number" groupingUsed="true"/>₫
                    </span>
                  </c:if>
                </div>

                <button
                  class="btn"
                  onclick="addToCart({
                    id: 'sp${p.maSanPham}',
                    name: '${p.tenSanPham}',
                    price: ${p.gia},
                    oldPrice: ${p.giaCu == null ? p.gia : p.giaCu},
                    image: '${imgUrl}'
                  })">
                  Thêm vào giỏ
                </button>
              </article>

            </c:if>
          </c:forEach>
        </c:if>

      </div>
        <!-- thêm sản phẩm linh kiện khác ở đây -->
      </div>
    </section>
  </main>

  !-- Cart notification -->
  <div class="cart-notification" id="cartNotification">
    <div class="cart-notification-content">
      <span class="cart-notification-icon">✓</span>
      <span class="cart-notification-text">Đã thêm vào giỏ hàng</span>
    </div>
  </div>

  <!-- Footer -->
  <footer class="footer">
    <div class="container">
      <div class="col">
        <h4>Về Laptop4Study</h4>
        <ul>
          <li><a href="#">Giới thiệu</a></li>
          <li><a href="#">Tuyển dụng</a></li>
          <li><a href="#">Hệ thống cửa hàng</a></li>
        </ul>
      </div>
      <div class="col">
        <h4>Chính sách</h4>
        <ul>
          <li><a href="#">Giao hàng</a></li>
          <li><a href="#">Đổi trả & Hoàn tiền</a></li>
          <li><a href="#">Bảo hành</a></li>
          <li><a href="#">Bảo mật</a></li>
          <li><a href="#">Điều khoản sử dụng</a></li>
        </ul>
      </div>
      <div class="col">
        <h4>Hỗ trợ</h4>
        <ul>
          <li><a href="#">Hướng dẫn mua hàng</a></li>
          <li><a href="#">Tra cứu đơn hàng</a></li>
          <li><a href="#">FAQ</a></li>
          <li><a href="#">Liên hệ</a></li>
        </ul>
      </div>
      <div class="col">
        <h4>Liên hệ</h4>
        <p>Hotline: <a href="#">1900 1234</a></p>
        <p>Email: <a href="#">tranhieutvh890@gmail.com.vn</a></p>
        <p>Địa chỉ: Trâu Quỳ, Gia Lâm, Hà Nội</p>
      </div>
    </div>
    <div class="bottom">
      <p>© 2025 Được phát triển bởi Trần Hiếu • MST</p>
    </div>
  </footer>

  <!-- Login/Register modal -->
<div class="login-modal-overlay" id="loginModal" aria-hidden="true">
  <div class="login-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <button class="close" id="loginClose" aria-label="Đóng">&times;</button>

    <!-- 🔹 Form đăng nhập -->
    <div id="loginForm">
      <form id="loginRealForm" method="post">
        <h3>Đăng nhập</h3>
        <p class="note">Tài khoản sử dụng mọi dịch vụ của laptop4study</p>

        <div id="loginError" style="color:red; font-size:14px; display:none;"></div>

        <input type="text" name="username" placeholder="Tên đăng nhập" required />
        <input type="password" name="password" placeholder="Mật khẩu" required />
        <button type="submit" class="primary">Đăng nhập</button>
      </form>
      <p class="switch">Bạn chưa có tài khoản 😥 <a href="#" id="showRegister">👉 Đăng ký ngay</a></p>
    </div>

    <!-- 🔹 Form đăng ký -->
    <div id="registerForm" style="display:none;">
      <form id="registerRealForm" method="post">
        <h3>Đăng ký tài khoản</h3>
        <p class="note">Tạo tài khoản mới tại laptop4study</p>

        <div id="registerError" style="color:red; font-size:14px; display:none;"></div>
        <div id="registerSuccess" style="color:green; font-size:14px; display:none;"></div>

        <input type="text" name="username" placeholder="Tên đăng nhập hoặc số điện thoại" required />
        <input type="text" name="fullname" placeholder="Họ và tên" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Mật khẩu" required />
        <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required />
        <button type="submit" class="primary">Đăng ký</button>
      </form>
      <p class="switch">Đã có tài khoản 😘 <a href="#" id="showLogin">👉 Đăng nhập</a></p>
    </div>
  </div>
</div>


  <script>
  const LOGIN_URL    = '<c:url value="/login"/>';
  const REGISTER_URL = '<c:url value="/register"/>';
  const ADMIN_URL    = '<c:url value="/admin/products"/>';</script>
  <script src="${pageContext.request.contextPath}/static/js/home.js"></script>
</body>
</html>