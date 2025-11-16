// Lấy các URL cơ bản từ data-attribute trên #cartPage
let STATIC_BASE = '';
let CONTEXT_BASE = '/';
let HOME_URL = '/';

(function initConfig() {
  const root = document.getElementById('cartPage');
  if (!root) return;
  STATIC_BASE = root.getAttribute('data-static-base') || '';
  CONTEXT_BASE = root.getAttribute('data-context-base') || '/';
  HOME_URL = root.getAttribute('data-home-url') || '/';
})();

// Chuẩn hoá URL ảnh: nhận vào tương đối hay tuyệt đối đều trả về tuyệt đối
function toAbsoluteUrl(src) {
  if (!src) return '';
  try {
    // Nếu đã là absolute (http:, https:, data:, blob:)
    if (/^(?:[a-z]+:)?\/\//i.test(src) || /^data:|^blob:/i.test(src)) return src;
    // Nếu bắt đầu bằng "/" thì ghép origin
    if (src.startsWith('/')) return new URL(src, window.location.origin).toString();
    // Nếu là đường dẫn tương đối -> ghép origin + context
    return new URL(src, window.location.origin + CONTEXT_BASE).toString();
  } catch (e) {
    return src;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  renderCart();

  window.addEventListener('storage', (e) => {
    if (e.key === 'cart') renderCart();
  });

  const deleteSelectedBtn = document.querySelector('.delete-selected');
  if (deleteSelectedBtn) deleteSelectedBtn.onclick = removeSelectedItems;

  // Khởi tạo login modal
  initLoginModal();
});

function renderCart() {
  const cart = JSON.parse(localStorage.getItem('cart')) || [];
  const shopSection = document.querySelector('.shop-section');
  const cartHeader = document.querySelector('.cart-header');
  const cartFooter = document.querySelector('.cart-footer');

  if (cartHeader) cartHeader.style.display = cart.length > 0 ? 'grid' : 'none';
  if (cartFooter) cartFooter.style.display = cart.length > 0 ? 'flex' : 'none';

  if (cart.length === 0) {
    showEmptyCart();
    return;
  }

  shopSection.innerHTML = '';

  cart.forEach(item => {
    // Chuẩn hoá ảnh: nếu rỗng dùng no-image
    let imgSrc = item.image ? toAbsoluteUrl(item.image) : (STATIC_BASE + 'images/no-image.svg');

    const oldPriceHtml = item.oldPrice
      ? '<span class="original-price">' + Number(item.oldPrice).toLocaleString('vi-VN') + '₫</span>'
      : '';

    const cartItemHtml =
      '<div class="cart-item" data-id="' + (item.id || '') + '">' +
        '<div class="checkbox">' +
          '<input type="checkbox">' +
        '</div>' +
        '<div class="item-info">' +
          '<img src="' + imgSrc + '" alt="' + (item.name || '') + '"' +
               ' onerror="this.onerror=null;this.src=\'' + STATIC_BASE + 'images/no-image.svg\';">' +
          '<div class="item-details">' +
            '<h3>' + (item.name || '') + '</h3>' +
            '<div class="item-variant"><span>Phân Loại: ' + (item.variant || '-') + '</span></div>' +
          '</div>' +
        '</div>' +
        '<div class="item-price">' +
          oldPriceHtml +
          '<span class="current-price">' + Number(item.price || 0).toLocaleString('vi-VN') + '₫</span>' +
        '</div>' +
        '<div class="quantity-controls">' +
          '<button class="qty-btn" onclick="updateQuantity(\'' + (item.id || '') + '\', -1)">-</button>' +
          '<input type="number" value="' + (item.quantity || 1) + '" min="1" max="99" ' +
                 'onchange="updateQuantity(\'' + (item.id || '') + '\', 0, this.value)">' +
          '<button class="qty-btn" onclick="updateQuantity(\'' + (item.id || '') + '\', 1)">+</button>' +
        '</div>' +
        '<div class="item-total">' + Number((item.price || 0) * (item.quantity || 1)).toLocaleString('vi-VN') + '₫</div>' +
        '<div class="item-actions">' +
          '<button class="remove-btn" onclick="removeItem(\'' + (item.id || '') + '\')">Xóa</button>' +
        '</div>' +
      '</div>';

    shopSection.insertAdjacentHTML('beforeend', cartItemHtml);
  });

  updateCartTotal();

  const totalItems = cart.reduce((s, it) => s + (it.quantity || 0), 0);
  const totalPrice = cart.reduce((s, it) => s + ((it.price || 0) * (it.quantity || 0)), 0);

  const totalAmountEl = document.querySelector('.total-amount');
  if (totalAmountEl) totalAmountEl.textContent = totalPrice.toLocaleString('vi-VN') + '₫';

  const badge = document.getElementById('cartCount');
  if (badge) {
    badge.textContent = totalItems;
    badge.style.display = totalItems > 0 ? 'flex' : 'none';
  }

  const chooseAllSpan = document.querySelector('.cart-footer-left .checkbox span');
  if (chooseAllSpan) chooseAllSpan.textContent = 'Chọn Tất Cả (' + totalItems + ')';

  const totalSectionSpan = document.querySelector('.total-section span:first-child');
  if (totalSectionSpan) totalSectionSpan.textContent = 'Tổng thanh toán (' + totalItems + ' sản phẩm):';

  document.querySelectorAll('.cart-item input[type="checkbox"]').forEach(cb => {
    cb.addEventListener('change', updateCartTotal);
  });
}

// Cho phép dùng trong HTML onclick
function updateQuantity(productId, change, newValue = null) {
  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  const item = cart.find(i => i.id === productId);
  if (!item) return;

  if (newValue !== null) {
    const v = Math.max(1, Math.min(99, parseInt(newValue || '1', 10)));
    item.quantity = v;
  } else {
    const v = (item.quantity || 1) + change;
    if (v >= 1 && v <= 99) item.quantity = v;
  }

  localStorage.setItem('cart', JSON.stringify(cart));
  renderCart();
}

// Cho phép dùng trong HTML onclick
function removeItem(productId) {
  if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;
  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  cart = cart.filter(i => i.id !== productId);
  localStorage.setItem('cart', JSON.stringify(cart));
  renderCart();
}

function removeSelectedItems() {
  const selected = document.querySelectorAll('.cart-item input[type="checkbox"]:checked');
  if (selected.length === 0) { alert('Vui lòng chọn sản phẩm cần xóa'); return; }
  if (!confirm('Bạn có chắc muốn xóa ' + selected.length + ' sản phẩm đã chọn?')) return;

  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  const ids = Array.from(selected).map(cb => cb.closest('.cart-item').dataset.id);
  cart = cart.filter(i => !ids.includes(i.id));
  localStorage.setItem('cart', JSON.stringify(cart));
  renderCart();
}

function updateCartTotal() {
  const checked = document.querySelectorAll('.cart-item input[type="checkbox"]:checked');
  let total = 0;
  let itemCount = 0;

  checked.forEach(cb => {
    const row = cb.closest('.cart-item');
    const qty = parseInt(row.querySelector('.quantity-controls input').value || '0', 10);
    const totalText = row.querySelector('.item-total').textContent;
    const rowTotal = parseInt(totalText.replace(/\D/g, ''), 10) || 0;
    total += rowTotal;
    itemCount += qty;
  });

  const totalAmountEl = document.querySelector('.total-amount');
  if (totalAmountEl) totalAmountEl.textContent = total.toLocaleString('vi-VN') + '₫';

  const totalSectionSpan = document.querySelector('.total-section span:first-child');
  if (totalSectionSpan) totalSectionSpan.textContent = 'Tổng thanh toán (' + itemCount + ' sản phẩm):';
}

const selectAllEl = document.getElementById('selectAll');
const cartFooterCheckbox = document.querySelector('.cart-footer-left .checkbox input');

function updateAllCheckboxes(checked) {
  document.querySelectorAll('.cart-item input[type="checkbox"]').forEach(cb => cb.checked = checked);
  if (selectAllEl) selectAllEl.checked = checked;
  if (cartFooterCheckbox) cartFooterCheckbox.checked = checked;
  updateCartTotal();
}

if (selectAllEl) selectAllEl.addEventListener('change', function () {
  updateAllCheckboxes(this.checked);
});
if (cartFooterCheckbox) cartFooterCheckbox.addEventListener('change', function () {
  updateAllCheckboxes(this.checked);
});

function showEmptyCart() {
  const cartItems = document.querySelector('.cart-items');
  const header = document.querySelector('.cart-header');
  const footer = document.querySelector('.cart-footer');
  const badge = document.getElementById('cartCount');

  if (header) header.style.display = 'none';
  if (footer) footer.style.display = 'none';

  if (badge) { badge.textContent = '0'; badge.style.display = 'none'; }

  if (cartItems) {
    cartItems.innerHTML =
      '<div class="empty-cart">' +
        '<div class="empty-cart-message">' +
          '<img src="' + STATIC_BASE + 'images/giohangtrong.png" alt="Giỏ hàng trống" style="width:200px;margin-bottom:20px;">' +
          '<p>Tiếc quá 😞 chưa có sản phẩm nào trong giỏ hàng</p>' +
          '<a href="' + HOME_URL + '" class="primary">Tiếp tục mua sắm</a>' +
        '</div>' +
      '</div>';
  }
}

/* ========== LOGIN MODAL ========== */
function initLoginModal() {
  const openers = document.querySelectorAll('.login-trigger');
  const modal = document.getElementById('loginModal');
  const closeBtn = document.getElementById('loginClose');
  const loginForm = document.getElementById('loginForm');
  const registerForm = document.getElementById('registerForm');
  const showRegisterBtn = document.getElementById('showRegister');
  const showLoginBtn = document.getElementById('showLogin');

  if (!modal || !loginForm || !registerForm) return;

  function open() {
    modal.classList.add('active');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
    loginForm.style.display = 'block';
    registerForm.style.display = 'none';
  }
  function close() {
    modal.classList.remove('active');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
  }

  if (showRegisterBtn) showRegisterBtn.addEventListener('click', e => {
    e.preventDefault();
    loginForm.style.display = 'none';
    registerForm.style.display = 'block';
  });
  if (showLoginBtn) showLoginBtn.addEventListener('click', e => {
    e.preventDefault();
    registerForm.style.display = 'none';
    loginForm.style.display = 'block';
  });

  openers.forEach(o => o.addEventListener('click', e => {
    e.preventDefault();
    open();
  }));
  if (closeBtn) closeBtn.addEventListener('click', close);
  modal.addEventListener('click', e => {
    if (e.target === modal) close();
  });
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') close();
  });
}
