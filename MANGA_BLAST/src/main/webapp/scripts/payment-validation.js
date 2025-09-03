document.addEventListener("DOMContentLoaded", () => {
    const paymentForm = document.querySelector('.payment-form');
    if (!paymentForm) return;

    const cardHolder = document.getElementById('cardHolder');
    const cardNumber = document.getElementById('cardNumber');
    const expiry = document.getElementById('expiry');
    const cvv = document.getElementById('cvv');
    const autofillBtn = document.getElementById('autofillBtn');

    // Funzione per mostrare messaggi di errore nel DOM
    function showFieldError(field, message) {
        // Rimuovi messaggi di errore precedenti per questo campo
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }

        // Crea nuovo messaggio di errore
        const errorDiv = document.createElement('div');
        errorDiv.className = 'field-error';
        errorDiv.textContent = message;
        errorDiv.style.cssText = `
            color: #d32f2f;
            font-size: 12px;
            margin-top: 4px;
            font-weight: 500;
        `;

        // Inserisci il messaggio dopo il campo
        field.parentNode.appendChild(errorDiv);
    }

    // Funzione per rimuovere messaggi di errore
    function clearFieldError(field) {
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }
    }

    // Formattazione e validazione intestatario carta
    if (cardHolder) {
        cardHolder.addEventListener('input', function(e) {
            let value = e.target.value;
            // Rimuovi caratteri non validi
            value = value.replace(/[^A-Za-zÀ-ÖØ-öø-ÿ' ]+/g, '');
            // Rimuovi spazi multipli
            value = value.replace(/\s{2,}/g, ' ');
            e.target.value = value;

            if (value.length > 0 && !/^[A-Za-zÀ-ÖØ-öø-ÿ' ]{2,60}$/.test(value)) {
                showFieldError(this, 'Nome intestatario non valido');
            } else {
                clearFieldError(this);
            }
        });

        cardHolder.addEventListener('blur', function() {
            const value = this.value.trim();
            if (value.length < 2) {
                showFieldError(this, 'Nome intestatario troppo corto');
            }
        });
    }

    // Formattazione e validazione numero carta
    if (cardNumber) {
        cardNumber.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '').slice(0, 19);
            // Formatta con spazi ogni 4 cifre
            const parts = [];
            for (let i = 0; i < value.length; i += 4) {
                parts.push(value.substring(i, i + 4));
            }
            e.target.value = parts.join(' ');

            if (value.length > 0 && (value.length < 13 || value.length > 19)) {
                showFieldError(this, 'Numero carta non valido');
            } else {
                clearFieldError(this);
            }
        });

        cardNumber.addEventListener('blur', function() {
            const value = this.value.replace(/\D/g, '');
            if (value.length === 0) {
                showFieldError(this, 'Numero carta richiesto');
            } else if (value.length < 13) {
                showFieldError(this, 'Numero carta troppo corto');
            }
        });
    }

    // Formattazione e validazione scadenza
    if (expiry) {
        expiry.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '').slice(0, 4);
            if (value.length >= 1) {
                let mm = value.substring(0, Math.min(2, value.length));
                if (mm.length === 1 && mm > '1') { 
                    mm = '0' + mm; 
                }
                if (mm.length === 2) {
                    const n = parseInt(mm, 10);
                    if (n === 0) mm = '01';
                    if (n > 12) mm = '12';
                }
                const yy = value.substring(2);
                e.target.value = yy ? (mm + '/' + yy) : mm;
            } else {
                e.target.value = value;
            }

            if (value.length > 0 && !/^(0[1-9]|1[0-2])\/\d{2}$/.test(e.target.value)) {
                showFieldError(this, 'Formato scadenza non valido (MM/YY)');
            } else {
                clearFieldError(this);
            }
        });

        expiry.addEventListener('blur', function() {
            const value = this.value;
            if (value.length === 0) {
                showFieldError(this, 'Data scadenza richiesta');
            } else if (value.length === 5) {
                const [month, year] = value.split('/');
                const currentYear = new Date().getFullYear() % 100;
                const currentMonth = new Date().getMonth() + 1;
                
                if (parseInt(year) < currentYear || 
                    (parseInt(year) === currentYear && parseInt(month) < currentMonth)) {
                    showFieldError(this, 'Carta scaduta');
                }
            }
        });
    }

    // Formattazione e validazione CVV
    if (cvv) {
        cvv.addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/\D/g, '').slice(0, 4);
            
            const value = e.target.value;
            if (value.length > 0 && !/^\d{3,4}$/.test(value)) {
                showFieldError(this, 'CVV non valido');
            } else {
                clearFieldError(this);
            }
        });

        cvv.addEventListener('blur', function() {
            const value = this.value;
            if (value.length === 0) {
                showFieldError(this, 'CVV richiesto');
            } else if (value.length < 3) {
                showFieldError(this, 'CVV troppo corto');
            }
        });
    }

    // Funzionalità autofill
    if (autofillBtn) {
        autofillBtn.addEventListener('click', function() {
            const ds = this.dataset;
            if (cardHolder && ds.holder) cardHolder.value = ds.holder;
            if (expiry && ds.expiry) expiry.value = ds.expiry;
            if (cardNumber && ds.number) {
                const number = (ds.number || '').replace(/\D/g, '').replace(/(.{4})/g, '$1 ').trim();
                cardNumber.value = number;
            }
            if (cvv) { 
                cvv.value = ''; 
                cvv.focus(); 
            }
            
            // Rimuovi eventuali errori dopo l'autofill
            [cardHolder, cardNumber, expiry, cvv].forEach(field => {
                if (field) clearFieldError(field);
            });
        });
    }

    // Validazione submit del form
    paymentForm.addEventListener('submit', function(e) {
        let hasErrors = false;

        // Controlla tutti i campi
        if (cardHolder && cardHolder.value.trim().length < 2) {
            showFieldError(cardHolder, 'Nome intestatario richiesto');
            hasErrors = true;
        }

        if (cardNumber && cardNumber.value.replace(/\D/g, '').length < 13) {
            showFieldError(cardNumber, 'Numero carta richiesto');
            hasErrors = true;
        }

        if (expiry && !/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry.value)) {
            showFieldError(expiry, 'Data scadenza richiesta');
            hasErrors = true;
        }

        if (cvv && !/^\d{3,4}$/.test(cvv.value)) {
            showFieldError(cvv, 'CVV richiesto');
            hasErrors = true;
        }

        if (hasErrors) {
            e.preventDefault();
            // Mostra messaggio generale di errore
            showGeneralError('Correggi gli errori nel form prima di procedere');
        }
    });

    // Funzione per mostrare errore generale
    function showGeneralError(message) {
        // Rimuovi messaggi generali precedenti
        const existingError = document.querySelector('.general-error');
        if (existingError) {
            existingError.remove();
        }

        // Crea nuovo messaggio generale
        const errorDiv = document.createElement('div');
        errorDiv.className = 'general-error';
        errorDiv.textContent = message;
        errorDiv.style.cssText = `
            background-color: #ffebee;
            color: #c62828;
            border: 2px solid #ef5350;
            padding: 12px 16px;
            margin: 16px 0;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
        `;

        // Inserisci il messaggio prima del form
        paymentForm.parentNode.insertBefore(errorDiv, paymentForm);

        // Rimuovi il messaggio dopo 5 secondi
        setTimeout(() => {
            if (errorDiv.parentNode) {
                errorDiv.remove();
            }
        }, 5000);
    }
});
