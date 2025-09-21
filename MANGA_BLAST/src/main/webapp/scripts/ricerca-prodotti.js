function caricaProdotti() {
    const query = document.getElementById("searchQuery").value;
    const tipo = document.getElementById("filterTipo").value;
    const prezzoMin = document.getElementById("prezzoMin").value;
    const prezzoMax = document.getElementById("prezzoMax").value;
    const sortBy = document.getElementById("sortBy").value;

    const container = document.getElementById("prodottiContainer");
    
    // Mostra skeleton loading
    if (typeof loadingManager !== 'undefined') {
        loadingManager.showSkeletonLoading(container, 3);
    }

    const xhr = new XMLHttpRequest();
    let url = "RicercaProdottiServlet?";
    const params = new URLSearchParams();
    
    if (query) params.append("query", query);
    if (tipo) params.append("tipo", tipo);
    if (prezzoMin) params.append("prezzoMin", prezzoMin);
    if (prezzoMax) params.append("prezzoMax", prezzoMax);
    if (sortBy && sortBy !== "default") params.append("sortBy", sortBy);
    
    url += params.toString();
    
    xhr.open("GET", url, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onload = function() {
        // Nasconde skeleton loading
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideSkeletonLoading();
        }
        
        // Aggiorna contenuto con animazione
        container.innerHTML = xhr.responseText;
        container.classList.add('fade-in');
        
        // Aggiungi event listener per i pulsanti
        aggiungiEventListenersProdotti();
        
        // Rimuovi classe fade-in dopo l'animazione
        setTimeout(() => container.classList.remove('fade-in'), 500);
    };
    xhr.onerror = function() {
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideSkeletonLoading();
        }
        container.innerHTML = '<p style="text-align:center; color: #EF5350; margin: 2rem;">Errore nel caricamento dei prodotti. Riprova.</p>';
    };
    xhr.send();
}

function aggiungiEventListenersProdotti() {
    // I pulsanti carrello e preferiti sono gestiti dalle funzioni globali
    // definite nell'index.jsp, quindi non serve aggiungere event listener qui
}

function aggiungiCarrello(id, tipo, titolo, prezzo) {
    const button = event.target;
    
    // Mostra loading sul bottone
    if (typeof loadingManager !== 'undefined') {
        loadingManager.showButtonLoading(button, "Aggiungendo...");
    }
    
    fetch('AggiungiAlCarrelloServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo, titolo, prezzo })
    })
    .then(res => res.text())
    .then(text => {
        if (text.trim() === "aggiunto") {
            mostraBanner("Aggiunto al carrello!");
            // Aggiorna badge carrello
            if (typeof updateCartBadge === 'function') {
                updateCartBadge();
            }
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        mostraBanner("Errore nell'aggiunta al carrello!");
    })
    .finally(() => {
        // Nasconde loading dal bottone
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideButtonLoading(button);
        }
    });
}

function aggiungiPreferiti(idProdotto, tipo) {
    const button = event.target;
    
    // Mostra loading sul bottone
    if (typeof loadingManager !== 'undefined') {
        loadingManager.showButtonLoading(button, "Aggiungendo...");
    }
    
    fetch('AggiungiPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ idProdotto, tipo })
    })
    .then(res => res.text())
    .then(text => {
        if (text.trim() === "aggiunto") {
            mostraBanner("Aggiunto ai preferiti!");
            // Aggiorna badge preferiti
            if (typeof updateFavoritesBadge === 'function') {
                updateFavoritesBadge();
            }
        } else if (text.trim() === "esiste") {
            mostraBanner("Già presente nei preferiti!");
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        mostraBanner("Errore nell'aggiunta ai preferiti!");
    })
    .finally(() => {
        // Nasconde loading dal bottone
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideButtonLoading(button);
        }
    });
}

// 🔔 Sistema notifiche migliorato
function mostraBanner(msg) {
    // Usa il nuovo sistema toast se disponibile, altrimenti fallback al vecchio sistema
    if (typeof showToast !== 'undefined') {
        // Determina il tipo di toast basato sul messaggio
        let type = 'info';
        if (msg.includes('Aggiunto')) type = 'success';
        else if (msg.includes('Errore')) type = 'error';
        else if (msg.includes('Già presente')) type = 'warning';
        
        showToast(msg, type, { duration: 3000 });
    } else {
        // Fallback al vecchio sistema
        const banner = document.createElement("div");
        banner.textContent = msg;
        banner.className = "floating-banner";
        document.body.appendChild(banner);
        setTimeout(() => banner.remove(), 2500);
    }
}

// Funzioni per gestire la validazione del range di prezzo
function inizializzaValidazionePrezzo() {
    const prezzoMinInput = document.getElementById("prezzoMin");
    const prezzoMaxInput = document.getElementById("prezzoMax");
    
    if (!prezzoMinInput || !prezzoMaxInput) return;
    
    // Validazione per il prezzo minimo
    prezzoMinInput.addEventListener("input", function() {
        const value = parseFloat(this.value) || 0;
        const maxValue = parseFloat(prezzoMaxInput.value) || 200;
        
        // Se il minimo supera il massimo, scambia i valori
        if (value > maxValue) {
            prezzoMaxInput.value = value.toFixed(2);
        }
        
        caricaProdotti();
    });
    
    // Validazione per il prezzo massimo
    prezzoMaxInput.addEventListener("input", function() {
        const value = parseFloat(this.value) || 200;
        const minValue = parseFloat(prezzoMinInput.value) || 0;
        
        // Se il massimo è inferiore al minimo, scambia i valori
        if (value < minValue) {
            prezzoMinInput.value = value.toFixed(2);
        }
        
        caricaProdotti();
    });
}

// Event listeners per la ricerca in tempo reale
["searchQuery", "filterTipo", "prezzoMin", "prezzoMax", "sortBy"].forEach(id => {
    const element = document.getElementById(id);
    if (element) {
        element.addEventListener("input", caricaProdotti);
        element.addEventListener("change", caricaProdotti);
    }
});

// Carica i prodotti all'avvio della pagina
window.addEventListener("load", function() {
    inizializzaValidazionePrezzo();
    caricaProdotti();
});
