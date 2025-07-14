function modificaQuantita(id, tipo, delta) {
    fetch('AggiornaQuantitaCarrelloServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo, delta })
    })
        .then(res => res.json())
        .then(data => {
            const key = id + tipo;
            if (data.rimosso) {
                mostraBanner("🗑️ Prodotto rimosso dal carrello!");
                setTimeout(() => location.reload(), 1000);
            } else {
                document.getElementById("qta-" + key).textContent = data.nuovaQuantita;
                const prezzo = parseFloat(document.getElementById("subtotale-" + key).getAttribute("data-prezzo"));
                const subtotale = prezzo * data.nuovaQuantita;
                document.getElementById("subtotale-" + key).textContent = subtotale.toFixed(2) + "€";
                aggiornaTotale();
            }
        });
}

function aggiornaTotale() {
    let totale = 0;
    document.querySelectorAll("[id^='subtotale-']").forEach(td => {
        const text = td.textContent.replace("€", "").trim();
        const value = parseFloat(text);
        if (!isNaN(value)) totale += value;
    });
    document.getElementById("totaleCarrello").textContent = totale.toFixed(2);
}

function mostraBanner(msg) {
    const banner = document.createElement("div");
    banner.textContent = msg;
    banner.style.position = "fixed";
    banner.style.top = "10px";
    banner.style.right = "10px";
    banner.style.background = "#F44336"; // Rosso per rimozione
    banner.style.color = "#fff";
    banner.style.padding = "10px 20px";
    banner.style.fontWeight = "bold";
    banner.style.borderRadius = "5px";
    banner.style.zIndex = "1000";
    banner.style.boxShadow = "0 2px 6px rgba(0,0,0,0.2)";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2000);
}