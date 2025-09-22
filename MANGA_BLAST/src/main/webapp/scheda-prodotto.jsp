<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MangaDAO, model.FunkoDAO, model.Manga, model.Funko" %>
<%
    String tipo = request.getParameter("tipo");
    String id = request.getParameter("id");

    Object prodotto = null;
    String errore = null;

    try {
        if ("manga".equals(tipo)) {
            prodotto = new MangaDAO().doRetrieveByISBN(Long.parseLong(id));
        } else if ("funko".equals(tipo)) {
            prodotto = new FunkoDAO().doRetrieveByNumeroSerie(id);
        } else {
            errore = "Tipo prodotto non valido";
        }
    } catch (Exception e) {
        errore = "ID prodotto non valido";
        e.printStackTrace();
    }

    String emailUser = (String) session.getAttribute("user");
    String emailAdmin = (String) session.getAttribute("admin");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scheda Prodotto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/scheda.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/reviews.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/toast.css?v=<%= System.currentTimeMillis() %>">
    <script src="scripts/toast.js" defer></script>
    <script src="scripts/scheda-prodotto.js" defer></script>
    <script src="scripts/reviews.js" defer></script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="product-sheet">
    <% if (errore != null) { %>
    <div class="error-box">🚫 <%= errore %></div>
    <% } else if (prodotto != null) {
        String nome = tipo.equals("manga") ? ((Manga) prodotto).getNome() : ((Funko) prodotto).getNome();
        String descrizione = tipo.equals("manga") ? ((Manga) prodotto).getDescrizione() : ((Funko) prodotto).getDescrizione();
        String immagine = tipo.equals("manga") ? ((Manga) prodotto).getImmagine() : ((Funko) prodotto).getImmagine();
        String prezzo = tipo.equals("manga") ? ((Manga) prodotto).getPrezzo().toString() : ((Funko) prodotto).getPrezzo().toString();
    %>
    <div class="product-container">
        <div class="product-image">
            <img src="${pageContext.request.contextPath}/<%= immagine %>" alt="<%= nome %>" />
        </div>
        <div class="product-info">
            <h1><%= nome %></h1>
            <p class="description"><%= descrizione %></p>
            <p class="price-tag">💸 <strong><%= prezzo %> €</strong></p>

            <div class="action-buttons">
                <!-- ✅ Bottone solo per utenti normali (non admin) -->
                <% if (emailAdmin == null) { %>
                <button onclick="aggiungiCarrello('<%= id %>', '<%= tipo %>', '<%= nome %>', '<%= prezzo %>')">
                    Aggiungi al carrello
                </button>
                <% } %>

                <!-- ❤️ Solo utenti registrati -->
                <% if (emailUser != null) { %>
                <button onclick="aggiungiPreferiti('<%= id %>', '<%= tipo %>')">Aggiungi ai preferiti</button>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Sezione Recensioni -->
    <div class="reviews-section">
        <div class="reviews-header">
            <h2 class="reviews-title">Recensioni</h2>
            <div class="reviews-stats">
                <div class="rating-summary">
                    <span class="rating-average" id="ratingAverage">0.0</span>
                    <div class="rating-stars" id="ratingStars">
                        <span class="star empty">☆</span>
                        <span class="star empty">☆</span>
                        <span class="star empty">☆</span>
                        <span class="star empty">☆</span>
                        <span class="star empty">☆</span>
                    </div>
                    <span class="rating-count" id="ratingCount">0 recensioni</span>
                </div>
            </div>
        </div>
        
        <!-- Pulsante per aggiungere recensione (solo per utenti loggati, NON admin) -->
        <% if (emailUser != null && emailAdmin == null) { %>
        <button id="addReviewBtn" class="btn-review btn-review-primary" onclick="showReviewForm()">
            Lascia una recensione
        </button>
        
        <!-- Form per aggiungere recensione -->
        <form id="reviewForm" class="review-form" style="display: none;">
            <h3>Lascia una recensione</h3>
            
            <!-- Campi nascosti per ID e tipo prodotto -->
            <input type="hidden" name="id" value="<%= id %>">
            <input type="hidden" name="tipo" value="<%= tipo %>">
            <% if (emailUser != null) { %>
            <input type="hidden" id="loggedInUserEmail" value="<%= emailUser %>">
            <% } %>
            
            <div class="form-group">
                <label>Valutazione *</label>
                <div class="rating-input">
                    <div class="stars-container">
                        <span class="star empty" onclick="setRating(1)">☆</span>
                        <span class="star empty" onclick="setRating(2)">☆</span>
                        <span class="star empty" onclick="setRating(3)">☆</span>
                        <span class="star empty" onclick="setRating(4)">☆</span>
                        <span class="star empty" onclick="setRating(5)">☆</span>
                    </div>
                    <input type="hidden" id="ratingInput" name="voto" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="commentInput">Commento *</label>
                <textarea id="commentInput" name="commento" class="comment-textarea" 
                          placeholder="Condividi la tua esperienza con questo prodotto..." 
                          minlength="10" maxlength="1000" required></textarea>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn-review btn-review-secondary" onclick="hideReviewForm()">
                    Annulla
                </button>
                <button type="button" class="btn-review btn-review-primary" onclick="submitReview()">
                    Invia Recensione
                </button>
            </div>
        </form>
        <% } else if (emailAdmin == null) { %>
        <div class="review-message info">
            <p>Devi essere loggato per lasciare una recensione. <a href="login.jsp">Accedi</a> o <a href="signup.jsp">registrati</a>.</p>
        </div>
        <% } %>
        
        <!-- Campo nascosto per admin (sempre disponibile) -->
        <% if (emailAdmin != null) { %>
        <input type="hidden" id="isAdmin" value="true">
        <% } %>
        
        <!-- Lista recensioni -->
        <div class="reviews-list" id="reviewsList">
            <div class="empty-reviews">
                <h3>Caricamento recensioni...</h3>
            </div>
        </div>
    </div>
    
    <% } else { %>
    <div class="error-box">Prodotto non trovato</div>
    <% } %>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
