function rimuoviPreferito(id, tipo) {
    fetch('RimuoviPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo })
    })
        .then(() => {
            mostraBanner("🗑️ Rimosso dai preferiti!");
            evidenziaRimozione(id);
            setTimeout(() => location.reload(), 1000);
        });
}

function mostraBanner(msg) {
    const banner = document.createElement('div');
    banner.textContent = msg;
    banner.className = "floating-banner";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2500);
}

function evidenziaRimozione(id) {
    const card = document.querySelector(`.product-card[data-id='${id}']`);
    if (card) {
        card.style.opacity = "0.5";
        card.style.transition = "opacity 0.5s ease";
    }
}
