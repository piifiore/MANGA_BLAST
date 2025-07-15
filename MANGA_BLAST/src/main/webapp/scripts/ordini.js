document.addEventListener("DOMContentLoaded", () => {
    const ordini = document.querySelectorAll(".ordine-box");

    ordini.forEach(box => {
        box.style.opacity = "0";
        box.style.transform = "translateY(20px)";
        box.style.transition = "opacity 0.6s ease, transform 0.6s ease";
    });

    setTimeout(() => {
        ordini.forEach(box => {
            box.style.opacity = "1";
            box.style.transform = "translateY(0)";
        });
    }, 150);
});
