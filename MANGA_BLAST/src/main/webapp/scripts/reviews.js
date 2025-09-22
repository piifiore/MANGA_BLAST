/**
 * 🌟 Sistema Recensioni - MangaBlast
 * Gestisce recensioni, rating e interazioni utente
 */

class ReviewsManager {
    constructor() {
        this.currentProductId = null;
        this.currentProductType = null;
        this.currentUser = null;
        this.reviews = [];
        this.stats = null;
        this.init();
    }

    init() {
        console.log('🌟 ReviewsManager inizializzato');
        this.setupEventListeners();
        this.initializeProductData();
    }
    
    initializeProductData() {
        // Ottieni i dati del prodotto dalla pagina
        const productIdElement = document.getElementById('productId');
        const productTypeElement = document.getElementById('productType');
        
        if (productIdElement && productTypeElement) {
            this.currentProductId = productIdElement.value;
            this.currentProductType = productTypeElement.value;
            
            console.log('📦 Prodotto inizializzato:', {
                id: this.currentProductId,
                type: this.currentProductType
            });
            
            // Carica le recensioni e statistiche per questo prodotto
            this.loadReviews();
            this.loadStats();
        }
    }

    setupEventListeners() {
        // Event listener per il pulsante aggiungi recensione
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('add-review-btn')) {
                this.showReviewForm();
            }
            
            if (e.target.classList.contains('rating-star')) {
                this.handleStarClick(e.target);
            }
            
            if (e.target.classList.contains('like-btn')) {
                this.handleLike(e.target);
            }
            
            if (e.target.classList.contains('dislike-btn')) {
                this.handleDislike(e.target);
            }
            
            if (e.target.classList.contains('edit-review-btn')) {
                this.editReview(e.target);
            }
            
