<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>laptop4study.com.vn â€” MÃ¡y cÅ©, Thu cÅ©</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/static/css/styles.css'/>" />
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
      <h2><em><b><span class="rainbow-text">
        <span>L</span><span>a</span><span>p</span><span>t</span><span>o</span><span>p</span><span>4</span><span>S</span><span>t</span><span>u</span><span>d</span><span>y</span>
      </span><small><sub class="domain">.com.vn</sub></small></b></em></h2>

      <form class="search" onsubmit="return handleSearch(event)">
        <input type="text" id="searchInput" name="q" placeholder="Nháº­p sáº£n pháº©m, tá»« khÃ³aâ€¦" required />
        <button type="submit">TÃ¬m kiáº¿m</button>
      </form>

      <nav class="actions">
        <a href="<c:url value='/page/giohang'/>" class="cart">ðŸ›’ Giá» hÃ ng
          <span class="cart-badge" id="cartCount" style="display:none;">0</span>
        </a>

        
        <c:choose>
          <c:when test="${not empty sessionScope.username}">
            <span>Xin chÃ o ðŸ«¡ ${sessionScope.hoTen}</span>
            <a href="<c:url value='/logout'/>" class="logout">ÄÄƒng xuáº¥t</a>
          </c:when>
          <c:otherwise>
            <a href="#" class="account login-trigger">ðŸ‘¤ TÃ i khoáº£n</a>
          </c:otherwise>
        </c:choose>
      </nav>
    </div>
  </header>

  
  <div class="catbar">
    <div class="container catbar__inner">
      <a class="cat" href="<c:url value='/home'/>"><span>ðŸ </span>Trang chá»§</a>
      <a class="cat" href="<c:url value='/page/laptop'/>"><span>ðŸ§‘â€ðŸ’»</span>Laptop</a>
      <a class="cat" href="<c:url value='/page/pc'/>"><span>ðŸ–¥ï¸</span>PC </a>
      <a class="cat" href="<c:url value='/page/manhinh'/>"><span>ðŸ“º</span>MÃ n hÃ¬nh</a>
      <a class="cat" href="<c:url value='/page/tablet'/>"><span>ðŸ“±</span>Tablet</a>
      <a class="cat" href="<c:url value='/page/maycu'/>"><span>ðŸ§°</span>MÃ¡y cÅ©,Thu cÅ©</a>
      <a class="cat" href="<c:url value='/page/phukien'/>"><span>ðŸŽ§</span>Phá»¥ kiá»‡n</a>
      <a class="cat" href="<c:url value='/page/linhkien'/>"><span>ðŸ§©</span>Linh kiá»‡n</a>
      <a class="cat" href="<c:url value='/page/dichvu'/>"><span>ðŸŒ</span>Dá»‹ch vá»¥ tiá»‡n Ã­ch</a>
    </div>
  </div>

  
  <main class="container">
    <section class="section">
      <div class="section__head">
        <h2>MÃ¡y cÅ©, Thu cÅ©</h2>
        <a href="<c:url value='/page/maycu'/>" class="link">Xem táº¥t cáº£</a>
      </div>

      <div class="grid">
        

        <c:if test="${not empty products}">
          <c:forEach var="p" items="${products}">
            
            <c:if test="${p.maDanhMuc == 6}">

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
                  <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/>â‚«
                  <c:if test="${p.giaCu ne null}">
                    <span class="card__price--old">
                      <fmt:formatNumber value="${p.giaCu}" type="number" groupingUsed="true"/>â‚«
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
                  ThÃªm vÃ o giá»
                </button>
              </article>

            </c:if>
          </c:forEach>
        </c:if>

      </div>
        
      </div>
    </section>
  </main>

  
  <div class="cart-notification" id="cartNotification">
    <div class="cart-notification-content">
      <span class="cart-notification-icon">âœ“</span>
      <span class="cart-notification-text">ÄÃ£ thÃªm vÃ o giá» hÃ ng</span>
    </div>
  </div>

  
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
        <p>Hotline: <a href="#">1900 1234</a></p>
        <p>Email: <a href="#">tranhieutvh890@gmail.com.vn</a></p>
        <p>Äá»‹a chá»‰: TrÃ¢u Quá»³, Gia LÃ¢m, HÃ  Ná»™i</p>
      </div>
    </div>
    <div class="bottom">
      <p>Â© 2025 ÄÆ°á»£c phÃ¡t triá»ƒn bá»Ÿi Tráº§n Hiáº¿u â€¢ MST</p>
    </div>
  </footer>

  
<div class="login-modal-overlay" id="loginModal" aria-hidden="true">
  <div class="login-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <button class="close" id="loginClose" aria-label="ÄÃ³ng">&times;</button>

    
    <div id="loginForm">
      <form id="loginRealForm" method="post">
        <h3>ÄÄƒng nháº­p</h3>
        <p class="note">TÃ i khoáº£n sá»­ dá»¥ng má»i dá»‹ch vá»¥ cá»§a laptop4study</p>

        <div id="loginError" style="color:red; font-size:14px; display:none;"></div>

        <input type="text" name="username" placeholder="TÃªn Ä‘Äƒng nháº­p" required />
        <input type="password" name="password" placeholder="Máº­t kháº©u" required />
        <button type="submit" class="primary">ÄÄƒng nháº­p</button>
      </form>
      <p class="switch">Báº¡n chÆ°a cÃ³ tÃ i khoáº£n ðŸ˜¥ <a href="#" id="showRegister">ðŸ‘‰ ÄÄƒng kÃ½ ngay</a></p>
    </div>

    
    <div id="registerForm" style="display:none;">
      <form id="registerRealForm" method="post">
        <h3>ÄÄƒng kÃ½ tÃ i khoáº£n</h3>
        <p class="note">Táº¡o tÃ i khoáº£n má»›i táº¡i laptop4study</p>

        <div id="registerError" style="color:red; font-size:14px; display:none;"></div>
        <div id="registerSuccess" style="color:green; font-size:14px; display:none;"></div>

        <input type="text" name="username" placeholder="TÃªn Ä‘Äƒng nháº­p hoáº·c sá»‘ Ä‘iá»‡n thoáº¡i" required />
        <input type="text" name="fullname" placeholder="Há» vÃ  tÃªn" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Máº­t kháº©u" required />
        <input type="password" name="confirmPassword" placeholder="Nháº­p láº¡i máº­t kháº©u" required />
        <button type="submit" class="primary">ÄÄƒng kÃ½</button>
      </form>
      <p class="switch">ÄÃ£ cÃ³ tÃ i khoáº£n ðŸ˜˜ <a href="#" id="showLogin">ðŸ‘‰ ÄÄƒng nháº­p</a></p>
    </div>
  </div>
</div>


  <script>
  const LOGIN_URL    = '<c:url value="/login"/>';
  const REGISTER_URL = '<c:url value="/register"/>';
  const ADMIN_URL    = '<c:url value="/admin/products"/>';</script>
  <script src="<c:url value='/static/js/search.js'/>"></script>
  <script src="${pageContext.request.contextPath}/static/js/home.js"></script>
</body>
</html>


