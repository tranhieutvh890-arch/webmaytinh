// ================= Banner Carousel Handler =================

document.addEventListener("DOMContentLoaded", function () {
    var wrapper  = document.querySelector(".banner-wrapper");
    if (!wrapper) return;

    var slides   = document.querySelectorAll(".banner-slide");
    var dots     = document.querySelectorAll(".dot");
    var nextBtn  = document.querySelector(".next");
    var prevBtn  = document.querySelector(".prev");
    var totalSlides = slides.length;

    var currentSlide = 0;
    var autoTimer = null;

    function updateSlide() {
        wrapper.style.transform = "translateX(-" + (currentSlide * 100) + "%)";
        for (var i = 0; i < dots.length; i++) {
            if (i === currentSlide) dots[i].classList.add("active");
            else dots[i].classList.remove("active");
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

    if (nextBtn) {
        nextBtn.addEventListener("click", function () {
            currentSlide = (currentSlide + 1) % totalSlides;
            updateSlide();
            startAuto();
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener("click", function () {
            currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
            updateSlide();
            startAuto();
        });
    }

    for (var j = 0; j < dots.length; j++) {
        (function (index) {
            dots[index].addEventListener("click", function () {
                currentSlide = index;
                updateSlide();
                startAuto();
            });
        })(j);
    }

    updateSlide();
    startAuto();
});
