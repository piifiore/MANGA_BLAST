window.addEventListener("DOMContentLoaded", () => {
    const passwordField = document.getElementById("password");
    const form = document.getElementById("SignUpForm");

    const feedbackItems = {
        length: document.getElementById("length"),
        lowercase: document.getElementById("lowercase"),
        uppercase: document.getElementById("uppercase"),
        number: document.getElementById("number"),
        special: document.getElementById("special")
    };

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
        form.parentNode.insertBefore(messageDiv, form);

        // Rimuovi il messaggio dopo 5 secondi
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.remove();
            }
        }, 5000);
    }

    const checkPasswordRequirements = () => {
        const password = passwordField.value;

        return {
            length: password.length >= 8,
            lowercase: /[a-z]/.test(password),
            uppercase: /[A-Z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[^A-Za-z0-9]/.test(password)
        };
    };

    passwordField.addEventListener("input", () => {
        const checks = checkPasswordRequirements();
        let allValid = true;

        for (const [key, isValid] of Object.entries(checks)) {
            const item = feedbackItems[key];
            item.classList.toggle("valid", isValid);
            if (!isValid) allValid = false;
        }

        passwordField.classList.toggle("valid", allValid);
        passwordField.classList.toggle("invalid", !allValid);
    });

    form.addEventListener("submit", (e) => {
        const checks = checkPasswordRequirements();
        const allValid = Object.values(checks).every(Boolean);

        if (!allValid) {
            e.preventDefault();
            showErrorMessage("La password non soddisfa tutti i requisiti.");
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
