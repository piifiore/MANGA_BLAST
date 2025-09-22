// =============================================
// SISTEMA GESTIONE RECENSIONI
// =============================================

let currentProductId = null;
let currentProductType = null;
let userReview = null;

// Inizializzazione
document.addEventListener('DOMContentLoaded', function() {
    initializeReviews();
});

function initializeReviews() {
    // Inizializza i rating stars
    initializeStarRatings();
    
    // Carica le recensioni se siamo in una pagina prodotto
    if (currentProductId && currentProductType) {
        loadReviews();
    }
}

// =============================================
// GESTIONE STELLE RATING
// =============================================

function initializeStarRatings() {
    // Stelle per il form di recensione
    const reviewStars = document.querySelectorAll('.review-form .stars-container .star');
    reviewStars.forEach((star, index) => {
        star.addEventListener('click', () => setRating(index + 1));
        star.addEventListener('mouseenter', () => highlightStars(index + 1));
    });
    
    const starsContainer = document.querySelector('.review-form .stars-container');
    if (starsContainer) {
        starsContainer.addEventListener('mouseleave', () => resetStarHighlight());
    }
}

function setRating(rating) {
    const stars = document.querySelectorAll('.review-form .stars-container .star');
    const hiddenInput = document.getElementById('ratingInput');
    
    // Aggiorna le stelle visive
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('filled');
            star.classList.remove('empty');
        } else {
            star.classList.add('empty');
            star.classList.remove('filled');
        }
    });
    
    // Aggiorna l'input nascosto
    if (hiddenInput) {
        hiddenInput.value = rating;
    }
    
    // Salva il rating corrente
    window.currentRating = rating;
}

function highlightStars(rating) {
    const stars = document.querySelectorAll('.review-form .stars-container .star');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('active');
        } else {
            star.classList.remove('active');
        }
    });
}

function resetStarHighlight() {
    const stars = document.querySelectorAll('.review-form .stars-container .star');
    const currentRating = window.currentRating || 0;
    
    stars.forEach((star, index) => {
        star.classList.remove('active');
        if (index < currentRating) {
            star.classList.add('filled');
            star.classList.remove('empty');
        } else {
            star.classList.add('empty');
            star.classList.remove('filled');
        }
    });
}

// =============================================
// GESTIONE FORM RECENSIONE
// =============================================

function showReviewForm() {
    const form = document.getElementById('reviewForm');
    if (form) {
        form.style.display = 'block';
        form.scrollIntoView({ behavior: 'smooth' });
    }
}

function hideReviewForm() {
    const form = document.getElementById('reviewForm');
    if (form) {
        form.style.display = 'none';
        resetReviewForm();
    }
}

function resetReviewForm() {
    // Reset stelle
    const stars = document.querySelectorAll('.review-form .stars-container .star');
    stars.forEach(star => {
        star.classList.remove('filled', 'active');
        star.classList.add('empty');
    });
    
    // Reset form
    const form = document.getElementById('reviewForm');
    if (form) {
        form.reset();
    }
    
    window.currentRating = 0;
}

function submitReview() {
    const rating = window.currentRating;
    const comment = document.getElementById('commentInput').value.trim();
    
    if (!rating || rating < 1 || rating > 5) {
        showMessage('Seleziona un voto da 1 a 5 stelle', 'error');
        return;
    }
    
    if (!comment) {
        showMessage('Inserisci un commento', 'error');
        return;
    }
    
    if (comment.length < 10) {
        showMessage('Il commento deve essere di almeno 10 caratteri', 'error');
        return;
    }
    
    const params = new URLSearchParams();
    params.append('action', 'addRecensione');
    params.append('idProdotto', currentProductId);
    params.append('tipoProdotto', currentProductType);
    params.append('voto', rating);
    params.append('commento', comment);
    
    console.log('submitReview - Invio richiesta con parametri:');
    console.log('  idProdotto:', currentProductId);
    console.log('  tipoProdotto:', currentProductType);
    console.log('  voto:', rating);
    console.log('  commento:', comment);
    console.log('submitReview - URLSearchParams:', params.toString());
    
    fetch('GestioneRecensioniServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        console.log('submitReview - Response status:', response.status);
        console.log('submitReview - Response headers:', response.headers);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            return response.text().then(text => {
                console.error('submitReview - Expected JSON but got:', text);
                throw new Error('Server returned non-JSON response');
            });
        }
        
        return response.json();
    })
    .then(data => {
        console.log('submitReview - Response data:', data);
        if (data.success) {
            showMessage('Recensione aggiunta con successo!', 'success');
            hideReviewForm();
            loadReviews(); // Ricarica le recensioni
        } else {
            console.error('submitReview - Server returned error:', data.message);
            showMessage(data.message || 'Errore nell\'aggiunta della recensione', 'error');
        }
    })
    .catch(error => {
        console.error('submitReview - Errore:', error);
        showMessage('Errore di connessione: ' + error.message, 'error');
    });
}

// =============================================
// CARICAMENTO RECENSIONI
// =============================================

