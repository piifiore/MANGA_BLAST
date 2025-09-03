document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("profiloForm");
    const passwordInput = document.getElementById("nuovaPassword");
    const viaInput = document.getElementById("via");
    const numeroInput = document.getElementById("numeroCivico");
    const capInput = document.getElementById("cap");
    let isDisabled = false;
    // Rimosso toggle carta: la sezione è sempre visibile

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

    form.addEventListener("submit", (e) => {
        const password = passwordInput.value.trim();
        if (password && password.length < 6) {
            e.preventDefault();
            showErrorMessage("La nuova password deve contenere almeno 6 caratteri.");
        }

        // Validazioni base indirizzo
        if (capInput && capInput.value) {
            const cap = capInput.value.trim();
            if (!/^\d{5}$/.test(cap)) {
                e.preventDefault();
                showErrorMessage("Inserisci un CAP valido a 5 cifre.");
                return;
            }
        }
    });





});

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

// Gestione form carta nella pagina profilo
document.addEventListener("DOMContentLoaded", () => {
    const number = document.getElementById('cardNumber');
    const holder = document.getElementById('cardHolder');
    const expiry = document.getElementById('expiry');

    if (number) {
        number.addEventListener('input', (e) => {
            const v = e.target.value.replace(/\D+/g, '').slice(0, 19);
            const parts = [];
            for (let i = 0; i < v.length; i += 4) parts.push(v.substring(i, i+4));
            e.target.value = parts.join(' ');
        });
    }

    if (holder) {
        holder.addEventListener('input', (e) => {
            let v = e.target.value;
            v = v.replace(/[^A-Za-zÀ-ÖØ-öø-ÿ' ]+/g, '');
            v = v.replace(/\s{2,}/g, ' ');
            e.target.value = v;
        });
    }

    if (expiry) {
        expiry.addEventListener('input', (e) => {
            let v = e.target.value.replace(/\D+/g, '').slice(0, 4);
            if (v.length >= 1) {
                let mm = v.substring(0, Math.min(2, v.length));
                if (mm.length === 1 && mm > '1') { mm = '0' + mm; }
                if (mm.length === 2) {
                    const n = parseInt(mm, 10);
                    if (n === 0) mm = '01';
                    if (n > 12) mm = '12';
                }
                const yy = v.substring(2);
                e.target.value = yy ? (mm + '/' + yy) : mm;
            } else {
                e.target.value = v;
            }
        });
    }
});




