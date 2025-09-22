<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Categoria" %>

<%
    List<Categoria> categorie = (List<Categoria>) request.getAttribute("categorie");
    String emailAdmin = (String) session.getAttribute("admin");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Categorie - MangaBlast Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-prodotti-stile.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/gestione-categorie.css?v=<%= System.currentTimeMillis() %>">
    <script src="scripts/gestione-categorie.js" defer></script>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="admin-container">
    <div class="admin-navigation">
        <h1>🏷️ Gestione Categorie</h1>
        <div class="admin-links">
            <a href="admin-prodotti.jsp" class="admin-link">📦 Prodotti</a>
            <a href="GestioneCategorieServlet" class="admin-link active">🏷️ Categorie</a>
        </div>
        <p>Gestisci le categorie dei prodotti</p>
    </div>

    <% 
    String error = (String) request.getAttribute("error");
    if (error != null) {
    %>
    <div class="error-message">
        <strong>⚠️ Errore:</strong> <%= error %>
    </div>
    <% } %>

    <!-- Sezione Categorie -->
    <div class="categories-section">
        <div class="section-header">
            <h2>Categorie</h2>
            <button class="btn btn-primary" onclick="showAddCategoryModal()">
                ➕ Aggiungi Categoria
            </button>
        </div>

        <div class="categories-grid" id="categoriesGrid">
            <% if (categorie != null && !categorie.isEmpty()) { %>
                <% for (Categoria categoria : categorie) { %>
                <div class="category-card" data-id="<%= categoria.getId() %>">
                    <div class="category-header">
                        <div class="category-color" style="background-color: <%= categoria.getColore() %>"></div>
                        <h3><%= categoria.getNome() %></h3>
                        <div class="category-actions">
                            <button class="btn btn-sm btn-delete" onclick="deleteCategory(<%= categoria.getId() %>, '<%= categoria.getNome().replace("'", "\\'") %>')">🗑️</button>
                        </div>
                    </div>
                    <p class="category-description"><%= categoria.getDescrizione() %></p>
                    <div class="category-status">
                        <span class="status-badge <%= categoria.isAttiva() ? "active" : "inactive" %>">
                            <%= categoria.isAttiva() ? "Attiva" : "Inattiva" %>
                        </span>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <div class="empty-state">
                    <p>Nessuna categoria trovata</p>
                </div>
            <% } %>
        </div>
    </div>

</div>

<!-- Modal Aggiungi/Modifica Categoria -->
<div id="categoryModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Aggiungi Categoria</h3>
            <span class="close" onclick="closeAllModals()">&times;</span>
        </div>
        <form id="categoryForm" class="modal-form">
            
            <div class="form-group">
                <label for="categoryName">Nome Categoria *</label>
                <input type="text" id="categoryName" name="nome" required maxlength="100">
            </div>
            
            <div class="form-group">
                <label for="categoryDescription">Descrizione</label>
                <textarea id="categoryDescription" name="descrizione" rows="3" maxlength="500"></textarea>
            </div>
            
            <div class="form-group">
                <label for="categoryColor">Colore</label>
                <input type="color" id="categoryColor" name="colore" value="#FF6B35">
            </div>
            
            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" id="categoryActive" name="attiva" checked>
                    <span class="checkmark"></span>
                    Categoria attiva
                </label>
            </div>
            
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeAllModals()">Annulla</button>
                <button type="submit" class="btn btn-primary">Aggiungi</button>
            </div>
        </form>
    </div>
</div>


<!-- Toast per notifiche -->
<div id="toast" class="toast"></div>

<jsp:include page="footer.jsp" />

</body>
</html>
