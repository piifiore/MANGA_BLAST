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
                evidenziaRimozione(key);
                
                // Aggiorna sessionStorage
                updateSessionStorageCart(id, tipo, null, null, -1);
                
                
                setTimeout(() => location.reload(), 1000);
            } else {
                document.getElementById("qta-" + key).textContent = data.nuovaQuantita;
                const prezzo = parseFloat(document.getElementById("subtotale-" + key).getAttribute("data-prezzo"));
                const subtotale = prezzo * data.nuovaQuantita;
                document.getElementById("subtotale-" + key).textContent = subtotale.toFixed(2) + "€";
                aggiornaTotale();
                evidenziaModifica(key);
                
                // Aggiorna sessionStorage
                updateSessionStorageCart(id, tipo, null, null, delta);
                
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

// ✅ Glow visuale per modifica
function evidenziaModifica(key) {
    const row = document.getElementById("subtotale-" + key).closest("tr");
    if (row) {
        row.classList.add("row-highlight");
        setTimeout(() => row.classList.remove("row-highlight"), 1200);
    }
}

// ❌ Fade visivo per rimozione
function evidenziaRimozione(key) {
    const row = document.getElementById("subtotale-" + key).closest("tr");
    if (row) {
        row.style.opacity = "0.5";
        row.style.transition = "opacity 0.5s";
    }
}

// 🔔 Banner visivo
function mostraBanner(msg) {
    const banner = document.createElement("div");
    banner.textContent = msg;
    banner.className = "floating-banner";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2500);
}

// 🔄 Aggiorna sessionStorage per il carrello
function updateSessionStorageCart(id, tipo, titolo, prezzo, delta) {
    try {
        const carrello = JSON.parse(sessionStorage.getItem('carrello') || '[]');
        const existingItem = carrello.find(item => item.id === id && item.tipo === tipo);
        
        if (existingItem) {
            if (delta === -1) {
                // Rimuovi item
                const index = carrello.indexOf(existingItem);
                carrello.splice(index, 1);
            } else {
                // Aggiorna quantità
                existingItem.quantita += delta;
                if (existingItem.quantita <= 0) {
                    const index = carrello.indexOf(existingItem);
                    carrello.splice(index, 1);
                }
            }
        } else if (delta > 0 && titolo && prezzo) {
            // Aggiungi nuovo item
            carrello.push({
                id: id,
                nome: titolo,
                prezzo: parseFloat(prezzo),
                tipo: tipo,
                quantita: delta,
                immagine: ''
            });
        }
        
        sessionStorage.setItem('carrello', JSON.stringify(carrello));
        window.dispatchEvent(new CustomEvent('cartUpdated'));
    } catch (error) {
        console.error('Errore nell\'aggiornamento del carrello:', error);
    }
}

