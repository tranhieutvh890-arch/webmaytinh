// Shared search logic used by all pages
function handleSearch(event) {
  try {
    if (event && event.preventDefault) event.preventDefault();
    const raw = (document.getElementById('searchInput') || {}).value || '';
    const searchTerm = raw.trim().toLowerCase();
    if (!searchTerm) return false;

    console.log('🔍 Tìm kiếm:', searchTerm); // Debug

    const products = document.querySelectorAll('article.card, .product-item');
    let productMatches = 0;

    products.forEach(product => {
      // Lấy tên sản phẩm từ link tiêu đề
      const titleEl = product.querySelector('a.card__title, .card__title, .product-name');
      let productName = '';
      
      if (titleEl && titleEl.textContent) {
        // Normalize: trim, lowercase, xóa dấu cách thừa
        productName = titleEl.textContent
          .trim()
          .replace(/\s+/g, ' ')  // Xóa khoảng trắng thừa
          .toLowerCase();
      }
      
      // Lấy danh mục (nếu có)
      const catEl = product.querySelector('.product-category');
      let productCategory = '';
      if (catEl && catEl.textContent) {
        productCategory = catEl.textContent
          .trim()
          .replace(/\s+/g, ' ')
          .toLowerCase();
      }

      // Debug: hiển thị tên sản phẩm được tìm thấy
      if (productName.length > 0) {
        console.log('  📦', productName);
      }

      // So sánh (không phân biệt chữ hoa/thường)
      if (productName.includes(searchTerm) || productCategory.includes(searchTerm)) {
        product.style.display = '';
        productMatches++;
      } else {
        product.style.display = 'none';
      }
    });

    console.log('✅ Tìm thấy:', productMatches, 'sản phẩm'); // Debug

    const catLinks = Array.from(document.querySelectorAll('.catbar a.cat'));
    const matchedCats = catLinks.filter(a => 
      (a.textContent || '')
        .trim()
        .replace(/\s+/g, ' ')
        .toLowerCase()
        .includes(searchTerm)
    );

    const resultsEl = document.getElementById('searchResults') || createSearchResults();
    const catsEl = document.getElementById('categoryMatches') || createCategoryResults();

    if (productMatches > 0) {
      resultsEl.textContent = `Tìm thấy ${productMatches} sản phẩm cho "${raw}"`;
      resultsEl.style.display = 'block';
    } else {
      resultsEl.textContent = `Không tìm thấy sản phẩm cho "${raw}"`;
      resultsEl.style.display = 'block';
    }

    catsEl.innerHTML = '';
    if (matchedCats.length > 0) {
      const heading = document.createElement('div');
      heading.textContent = 'Danh mục khớp:';
      heading.style.fontWeight = '600';
      heading.style.marginBottom = '6px';
      catsEl.appendChild(heading);

      matchedCats.forEach(a => {
        const link = document.createElement('a');
        link.href = a.href || a.getAttribute('href');
        link.textContent = a.textContent.trim();
        link.style.display = 'inline-block';
        link.style.margin = '4px 8px 4px 0';
        link.className = 'cat-match-link';
        catsEl.appendChild(link);
      });
      catsEl.style.display = 'block';
    } else {
      catsEl.style.display = 'none';
    }

    // Nếu không tìm thấy sản phẩm nhưng có 1 danh mục khớp, chuyển hướng
    if (productMatches === 0 && matchedCats.length === 1) {
      const href = matchedCats[0].getAttribute('href');
      if (href) {
        console.log('🔄 Chuyển hướng đến:', href);
        window.location.href = href;
        return false;
      }
    }

    return false;
  } catch (err) {
    console.error('❌ Lỗi tìm kiếm:', err);
    const r = document.getElementById('searchResults') || createSearchResults();
    r.textContent = 'Lỗi tìm kiếm: ' + (err && err.message ? err.message : String(err));
    r.style.display = 'block';
    return false;
  }
}

function createSearchResults() {
  const results = document.createElement('div');
  results.id = 'searchResults';
  results.style.cssText = 'margin: 18px 0; padding: 8px 12px; text-align: left; font-weight: 600; background:#fff9; border-radius:4px;';
  const main = document.querySelector('main') || document.body;
  main.insertAdjacentElement('afterbegin', results);
  return results;
}

function createCategoryResults() {
  const el = document.createElement('div');
  el.id = 'categoryMatches';
  el.style.cssText = 'margin-top:8px;';
  const sr = document.getElementById('searchResults') || createSearchResults();
  sr.insertAdjacentElement('afterend', el);
  return el;
}

// Optionally expose for debugging
window.handleSearch = handleSearch;
