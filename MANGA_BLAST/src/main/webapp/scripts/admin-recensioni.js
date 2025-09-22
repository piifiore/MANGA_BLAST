// =============================================
// ADMIN RECENSIONI - JavaScript per gestione recensioni
// =============================================

document.addEventListener('DOMContentLoaded', function() {
    initializeFilters();
    updateStats();
});

// =============================================
// INIZIALIZZAZIONE FILTRI
// =============================================

function initializeFilters() {
    const statusFilter = document.getElementById('statusFilter');
    const productTypeFilter = document.getElementById('productTypeFilter');
    const ratingFilter = document.getElementById('ratingFilter');
    
    if (statusFilter) {
        statusFilter.addEventListener('change', filterReviews);
    }
    if (productTypeFilter) {
        productTypeFilter.addEventListener('change', filterReviews);
    }
    if (ratingFilter) {
        ratingFilter.addEventListener('change', filterReviews);
    }
}

// =============================================
// FILTRI RECENSIONI
// =============================================

function filterReviews() {
    const statusFilter = document.getElementById('statusFilter').value;
    const productTypeFilter = document.getElementById('productTypeFilter').value;
    const ratingFilter = document.getElementById('ratingFilter').value;
    
    const rows = document.querySelectorAll('#reviewsTableBody tr');
    
    rows.forEach(row => {
        const status = row.getAttribute('data-status');
        const productType = row.cells[3].textContent.trim();
        const rating = parseInt(row.querySelector('.rating-number').textContent.match(/\d+/)[0]);
        
        let showRow = true;
        
        // Filtro per stato
        if (statusFilter !== 'all' && status !== statusFilter) {
            showRow = false;
        }
        
        // Filtro per tipo prodotto
        if (productTypeFilter !== 'all' && productType !== productTypeFilter) {
            showRow = false;
        }
        
        // Filtro per valutazione
        if (ratingFilter !== 'all' && rating !== parseInt(ratingFilter)) {
            showRow = false;
        }
        
        row.style.display = showRow ? '' : 'none';
    });
    
    updateStats();
}

// =============================================
// AGGIORNAMENTO STATISTICHE
// =============================================

function updateStats() {
    const rows = document.querySelectorAll('#reviewsTableBody tr');
    let total = 0;
    let pending = 0;
    let approved = 0;
    
    rows.forEach(row => {
        if (row.style.display !== 'none') {
            total++;
            const status = row.getAttribute('data-status');
            if (status === 'pending') {
                pending++;
            } else if (status === 'approved') {
                approved++;
            }
        }
    });
    
    const totalElement = document.getElementById('totalReviews');
    const pendingElement = document.getElementById('pendingReviews');
    const approvedElement = document.getElementById('approvedReviews');
    
    if (totalElement) totalElement.textContent = total;
    if (pendingElement) pendingElement.textContent = pending;
    if (approvedElement) approvedElement.textContent = approved;
}

// =============================================
// MODERAZIONE RECENSIONI
// =============================================

function moderateReview(reviewId, approve) {
    const action = approve ? 'approve' : 'reject';
    const confirmMessage = approve ? 
        'Sei sicuro di voler approvare questa recensione?' : 
        'Sei sicuro di voler rifiutare questa recensione?';
    
    if (!confirm(confirmMessage)) {
        return;
    }
    
    const params = new URLSearchParams({
        action: 'moderateReview',
        reviewId: reviewId,
        approve: approve
    });
    
    fetch('GestioneRecensioniServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast(
                approve ? 'Recensione approvata con successo!' : 'Recensione rifiutata con successo!',
                'success'
            );
            
            // Aggiorna la riga nella tabella
            updateReviewRow(reviewId, approve);
            updateStats();
        } else {
            showToast(data.message || 'Errore nella moderazione della recensione', 'error');
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        showToast('Errore di connessione', 'error');
    });
}

// =============================================
// ELIMINAZIONE RECENSIONI
// =============================================

function deleteReview(reviewId) {
    if (!confirm('Sei sicuro di voler eliminare definitivamente questa recensione?')) {
        return;
    }
    
    const params = new URLSearchParams({
        action: 'deleteReview',
        reviewId: reviewId
    });
    
    fetch('GestioneRecensioniServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Recensione eliminata con successo!', 'success');
            
            // Rimuovi la riga dalla tabella
            const row = document.querySelector(`tr[data-review-id="${reviewId}"]`);
            if (row) {
                row.remove();
                updateStats();
            }
        } else {
            showToast(data.message || 'Errore nell\'eliminazione della recensione', 'error');
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        showToast('Errore di connessione', 'error');
    });
}

// =============================================
// AGGIORNAMENTO RIGA TABELLA
// =============================================

function updateReviewRow(reviewId, approve) {
    const row = document.querySelector(`tr[data-review-id="${reviewId}"]`);
    if (!row) return;
    
    const statusCell = row.cells[7];
    const actionsCell = row.cells[8];
    
    if (approve) {
        // Approva la recensione
        row.setAttribute('data-status', 'approved');
        statusCell.innerHTML = '<span class="status-badge approved">Approvata</span>';
        
        // Aggiorna i pulsanti
        actionsCell.innerHTML = `
            <button class="btn-action btn-reject" onclick="moderateReview(${reviewId}, false)">
                Rifiuta
            </button>
            <button class="btn-action btn-delete" onclick="deleteReview(${reviewId})">
                Elimina
            </button>
        `;
    } else {
        // Rifiuta la recensione
        row.setAttribute('data-status', 'rejected');
        statusCell.innerHTML = '<span class="status-badge rejected">Rifiutata</span>';
        
        // Aggiorna i pulsanti
        actionsCell.innerHTML = `
            <button class="btn-action btn-approve" onclick="moderateReview(${reviewId}, true)">
                Approva
            </button>
            <button class="btn-action btn-delete" onclick="deleteReview(${reviewId})">
                Elimina
            </button>
        `;
    }
}

// =============================================
// UTILITY FUNCTIONS
// =============================================

function showToast(message, type = 'info') {
    // Usa il sistema di toast globale se disponibile
    if (typeof window.showToast === 'function') {
        window.showToast(message, type);
    } else {
        // Fallback per alert
        alert(message);
    }
}
