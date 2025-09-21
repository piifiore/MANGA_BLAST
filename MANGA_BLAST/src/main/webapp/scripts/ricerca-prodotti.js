function caricaProdotti() {
    const query = document.getElementById("searchQuery").value;
    const tipo = document.getElementById("filterTipo").value;
    const prezzoMin = document.getElementById("prezzoMin").value;
    const prezzoMax = document.getElementById("prezzoMax").value;

    const xhr = new XMLHttpRequest();
    let url = "RicercaProdottiServlet?";
    const params = new URLSearchParams();
    
    if (query) params.append("query", query);
    if (tipo) params.append("tipo", tipo);
    if (prezzoMin) params.append("prezzoMin", prezzoMin);
    if (prezzoMax) params.append("prezzoMax", prezzoMax);
    
    url += params.toString();
    
    xhr.open("GET", url, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onload = function() {
        document.getElementById("prodottiContainer").innerHTML = xhr.responseText;
        
        // Aggiungi event listener per i pulsanti
        aggiungiEventListenersProdotti();
    };
    xhr.send();
}

function aggiungiEventListenersProdotti() {
    // I pulsanti carrello e preferiti sono gestiti dalle funzioni globali
    // definite nell'index.jsp, quindi non serve aggiungere event listener qui
}

function aggiungiCarrello(id, tipo, titolo, prezzo) {
    fetch('AggiungiAlCarrelloServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo, titolo, prezzo })
    })
    .then(res => res.text())
    .then(text => {
        if (text.trim() === "aggiunto") {
            mostraBanner("✅ Aggiunto al carrello!");
        }
    });
}

function aggiungiPreferiti(idProdotto, tipo) {
    fetch('AggiungiPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ idProdotto, tipo })
    })
    .then(res => res.text())
    .then(text => {
        if (text.trim() === "aggiunto") {
            mostraBanner("❤️ Aggiunto ai preferiti!");
        } else if (text.trim() === "esiste") {
            mostraBanner("⚠️ Già presente nei preferiti!");
        }
    });
}

// 🔔 Banner visivo (stesso sistema del carrello)
function mostraBanner(msg) {
    const banner = document.createElement("div");
    banner.textContent = msg;
    banner.className = "floating-banner";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2500);
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
["searchQuery", "filterTipo"].forEach(id => {
    const element = document.getElementById(id);
    if (element) {
        element.addEventListener("input", caricaProdotti);
    }
});

// Carica i prodotti all'avvio della pagina
window.addEventListener("load", function() {
    inizializzaValidazionePrezzo();
    caricaProdotti();
});
