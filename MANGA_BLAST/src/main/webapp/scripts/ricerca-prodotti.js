function caricaProdotti() {
    const query = document.getElementById("searchQuery").value;
    const tipo = getFilterTipo();
    const categorie = getFilterCategorie();
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
    if (categorie && categorie.length > 0) {
        categorie.forEach(cat => params.append("categoria", cat));
    }
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
            
            // Aggiorna sessionStorage
            updateSessionStorageCart(id, tipo, titolo, prezzo);
            
        } else if (text.trim() === "admin_non_autorizzato") {
            console.log('Admin non può aggiungere al carrello');
        }
    })
    .catch(error => {
        console.error('Errore:', error);
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
            
            // Aggiorna sessionStorage
            updateSessionStorageFavorites(idProdotto, tipo);
            
        } else if (text.trim() === "esiste") {
            console.log('Già presente nei preferiti');
        }
    })
    .catch(error => {
        console.error('Errore:', error);
    })
    .finally(() => {
        // Nasconde loading dal bottone
        if (typeof loadingManager !== 'undefined') {
            loadingManager.hideButtonLoading(button);
        }
    });
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
    // Controlla se ci sono solo le opzioni di base (Tutte + Caricamento...)
    if (categoriaOptions.length <= 2) {
        fetch('CategorieServlet', {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            if (data.success && data.categorie) {
                const filterOptions = document.getElementById('categoriaOptions');
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
                        input.type = 'checkbox';
                        input.name = 'filterCategoria';
                        input.value = categoria.id;
                        
                        const span = document.createElement('span');
                        span.textContent = categoria.nome;
                        span.style.color = categoria.colore;
                        
                        label.appendChild(input);
                        label.appendChild(span);
                        filterOptions.appendChild(label);
                        
                        // Aggiungi event listener
                        input.addEventListener('change', function() {
                            // Se viene selezionata una categoria specifica, deseleziona "Tutte"
                            if (this.value !== '' && this.checked) {
                                const allCheckbox = filterOptions.querySelector('input[value=""]');
                                if (allCheckbox) allCheckbox.checked = false;
                            }
                            // Se viene selezionata "Tutte", deseleziona tutte le altre
                            if (this.value === '' && this.checked) {
                                const otherCheckboxes = filterOptions.querySelectorAll('input[name="filterCategoria"]:not([value=""])');
                                otherCheckboxes.forEach(cb => cb.checked = false);
                            }
                            caricaProdotti();
                        });
                    });
                }
            }
        })
        .catch(error => {
            console.error('Errore nel caricamento categorie:', error);
            // In caso di errore, mostra un messaggio di fallback
            const filterOptions = document.getElementById('categoriaOptions');
            if (filterOptions) {
                const loadingLabel = filterOptions.querySelector('span');
                if (loadingLabel && loadingLabel.textContent === 'Caricamento...') {
                    loadingLabel.textContent = 'Errore nel caricamento';
                    loadingLabel.style.color = '#EF5350';
                }
            }
        });
    }
}

// Funzione per ottenere il valore del filtro tipo (radio buttons)
function getFilterTipo() {
    const selected = document.querySelector('input[name="filterTipo"]:checked');
    return selected ? selected.value : '';
}

// Funzione per ottenere i valori del filtro categoria (checkbox)
function getFilterCategorie() {
    const selected = document.querySelectorAll('input[name="filterCategoria"]:checked');
    const values = Array.from(selected).map(cb => cb.value);
    // Se "Tutte" è selezionata, non filtrare per categoria
    if (values.includes('')) {
        return [];
    }
    return values;
}

// Event listeners per i filtri
document.addEventListener('DOMContentLoaded', function() {
    // Event listeners per i radio buttons del tipo
    const filterTipoRadios = document.querySelectorAll('input[name="filterTipo"]');
    filterTipoRadios.forEach(radio => {
        radio.addEventListener('change', caricaProdotti);
    });
    
    // Event listeners per le checkbox delle categorie
    const filterCategoriaCheckboxes = document.querySelectorAll('input[name="filterCategoria"]');
    filterCategoriaCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            // Se viene selezionata una categoria specifica, deseleziona "Tutte"
            if (this.value !== '' && this.checked) {
                const allCheckbox = document.querySelector('input[name="filterCategoria"][value=""]');
                if (allCheckbox) allCheckbox.checked = false;
            }
            // Se viene selezionata "Tutte", deseleziona tutte le altre
            if (this.value === '' && this.checked) {
                const otherCheckboxes = document.querySelectorAll('input[name="filterCategoria"]:not([value=""])');
                otherCheckboxes.forEach(cb => cb.checked = false);
            }
            caricaProdotti();
        });
    });
    
    // Carica categorie se non presenti
    caricaCategorie();
});
