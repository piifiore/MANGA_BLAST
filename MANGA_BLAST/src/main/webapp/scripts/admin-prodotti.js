document.addEventListener("DOMContentLoaded", () => {
    const wrapper = document.querySelector(".admin-prodotti-wrapper");

    if (wrapper) {
        wrapper.style.opacity = "0";
        wrapper.style.transform = "translateY(20px)";
        wrapper.style.transition = "opacity 0.5s ease, transform 0.5s ease";

        setTimeout(() => {
            wrapper.style.opacity = "1";
            wrapper.style.transform = "translateY(0)";
        }, 100);
    }

    const formGroups = document.querySelectorAll(".form-group input, .form-group textarea");
    formGroups.forEach(input => {
        input.addEventListener("focus", () => {
            input.style.boxShadow = "0 0 8px #EF5350";
        });
        input.addEventListener("blur", () => {
            input.style.boxShadow = "none";
        });
    });
});
