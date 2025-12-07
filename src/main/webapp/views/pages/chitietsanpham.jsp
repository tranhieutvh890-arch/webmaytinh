<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Chi tiết sản phẩm - laptop4study.com.vn</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/static/css/styles.css' />" />

  <link rel="stylesheet" href="<c:url value='/static/css/product-detail.css' />" />
</head>
<body>
  <!-- top bar -->
  <div class="header">
    <div class="promo">
        <div class="container" >
            <marquee behavior="scroll" direction="left" scrollamount="7">
                🎉 Khuyến mãi Back 2 School! Giảm đến 30% Laptop sinh viên - Tặng chuột không dây & Balo cao cấp - Trả góp 0% lãi suất! 🎉
            </marquee>
        </div>
    </div>

  <!-- header -->
  <header class="header">
    <div class="container header__inner">
      <h2>
        <a href="<c:url value='/home'/>" style="text-decoration:none;color:inherit;">
          <em><b><span class="rainbow-text">
            <span>L</span><span>a</span><span>p</span><span>t</span><span>o</span><span>p</span><span>4</span><span>S</span><span>t</span><span>u</span><span>d</span><span>y</span>
          </span><small><sub class="domain">.com.vn</sub></small></b></em>
        </a>
      </h2>

      <form class="search" onsubmit="return handleSearch(event)">
        <input type="text" id="searchInput" name="q" placeholder="Nhập sản phẩm, từ khóa…" required />
        <button type="submit">Tìm kiếm</button>
      </form>

      <nav class="actions">
        <a href="<c:url value='/page/giohang'/>" class="cart">🛒 Giỏ hàng
          <span class="cart-badge" id="cartCount" style="display:none;">0</span>
        </a>
        <a href="#" class="account login-trigger">👤 Tài khoản</a>
      </nav>
    </div>
  </header>

  <!-- catbar -->
  <div class="catbar">
    <div class="container catbar__inner">
      <a class="cat" href="<c:url value='/home'/>"><span>🏠</span>Trang chủ</a>
      <a class="cat" href="<c:url value='/page/laptop'/>"><span>🧑‍💻</span>Laptop</a>
      <a class="cat" href="<c:url value='/page/pc'/>"><span>🖥️</span>PC</a>
      <a class="cat" href="<c:url value='/page/manhinh'/>"><span>📺</span>Màn hình</a>
      <a class="cat" href="<c:url value='/page/tablet'/>"><span>📱</span>Tablet</a>
      <a class="cat" href="<c:url value='/page/maycu'/>"><span>🧰</span>Máy cũ, Thu cũ</a>
      <a class="cat" href="<c:url value='/page/phukien'/>"><span>🎧</span>Phụ kiện</a>
      <a class="cat" href="<c:url value='/page/linhkien'/>"><span>🧩</span>Linh kiện</a>
      <a class="cat" href="<c:url value='/page/dichvu'/>"><span>🌐</span>Dịch vụ tiện ích</a>
    </div>
  </div>

  <!-- cart toast -->
  <div class="cart-notification" id="cartNotification">
    <div class="cart-notification-content">
      <span class="cart-notification-icon">✓</span>
      <span class="cart-notification-text">Đã thêm vào giỏ hàng</span>
    </div>
  </div>

  <!-- main -->
  <main class="container">
    <c:choose>
      <c:when test="${empty product}">
        <p>Không tìm thấy sản phẩm.</p>
      </c:when>

      <c:otherwise>
        <!-- Chuẩn bị URL ảnh đại diện -->
        <c:choose>
          <c:when test="${not empty product.anhDaiDien}">
            <c:url var="productImageUrl" value="/${product.anhDaiDien}" />
          </c:when>
          <c:otherwise>
            <c:url var="productImageUrl" value="/static/images/placeholder.png" />
          </c:otherwise>
        </c:choose>

        <div class="product-detail">
          <div class="product-grid">
            <!-- Hình ảnh -->
            <div class="product-images">
              <img id="mainImage" class="main-image" src="${productImageUrl}" alt="${product.tenSanPham}" />
            </div>

            <!-- Thông tin sản phẩm -->
            <div class="product-info">
              <div class="product-meta">
                Mã sản phẩm: <strong>${product.maSanPham}</strong>
              </div>

              <h1>${product.tenSanPham}</h1>

              <c:if test="${not empty product.moTaNgan}">
                <p>${product.moTaNgan}</p>
              </c:if>

              <div class="price-block">
                <span class="current-price">
                  <c:out value="${product.gia}" />₫
                </span>

                <c:if test="${not empty product.giaCu}">
                  <span class="old-price">
                    <c:out value="${product.giaCu}" />₫
                  </span>
                </c:if>
              </div>

              <div class="product-actions">
                <div class="quantity-selector">
                  <button class="quantity-btn" onclick="updateQuantity(-1)">-</button>
                  <input type="number" id="quantity" class="quantity-input" value="1" min="1">
                  <button class="quantity-btn" onclick="updateQuantity(1)">+</button>
                </div>
                <button onclick="addToCartFromDetail()" class="buy-btn">Thêm vào giỏ</button>
              </div>

              <div class="product-meta">
                <c:if test="${product.soLuongTon gt 0}">
                  <span>Còn hàng: <strong>${product.soLuongTon}</strong></span>
                </c:if>
                <c:if test="${product.soLuongTon le 0}">
                  <span style="color:#dc2626;">Hết hàng</span>
                </c:if>

                <c:if test="${not empty product.baoHanhThang}">
                  • Bảo hành: <strong>${product.baoHanhThang}</strong> tháng
                </c:if>

                <c:if test="${product.sanPhamCu}">
                  • <span style="color:#ea580c;">Sản phẩm cũ / Like New</span>
                </c:if>
              </div>
            </div>
          </div>

          <!-- Mô tả chi tiết -->
          <div class="product-description">
            <h3>Mô tả chi tiết</h3>
            <c:if test="${not empty product.moTaChiTiet}">
              <p><c:out value="${product.moTaChiTiet}" /></p>
            </c:if>
            <c:if test="${empty product.moTaChiTiet}">
              <p>Thông tin chi tiết sản phẩm đang được cập nhật.</p>
            </c:if>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </main>

  <!-- Footer có thể dùng lại giống trang khác -->
  <footer class="footer">
    <div class="container">
      <div class="col">
        <h4>Về N4Computer</h4>
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
        <p>Hotline: <a href="tel:19001234">1900 1234</a></p>
        <p>Email: <a href="mailto:cs@laptop4study.com.vn">cs@laptop4study.com.vn</a></p>
        <p>Địa chỉ: Trâu Quỳ, Gia Lâm, Hà Nội</p>
      </div>
    </div>

    <div class="bottom">
      <p>© 2025 Được phát triển bởi Trần Hiếu • MST 0123456789</p>
    </div>
  </footer>

  <!-- Scripts for cart and product detail functionality -->
  <script>
    // Context path for use in product detail page
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
    const LOGIN_URL    = '<c:url value="/login"/>';
    const REGISTER_URL = '<c:url value="/register"/>';
    const ADMIN_URL    = '<c:url value="/admin/products"/>';
  </script>
  <script src="<c:url value='/static/js/utils.js'/>"></script>
  <script src="<c:url value='/static/js/search.js' />"></script>
  <script src="${pageContext.request.contextPath}/static/js/home.js"></script>
</body>
</html>
