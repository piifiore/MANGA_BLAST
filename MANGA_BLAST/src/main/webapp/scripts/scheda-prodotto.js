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

function mostraBanner(msg) {
    let banner = document.createElement('div');
    banner.textContent = msg;
    banner.style.position = 'fixed';
    banner.style.top = '10px';
    banner.style.right = '10px';
    banner.style.background = msg.includes("⚠️") ? '#FFC107' : msg.includes("✅") ? '#4CAF50' : '#E91E63';
    banner.style.color = '#fff';
    banner.style.padding = '10px 20px';
    banner.style.fontWeight = 'bold';
    banner.style.borderRadius = '5px';
    banner.style.zIndex = '1000';
    banner.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2000);
}