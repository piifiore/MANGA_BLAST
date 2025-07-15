function toggleMenu() {
    const navbar = document.querySelector(".navbar");
    if (navbar) {
        navbar.classList.toggle("show");
    }
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
});
