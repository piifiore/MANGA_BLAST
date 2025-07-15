document.addEventListener("DOMContentLoaded", () => {
    const cards = document.querySelectorAll(".admin-card");

    cards.forEach(card => {
        card.style.opacity = "0";
        card.style.transform = "translateY(20px)";
        card.style.transition = "opacity 0.5s ease, transform 0.5s ease";
    });

    setTimeout(() => {
        cards.forEach(card => {
            card.style.opacity = "1";
            card.style.transform = "translateY(0)";
        });
    }, 150);
});
