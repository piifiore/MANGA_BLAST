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
            } else {
                mostraBanner("⚠️ Operazione non riuscita");
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
            } else {
                mostraBanner("⚠️ Errore imprevisto");
            }
        });
}

function mostraBanner(msg) {
    const banner = document.createElement('div');
    banner.textContent = msg;
    banner.className = "floating-banner";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2500);
}
