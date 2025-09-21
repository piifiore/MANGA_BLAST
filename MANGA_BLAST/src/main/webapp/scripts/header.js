function toggleMenu() {
    const navbar = document.querySelector(".navbar");
    if (navbar) {
        navbar.classList.toggle("show");
    }
}

// 🏷️ Funzioni per gestire i badge
function updateCartBadge() {
    const cartBadge = document.getElementById("cart-badge");
    if (cartBadge) {
        const carrello = JSON.parse(sessionStorage.getItem("carrello") || "[]");
        const totalItems = carrello.reduce((sum, item) => sum + item.quantita, 0);
        cartBadge.textContent = totalItems;
        cartBadge.classList.toggle("hidden", totalItems === 0);
    }
}

function updateFavoritesBadge() {
    const favoritesBadge = document.getElementById("favorites-badge");
    if (favoritesBadge) {
        const preferiti = JSON.parse(sessionStorage.getItem("preferiti") || "[]");
        favoritesBadge.textContent = preferiti.length;
        favoritesBadge.classList.toggle("hidden", preferiti.length === 0);
    }
}

// 🔄 Aggiorna badge al caricamento della pagina
function updateAllBadges() {
    updateCartBadge();
    updateFavoritesBadge();
}

document.addEventListener("DOMContentLoaded", () => {
    const links = document.querySelectorAll(".navbar a");
    const navbar = document.querySelector(".navbar");

    links.forEach(link => {
        link.addEventListener("click", () => {
            if (navbar && navbar.classList.contains("show")) {
                navbar.classList.remove("show");
            }
        });
    });
    
    // Aggiorna i badge al caricamento
    updateAllBadges();
    
    // Aggiorna i badge quando cambia il carrello o i preferiti
    window.addEventListener("storage", updateAllBadges);
    window.addEventListener("cartUpdated", updateCartBadge);
    window.addEventListener("favoritesUpdated", updateFavoritesBadge);
});
