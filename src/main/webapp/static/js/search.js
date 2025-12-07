function handleSearch(event) {
  try {
    if (event && event.preventDefault) event.preventDefault();
    var searchInput = document.getElementById('searchInput') || {};
    var raw = searchInput.value || '';
    var searchTerm = raw.trim().toLowerCase();
    if (!searchTerm) return false;

    console.log('Search term:', searchTerm);

    var products = document.querySelectorAll('article.card, .product-item');
    var productMatches = 0;

    for (var k = 0; k < products.length; k++) {
      var product = products[k];
      var titleEl = product.querySelector('a.card__title, .card__title, .product-name');
      var productName = '';
      
      if (titleEl && titleEl.textContent) {
        productName = titleEl.textContent
          .trim()
          .replace(/\s+/g, ' ')
          .toLowerCase();
      }
      
      var catEl = document.querySelector('.product-category');
      var productCategory = '';
      if (catEl && catEl.textContent) {
        productCategory = catEl.textContent
          .trim()
          .replace(/\s+/g, ' ')
          .toLowerCase();
      }

      if (productName.length > 0) {
        console.log('Product:', productName);
      }

      if (productName.indexOf(searchTerm) >= 0 || productCategory.indexOf(searchTerm) >= 0) {
        product.style.display = '';
        productMatches++;
      } else {
        product.style.display = 'none';
      }
    }

    console.log('Found:', productMatches, 'products');

    var catLinks = document.querySelectorAll('.catbar a.cat');
    var matchedCats = [];
    
    for (var i = 0; i < catLinks.length; i++) {
      var a = catLinks[i];
      var text = (a.textContent || '')
        .trim()
        .replace(/\s+/g, ' ')
        .toLowerCase();
      if (text.indexOf(searchTerm) >= 0) {
        matchedCats.push(a);
      }
    }

    var resultsEl = document.getElementById('searchResults') || createSearchResults();
    var catsEl = document.getElementById('categoryMatches') || createCategoryResults();

    if (productMatches > 0) {
      resultsEl.textContent = 'Found ' + productMatches + ' products for "' + raw + '"';
      resultsEl.style.display = 'block';
    } else {
      resultsEl.textContent = 'No products found for "' + raw + '"';
      resultsEl.style.display = 'block';
    }

    catsEl.innerHTML = '';
    if (matchedCats.length > 0) {
      var heading = document.createElement('div');
      heading.textContent = 'Matching categories:';
      heading.style.fontWeight = '600';
      heading.style.marginBottom = '6px';
      catsEl.appendChild(heading);

      for (var j = 0; j < matchedCats.length; j++) {
        var catLink = matchedCats[j];
        var link = document.createElement('a');
        link.href = catLink.href || catLink.getAttribute('href');
        link.textContent = catLink.textContent.trim();
        link.style.display = 'inline-block';
        link.style.margin = '4px 8px 4px 0';
        link.className = 'cat-match-link';
        catsEl.appendChild(link);
      }
      catsEl.style.display = 'block';
    } else {
      catsEl.style.display = 'none';
    }

    if (productMatches === 0 && matchedCats.length === 1) {
      var href = matchedCats[0].getAttribute('href');
      if (href) {
        console.log('Redirecting to:', href);
        window.location.href = href;
        return false;
      }
    }

    return false;
  } catch (err) {
    console.error('Search error:', err);
    var r = document.getElementById('searchResults') || createSearchResults();
    r.textContent = 'Search error: ' + (err && err.message ? err.message : String(err));
    r.style.display = 'block';
    return false;
  }
}

function createSearchResults() {
  var results = document.createElement('div');
  results.id = 'searchResults';
  results.style.cssText = 'margin: 18px 0; padding: 8px 12px; text-align: left; font-weight: 600; background:#fff9; border-radius:4px;';
  var main = document.querySelector('main') || document.body;
  main.insertAdjacentElement('afterbegin', results);
  return results;
}

function createCategoryResults() {
  var el = document.createElement('div');
  el.id = 'categoryMatches';
  el.style.cssText = 'margin-top:8px;';
  var sr = document.getElementById('searchResults') || createSearchResults();
  sr.insertAdjacentElement('afterend', el);
  return el;
}

window.handleSearch = handleSearch;
