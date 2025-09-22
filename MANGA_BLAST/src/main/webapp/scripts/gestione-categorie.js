/**
 * 🏷️ Gestione Categorie - MangaBlast Admin (Versione Semplificata)
 */

// Variabili globali
let currentCategoryId = null;
let currentSubcategoryId = null;

// Inizializzazione quando il DOM è pronto
document.addEventListener('DOMContentLoaded', function() {
    console.log('🏷️ Inizializzazione gestione categorie');
    setupEventListeners();
    loadInitialData();
});

function setupEventListeners() {
    // Form categoria
    const categoryForm = document.getElementById('categoryForm');
    if (categoryForm) {
        categoryForm.addEventListener('submit', handleCategorySubmit);
    }

    // Form sottocategoria
    const subcategoryForm = document.getElementById('subcategoryForm');
    if (subcategoryForm) {
        subcategoryForm.addEventListener('submit', handleSubcategorySubmit);
    }

    // Pulsanti di chiusura modal
    const closeButtons = document.querySelectorAll('.close-modal');
    closeButtons.forEach(btn => {
        btn.addEventListener('click', closeAllModals);
    });

    // Chiusura modal cliccando fuori
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) {
            closeAllModals();
        }
    });
}

function loadInitialData() {
    // I dati vengono caricati dal server nella pagina JSP
    console.log('📊 Dati iniziali caricati dalla pagina');
}

// =============================================
// GESTIONE CATEGORIE
// =============================================

function handleCategorySubmit(e) {
    e.preventDefault();
    
    const form = e.target;
    const formData = new FormData(form);
    
    // Aggiungi il parametro action (sempre addCategoria)
    formData.append('action', 'addCategoria');
    
    // Converti FormData in URLSearchParams
    const params = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }
    
    fetch('GestioneCategorieServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        if (response.ok) {
            showToast('Categoria aggiunta con successo!', 'success');
            form.reset();
            closeAllModals();
            // Ricarica la pagina per vedere le modifiche
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        } else {
            throw new Error('Errore nel salvataggio');
        }
    })
    .catch(error => {
        console.error('Errore nel salvataggio categoria:', error);
        showToast('Errore nel salvataggio della categoria', 'error');
    });
}

function handleSubcategorySubmit(e) {
    e.preventDefault();
    
    const form = e.target;
    const formData = new FormData(form);
    
    // Aggiungi il parametro action (sempre addSottocategoria)
    formData.append('action', 'addSottocategoria');
    
    // Converti FormData in URLSearchParams
    const params = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }
    
    fetch('GestioneCategorieServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        if (response.ok) {
            showToast('Sottocategoria aggiunta con successo!', 'success');
            form.reset();
            closeAllModals();
            // Ricarica la pagina per vedere le modifiche
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        } else {
            throw new Error('Errore nel salvataggio');
        }
    })
    .catch(error => {
        console.error('Errore nel salvataggio sottocategoria:', error);
        showToast('Errore nel salvataggio della sottocategoria', 'error');
    });
}

// =============================================
// FUNZIONI GLOBALI (chiamate dai pulsanti HTML)
// =============================================

// Funzione di modifica rimossa - solo aggiunta e eliminazione

function deleteCategory(id, nome) {
    if (confirm(`Sei sicuro di voler eliminare la categoria "${nome}"?`)) {
        const params = new URLSearchParams();
        params.append('action', 'deleteCategoria');
        params.append('id', id);
        
        fetch('GestioneCategorieServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
        .then(response => {
            if (response.ok) {
                showToast('Categoria eliminata con successo!', 'success');
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                throw new Error('Errore nell\'eliminazione');
            }
        })
        .catch(error => {
            console.error('Errore nell\'eliminazione categoria:', error);
            showToast('Errore nell\'eliminazione della categoria', 'error');
        });
    }
}

// Funzione di modifica sottocategoria rimossa - solo aggiunta e eliminazione

function deleteSubcategory(id, nome) {
    if (confirm(`Sei sicuro di voler eliminare la sottocategoria "${nome}"?`)) {
        const params = new URLSearchParams();
        params.append('action', 'deleteSottocategoria');
        params.append('id', id);
        
        fetch('GestioneCategorieServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
        .then(response => {
            if (response.ok) {
                showToast('Sottocategoria eliminata con successo!', 'success');
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                throw new Error('Errore nell\'eliminazione');
            }
        })
        .catch(error => {
            console.error('Errore nell\'eliminazione sottocategoria:', error);
            showToast('Errore nell\'eliminazione della sottocategoria', 'error');
        });
    }
}

function showAddCategoryModal() {
    // Pulisci il form
    document.getElementById('categoryForm').reset();
    
    // Mostra il modal
    document.getElementById('categoryModal').style.display = 'block';
}

function showAddSubcategoryModal() {
    // Pulisci il form
    document.getElementById('subcategoryForm').reset();
    
    // Mostra il modal
    document.getElementById('subcategoryModal').style.display = 'block';
}

function closeAllModals() {
    document.getElementById('categoryModal').style.display = 'none';
    document.getElementById('subcategoryModal').style.display = 'none';
}

// =============================================
// UTILITY FUNCTIONS
// =============================================

function showToast(message, type = 'info') {
    // Crea il toast se non esiste
    let toast = document.getElementById('toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'toast';
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            z-index: 10000;
            max-width: 300px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            transform: translateX(100%);
            transition: transform 0.3s ease;
        `;
        document.body.appendChild(toast);
    }
    
    // Imposta il colore in base al tipo
    const colors = {
        success: '#4CAF50',
        error: '#F44336',
        warning: '#FF9800',
        info: '#2196F3'
    };
    
    toast.style.backgroundColor = colors[type] || colors.info;
    toast.textContent = message;
    
    // Mostra il toast
    setTimeout(() => {
        toast.style.transform = 'translateX(0)';
    }, 100);
    
    // Nascondi il toast dopo 3 secondi
    setTimeout(() => {
        toast.style.transform = 'translateX(100%)';
    }, 3000);
}

// Chiusura modal con ESC
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeAllModals();
    }
});