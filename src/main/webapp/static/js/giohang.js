var STATIC_BASE = '';
var CONTEXT_BASE = '/';
var HOME_URL = '/';

(function initConfig() {
  var root = document.getElementById('cartPage');
  if (!root) return;
  STATIC_BASE = root.getAttribute('data-static-base') || '';
  CONTEXT_BASE = root.getAttribute('data-context-base') || '/';
  HOME_URL = root.getAttribute('data-home-url') || '/';
})();

function toAbsoluteUrl(src) {
  if (!src) return '';
  try {
    if (/^(?:[a-z]+:)?\/\//i.test(src) || /^data:|^blob:/i.test(src)) return src;
    if (src.indexOf('/') === 0) return new URL(src, window.location.origin).toString();
    return new URL(src, window.location.origin + CONTEXT_BASE).toString();
  } catch (e) {
    return src;
  }
}

document.addEventListener('DOMContentLoaded', function() {
  renderCart();

  window.addEventListener('storage', function(e) {
    if (e.key === 'cart') renderCart();
  });

  var deleteSelectedBtn = document.querySelector('.delete-selected');
  if (deleteSelectedBtn) deleteSelectedBtn.onclick = removeSelectedItems;

  initLoginModal();
});

function renderCart() {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var shopSection = document.querySelector('.shop-section');
  var cartHeader = document.querySelector('.cart-header');
  var cartFooter = document.querySelector('.cart-footer');

  if (cartHeader) cartHeader.style.display = cart.length > 0 ? 'grid' : 'none';
  if (cartFooter) cartFooter.style.display = cart.length > 0 ? 'flex' : 'none';

  if (cart.length === 0) {
    showEmptyCart();
    return;
  }

  shopSection.innerHTML = '';

  for (var i = 0; i < cart.length; i++) {
    var item = cart[i];
    var imgSrc = item.image ? toAbsoluteUrl(item.image) : (STATIC_BASE + 'images/no-image.svg');
    var oldPriceHtml = item.oldPrice
      ? '<span class="original-price">' + Number(item.oldPrice).toLocaleString('vi-VN') + 'â‚«</span>'
      : '';

    var cartItemHtml =
      '<div class="cart-item" data-id="' + (item.id || '') + '">' +
        '<div class="checkbox">' +
          '<input type="checkbox">' +
        '</div>' +
        '<div class="item-info">' +
          '<img src="' + imgSrc + '" alt="' + (item.name || '') + '"' +
               ' onerror="this.onerror=null;this.src=\'' + STATIC_BASE + 'images/no-image.svg\';">' +
          '<div class="item-details">' +
            '<h3>' + (item.name || '') + '</h3>' +
            '<div class="item-variant"><span>PhÃ¢n Loáº¡i: ' + (item.variant || '-') + '</span></div>' +
          '</div>' +
        '</div>' +
        '<div class="item-price">' +
          oldPriceHtml +
          '<span class="current-price">' + Number(item.price || 0).toLocaleString('vi-VN') + 'â‚«</span>' +
        '</div>' +
        '<div class="quantity-controls">' +
          '<button class="qty-btn" onclick="updateQuantity(\'' + (item.id || '') + '\', -1)">-</button>' +
          '<input type="number" value="' + (item.quantity || 1) + '" min="1" max="99" ' +
                 'onchange="updateQuantity(\'' + (item.id || '') + '\', 0, this.value)">' +
          '<button class="qty-btn" onclick="updateQuantity(\'' + (item.id || '') + '\', 1)">+</button>' +
        '</div>' +
        '<div class="item-total">' + Number((item.price || 0) * (item.quantity || 1)).toLocaleString('vi-VN') + 'â‚«</div>' +
        '<div class="item-actions">' +
          '<button class="remove-btn" onclick="removeItem(\'' + (item.id || '') + '\')">XÃ³a</button>' +
        '</div>' +
      '</div>';

    shopSection.insertAdjacentHTML('beforeend', cartItemHtml);
  }

  updateCartTotal();
}

function showEmptyCart() {
  var shopSection = document.querySelector('.shop-section');
  shopSection.innerHTML = '<div style="text-align:center;padding:40px;color:#999;"><p>Giá» hÃ ng cá»§a báº¡n trá»‘ng</p><a href="' + HOME_URL + '" style="color:#007bff;text-decoration:none;">â† Quay láº¡i mua sáº¯m</a></div>';
  
  var cartHeader = document.querySelector('.cart-header');
  var cartFooter = document.querySelector('.cart-footer');
  if (cartHeader) cartHeader.style.display = 'none';
  if (cartFooter) cartFooter.style.display = 'none';
}

function updateCartTotal() {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var total = 0;
  for (var i = 0; i < cart.length; i++) {
    total += (cart[i].price || 0) * (cart[i].quantity || 1);
  }

  var totalEl = document.querySelector('.total-amount');
  var countEl = document.querySelector('.total-section span');
  if (totalEl) totalEl.textContent = Number(total).toLocaleString('vi-VN') + 'â‚«';
  if (countEl) countEl.textContent = 'Tá»•ng thanh toÃ¡n (' + cart.length + ' sáº£n pháº©m):';

  var checkboxes = document.querySelectorAll('.cart-item .checkbox input[type="checkbox"]');
  var anyChecked = false;
  for (var j = 0; j < checkboxes.length; j++) {
    if (checkboxes[j].checked) {
      anyChecked = true;
      break;
    }
  }

  var footer = document.querySelector('.cart-footer');
  if (footer) footer.style.display = anyChecked || cart.length > 0 ? 'flex' : 'none';
}

function updateQuantity(itemId, delta, newValue) {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var target = null;
  for (var i = 0; i < cart.length; i++) {
    if (cart[i].id === itemId) {
      target = cart[i];
      break;
    }
  }
  
  if (!target) return;

  if (newValue !== undefined) {
    target.quantity = Math.max(1, parseInt(newValue) || 1);
  } else if (delta) {
    target.quantity = Math.max(1, (target.quantity || 1) + delta);
  }

  localStorage.setItem('cart', JSON.stringify(cart));
  renderCart();
}

function removeItem(itemId) {
  if (!confirm('Báº¡n cháº¯c cháº¯n muá»‘n xÃ³a sáº£n pháº©m nÃ y?')) return;
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var filtered = [];
  for (var i = 0; i < cart.length; i++) {
    if (cart[i].id !== itemId) filtered.push(cart[i]);
  }
  localStorage.setItem('cart', JSON.stringify(filtered));
  renderCart();
}

function removeSelectedItems() {
  var checkboxes = document.querySelectorAll('.cart-item .checkbox input[type="checkbox"]');
  var idsToRemove = [];
  for (var i = 0; i < checkboxes.length; i++) {
    if (checkboxes[i].checked) {
      var item = checkboxes[i].closest('.cart-item');
      idsToRemove.push(item.getAttribute('data-id'));
    }
  }

  if (idsToRemove.length === 0) {
    alert('Vui lÃ²ng chá»n sáº£n pháº©m Ä‘á»ƒ xÃ³a');
    return;
  }

  if (!confirm('Báº¡n cháº¯c cháº¯n muá»‘n xÃ³a ' + idsToRemove.length + ' sáº£n pháº©m?')) return;

  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var filtered = [];
  for (var i = 0; i < cart.length; i++) {
    var found = false;
    for (var j = 0; j < idsToRemove.length; j++) {
      if (cart[i].id === idsToRemove[j]) {
        found = true;
        break;
      }
    }
    if (!found) filtered.push(cart[i]);
  }

  localStorage.setItem('cart', JSON.stringify(filtered));
  renderCart();
}

function initLoginModal() {
  var modal = document.getElementById('loginModal');
  if (!modal) return;

  var loginForm = document.getElementById('loginForm');
  var registerForm = document.getElementById('registerForm');
  var showRegisterBtn = document.getElementById('showRegister');
  var showLoginBtn = document.getElementById('showLogin');
  var closeBtn = document.getElementById('loginClose');
  var openers = document.querySelectorAll('.login-trigger');

  function open() {
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function close() {
    modal.classList.remove('active');
    document.body.style.overflow = '';
  }

  if (showRegisterBtn && showLoginBtn && loginForm && registerForm) {
    showRegisterBtn.addEventListener('click', function(e) {
      e.preventDefault();
      loginForm.style.display = 'none';
      registerForm.style.display = 'block';
    });
    showLoginBtn.addEventListener('click', function(e) {
      e.preventDefault();
      registerForm.style.display = 'none';
      loginForm.style.display = 'block';
    });
  }

  for (var i = 0; i < openers.length; i++) {
    openers[i].addEventListener('click', function(e) {
      e.preventDefault();
      open();
    });
  }

  if (closeBtn) closeBtn.addEventListener('click', close);
  modal.addEventListener('click', function(e) {
    if (e.target === modal) close();
  });
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') close();
  });
}

