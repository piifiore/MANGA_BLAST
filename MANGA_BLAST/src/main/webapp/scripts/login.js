document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("loginForm");

    loginForm.addEventListener("submit", (e) => {
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();

        if (!email.match(/^\S+@\S+\.\S+$/)) {
            e.preventDefault();
            alert("Inserisci una email valida.");
        } else if (password.length < 5) {
            e.preventDefault();
            alert("La password deve contenere almeno 5 caratteri.");
        }
    });
});

// 👁️ Toggle password con Font Awesome
function togglePassword(inputId, iconElement) {
    const input = document.getElementById(inputId);
    const icon = iconElement.querySelector("i");

    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}