function loadReviews() {
    if (!currentProductId || !currentProductType) {
        console.error('ID prodotto o tipo non definiti');
        return;
    }
    
    const params = new URLSearchParams({
        action: 'getRecensioni',
        idProdotto: currentProductId,
        tipoProdotto: currentProductType
    });
    
    fetch(`GestioneRecensioniServlet?${params}`)
    .then(response => {
        console.log('Response status:', response.status);
        console.log('Response headers:', response.headers);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            return response.text().then(text => {
                console.error('Expected JSON but got:', text);
                throw new Error('Server returned non-JSON response');
            });
        }
        
        return response.json();
    })
    .then(data => {
        if (data.success) {
            displayReviews(data);
            updateReviewStats(data);
            handleUserReview(data);
        } else {
            console.error('Errore nel caricamento recensioni:', data.message);
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        // Mostra messaggio di errore nella pagina
        const reviewsList = document.getElementById('reviewsList');
        if (reviewsList) {
            reviewsList.innerHTML = `
                <div class="empty-reviews">
                    <h3>Errore nel caricamento</h3>
                    <p>Impossibile caricare le recensioni. Errore: ${error.message}</p>
                </div>
            `;
        }
    });
}

function displayReviews(data) {
    const reviewsList = document.getElementById('reviewsList');
    if (!reviewsList) return;
    
    if (data.recensioni.length === 0) {
        reviewsList.innerHTML = `
            <div class="empty-reviews">
                <h3>Nessuna recensione</h3>
                <p>Sii il primo a recensire questo prodotto!</p>
            </div>
        `;
        return;
    }
    
    reviewsList.innerHTML = data.recensioni.map(review => `
        <div class="review-item">
            <div class="review-header">
                <div class="review-user">
                    <div class="user-avatar">
                        ${review.emailUtente.charAt(0).toUpperCase()}
                    </div>
                    <div class="user-info">
                        <h4>${review.emailUtente}</h4>
                        <div class="review-date">${formatDate(review.dataCreazione)}</div>
                    </div>
                </div>
                <div class="review-rating">
                    <div class="stars-container">
                        ${generateStarsHTML(review.voto)}
                    </div>
                </div>
            </div>
            <div class="review-content">
                ${review.commento}
            </div>
        </div>
    `).join('');
}

function updateReviewStats(data) {
    const averageElement = document.getElementById('ratingAverage');
    const countElement = document.getElementById('ratingCount');
    const starsElement = document.getElementById('ratingStars');
    
    if (averageElement) {
        averageElement.textContent = data.mediaVoti.toFixed(1);
    }
    
    if (countElement) {
        countElement.textContent = `${data.numeroRecensioni} recensioni`;
    }
    
    if (starsElement) {
        starsElement.innerHTML = generateStarsHTML(Math.round(data.mediaVoti));
    }
}

function handleUserReview(data) {
    const reviewForm = document.getElementById('reviewForm');
    const addReviewBtn = document.getElementById('addReviewBtn');
    
    if (data.hasReviewed && data.userReview) {
        userReview = data.userReview;
        
        // Nascondi il form e il pulsante aggiungi
        if (reviewForm) reviewForm.style.display = 'none';
        if (addReviewBtn) addReviewBtn.style.display = 'none';
        
        // Mostra la recensione dell'utente
        showUserReview(data.userReview);
    } else {
        // Mostra il pulsante per aggiungere recensione
        if (addReviewBtn) addReviewBtn.style.display = 'block';
        if (reviewForm) reviewForm.style.display = 'none';
    }
}

function showUserReview(review) {
    const reviewsList = document.getElementById('reviewsList');
    if (!reviewsList) return;
    
    // Controlla se review è valida
    if (!review || !review.emailUtente) {
        console.error('showUserReview - Review o emailUtente non valida:', review);
        return;
    }
    
    const userReviewHTML = `
        <div class="review-item" id="userReview">
            <div class="review-header">
                <div class="review-user">
                    <div class="user-avatar">
                        ${review.emailUtente.charAt(0).toUpperCase()}
                    </div>
                    <div class="user-info">
                        <h4>La tua recensione</h4>
                        <div class="review-date">${formatDate(review.dataCreazione)}</div>
                    </div>
                </div>
                <div class="review-rating">
                    <div class="stars-container">
                        ${generateStarsHTML(review.voto)}
                    </div>
                </div>
            </div>
            <div class="review-content">
                ${review.commento}
            </div>
            <div class="review-actions">
                <button class="btn-review-action btn-edit" onclick="editUserReview(${review.id})">
                    Modifica
                </button>
                <button class="btn-review-action btn-delete" onclick="deleteUserReview(${review.id})">
                    Elimina
                </button>
            </div>
        </div>
    `;
    
    // Inserisci la recensione dell'utente all'inizio
    reviewsList.insertAdjacentHTML('afterbegin', userReviewHTML);
}

// =============================================
// GESTIONE RECENSIONE UTENTE
// =============================================

