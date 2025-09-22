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
    
    if (productId && productType) {
        // Inizializza il sistema recensioni
        initProductReviews(productId, productType);
    }
});

