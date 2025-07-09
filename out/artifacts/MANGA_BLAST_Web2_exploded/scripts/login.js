document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("loginForm");
    const errorMessage = document.getElementById("errorMessage");

    loginForm.addEventListener("submit", (e) => {
        const email = document.getElementById("username").value.trim();
        const password = document.getElementById("password").value.trim();

        // Validazione base
        if (!email.match(/^\S+@\S+\.\S+$/)) {
            e.preventDefault();
            errorMessage.textContent = "Inserisci una email valida.";
            errorMessage.style.color = "red";
        } else if (password.length < 5) {
            e.preventDefault();
            errorMessage.textContent = "La password deve contenere almeno 5 caratteri.";
            errorMessage.style.color = "red";
        } else {
            errorMessage.textContent = ""; // Reset messaggio
        }
    });

    // Eventi dinamici per feedback immediato
    ["username", "password"].forEach(id => {
        document.getElementById(id).addEventListener("change", () => {
            errorMessage.textContent = ""; // Pulisce l'errore appena l'utente modifica
        });
    });
});
