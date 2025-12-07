<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Chi tiáº¿t sáº£n pháº©m - laptop4study.com.vn</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/static/css/styles.css' />" />

  <link rel="stylesheet" href="<c:url value='/static/css/product-detail.css' />" />
</head>
<body>
  
  <div class="header">
    <div class="promo">
        <div class="container" >
            <marquee behavior="scroll" direction="left" scrollamount="7">
                ðŸŽ‰ Khuyáº¿n mÃ£i Back 2 School! Giáº£m Ä‘áº¿n 30% Laptop sinh viÃªn - Táº·ng chuá»™t khÃ´ng dÃ¢y & Balo cao cáº¥p - Tráº£ gÃ³p 0% lÃ£i suáº¥t! ðŸŽ‰
            </marquee>
        </div>
    </div>

  
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
        <input type="text" id="searchInput" name="q" placeholder="Nháº­p sáº£n pháº©m, tá»« khÃ³aâ€¦" required />
        <button type="submit">TÃ¬m kiáº¿m</button>
      </form>

      <nav class="actions">
        <a href="<c:url value='/page/giohang'/>" class="cart">ðŸ›’ Giá» hÃ ng
          <span class="cart-badge" id="cartCount" style="display:none;">0</span>
        </a>
        <a href="#" class="account login-trigger">ðŸ‘¤ TÃ i khoáº£n</a>
      </nav>
    </div>
  </header>

  
  <div class="catbar">
    <div class="container catbar__inner">
      <a class="cat" href="<c:url value='/home'/>"><span>ðŸ </span>Trang chá»§</a>
      <a class="cat" href="<c:url value='/page/laptop'/>"><span>ðŸ§‘â€ðŸ’»</span>Laptop</a>
      <a class="cat" href="<c:url value='/page/pc'/>"><span>ðŸ–¥ï¸</span>PC</a>
      <a class="cat" href="<c:url value='/page/manhinh'/>"><span>ðŸ“º</span>MÃ n hÃ¬nh</a>
      <a class="cat" href="<c:url value='/page/tablet'/>"><span>ðŸ“±</span>Tablet</a>
      <a class="cat" href="<c:url value='/page/maycu'/>"><span>ðŸ§°</span>MÃ¡y cÅ©, Thu cÅ©</a>
      <a class="cat" href="<c:url value='/page/phukien'/>"><span>ðŸŽ§</span>Phá»¥ kiá»‡n</a>
      <a class="cat" href="<c:url value='/page/linhkien'/>"><span>ðŸ§©</span>Linh kiá»‡n</a>
      <a class="cat" href="<c:url value='/page/dichvu'/>"><span>ðŸŒ</span>Dá»‹ch vá»¥ tiá»‡n Ã­ch</a>
    </div>
  </div>

  
  <div class="cart-notification" id="cartNotification">
    <div class="cart-notification-content">
      <span class="cart-notification-icon">âœ“</span>
      <span class="cart-notification-text">ÄÃ£ thÃªm vÃ o giá» hÃ ng</span>
    </div>
  </div>

  
  <main class="container">
    <c:choose>
      <c:when test="${empty product}">
        <p>KhÃ´ng tÃ¬m tháº¥y sáº£n pháº©m.</p>
      </c:when>

      <c:otherwise>
        
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
            
            <div class="product-images">
              <img id="mainImage" class="main-image" src="${productImageUrl}" alt="${product.tenSanPham}" />
            </div>

            
            <div class="product-info">
              <div class="product-meta">
                MÃ£ sáº£n pháº©m: <strong>${product.maSanPham}</strong>
              </div>

              <h1>${product.tenSanPham}</h1>

              <c:if test="${not empty product.moTaNgan}">
                <p>${product.moTaNgan}</p>
              </c:if>

              <div class="price-block">
                <span class="current-price">
                  <c:out value="${product.gia}" />â‚«
                </span>

                <c:if test="${not empty product.giaCu}">
                  <span class="old-price">
                    <c:out value="${product.giaCu}" />â‚«
                  </span>
                </c:if>
              </div>

              <div class="product-actions">
                <div class="quantity-selector">
                  <button class="quantity-btn" onclick="updateQuantity(-1)">-</button>
                  <input type="number" id="quantity" class="quantity-input" value="1" min="1">
                  <button class="quantity-btn" onclick="updateQuantity(1)">+</button>
                </div>
                <button onclick="addToCartFromDetail()" class="buy-btn">ThÃªm vÃ o giá»</button>
              </div>

              <div class="product-meta">
                <c:if test="${product.soLuongTon gt 0}">
                  <span>CÃ²n hÃ ng: <strong>${product.soLuongTon}</strong></span>
                </c:if>
                <c:if test="${product.soLuongTon le 0}">
                  <span style="color:#dc2626;">Háº¿t hÃ ng</span>
                </c:if>

                <c:if test="${not empty product.baoHanhThang}">
                  â€¢ Báº£o hÃ nh: <strong>${product.baoHanhThang}</strong> thÃ¡ng
                </c:if>

                <c:if test="${product.sanPhamCu}">
                  â€¢ <span style="color:#ea580c;">Sáº£n pháº©m cÅ© / Like New</span>
                </c:if>
              </div>
            </div>
          </div>

          
          <div class="product-description">
            <h3>MÃ´ táº£ chi tiáº¿t</h3>
            <c:if test="${not empty product.moTaChiTiet}">
              <p><c:out value="${product.moTaChiTiet}" /></p>
            </c:if>
            <c:if test="${empty product.moTaChiTiet}">
              <p>ThÃ´ng tin chi tiáº¿t sáº£n pháº©m Ä‘ang Ä‘Æ°á»£c cáº­p nháº­t.</p>
            </c:if>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </main>

  
  <footer class="footer">
    <div class="container">
      <div class="col">
        <h4>Vá» N4Computer</h4>
        <ul>
          <li><a href="#">Giá»›i thiá»‡u</a></li>
          <li><a href="#">Tuyá»ƒn dá»¥ng</a></li>
          <li><a href="#">Há»‡ thá»‘ng cá»­a hÃ ng</a></li>
        </ul>
      </div>

      <div class="col">
        <h4>ChÃ­nh sÃ¡ch</h4>
        <ul>
          <li><a href="#">Giao hÃ ng</a></li>
          <li><a href="#">Äá»•i tráº£ & HoÃ n tiá»n</a></li>
          <li><a href="#">Báº£o hÃ nh</a></li>
          <li><a href="#">Báº£o máº­t</a></li>
          <li><a href="#">Äiá»u khoáº£n sá»­ dá»¥ng</a></li>
        </ul>
      </div>

      <div class="col">
        <h4>Há»— trá»£</h4>
        <ul>
          <li><a href="#">HÆ°á»›ng dáº«n mua hÃ ng</a></li>
          <li><a href="#">Tra cá»©u Ä‘Æ¡n hÃ ng</a></li>
          <li><a href="#">FAQ</a></li>
          <li><a href="#">LiÃªn há»‡</a></li>
        </ul>
      </div>

      <div class="col">
        <h4>LiÃªn há»‡</h4>
        <p>Hotline: <a href="tel:19001234">1900 1234</a></p>
        <p>Email: <a href="mailto:cs@laptop4study.com.vn">cs@laptop4study.com.vn</a></p>
        <p>Äá»‹a chá»‰: TrÃ¢u Quá»³, Gia LÃ¢m, HÃ  Ná»™i</p>
      </div>
    </div>

    <div class="bottom">
      <p>Â© 2025 ÄÆ°á»£c phÃ¡t triá»ƒn bá»Ÿi Tráº§n Hiáº¿u â€¢ MST 0123456789</p>
    </div>
  </footer>

  
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


