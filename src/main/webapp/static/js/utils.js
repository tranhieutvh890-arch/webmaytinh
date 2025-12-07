// Cart utilities
function updateCartCount() {
  const cart = JSON.parse(localStorage.getItem('cart')) || [];
  const total = cart.reduce((s, i) => s + (i.quantity || 0), 0);
  const badge = document.getElementById('cartCount');
  if (!badge) return total;
  if (total > 0) { badge.textContent = total; badge.style.display = 'flex'; }
  else { badge.textContent = '0'; badge.style.display = 'none'; }
  return total;
}

function showNotification() {
  const n = document.getElementById('cartNotification');
  if (!n) return;
  n.classList.add('show');
  setTimeout(() => n.classList.remove('show'), 2000);
}

function addToCart(product) {
  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  const ex = cart.find(i => i.id === product.id);
  if (ex) ex.quantity = (ex.quantity || 1) + (product.quantity || 1);
  else cart.push({...product, quantity: product.quantity || 1});
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
  showNotification();
}

function removeFromCart(id) {
  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  cart = cart.filter(i => i.id !== id);
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
}

function updateCartQuantity(id, qty) {
  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  const item = cart.find(i => i.id === id);
  if (item) item.quantity = Math.max(1, qty);
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
}

function getCart() {
  return JSON.parse(localStorage.getItem('cart')) || [];
}

// Product Detail Page
function updateQuantity(change) {
  const input = document.getElementById('quantity');
  if (!input) return;
  const newVal = Math.max(1, (parseInt(input.value) || 1) + change);
  input.value = newVal;
}

function addToCartFromDetail() {
  var qtyInput = document.getElementById('quantity');
  var quantity = qtyInput ? parseInt(qtyInput.value) || 1 : 1;
  if (quantity < 1) return;
  
  // Lấy thông tin từ page
  var h1 = document.querySelector('.product-info h1');
  var productName = h1 ? h1.textContent : 'Sản phẩm';
  
  var priceEl = document.querySelector('.current-price');
  var priceText = priceEl ? priceEl.textContent : '0';
  var price = parseInt(priceText.replace(/[^0-9]/g, '')) || 0;
  
  var mainImg = document.getElementById('mainImage');
  var image = mainImg ? mainImg.src : '/static/images/placeholder.png';
  
  // URL sản phẩm từ URL hiện tại
  var urlParams = new URLSearchParams(window.location.search);
  var productId = 'sp' + (urlParams.get('id') || Date.now());
  var detailUrl = window.location.href;

  addToCart({
    id: productId,
    name: productName,
    price: price,
    image: image,
    quantity: quantity,
    url: detailUrl
  });
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  updateCartCount();
  
  // Nếu có nút add to cart
  const addBtn = document.querySelector('.buy-btn');
  if (addBtn) {
    addBtn.addEventListener('click', addToCartFromDetail);
  }
});
