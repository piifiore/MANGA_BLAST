// 🔍 Autocomplete Intelligente

class AutocompleteManager {
    constructor() {
        this.searchInput = null;
        this.dropdown = null;
        this.currentResults = [];
        this.selectedIndex = -1;
        this.isLoading = false;
        this.debounceTimer = null;
        this.suggestions = [
            'One Piece', 'Naruto', 'Dragon Ball', 'Attack on Titan', 'Demon Slayer',
            'My Hero Academia', 'Tokyo Ghoul', 'Death Note', 'Fullmetal Alchemist',
            'Funko Pop', 'Action Figure', 'Collectible', 'Limited Edition'
        ];
        this.init();
    }

    init() {
        this.createAutocompleteHTML();
        this.addEventListeners();
        this.loadPopularSuggestions();
    }

    createAutocompleteHTML() {
        const searchInput = document.getElementById('searchQuery');
        if (!searchInput) return;

        this.searchInput = searchInput;
        
        // Wrappare l'input in un container
        const container = document.createElement('div');
        container.className = 'autocomplete-container';
        searchInput.parentNode.insertBefore(container, searchInput);
        container.appendChild(searchInput);

        // Creare il dropdown
        this.dropdown = document.createElement('div');
        this.dropdown.className = 'autocomplete-dropdown';
        this.dropdown.id = 'autocompleteDropdown';
        container.appendChild(this.dropdown);
    }

