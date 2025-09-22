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
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scheda Prodotto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/scheda.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/reviews.css?v=<%= System.currentTimeMillis() %>">
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
                <!-- ✅ Bottone sempre visibile -->
                <button onclick="aggiungiCarrello('<%= id %>', '<%= tipo %>', '<%= nome %>', '<%= prezzo %>')">
                    Aggiungi al carrello
                </button>

                <!-- ❤️ Solo utenti registrati -->
                <% if (emailUser != null) { %>
                <button onclick="aggiungiPreferiti('<%= id %>', '<%= tipo %>')">Aggiungi ai preferiti</button>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Sezione Recensioni -->
    <div class="reviews-section" id="reviewsSection">
        <h2>Recensioni</h2>
        
        <!-- Form per aggiungere recensione (solo per utenti loggati) -->
        <% if (emailUser != null) { %>
        <div class="review-form-container">
            <h3>Lascia una recensione</h3>
            <form id="reviewForm" class="review-form">
                <input type="hidden" id="productId" value="<%= id %>">
                <input type="hidden" id="productType" value="<%= tipo %>">
                
                <div class="rating-input">
                    <label>Valutazione:</label>
                    <div class="star-rating" id="starRating">
                        <span class="star" data-rating="1">★</span>
                        <span class="star" data-rating="2">★</span>
                        <span class="star" data-rating="3">★</span>
                        <span class="star" data-rating="4">★</span>
                        <span class="star" data-rating="5">★</span>
                    </div>
                    <input type="hidden" id="rating" name="rating" required>
                </div>
                
                <div class="form-group">
                    <label for="reviewTitle">Titolo recensione:</label>
                    <input type="text" id="reviewTitle" name="title" maxlength="255" placeholder="Inserisci un titolo...">
                </div>
                
                <div class="form-group">
                    <label for="reviewComment">Commento:</label>
                    <textarea id="reviewComment" name="comment" rows="4" placeholder="Condividi la tua esperienza con questo prodotto..."></textarea>
                </div>
                
                <button type="submit" class="submit-review-btn">Invia Recensione</button>
            </form>
        </div>
        <% } else { %>
        <div class="login-prompt">
            <p>Devi essere loggato per lasciare una recensione. <a href="login.jsp">Accedi</a> o <a href="signup.jsp">registrati</a>.</p>
        </div>
        <% } %>
        
        <!-- Statistiche recensioni -->
        <div class="rating-stats" id="ratingStats">
            <div class="loading-stats">Caricamento statistiche...</div>
        </div>
        
        <!-- Lista recensioni -->
        <div class="reviews-list" id="reviewsList">
            <div class="loading-reviews">Caricamento recensioni...</div>
        </div>
    </div>
    
    <% } else { %>
    <div class="error-box">Prodotto non trovato</div>
    <% } %>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
