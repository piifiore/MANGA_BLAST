// 🔄 Sistema di Loading States

class LoadingManager {
    constructor() {
        this.activeLoadings = new Set();
    }

    // Mostra overlay di caricamento globale
    showGlobalLoading(message = "Caricamento...") {
        const overlay = document.createElement('div');
        overlay.className = 'loading-overlay';
        overlay.id = 'global-loading';
        
        overlay.innerHTML = `
            <div style="text-align: center; color: white;">
                <div class="spinner spinner-large"></div>
                <p style="margin-top: 1rem; font-size: 1.1rem;">${message}</p>
            </div>
        `;
        
        document.body.appendChild(overlay);
        this.activeLoadings.add('global-loading');
    }

    // Nasconde overlay di caricamento globale
    hideGlobalLoading() {
        const overlay = document.getElementById('global-loading');
        if (overlay) {
            overlay.remove();
            this.activeLoadings.delete('global-loading');
        }
    }

    // Mostra loading su un bottone
    showButtonLoading(button, text = "Caricamento...") {
        if (button.classList.contains('btn-loading')) return;
        
        button.dataset.originalText = button.textContent;
        button.textContent = text;
        button.classList.add('btn-loading');
        button.disabled = true;
        
        this.activeLoadings.add(button.id || `btn-${Date.now()}`);
    }

    // Nasconde loading su un bottone
    hideButtonLoading(button) {
        if (!button.classList.contains('btn-loading')) return;
        
        button.textContent = button.dataset.originalText || button.textContent;
        button.classList.remove('btn-loading');
        button.disabled = false;
        
        this.activeLoadings.delete(button.id || `btn-${Date.now()}`);
    }

    // Mostra loading su una card prodotto
    showProductLoading(card) {
        card.classList.add('loading');
        this.activeLoadings.add(card.id || `card-${Date.now()}`);
    }

    // Nasconde loading su una card prodotto
    hideProductLoading(card) {
        card.classList.remove('loading');
        this.activeLoadings.delete(card.id || `card-${Date.now()}`);
    }

    // Mostra skeleton loading per prodotti
    showSkeletonLoading(container, count = 3) {
        const skeletonHTML = Array(count).fill(0).map(() => `
            <div class="product-card skeleton-card">
                <div class="skeleton skeleton-image"></div>
                <div class="skeleton skeleton-title"></div>
                <div class="skeleton skeleton-text"></div>
                <div class="skeleton skeleton-text" style="width: 50%;"></div>
                <div class="skeleton skeleton-text" style="width: 30%; height: 2rem; margin-top: 1rem;"></div>
            </div>
        `).join('');
        
        container.innerHTML = skeletonHTML;
        this.activeLoadings.add('skeleton-loading');
    }

    // Nasconde skeleton loading
    hideSkeletonLoading() {
        this.activeLoadings.delete('skeleton-loading');
    }

    // Mostra loading su input di ricerca
    showSearchLoading(input) {
        input.classList.add('search-loading');
        this.activeLoadings.add('search-loading');
    }

    // Nasconde loading su input di ricerca
    hideSearchLoading(input) {
        input.classList.remove('search-loading');
        this.activeLoadings.delete('search-loading');
    }

    // Nasconde tutti i loading attivi
    hideAllLoading() {
        this.activeLoadings.forEach(loadingId => {
            if (loadingId === 'global-loading') {
                this.hideGlobalLoading();
            } else if (loadingId === 'skeleton-loading') {
                this.hideSkeletonLoading();
            } else if (loadingId === 'search-loading') {
                const searchInput = document.querySelector('.search-loading');
                if (searchInput) this.hideSearchLoading(searchInput);
            }
        });
        this.activeLoadings.clear();
    }

    // Utility per animazioni di entrata
    fadeInElement(element, delay = 0) {
        setTimeout(() => {
            element.classList.add('fade-in');
        }, delay);
    }

    // Utility per shimmer effect
    addShimmerEffect(element) {
        element.classList.add('shimmer');
    }

    removeShimmerEffect(element) {
        element.classList.remove('shimmer');
    }
}

// Istanza globale
const loadingManager = new LoadingManager();

// Funzioni di utilità globali
function showLoading(message) {
    loadingManager.showGlobalLoading(message);
}

function hideLoading() {
    loadingManager.hideGlobalLoading();
}

function showButtonSpinner(button, text) {
    loadingManager.showButtonLoading(button, text);
}

function hideButtonSpinner(button) {
    loadingManager.hideButtonLoading(button);
}

// Auto-hide loading dopo timeout (safety net)
setTimeout(() => {
    if (loadingManager.activeLoadings.size > 0) {
        console.warn('Auto-hiding stuck loading states');
        loadingManager.hideAllLoading();
    }
}, 30000); // 30 secondi timeout