    addEventListeners() {
        if (!this.searchInput) return;

        // Input events
        this.searchInput.addEventListener('input', (e) => {
            this.handleInput(e.target.value);
        });

        this.searchInput.addEventListener('focus', () => {
            if (this.searchInput.value.length > 0) {
                this.showDropdown();
            }
        });

        this.searchInput.addEventListener('blur', (e) => {
            // Delay per permettere click su item
            setTimeout(() => {
                this.hideDropdown();
            }, 200);
        });

        // Keyboard navigation
        this.searchInput.addEventListener('keydown', (e) => {
            this.handleKeydown(e);
        });

        // Click outside per chiudere
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.autocomplete-container')) {
                this.hideDropdown();
            }
        });
    }

    handleInput(value) {
        // Debounce per evitare troppe richieste
        clearTimeout(this.debounceTimer);
        
        if (value.length < 2) {
            this.hideDropdown();
            return;
        }

        this.debounceTimer = setTimeout(() => {
            this.searchProducts(value);
        }, 300);
    }

    async searchProducts(query) {
        if (this.isLoading) return;

        this.isLoading = true;
        this.showLoading();

        try {
            const response = await fetch(`RicercaProdottiServlet?query=${encodeURIComponent(query)}&limit=5`);
            const html = await response.text();
            
            // Parse HTML per estrarre i prodotti
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const products = this.extractProductsFromHTML(doc);
            
            this.currentResults = products;
            this.selectedIndex = -1;
            this.showResults(products, query);
            
        } catch (error) {
            console.error('Errore nella ricerca autocomplete:', error);
            this.showError();
        } finally {
            this.isLoading = false;
        }
    }

    extractProductsFromHTML(doc) {
        const products = [];
        
        // Cerca manga
        const mangaCards = doc.querySelectorAll('.manga-card');
        mangaCards.forEach(card => {
            const name = card.querySelector('.manga-name')?.textContent?.trim();
            const price = card.querySelector('.manga-price')?.textContent?.trim();
            const image = card.querySelector('.manga-image')?.src;
            
            if (name && price) {
                products.push({
                    id: card.dataset.id,
                    nome: name,
                    prezzo: parseFloat(price.replace('€', '').replace(',', '.')),
                    immagine: image || '',
                    tipo: 'manga'
                });
            }
        });

        // Cerca funko
        const funkoCards = doc.querySelectorAll('.funko-card');
        funkoCards.forEach(card => {
            const name = card.querySelector('.funko-name')?.textContent?.trim();
            const price = card.querySelector('.funko-price')?.textContent?.trim();
            const image = card.querySelector('.funko-image')?.src;
            
            if (name && price) {
                products.push({
                    id: card.dataset.id,
                    nome: name,
                    prezzo: parseFloat(price.replace('€', '').replace(',', '.')),
                    immagine: image || '',
                    tipo: 'funko'
                });
            }
        });

        return products;
    }

    showResults(products, query) {
        if (products.length === 0) {
            this.showNoResults();
            return;
        }

        const html = `
            <div class="autocomplete-suggestions">
                <p class="autocomplete-suggestions-title">Prodotti trovati</p>
            </div>
            ${products.map((product, index) => `
                <div class="autocomplete-item" data-index="${index}" data-product='${JSON.stringify(product)}'>
                    <img src="${product.immagine}" alt="${product.nome}" class="autocomplete-item-image"
                         onerror="this.src='data:image/svg+xml,<svg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 100 100\'><rect width=\'100\' height=\'100\' fill=\'%23f0f0f0\'/><text x=\'50\' y=\'50\' text-anchor=\'middle\' dy=\'.3em\' fill=\'%23999\'>N/A</text></svg>'">
                    <div class="autocomplete-item-details">
                        <h4 class="autocomplete-item-name">${this.highlightText(product.nome, query)}</h4>
                        <p class="autocomplete-item-price">€${product.prezzo.toFixed(2)}</p>
                    </div>
                    <span class="autocomplete-item-type ${product.tipo}">${product.tipo}</span>
                </div>
            `).join('')}
        `;

        this.dropdown.innerHTML = html;
        this.showDropdown();
        this.addItemEventListeners();
    }

    showNoResults() {
        this.dropdown.innerHTML = `
            <div class="autocomplete-no-results">
                Nessun prodotto trovato
            </div>
        `;
        this.showDropdown();
    }

    showLoading() {
        this.dropdown.innerHTML = `
            <div class="autocomplete-loading">
                Ricerca in corso...
            </div>
        `;
        this.showDropdown();
    }

    showError() {
        this.dropdown.innerHTML = `
            <div class="autocomplete-no-results">
                Errore nella ricerca
            </div>
        `;
        this.showDropdown();
    }

    showPopularSuggestions() {
        const html = `
            <div class="autocomplete-suggestions">
                <p class="autocomplete-suggestions-title">Suggerimenti popolari</p>
                <div class="autocomplete-suggestion-tags">
                    ${this.suggestions.map(suggestion => `
                        <span class="autocomplete-suggestion-tag" data-suggestion="${suggestion}">
                            ${suggestion}
                        </span>
                    `).join('')}
                </div>
            </div>
        `;

        this.dropdown.innerHTML = html;
        this.showDropdown();
        this.addSuggestionEventListeners();
    }

    addItemEventListeners() {
        const items = this.dropdown.querySelectorAll('.autocomplete-item');
        items.forEach((item, index) => {
            item.addEventListener('click', () => {
                this.selectProduct(index);
            });

            item.addEventListener('mouseenter', () => {
                this.selectedIndex = index;
                this.updateSelection();
            });
        });
    }

    addSuggestionEventListeners() {
        const tags = this.dropdown.querySelectorAll('.autocomplete-suggestion-tag');
        tags.forEach(tag => {
            tag.addEventListener('click', () => {
                const suggestion = tag.dataset.suggestion;
                this.searchInput.value = suggestion;
                this.searchInput.focus();
                this.searchProducts(suggestion);
            });
        });
    }

    selectProduct(index) {
        if (index >= 0 && index < this.currentResults.length) {
            const product = this.currentResults[index];
            this.searchInput.value = product.nome;
            this.hideDropdown();
            
            // Trigger ricerca completa
            if (typeof caricaProdotti === 'function') {
                caricaProdotti();
            }
            
            // Scroll al prodotto selezionato
            this.scrollToProduct(product);
        }
    }

    scrollToProduct(product) {
        // Cerca il prodotto nella pagina e scrolla ad esso
        const productElement = document.querySelector(`[data-id="${product.id}"][data-tipo="${product.tipo}"]`);
        if (productElement) {
            productElement.scrollIntoView({ 
                behavior: 'smooth', 
                block: 'center' 
            });
            
            // Evidenzia temporaneamente il prodotto
            productElement.style.animation = 'pulse 1s ease-in-out';
            setTimeout(() => {
                productElement.style.animation = '';
            }, 1000);
        }
    }

    handleKeydown(e) {
        if (!this.dropdown.classList.contains('active')) {
            if (e.key === 'ArrowDown' && this.searchInput.value.length > 0) {
                this.showPopularSuggestions();
                return;
            }
            return;
        }

        const items = this.dropdown.querySelectorAll('.autocomplete-item');
        
        switch (e.key) {
            case 'ArrowDown':
                e.preventDefault();
                this.selectedIndex = Math.min(this.selectedIndex + 1, items.length - 1);
                this.updateSelection();
                break;
                
            case 'ArrowUp':
                e.preventDefault();
                this.selectedIndex = Math.max(this.selectedIndex - 1, -1);
                this.updateSelection();
                break;
                
            case 'Enter':
                e.preventDefault();
                if (this.selectedIndex >= 0) {
                    this.selectProduct(this.selectedIndex);
                } else {
                    // Trigger ricerca normale
                    if (typeof caricaProdotti === 'function') {
                        caricaProdotti();
                    }
                }
                break;
                
            case 'Escape':
                this.hideDropdown();
                break;
        }
    }

    updateSelection() {
        const items = this.dropdown.querySelectorAll('.autocomplete-item');
        items.forEach((item, index) => {
            item.classList.toggle('selected', index === this.selectedIndex);
        });
    }

    showDropdown() {
        this.dropdown.classList.add('active');
    }

    hideDropdown() {
        this.dropdown.classList.remove('active');
        this.selectedIndex = -1;
    }

    highlightText(text, query) {
        if (!query) return text;
        
        const regex = new RegExp(`(${query})`, 'gi');
        return text.replace(regex, '<span class="autocomplete-highlight">$1</span>');
    }

    loadPopularSuggestions() {
        // Mostra suggerimenti popolari quando l'input è vuoto e ha focus
        this.searchInput.addEventListener('focus', () => {
            if (this.searchInput.value.length === 0) {
                this.showPopularSuggestions();
            }
        });
    }

    // Metodo pubblico per aggiornare i suggerimenti
    updateSuggestions(newSuggestions) {
        this.suggestions = [...new Set([...this.suggestions, ...newSuggestions])];
    }

    // Metodo pubblico per pulire l'autocomplete
    clear() {
        this.hideDropdown();
        this.currentResults = [];
        this.selectedIndex = -1;
    }
}

// Istanza globale
let autocompleteManager;

// Inizializzazione
document.addEventListener('DOMContentLoaded', () => {
    autocompleteManager = new AutocompleteManager();
});

// Funzioni di utilità globali
function clearAutocomplete() {
    if (autocompleteManager) {
        autocompleteManager.clear();
    }
}

function updateAutocompleteSuggestions(suggestions) {
    if (autocompleteManager) {
        autocompleteManager.updateSuggestions(suggestions);
    }
}