function editUserReview(reviewId) {
    // Implementa la modifica della recensione
    const newRating = prompt('Nuovo voto (1-5):');
    const newComment = prompt('Nuovo commento:');
    
    if (newRating && newComment) {
        const formData = new FormData();
        formData.append('action', 'updateRecensione');
        formData.append('id', reviewId);
        formData.append('voto', newRating);
        formData.append('commento', newComment);
        
        fetch('GestioneRecensioniServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showMessage('Recensione aggiornata con successo!', 'success');
                loadReviews();
            } else {
                showMessage(data.message || 'Errore nell\'aggiornamento', 'error');
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            showMessage('Errore di connessione', 'error');
        });
    }
}

function deleteUserReview(reviewId) {
    if (confirm('Sei sicuro di voler eliminare la tua recensione?')) {
        const formData = new FormData();
        formData.append('action', 'deleteRecensione');
        formData.append('id', reviewId);
        
        fetch('GestioneRecensioniServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showMessage('Recensione eliminata con successo!', 'success');
                loadReviews();
            } else {
                showMessage(data.message || 'Errore nell\'eliminazione', 'error');
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            showMessage('Errore di connessione', 'error');
        });
    }
}

// =============================================
// FUNZIONI UTILITY
// =============================================

function generateStarsHTML(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= rating) {
            stars += '<span class="star filled">★</span>';
        } else {
            stars += '<span class="star empty">☆</span>';
        }
    }
    return stars;
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('it-IT', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

function showMessage(message, type) {
    // Usa il sistema di toast esistente se disponibile
    if (typeof showToast === 'function') {
        showToast(message, type, { duration: 3000 });
    } else {
        // Fallback: alert semplice
        alert(message);
    }
}

// =============================================
// FUNZIONI GLOBALI (chiamate dalle pagine)
// =============================================

function initProductReviews(productId, productType) {
    currentProductId = productId;
    currentProductType = productType;
    loadReviews();
}

function loadUserReviews() {
    console.log('loadUserReviews - Inizio caricamento recensioni utente');
    
    fetch('GestioneRecensioniServlet?action=getRecensioniUtente')
    .then(response => {
        console.log('loadUserReviews - Response status:', response.status);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('loadUserReviews - Response data:', data);
        if (data.success && data.recensioni) {
            displayUserReviews(data.recensioni);
        } else {
            console.error('loadUserReviews - Dati non validi:', data);
            displayUserReviews([]);
        }
    })
    .catch(error => {
        console.error('loadUserReviews - Errore:', error);
        displayUserReviews([]);
    });
}

async function displayUserReviews(reviews) {
    const container = document.getElementById('userReviewsContainer');
    if (!container) return;
    
    if (reviews.length === 0) {
        container.innerHTML = `
            <div class="empty-reviews">
                <h3>Nessuna recensione</h3>
                <p>Non hai ancora recensito nessun prodotto.</p>
            </div>
        `;
        return;
    }
    
    // Carica i nomi dei prodotti per tutte le recensioni
    const reviewsWithNames = await Promise.all(
        reviews.map(async (review) => {
            const productName = await fetchProductName(review.tipoProdotto, review.idProdotto);
            return { ...review, productName };
        })
    );
    
    container.innerHTML = reviewsWithNames.map(review => `
        <div class="review-item">
            <div class="review-header">
                <div class="review-user">
                    <div class="user-avatar">
                        ${review.emailUtente ? review.emailUtente.charAt(0).toUpperCase() : 'U'}
                    </div>
                    <div class="user-info">
                        <h4>${review.productName}</h4>
                        <div class="review-date">${formatDate(review.dataCreazione)}</div>
                    </div>
                </div>
                <div class="review-rating">
                    <div class="stars-container">
                        ${generateStarsHTML(review.voto)}
                    </div>
                </div>
            </div>
            <div class="review-content">
                ${review.commento}
            </div>
            <div class="review-actions">
                <a href="scheda-prodotto.jsp?id=${review.idProdotto}&tipo=${review.tipoProdotto}" 
                   class="btn-review-action btn-edit">
                    Vai al prodotto
                </a>
            </div>
        </div>
    `).join('');
}

function getProductName(tipo, id) {
    // Questa funzione dovrebbe essere implementata per ottenere il nome del prodotto
    // Per ora restituisce un placeholder
    return `${tipo.charAt(0).toUpperCase() + tipo.slice(1)} #${id}`;
}

// Funzione per ottenere il nome del prodotto dal server
async function fetchProductName(tipo, id) {
    try {
        const params = new URLSearchParams({
            action: 'getProductName',
            idProdotto: id,
            tipoProdotto: tipo
        });
        
        const response = await fetch(`GestioneRecensioniServlet?${params}`);
        const data = await response.json();
        
        if (data.success) {
            return data.nome;
        } else {
            return getProductName(tipo, id); // Fallback
        }
    } catch (error) {
        console.error('Errore nel recupero nome prodotto:', error);
        return getProductName(tipo, id); // Fallback
    }
}