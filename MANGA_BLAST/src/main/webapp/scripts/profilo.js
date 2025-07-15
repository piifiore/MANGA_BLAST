document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("profiloForm");
    const passwordInput = document.getElementById("nuovaPassword");

    form.addEventListener("submit", (e) => {
        const password = passwordInput.value.trim();
        if (password && password.length < 6) {
            e.preventDefault();
            alert("La nuova password deve contenere almeno 6 caratteri.");
        }
    });
});

// 👁️ Font Awesome toggle
function togglePassword(inputId, iconElement) {
    const input = document.getElementById(inputId);
    const icon = iconElement.querySelector("i");

    if (input.type === "password") {
        input.type = "text";
        icon.classList.replace("fa-eye", "fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.replace("fa-eye-slash", "fa-eye");
    }
}