            if (e.target.classList.contains('delete-review-btn')) {
                this.deleteReview(e.target);
            }
        });

        // Event listener per il form recensione
        document.addEventListener('submit', (e) => {
            if (e.target.classList.contains('review-form')) {
                e.preventDefault();
                this.submitReview(e.target);
            }
        });
    }

    // Inizializza il sistema per un prodotto
    initForProduct(productId, productType, userEmail = null) {
        this.currentProductId = productId;
        this.currentProductType = productType;
        this.currentUser = userEmail;
        
        console.log(`🌟 Inizializzazione recensioni per prodotto ${productId} (${productType})`);
        
        this.loadReviews();
        this.loadStats();
    }

    // Carica le recensioni
    async loadReviews() {
        try {
            const response = await fetch(`RecensioniServlet?action=getRecensioni&idProdotto=${this.currentProductId}&tipoProdotto=${this.currentProductType}`);
            const data = await response.json();
            
            if (response.ok) {
                this.reviews = data;
                this.renderReviews();
            } else {
                console.error('Errore nel caricamento recensioni:', data.error);
                this.showError('Errore nel caricamento delle recensioni');
            }
        } catch (error) {
            console.error('Errore nella richiesta recensioni:', error);
            this.showError('Errore di connessione');
        }
    }

    // Carica le statistiche
    async loadStats() {
        try {
            const response = await fetch(`RecensioniServlet?action=getStatistiche&idProdotto=${this.currentProductId}&tipoProdotto=${this.currentProductType}`);
            const data = await response.json();
            
            if (response.ok) {
                this.stats = data;
                this.renderStats();
            } else {
                console.error('Errore nel caricamento statistiche:', data.error);
            }
        } catch (error) {
            console.error('Errore nella richiesta statistiche:', error);
        }
    }

    // Renderizza le statistiche
    renderStats() {
        const statsContainer = document.getElementById('ratingStats');
        if (!statsContainer || !this.stats) return;

        const ratingMedio = this.stats.ratingMedio || 0;
        const totaleRecensioni = this.stats.totaleRecensioni || 0;

        statsContainer.innerHTML = `
            <div class="rating-overview">
                <div class="rating-score">${ratingMedio.toFixed(1)}</div>
                <div class="rating-stars-display">${this.generateStars(Math.round(ratingMedio))}</div>
                <div class="rating-count">${totaleRecensioni} recensioni</div>
            </div>
            <div class="rating-breakdown">
                ${this.generateRatingBars()}
            </div>
        `;
    }

    // Genera le barre di rating
    generateRatingBars() {
        const total = this.stats.totaleRecensioni || 1;
        const ratings = [
            { stars: 5, count: this.stats.recensioni5Stelle || 0 },
            { stars: 4, count: this.stats.recensioni4Stelle || 0 },
            { stars: 3, count: this.stats.recensioni3Stelle || 0 },
            { stars: 2, count: this.stats.recensioni2Stelle || 0 },
            { stars: 1, count: this.stats.recensioni1Stella || 0 }
        ];

        return ratings.map(rating => {
            const percentage = (rating.count / total) * 100;
            return `
                <div class="rating-bar">
                    <span class="rating-label">${rating.stars}★</span>
                    <div class="rating-progress">
                        <div class="rating-progress-fill" style="width: ${percentage}%"></div>
                    </div>
                    <span class="rating-number">${rating.count}</span>
                </div>
            `;
        }).join('');
    }

    // Renderizza le recensioni
    renderReviews() {
        const reviewsContainer = document.getElementById('reviewsList');
        if (!reviewsContainer) return;

        if (this.reviews.length === 0) {
            reviewsContainer.innerHTML = `
                <div class="reviews-empty">
                    <div class="reviews-empty-icon">⭐</div>
                    <h3>Nessuna recensione</h3>
                    <p>Sii il primo a lasciare una recensione per questo prodotto!</p>
                </div>
            `;
            return;
        }

        reviewsContainer.innerHTML = this.reviews.map(review => this.renderReviewItem(review)).join('');
    }

    // Renderizza una singola recensione
    renderReviewItem(review) {
        const userInitial = review.emailUtente.charAt(0).toUpperCase();
        const formattedDate = new Date(review.dataRecensione).toLocaleDateString('it-IT');
        const canEdit = this.currentUser === review.emailUtente;
        
        return `
            <div class="review-item" data-review-id="${review.id}">
                <div class="review-header">
                    <div class="review-user">
                        <div class="user-avatar">${userInitial}</div>
                        <div class="user-info">
                            <h4>${this.maskEmail(review.emailUtente)}</h4>
                            <p>${formattedDate}</p>
                        </div>
                    </div>
                    <div class="review-rating">
                        <div class="review-stars">${this.generateStars(review.rating)}</div>
                    </div>
                </div>
                <div class="review-content">
                    <h5 class="review-title">${review.titolo || 'Recensione'}</h5>
                    <p class="review-comment">${review.commento}</p>
                </div>
                <div class="review-actions">
                    <div class="review-likes">
                        <button class="like-btn" data-review-id="${review.id}">
                            👍 ${review.likeCount}
                        </button>
                        <button class="dislike-btn" data-review-id="${review.id}">
                            👎 ${review.dislikeCount}
                        </button>
                    </div>
                    ${canEdit ? `
                        <div class="review-edit">
                            <button class="edit-btn edit-review-btn" data-review-id="${review.id}">Modifica</button>
                            <button class="delete-btn delete-review-btn" data-review-id="${review.id}">Elimina</button>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    // Mostra il form recensione
    showReviewForm() {
        if (!this.currentUser) {
            this.showError('Devi essere loggato per lasciare una recensione');
            return;
        }

        const form = document.getElementById('review-form');
        if (form) {
            form.classList.add('active');
            form.scrollIntoView({ behavior: 'smooth' });
        }
    }

    // Gestisce il click sulle stelle
    handleStarClick(starElement) {
        const rating = parseInt(starElement.dataset.rating);
        this.setRating(rating);
    }

    // Imposta il rating
    setRating(rating) {
        const stars = document.querySelectorAll('.rating-star');
        stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.add('active');
            } else {
                star.classList.remove('active');
            }
        });
        
        // Salva il rating nel form
        const ratingInput = document.getElementById('rating-input');
        if (ratingInput) {
            ratingInput.value = rating;
        }
    }

    // Invia la recensione
    async submitReview(form) {
        const formData = new FormData(form);
        const rating = parseInt(formData.get('rating'));
        const titolo = formData.get('titolo');
        const commento = formData.get('commento');

        if (!rating || rating < 1 || rating > 5) {
            this.showError('Seleziona un rating valido');
            return;
        }

        if (!commento.trim()) {
            this.showError('Inserisci un commento');
            return;
        }

        try {
            const response = await fetch('RecensioniServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    action: 'addRecensione',
                    idProdotto: this.currentProductId,
                    tipoProdotto: this.currentProductType,
                    rating: rating,
                    titolo: titolo,
                    commento: commento
                })
            });

            const data = await response.json();

            if (response.ok && data.success) {
                this.showSuccess('Recensione aggiunta con successo!');
                form.reset();
                form.classList.remove('active');
                this.loadReviews();
                this.loadStats();
            } else {
                this.showError(data.error || 'Errore nell\'aggiunta della recensione');
            }
        } catch (error) {
            console.error('Errore nell\'invio recensione:', error);
            this.showError('Errore di connessione');
        }
    }

    // Gestisce i like
    async handleLike(button) {
        if (!this.currentUser) {
            this.showError('Devi essere loggato per votare');
            return;
        }

        const reviewId = button.dataset.reviewId;
        await this.toggleLike(reviewId, 'like');
    }

    // Gestisce i dislike
    async handleDislike(button) {
        if (!this.currentUser) {
            this.showError('Devi essere loggato per votare');
            return;
        }

        const reviewId = button.dataset.reviewId;
        await this.toggleLike(reviewId, 'dislike');
    }

    // Toggle like/dislike
    async toggleLike(reviewId, tipo) {
        try {
            const response = await fetch('RecensioniServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    action: 'likeRecensione',
                    idRecensione: reviewId,
                    tipo: tipo
                })
            });

            const data = await response.json();

            if (response.ok && data.success) {
                this.loadReviews(); // Ricarica per aggiornare i contatori
            } else {
                this.showError(data.error || 'Errore nel voto');
            }
        } catch (error) {
            console.error('Errore nel toggle like:', error);
            this.showError('Errore di connessione');
        }
    }

    // Modifica recensione
    editReview(button) {
        const reviewId = button.dataset.reviewId;
        const review = this.reviews.find(r => r.id == reviewId);
        
        if (!review) return;

        // Popola il form con i dati esistenti
        const form = document.getElementById('review-form');
        if (form) {
            form.querySelector('[name="rating"]').value = review.rating;
            form.querySelector('[name="titolo"]').value = review.titolo || '';
            form.querySelector('[name="commento"]').value = review.commento;
            
            // Imposta le stelle
            this.setRating(review.rating);
            
            // Mostra il form
            form.classList.add('active');
            form.scrollIntoView({ behavior: 'smooth' });
            
            // Aggiungi flag per modifica
            form.dataset.editId = reviewId;
        }
    }

    // Elimina recensione
    async deleteReview(button) {
        if (!confirm('Sei sicuro di voler eliminare questa recensione?')) {
            return;
        }

        const reviewId = button.dataset.reviewId;

        try {
            const response = await fetch('RecensioniServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    action: 'deleteRecensione',
                    idRecensione: reviewId
                })
            });

            const data = await response.json();

            if (response.ok && data.success) {
                this.showSuccess('Recensione eliminata con successo!');
                this.loadReviews();
                this.loadStats();
            } else {
                this.showError(data.error || 'Errore nell\'eliminazione della recensione');
            }
        } catch (error) {
            console.error('Errore nell\'eliminazione recensione:', error);
            this.showError('Errore di connessione');
        }
    }

    // Utility functions
    generateStars(rating) {
        return '★'.repeat(rating) + '☆'.repeat(5 - rating);
    }

    maskEmail(email) {
        const [username, domain] = email.split('@');
        const maskedUsername = username.charAt(0) + '*'.repeat(username.length - 2) + username.charAt(username.length - 1);
        return `${maskedUsername}@${domain}`;
    }

    showSuccess(message) {
        if (typeof showToast === 'function') {
            showToast(message, 'success');
        } else {
            alert(message);
        }
    }

    showError(message) {
        if (typeof showToast === 'function') {
            showToast(message, 'error');
        } else {
            alert(message);
        }
    }
}

// Inizializza il sistema recensioni
const reviewsManager = new ReviewsManager();

// Esponi globalmente per l'uso
window.reviewsManager = reviewsManager;
