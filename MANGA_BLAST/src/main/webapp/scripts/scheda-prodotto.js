function aggiungiCarrello(id, tipo, titolo, prezzo) {
    fetch('AggiungiAlCarrelloServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo, titolo, prezzo })
    })
        .then(res => res.text())
        .catch(error => {
            console.error('Errore carrello:', error);
        });
}

function aggiungiPreferiti(idProdotto, tipo) {
    fetch('AggiungiPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ idProdotto, tipo })
    })
        .then(res => res.text())
        .catch(error => {
            console.error('Errore preferiti:', error);
        });
}

// Inizializzazione recensioni
document.addEventListener('DOMContentLoaded', function() {
    // Ottieni ID e tipo prodotto dalla pagina
    const productId = document.querySelector('input[name="id"]')?.value || 
                     new URLSearchParams(window.location.search).get('id');
    const productType = document.querySelector('input[name="tipo"]')?.value || 
                       new URLSearchParams(window.location.search).get('tipo');
    
    console.log('scheda-prodotto.js - DOMContentLoaded');
    console.log('scheda-prodotto.js - productId:', productId);
    console.log('scheda-prodotto.js - productType:', productType);
    
    if (productId && productType) {
        // Aspetta che reviews.js sia caricato
        setTimeout(() => {
            if (typeof initProductReviews === 'function') {
                console.log('scheda-prodotto.js - Chiamata initProductReviews');
                initProductReviews(productId, productType);
            } else {
                console.error('scheda-prodotto.js - initProductReviews non disponibile');
            }
        }, 100);
    }
});

