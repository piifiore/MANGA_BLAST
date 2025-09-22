// 🌓 Sistema Dark/Light Mode

class ThemeManager {
    constructor() {
        this.currentTheme = this.getStoredTheme() || 'dark';
        this.init();
    }

    init() {
        // Applica il tema salvato
        this.applyTheme(this.currentTheme);
        
        // Crea il toggle button
        this.createToggleButton();
        
        // Aggiungi event listener
        this.addEventListeners();
    }

    createToggleButton() {
        // Rimuovi toggle esistente se presente
        const existingToggle = document.querySelector('.theme-toggle');
        if (existingToggle) {
            existingToggle.remove();
        }

        const toggle = document.createElement('div');
        toggle.className = 'theme-toggle';
        toggle.innerHTML = `
            <span class="theme-toggle-icon">${this.currentTheme === 'dark' ? '☀️' : '🌙'}</span>
            <span class="theme-toggle-text">${this.currentTheme === 'dark' ? 'Light' : 'Dark'}</span>
        `;
        
        document.body.appendChild(toggle);
    }

    addEventListeners() {
        const toggle = document.querySelector('.theme-toggle');
        if (toggle) {
            toggle.addEventListener('click', () => {
                this.toggleTheme();
            });
        }
    }

    toggleTheme() {
        this.currentTheme = this.currentTheme === 'dark' ? 'light' : 'dark';
        this.applyTheme(this.currentTheme);
        this.saveTheme(this.currentTheme);
        this.updateToggleButton();
    }

    applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        
        // Aggiorna meta theme-color per mobile
        const metaThemeColor = document.querySelector('meta[name="theme-color"]');
        if (metaThemeColor) {
            metaThemeColor.content = theme === 'dark' ? '#0f0f23' : '#ffffff';
        } else {
            const meta = document.createElement('meta');
            meta.name = 'theme-color';
            meta.content = theme === 'dark' ? '#0f0f23' : '#ffffff';
            document.head.appendChild(meta);
        }
    }

    updateToggleButton() {
        const toggle = document.querySelector('.theme-toggle');
        if (toggle) {
            const icon = toggle.querySelector('.theme-toggle-icon');
            const text = toggle.querySelector('.theme-toggle-text');
            
            if (icon && text) {
                icon.textContent = this.currentTheme === 'dark' ? '☀️' : '🌙';
                text.textContent = this.currentTheme === 'dark' ? 'Light' : 'Dark';
            }
        }
    }

    saveTheme(theme) {
        try {
            localStorage.setItem('mangablast-theme', theme);
        } catch (e) {
            console.warn('Impossibile salvare il tema:', e);
        }
    }

    getStoredTheme() {
        try {
            return localStorage.getItem('mangablast-theme');
        } catch (e) {
            console.warn('Impossibile leggere il tema salvato:', e);
            return null;
        }
    }

    // Metodo pubblico per cambiare tema programmaticamente
    setTheme(theme) {
        if (theme === 'dark' || theme === 'light') {
            this.currentTheme = theme;
            this.applyTheme(theme);
            this.saveTheme(theme);
            this.updateToggleButton();
        }
    }

    // Metodo pubblico per ottenere tema corrente
    getCurrentTheme() {
        return this.currentTheme;
    }
}

// Istanza globale
let themeManager;

// Inizializzazione
document.addEventListener('DOMContentLoaded', () => {
    themeManager = new ThemeManager();
});

// Funzioni di utilità globali
function toggleTheme() {
    if (themeManager) {
        themeManager.toggleTheme();
    }
}

function setTheme(theme) {
    if (themeManager) {
        themeManager.setTheme(theme);
    }
}

function getCurrentTheme() {
    return themeManager ? themeManager.getCurrentTheme() : 'dark';
}
