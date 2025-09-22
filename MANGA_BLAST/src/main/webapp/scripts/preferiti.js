function rimuoviPreferito(id, tipo) {
    fetch('RimuoviPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo })
    })
        .then(() => {
            mostraBanner("🗑️ Rimosso dai preferiti!");
            evidenziaRimozione(id);
            
            // Aggiorna sessionStorage
            updateSessionStorageFavorites(id, tipo, true);
            
            
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

// 🔄 Aggiorna sessionStorage per i preferiti
function updateSessionStorageFavorites(id, tipo, remove = false) {
    try {
        const preferiti = JSON.parse(sessionStorage.getItem('preferiti') || '[]');
        
        if (remove) {
            // Rimuovi dai preferiti
            const index = preferiti.findIndex(item => item.id === id && item.tipo === tipo);
            if (index !== -1) {
                preferiti.splice(index, 1);
            }
        } else {
            // Aggiungi ai preferiti
            const existingItem = preferiti.find(item => item.id === id && item.tipo === tipo);
            if (!existingItem) {
                preferiti.push({
                    id: id,
                    tipo: tipo,
                    nome: '',
                    prezzo: 0,
                    immagine: ''
                });
            }
        }
        
        sessionStorage.setItem('preferiti', JSON.stringify(preferiti));
        window.dispatchEvent(new CustomEvent('favoritesUpdated'));
    } catch (error) {
        console.error('Errore nell\'aggiornamento dei preferiti:', error);
    }
}

