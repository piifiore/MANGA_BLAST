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
                evidenziaCard(id);
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
                evidenziaCard(idProdotto);
            } else if (text.trim() === "esiste") {
                mostraBanner("⚠️ Già presente nei preferiti!");
            }
        });
}

// 🔔 Banner visivo
function mostraBanner(msg) {
    const banner = document.createElement('div');
    banner.textContent = msg;
    banner.className = "floating-banner";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2500);
}

// ✨ Glow sulla card
function evidenziaCard(id) {
    const card = document.querySelector(`.product-card[data-id='${id}']`);
    if (card) {
        card.classList.add('highlighted');
        setTimeout(() => card.classList.remove('highlighted'), 1500);
    }
}

// 💡 Scroll morbido per UX mobile
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// I filtri nell'index funzionano con il submit normale del form
// Non serve JavaScript per il redirect - il form si comporta normalmente
