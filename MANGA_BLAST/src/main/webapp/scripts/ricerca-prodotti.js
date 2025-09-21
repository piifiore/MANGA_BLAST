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
            alert("✅ Aggiunto al carrello!");
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
            alert("❤️ Aggiunto ai preferiti!");
        } else if (text.trim() === "esiste") {
            alert("⚠️ Già presente nei preferiti!");
        }
    });
}

// Event listeners per la ricerca in tempo reale
["searchQuery", "filterTipo", "prezzoMin", "prezzoMax"].forEach(id => {
    const element = document.getElementById(id);
    if (element) {
        element.addEventListener("input", caricaProdotti);
    }
});

// Carica i prodotti all'avvio della pagina
window.addEventListener("load", function() {
    caricaProdotti();
});
