// ================= Cart Utilities =================

function updateCartCount() {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var total = 0;
  for (var i = 0; i < cart.length; i++) {
    total += (cart[i].quantity || 0);
  }
  var badge = document.getElementById('cartCount');
  if (!badge) return total;
  if (total > 0) {
    badge.textContent = total;
    badge.style.display = 'flex';
  } else {
    badge.textContent = '0';
    badge.style.display = 'none';
  }
  return total;
}

function showNotification() {
  var n = document.getElementById('cartNotification');
  if (!n) return;
  n.classList.add('show');
  setTimeout(function() {
    n.classList.remove('show');
  }, 2000);
}

function addToCart(product) {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var ex = null;
  for (var i = 0; i < cart.length; i++) {
    if (cart[i].id === product.id) {
      ex = cart[i];
      break;
    }
  }
  if (ex) {
    ex.quantity = (ex.quantity || 1) + (product.quantity || 1);
  } else {
    var newItem = {};
    for (var key in product) {
      if (product.hasOwnProperty(key)) {
        newItem[key] = product[key];
      }
    }
    newItem.quantity = product.quantity || 1;
    cart.push(newItem);
  }
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
  showNotification();
}

function removeFromCart(id) {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  var filtered = [];
  for (var i = 0; i < cart.length; i++) {
    if (cart[i].id !== id) {
      filtered.push(cart[i]);
    }
  }
  localStorage.setItem('cart', JSON.stringify(filtered));
  updateCartCount();
}

function updateCartQuantity(id, qty) {
  var cart = JSON.parse(localStorage.getItem('cart')) || [];
  for (var i = 0; i < cart.length; i++) {
    if (cart[i].id === id) {
      cart[i].quantity = Math.max(1, qty);
      break;
    }
  }
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
}

function getCart() {
  return JSON.parse(localStorage.getItem('cart')) || [];
}

// ================= Product Detail Page =================

function updateQuantity(change) {
  var input = document.getElementById('quantity');
  if (!input) return;
  var newVal = Math.max(1, (parseInt(input.value) || 1) + change);
  input.value = newVal;
}

function addToCartFromDetail() {
  var qtyInput = document.getElementById('quantity');
  var quantity = qtyInput ? parseInt(qtyInput.value) || 1 : 1;
  if (quantity < 1) return;
  
  // Get product info from page
  var h1 = document.querySelector('.product-info h1');
  var productName = h1 ? h1.textContent : 'Sản phẩm';
  
  var priceEl = document.querySelector('.current-price');
  var priceText = priceEl ? priceEl.textContent : '0';
  var price = parseInt(priceText.replace(/[^0-9]/g, '')) || 0;
  
  var mainImg = document.getElementById('mainImage');
  var image = mainImg ? mainImg.src : '/static/images/placeholder.png';
  
  // Get product ID from URL
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

// ================= Initialize =================

document.addEventListener('DOMContentLoaded', function() {
  updateCartCount();
  
  // Add event listener to buy button if exists
  var addBtn = document.querySelector('.buy-btn');
  if (addBtn) {
    addBtn.addEventListener('click', addToCartFromDetail);
  }
});
