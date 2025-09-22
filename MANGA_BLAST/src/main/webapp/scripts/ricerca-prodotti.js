function caricaProdotti() {
    const query = document.getElementById("searchQuery").value;
    const tipo = getFilterTipo();
    const categoria = getFilterCategoria();
    const prezzoMin = document.getElementById("prezzoMin").value;
    const prezzoMax = document.getElementById("prezzoMax").value;
    const sortBy = document.getElementById("sortBy").value;

    const container = document.getElementById("prodottiContainer");
    
    // Mostra skeleton loading
    if (typeof loadingManager !== 'undefined') {
        loadingManager.showSkeletonLoading(container, 3);
    }

    const xhr = new XMLHttpRequest();
    let url = "RicercaProdottiServlet?";
    const params = new URLSearchParams();
    
    if (query) params.append("query", query);
    if (tipo) params.append("tipo", tipo);
    if (categoria) params.append("categoria", categoria);
    if (prezzoMin) params.append("prezzoMin", prezzoMin);
    if (prezzoMax) params.append("prezzoMax", prezzoMax);
    if (sortBy && sortBy !== "default") params.append("sortBy", sortBy);
    
    url += params.toString();
    
    xhr.open("GET", url, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onload = function() {
        // Nasconde skeleton loading
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideSkeletonLoading();
        }
        
        // Aggiorna contenuto con animazione
        container.innerHTML = xhr.responseText;
        container.classList.add('fade-in');
        
        // Aggiungi event listener per i pulsanti
        aggiungiEventListenersProdotti();
        
        // Rimuovi classe fade-in dopo l'animazione
        setTimeout(() => container.classList.remove('fade-in'), 500);
    };
    xhr.onerror = function() {
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideSkeletonLoading();
        }
        container.innerHTML = '<p style="text-align:center; color: #EF5350; margin: 2rem;">Errore nel caricamento dei prodotti. Riprova.</p>';
    };
    xhr.send();
}

function aggiungiEventListenersProdotti() {
    // I pulsanti carrello e preferiti sono gestiti dalle funzioni globali
    // definite nell'index.jsp, quindi non serve aggiungere event listener qui
}

// 🔄 Aggiorna sessionStorage per il carrello
function updateSessionStorageCart(id, tipo, titolo, prezzo) {
    try {
        const carrello = JSON.parse(sessionStorage.getItem('carrello') || '[]');
        const existingItem = carrello.find(item => item.id === id && item.tipo === tipo);
        
        if (existingItem) {
            existingItem.quantita += 1;
        } else {
            carrello.push({
                id: id,
                nome: titolo,
                prezzo: parseFloat(prezzo),
                tipo: tipo,
                quantita: 1,
                immagine: ''
            });
        }
        
        sessionStorage.setItem('carrello', JSON.stringify(carrello));
        window.dispatchEvent(new CustomEvent('cartUpdated'));
    } catch (error) {
        console.error('Errore nell\'aggiornamento del carrello:', error);
    }
}

// 🔄 Aggiorna sessionStorage per i preferiti
function updateSessionStorageFavorites(id, tipo) {
    try {
        const preferiti = JSON.parse(sessionStorage.getItem('preferiti') || '[]');
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
        
        sessionStorage.setItem('preferiti', JSON.stringify(preferiti));
        window.dispatchEvent(new CustomEvent('favoritesUpdated'));
    } catch (error) {
        console.error('Errore nell\'aggiornamento dei preferiti:', error);
    }
}



function aggiungiCarrello(id, tipo, titolo, prezzo) {
    console.log('aggiungiCarrello chiamata con:', { id, tipo, titolo, prezzo });
    
    const button = event.target;
    
    // Mostra loading sul bottone
    if (typeof loadingManager !== 'undefined') {
        loadingManager.showButtonLoading(button, "Aggiungendo...");
    }
    
    console.log('Inviando richiesta al server...');
    fetch('AggiungiAlCarrelloServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo, titolo, prezzo })
    })
    .then(res => res.text())
    .then(text => {
        console.log('Risposta server:', text);
        if (text.trim() === "aggiunto") {
            console.log('Server ha confermato aggiunta al carrello');
            mostraBanner("Aggiunto al carrello!");
            
            // Aggiorna sessionStorage
            updateSessionStorageCart(id, tipo, titolo, prezzo);
            
        } else if (text.trim() === "admin_non_autorizzato") {
            console.log('Admin non può aggiungere al carrello');
            mostraBanner("Gli admin non possono aggiungere prodotti al carrello!");
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        mostraBanner("Errore nell'aggiunta al carrello!");
    })
    .finally(() => {
        // Nasconde loading dal bottone
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideButtonLoading(button);
        }
    });
}

function aggiungiPreferiti(idProdotto, tipo) {
    console.log('aggiungiPreferiti chiamata con:', { idProdotto, tipo });
    
    const button = event.target;
    
    // Mostra loading sul bottone
    if (typeof loadingManager !== 'undefined') {
        loadingManager.showButtonLoading(button, "Aggiungendo...");
    }
    
    console.log('Inviando richiesta al server per preferiti...');
    fetch('AggiungiPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ idProdotto, tipo })
    })
    .then(res => res.text())
    .then(text => {
        console.log('Risposta server preferiti:', text);
        if (text.trim() === "aggiunto") {
            console.log('Server ha confermato aggiunta ai preferiti');
            mostraBanner("Aggiunto ai preferiti!");
            
            // Aggiorna sessionStorage
            updateSessionStorageFavorites(idProdotto, tipo);
            
        } else if (text.trim() === "esiste") {
            mostraBanner("Già presente nei preferiti!");
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        mostraBanner("Errore nell'aggiunta ai preferiti!");
    })
    .finally(() => {
        // Nasconde loading dal bottone
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideButtonLoading(button);
        }
    });
}

