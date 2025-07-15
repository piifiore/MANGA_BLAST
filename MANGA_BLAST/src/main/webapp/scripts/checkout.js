document.addEventListener("DOMContentLoaded", () => {
    const wrapper = document.querySelector(".checkout-wrapper");
    wrapper.style.opacity = "0";
    wrapper.style.transform = "translateY(20px)";
    wrapper.style.transition = "opacity 0.5s ease, transform 0.5s ease";

    setTimeout(() => {
        wrapper.style.opacity = "1";
        wrapper.style.transform = "translateY(0)";
    }, 150);
});
