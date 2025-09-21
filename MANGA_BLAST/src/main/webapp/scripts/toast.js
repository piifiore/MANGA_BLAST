// 🔔 Sistema Toast Notifications

class ToastManager {
    constructor() {
        this.container = null;
        this.toasts = new Map();
        this.maxToasts = 5;
        this.defaultDuration = 4000;
        this.init();
    }

    init() {
        // Crea il container se non esiste
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        }
    }

    show(message, options = {}) {
        const {
            type = 'info',
            title = '',
            duration = this.defaultDuration,
            closable = true,
            icon = this.getDefaultIcon(type)
        } = options;

        // Rimuovi toast vecchi se superiamo il limite
        if (this.toasts.size >= this.maxToasts) {
            const oldestToast = this.toasts.values().next().value;
            this.hide(oldestToast.id);
        }

        const toastId = `toast-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
        
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.id = toastId;
        
        toast.innerHTML = `
            <div class="toast-icon">${icon}</div>
            <div class="toast-content">
                ${title ? `<div class="toast-title">${title}</div>` : ''}
                <div class="toast-message">${message}</div>
            </div>
            ${closable ? '<button class="toast-close" onclick="toastManager.hide(\'' + toastId + '\')">&times;</button>' : ''}
            <div class="toast-progress"></div>
        `;

        this.container.appendChild(toast);
        this.toasts.set(toastId, toast);

        // Animazione di entrata
        requestAnimationFrame(() => {
            toast.classList.add('show');
        });

        // Auto-hide se duration > 0
        if (duration > 0) {
            const progressBar = toast.querySelector('.toast-progress');
            if (progressBar) {
                progressBar.style.width = '100%';
                progressBar.style.transition = `width ${duration}ms linear`;
                progressBar.style.width = '0%';
            }

            setTimeout(() => {
                this.hide(toastId);
            }, duration);
        }

        return toastId;
    }

    hide(toastId) {
        const toast = this.toasts.get(toastId);
        if (!toast) return;

        toast.classList.remove('show');
        toast.classList.add('hide');

        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
            this.toasts.delete(toastId);
        }, 300);
    }

    hideAll() {
        this.toasts.forEach((toast, id) => {
            this.hide(id);
        });
    }

    getDefaultIcon(type) {
        const icons = {
            success: '✓',
            error: '✗',
            warning: '!',
            info: 'i'
        };
        return icons[type] || icons.info;
    }

    // Metodi di convenienza
    success(message, options = {}) {
        return this.show(message, { ...options, type: 'success' });
    }

    error(message, options = {}) {
        return this.show(message, { ...options, type: 'error' });
    }

    warning(message, options = {}) {
        return this.show(message, { ...options, type: 'warning' });
    }

    info(message, options = {}) {
        return this.show(message, { ...options, type: 'info' });
    }
}

// Istanza globale
const toastManager = new ToastManager();

// Funzioni di utilità globali
function showToast(message, type = 'info', options = {}) {
    return toastManager.show(message, { ...options, type });
}

function showSuccess(message, options = {}) {
    return toastManager.success(message, options);
}

function showError(message, options = {}) {
    return toastManager.error(message, options);
}

function showWarning(message, options = {}) {
    return toastManager.warning(message, options);
}

function showInfo(message, options = {}) {
    return toastManager.info(message, options);
}

// Toast specializzati per l'app
function showCartToast(message, isSuccess = true) {
    return toastManager.show(message, {
        type: isSuccess ? 'success' : 'error',
        title: 'Carrello',
        icon: isSuccess ? '✓' : '✗',
        duration: 3000
    });
}

function showFavoritesToast(message, isSuccess = true) {
    return toastManager.show(message, {
        type: isSuccess ? 'success' : 'warning',
        title: 'Preferiti',
        icon: isSuccess ? '✓' : '!',
        duration: 3000
    });
}

function showSearchToast(message, type = 'info') {
    return toastManager.show(message, {
        type: type,
        title: 'Ricerca',
        icon: 'i',
        duration: 2000
    });
}

// Auto-inizializzazione
document.addEventListener('DOMContentLoaded', () => {
    // Assicurati che il toast manager sia inizializzato
    if (!window.toastManager) {
        window.toastManager = toastManager;
    }
});