// 🔔 Sistema notifiche migliorato
function mostraBanner(msg) {
    // Usa il nuovo sistema toast se disponibile, altrimenti fallback al vecchio sistema
    if (typeof showToast !== 'undefined') {
        // Determina il tipo di toast basato sul messaggio
        let type = 'info';
        if (msg.includes('Aggiunto')) type = 'success';
        else if (msg.includes('Errore')) type = 'error';
        else if (msg.includes('Già presente')) type = 'warning';
        
        showToast(msg, type, { duration: 3000 });
    } else {
        // Fallback al vecchio sistema
        const banner = document.createElement("div");
        banner.textContent = msg;
        banner.className = "floating-banner";
        document.body.appendChild(banner);
        setTimeout(() => banner.remove(), 2500);
    }
}

// Funzioni per gestire la validazione del range di prezzo
function inizializzaValidazionePrezzo() {
    const prezzoMinInput = document.getElementById("prezzoMin");
    const prezzoMaxInput = document.getElementById("prezzoMax");
    
    if (!prezzoMinInput || !prezzoMaxInput) return;
    
    // Validazione per il prezzo minimo
    prezzoMinInput.addEventListener("input", function() {
        const value = parseFloat(this.value) || 0;
        const maxValue = parseFloat(prezzoMaxInput.value) || 200;
        
        // Se il minimo supera il massimo, scambia i valori
        if (value > maxValue) {
            prezzoMaxInput.value = value.toFixed(2);
        }
        
        caricaProdotti();
    });
    
    // Validazione per il prezzo massimo
    prezzoMaxInput.addEventListener("input", function() {
        const value = parseFloat(this.value) || 200;
        const minValue = parseFloat(prezzoMinInput.value) || 0;
        
        // Se il massimo è inferiore al minimo, scambia i valori
        if (value < minValue) {
            prezzoMinInput.value = value.toFixed(2);
        }
        
        caricaProdotti();
    });
}

// Event listeners per la ricerca in tempo reale
["searchQuery", "filterTipo", "filterCategoria", "prezzoMin", "prezzoMax", "sortBy"].forEach(id => {
    const element = document.getElementById(id);
    if (element) {
        element.addEventListener("input", caricaProdotti);
        element.addEventListener("change", caricaProdotti);
    }
});

// Carica i prodotti all'avvio della pagina
window.addEventListener("load", function() {
    inizializzaValidazionePrezzo();
    caricaCategorie();
    caricaProdotti();
});

// Funzione per caricare le categorie se non sono presenti
function caricaCategorie() {
    const categoriaOptions = document.querySelectorAll('input[name="filterCategoria"]');
    if (categoriaOptions.length <= 1) {
        fetch('GestioneCategorieServlet?action=getCategorie')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.categorie) {
                    const filterOptions = document.querySelector('.filter-section:nth-child(3) .filter-options');
                    if (filterOptions) {
                        // Pulisci le opzioni esistenti (mantieni solo "Tutte")
                        const allOption = filterOptions.querySelector('input[value=""]').parentElement;
                        filterOptions.innerHTML = '';
                        filterOptions.appendChild(allOption);
                        
                        // Aggiungi le categorie
                        data.categorie.forEach(categoria => {
                            const label = document.createElement('label');
                            label.className = 'filter-option';
                            
                            const input = document.createElement('input');
                            input.type = 'radio';
                            input.name = 'filterCategoria';
                            input.value = categoria.id;
                            
                            const span = document.createElement('span');
                            span.textContent = categoria.nome;
                            span.style.color = categoria.colore;
                            
                            label.appendChild(input);
                            label.appendChild(span);
                            filterOptions.appendChild(label);
                            
                            // Aggiungi event listener
                            input.addEventListener('change', caricaProdotti);
                        });
                    }
                }
            })
            .catch(error => {
                console.error('Errore nel caricamento categorie:', error);
            });
    }
}

// Funzione per ottenere il valore del filtro tipo (radio buttons)
function getFilterTipo() {
    const selected = document.querySelector('input[name="filterTipo"]:checked');
    return selected ? selected.value : '';
}

// Funzione per ottenere il valore del filtro categoria (radio buttons)
function getFilterCategoria() {
    const selected = document.querySelector('input[name="filterCategoria"]:checked');
    return selected ? selected.value : '';
}

// Event listeners per i filtri radio
document.addEventListener('DOMContentLoaded', function() {
    // Event listeners per i radio buttons
    const filterTipoRadios = document.querySelectorAll('input[name="filterTipo"]');
    const filterCategoriaRadios = document.querySelectorAll('input[name="filterCategoria"]');
    
    filterTipoRadios.forEach(radio => {
        radio.addEventListener('change', caricaProdotti);
    });
    
    filterCategoriaRadios.forEach(radio => {
        radio.addEventListener('change', caricaProdotti);
    });
    
    // Carica categorie se non presenti
    caricaCategorie();
});
