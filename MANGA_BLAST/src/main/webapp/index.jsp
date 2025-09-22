<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Categoria" %>

<%
  String emailUser = (String) session.getAttribute("user");
  String nomeUser = "";
  String emailAdmin = (String) session.getAttribute("admin");
  String nomeAdmin = "";
  if (emailUser != null && emailUser.contains("@")) {
    nomeUser = emailUser.substring(0, emailUser.indexOf("@"));
  }
  if (emailAdmin != null && emailAdmin.contains("@")) {
    nomeAdmin = emailAdmin.substring(0, emailAdmin.indexOf("@"));
  }
%>

<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MangaBlast - Il tuo negozio online di Manga e Funko Pop</title>
  
  <!-- SEO Meta Tags -->
  <meta name="description" content="Scopri la più vasta collezione di Manga e Funko Pop su MangaBlast. Acquista online i tuoi fumetti e action figure preferiti con spedizione veloce e prezzi competitivi.">
  <meta name="keywords" content="manga, funko pop, fumetti, action figure, anime, negozio online, acquisti online, spedizione">
  <meta name="author" content="MangaBlast">
  <meta name="robots" content="index, follow">
  
  <!-- Open Graph Meta Tags -->
  <meta property="og:title" content="MangaBlast - Il tuo negozio online di Manga e Funko Pop">
  <meta property="og:description" content="Scopri la più vasta collezione di Manga e Funko Pop. Acquista online con spedizione veloce e prezzi competitivi.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="<%= request.getRequestURL() %>">
  <meta property="og:site_name" content="MangaBlast">
  
  <!-- Twitter Card Meta Tags -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="MangaBlast - Il tuo negozio online di Manga e Funko Pop">
  <meta name="twitter:description" content="Scopri la più vasta collezione di Manga e Funko Pop. Acquista online con spedizione veloce e prezzi competitivi.">
  
  <!-- Favicon -->
  <link rel="icon" type="image/x-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='60' fill='%23EF5350'>MB</text></svg>">
  
  <!-- Canonical URL -->
  <link rel="canonical" href="<%= request.getRequestURL() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/index.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/ecommerce-layout.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/loading.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/toast.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/theme.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/autocomplete.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/animations.css?v=<%= System.currentTimeMillis() %>">
  <script src="scripts/toast.js" defer></script>
  <script src="scripts/loading.js" defer></script>
  <script src="scripts/theme.js" defer></script>
  <script src="scripts/autocomplete.js" defer></script>
  <script src="scripts/ricerca-prodotti.js" defer></script>
</head>

<body>

<% if (emailUser != null) { %>
<div class="welcome-message">
  Benvenuto, <strong><%= nomeUser %></strong> su <strong>MangaBlast</strong>
</div>
<% } else if (emailAdmin != null) { %>
<div class="welcome-message">
  Ciao <strong><%= nomeAdmin %></strong>!
</div>
<% } %>

<!-- Header con barra di ricerca -->
<div class="search-header">
  <div class="search-container">
    <h1 class="page-title">Catalogo Prodotti</h1>
    <div class="search-bar">
      <input type="text" id="searchQuery" placeholder="Cerca manga, funko, personaggi..." class="search-input" />
      <button type="button" class="search-btn" onclick="caricaProdotti()">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"></circle>
          <path d="m21 21-4.35-4.35"></path>
        </svg>
      </button>
    </div>
  </div>
</div>

<!-- Layout principale con sidebar filtri -->
<div class="main-layout">
  <!-- Sidebar filtri -->
  <div class="filters-sidebar">
    <h3 class="filters-title">Filtri</h3>
    
    <!-- Filtro Tipo -->
    <div class="filter-section">
      <h4 class="filter-label">Tipo Prodotto</h4>
      <div class="filter-options">
        <label class="filter-option">
          <input type="radio" name="filterTipo" value="" checked>
          <span>Tutti</span>
        </label>
        <label class="filter-option">
          <input type="radio" name="filterTipo" value="manga">
          <span>Manga</span>
        </label>
        <label class="filter-option">
          <input type="radio" name="filterTipo" value="funko">
          <span>Funko</span>
        </label>
      </div>
    </div>

    <!-- Filtro Categoria -->
    <div class="filter-section">
      <h4 class="filter-label">Categoria</h4>
      <div class="filter-options">
        <label class="filter-option">
          <input type="radio" name="filterCategoria" value="" checked>
          <span>Tutte</span>
        </label>
        <% 
        List<Categoria> categorie = (List<Categoria>) request.getAttribute("categorie");
        if (categorie != null && !categorie.isEmpty()) {
            for (Categoria categoria : categorie) {
        %>
        <label class="filter-option">
          <input type="radio" name="filterCategoria" value="<%= categoria.getId() %>">
          <span style="color: <%= categoria.getColore() %>"><%= categoria.getNome() %></span>
        </label>
        <% 
            }
        } else {
        %>
        <label class="filter-option">
          <span>Caricamento...</span>
        </label>
        <% } %>
      </div>
    </div>

    <!-- Filtro Prezzo -->
    <div class="filter-section">
      <h4 class="filter-label">Range di Prezzo (€)</h4>
      <div class="price-range">
        <div class="price-inputs">
          <input type="number" id="prezzoMin" placeholder="Min" step="0.01" min="0" max="200" />
          <span class="price-separator">-</span>
          <input type="number" id="prezzoMax" placeholder="Max" step="0.01" min="0" max="200" />
        </div>
      </div>
    </div>

    <!-- Ordinamento -->
    <div class="filter-section">
      <h4 class="filter-label">Ordina per</h4>
      <select id="sortBy" class="sort-select">
        <option value="default">Predefinito</option>
        <option value="prezzo-asc">Prezzo: Basso → Alto</option>
        <option value="prezzo-desc">Prezzo: Alto → Basso</option>
        <option value="nome-asc">Nome: A → Z</option>
        <option value="nome-desc">Nome: Z → A</option>
      </select>
    </div>

    <!-- Pulsante applica filtri -->
    <button type="button" class="apply-filters-btn" onclick="caricaProdotti()">
      Applica Filtri
    </button>
  </div>

  <!-- Contenuto principale -->
  <div class="main-content">
    <div id="prodottiContainer">
      <!-- I prodotti verranno caricati qui via AJAX -->
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />


</body>
</html>
