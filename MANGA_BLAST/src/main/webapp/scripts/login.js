document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("loginForm");

    // Funzione per mostrare messaggi di errore nel DOM
    function showErrorMessage(message, isError = true) {
        // Rimuovi messaggi precedenti
        const existingMessage = document.querySelector('.form-message');
        if (existingMessage) {
            existingMessage.remove();
        }

        // Crea nuovo messaggio
        const messageDiv = document.createElement('div');
        messageDiv.className = `form-message ${isError ? 'error' : 'success'}`;
        messageDiv.textContent = message;

        // Inserisci il messaggio prima del form
        loginForm.parentNode.insertBefore(messageDiv, loginForm);

        // Rimuovi il messaggio dopo 5 secondi
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.remove();
            }
        }, 5000);
    }

    loginForm.addEventListener("submit", (e) => {
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();

        if (!email.match(/^\S+@\S+\.\S+$/)) {
            e.preventDefault();
            showErrorMessage("Inserisci una email valida.");
        } else if (password.length < 5) {
            e.preventDefault();
            showErrorMessage("La password deve contenere almeno 5 caratteri.");
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
