// =======================
// 1. GIỎ HÀNG (localStorage)
// =======================
function updateCartCount() {
    var cartStr = localStorage.getItem("cart");
    var cart = cartStr ? JSON.parse(cartStr) : [];
    var totalItems = 0;

    for (var i = 0; i < cart.length; i++) {
        var q = cart[i].quantity || 0;
        totalItems += q;
    }

    var badge = document.getElementById("cartCount");
    if (!badge) return;

    badge.style.display = totalItems > 0 ? "flex" : "none";
    badge.textContent = totalItems;
}

function addToCart(product) {
    var cartStr = localStorage.getItem("cart");
    var cart = cartStr ? JSON.parse(cartStr) : [];
    var found = null;

    for (var i = 0; i < cart.length; i++) {
        if (cart[i].id === product.id) {
            found = cart[i];
            break;
        }
    }

    if (found) {
        found.quantity = (found.quantity || 0) + 1;
    } else {
        var newItem = {
            id: product.id,
            name: product.name,
            price: product.price,
            image: product.image,
            quantity: 1
        };
        cart.push(newItem);
    }

    localStorage.setItem("cart", JSON.stringify(cart));
    updateCartCount();
}

// =======================
// 2. POPUP ĐĂNG NHẬP / ĐĂNG KÝ
// =======================
function initAuthModal() {
    var modal = document.getElementById("loginModal");
    if (!modal) return;

    var loginForm = document.getElementById("loginForm");
    var registerForm = document.getElementById("registerForm");
    var showRegisterBtn = document.getElementById("showRegister");
    var showLoginBtn = document.getElementById("showLogin");
    var closeBtn = document.getElementById("loginClose");
    var triggers = document.querySelectorAll(".login-trigger");

    function openModal() {
        modal.classList.add("active");
        document.body.style.overflow = "hidden";
    }

    function closeModal() {
        modal.classList.remove("active");
        document.body.style.overflow = "";
    }

    if (showRegisterBtn && showLoginBtn && loginForm && registerForm) {
        showRegisterBtn.addEventListener("click", function (e) {
            e.preventDefault();
            loginForm.style.display = "none";
            registerForm.style.display = "block";
        });

        showLoginBtn.addEventListener("click", function (e) {
            e.preventDefault();
            registerForm.style.display = "none";
            loginForm.style.display = "block";
        });
    }

    for (var i = 0; i < triggers.length; i++) {
        triggers[i].addEventListener("click", function (e) {
            e.preventDefault();
            openModal();
        });
    }

    if (closeBtn) {
        closeBtn.addEventListener("click", function () {
            closeModal();
        });
    }

    modal.addEventListener("click", function (e) {
        if (e.target === modal) {
            closeModal();
        }
    });

    // ============= ĐĂNG NHẬP =============
    var loginRealForm = document.getElementById("loginRealForm");
    if (loginRealForm && typeof LOGIN_URL !== "undefined") {
        loginRealForm.addEventListener("submit", function (e) {
            e.preventDefault();

            var errorDiv = document.getElementById("loginError");
            if (errorDiv) {
                errorDiv.style.display = "none";
            }

            var formData = new FormData(loginRealForm);
            var params = new URLSearchParams(formData);

            fetch(LOGIN_URL, {
                method: "POST",
                body: params
            }).then(function (res) {
                if (res.ok) {
                    return res.text();
                } else {
                    throw new Error("Login failed");
                }
            }).then(function (text) {
                if (text.indexOf("admin") !== -1 && typeof ADMIN_URL !== "undefined") {
                    window.location.href = ADMIN_URL;
                } else {
                    window.location.reload();
                }
            }).catch(function () {
                if (errorDiv) {
                    errorDiv.textContent = "❌ Sai tên đăng nhập hoặc mật khẩu!";
                    errorDiv.style.display = "block";
                }
            });
        });
    }

    // ============= ĐĂNG KÝ =============
    var registerRealForm = document.getElementById("registerRealForm");
    if (registerRealForm && typeof REGISTER_URL !== "undefined") {
        registerRealForm.addEventListener("submit", function (e) {
            e.preventDefault();

            var err = document.getElementById("registerError");
            var ok = document.getElementById("registerSuccess");
            if (err) err.style.display = "none";
            if (ok) ok.style.display = "none";

            var formData = new FormData(registerRealForm);
            var params = new URLSearchParams(formData);

            fetch(REGISTER_URL, {
                method: "POST",
                body: params
            }).then(function (res) {
                return res.text().then(function (msg) {
                    return { ok: res.ok, msg: msg };
                });
            }).then(function (result) {
                if (result.ok) {
                    if (ok) {
                        ok.textContent = "🎉 Đăng ký thành công! Bạn có thể đăng nhập ngay.";
                        ok.style.display = "block";
                    }
                    registerRealForm.reset();
                } else {
                    if (err) {
                        err.textContent = result.msg || "❌ Tên đăng nhập đã tồn tại hoặc dữ liệu không hợp lệ.";
                        err.style.display = "block";
                    }
                }
            }).catch(function (e2) {
                if (err) {
                    err.textContent = "❌ Lỗi kết nối: " + e2;
                    err.style.display = "block";
                }
            });
        });
    }
}

// =======================
// 3. BANNER SLIDER TRANG CHỦ
// =======================
// =======================
// 3. BANNER SLIDER TRANG CHỦ
// =======================
function initBannerSlider() {
    var wrapper  = document.querySelector(".banner-wrapper");
    if (!wrapper) {
        console.log("Không tìm thấy .banner-wrapper");
        return;
    }

    var slides   = document.querySelectorAll(".banner-slide");
    var dots     = document.querySelectorAll(".dot");
    var nextBtn  = document.querySelector(".next");
    var prevBtn  = document.querySelector(".prev");
    var totalSlides = slides.length;

    if (totalSlides === 0) {
        console.log("Không có slide nào");
        return;
    }

    var currentSlide = 0;
    var autoTimer = null;

    function updateSlide() {
        // Di chuyển wrapper
        wrapper.style.transform = "translateX(-" + (currentSlide * 100) + "%)";

        // Cập nhật dot active
        for (var i = 0; i < dots.length; i++) {
            if (i === currentSlide) {
                dots[i].classList.add("active");
            } else {
                dots[i].classList.remove("active");
            }
        }
    }

    function startAuto() {
        stopAuto();
        autoTimer = setInterval(function () {
            currentSlide = (currentSlide + 1) % totalSlides;
            updateSlide();
        }, 4000);
    }

    function stopAuto() {
        if (autoTimer) {
            clearInterval(autoTimer);
            autoTimer = null;
        }
    }

    // Nút next
    if (nextBtn) {
        nextBtn.addEventListener("click", function () {
            currentSlide = (currentSlide + 1) % totalSlides;
            updateSlide();
            startAuto();
        });
    }

    // Nút prev
    if (prevBtn) {
        prevBtn.addEventListener("click", function () {
            currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
            updateSlide();
            startAuto();
        });
    }

    // Click vào dot
    for (var j = 0; j < dots.length; j++) {
        (function (index) {
            dots[index].addEventListener("click", function () {
                currentSlide = index;
                updateSlide();
                startAuto();
            });
        })(j);
    }

    // Khởi tạo lần đầu
    updateSlide();
    startAuto();

    console.log("initBannerSlider chạy xong, totalSlides =", totalSlides);
}

// =======================
// 4. KHỞI TẠO SAU KHI DOM SẴN SÀNG
// =======================
document.addEventListener("DOMContentLoaded", function () {
    updateCartCount();
    initAuthModal();
    initBannerSlider();
});
