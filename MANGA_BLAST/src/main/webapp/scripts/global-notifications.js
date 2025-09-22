// Sistema globale per notifiche automatiche basate su AJAX
(function() {
    'use strict';
    
    // Salva i metodi originali
    const originalFetch = window.fetch;
    const originalXMLHttpRequest = window.XMLHttpRequest;
    
    // Funzione per mostrare notifiche
    function showNotification(message, type = 'success') {
        if (typeof showToast !== 'undefined') {
            showToast(message, type, { duration: 3000 });
        } else {
            // Fallback con banner
            const banner = document.createElement("div");
            banner.textContent = message;
            banner.className = "floating-banner";
            banner.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: ${type === 'success' ? '#4CAF50' : type === 'error' ? '#f44336' : '#2196F3'};
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                z-index: 10000;
                font-weight: 500;
                max-width: 300px;
                word-wrap: break-word;
                animation: slideIn 0.3s ease-out;
            `;
            
            // Aggiungi animazione CSS se non esiste
            if (!document.getElementById('banner-animation')) {
                const style = document.createElement('style');
                style.id = 'banner-animation';
                style.textContent = `
                    @keyframes slideIn {
                        from { transform: translateX(100%); opacity: 0; }
                        to { transform: translateX(0); opacity: 1; }
                    }
                `;
                document.head.appendChild(style);
            }
            
            document.body.appendChild(banner);
            setTimeout(() => {
                if (banner.parentNode) {
                    banner.style.animation = 'slideOut 0.3s ease-in';
                    setTimeout(() => banner.remove(), 300);
                }
            }, 3000);
        }
    }
    
    // Intercetta fetch
    window.fetch = function(...args) {
        return originalFetch.apply(this, args).then(response => {
            // Clona la response per poterla leggere
            const clonedResponse = response.clone();
            
            // Controlla se è una chiamata ai servlet di carrello/preferiti
            const url = args[0];
            if (typeof url === 'string') {
                if (url.includes('AggiungiAlCarrelloServlet')) {
                    clonedResponse.text().then(text => {
                        if (text.trim() === "aggiunto") {
                            showNotification("✅ Aggiunto al carrello!", 'success');
                        } else if (text.trim() === "admin_non_autorizzato") {
                            showNotification("❌ Gli admin non possono aggiungere prodotti al carrello!", 'error');
                        }
                    }).catch(() => {});
                } else if (url.includes('AggiungiPreferitoServlet')) {
                    clonedResponse.text().then(text => {
                        if (text.trim() === "aggiunto") {
                            showNotification("❤️ Aggiunto ai preferiti!", 'success');
                        } else if (text.trim() === "esiste") {
                            showNotification("⚠️ Già presente nei preferiti!", 'warning');
                        }
                    }).catch(() => {});
                } else if (url.includes('RimuoviPreferitoServlet')) {
                    clonedResponse.text().then(text => {
                        if (text.trim() === "rimosso") {
                            showNotification("🗑️ Rimosso dai preferiti!", 'info');
                        }
                    }).catch(() => {});
                }
            }
            
            return response;
        });
    };
    
    // Intercetta XMLHttpRequest
    const originalOpen = originalXMLHttpRequest.prototype.open;
    const originalSend = originalXMLHttpRequest.prototype.send;
    
    originalXMLHttpRequest.prototype.open = function(method, url, ...args) {
        this._url = url;
        return originalOpen.apply(this, [method, url, ...args]);
    };
    
    originalXMLHttpRequest.prototype.send = function(data) {
        const xhr = this;
        const originalOnReadyStateChange = xhr.onreadystatechange;
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const url = xhr._url;
                if (url && typeof url === 'string') {
                    if (url.includes('AggiungiAlCarrelloServlet')) {
                        if (xhr.responseText.trim() === "aggiunto") {
                            showNotification("✅ Aggiunto al carrello!", 'success');
                        } else if (xhr.responseText.trim() === "admin_non_autorizzato") {
                            showNotification("❌ Gli admin non possono aggiungere prodotti al carrello!", 'error');
                        }
                    } else if (url.includes('AggiungiPreferitoServlet')) {
                        if (xhr.responseText.trim() === "aggiunto") {
                            showNotification("❤️ Aggiunto ai preferiti!", 'success');
                        } else if (xhr.responseText.trim() === "esiste") {
                            showNotification("⚠️ Già presente nei preferiti!", 'warning');
                        }
                    } else if (url.includes('RimuoviPreferitoServlet')) {
                        if (xhr.responseText.trim() === "rimosso") {
                            showNotification("🗑️ Rimosso dai preferiti!", 'info');
                        }
                    }
                }
            }
            
            if (originalOnReadyStateChange) {
                originalOnReadyStateChange.apply(this, arguments);
            }
        };
        
        return originalSend.apply(this, arguments);
    };
    
    console.log('🔔 Sistema notifiche globali attivato');
})();
