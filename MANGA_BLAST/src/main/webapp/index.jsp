<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/loading.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/toast.css?v=<%= System.currentTimeMillis() %>">
  <script src="scripts/toast.js" defer></script>
  <script src="scripts/loading.js" defer></script>
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

<div class="search-box">
  <div class="search-filters">
    <div class="filter-group">
      <label for="searchQuery">Cerca prodotti:</label>
      <input type="text" id="searchQuery" placeholder="Nome o codice prodotto..." />
    </div>
    
    <div class="filter-group">
      <label for="filterTipo">Categoria:</label>
      <select id="filterTipo">
        <option value="">Tutti i prodotti</option>
        <option value="manga">Manga</option>
        <option value="funko">Funko</option>
      </select>
    </div>
    
    <div class="filter-group price-range-group">
      <label>Range di prezzo (€):</label>
      <div class="price-inputs">
        <input type="number" id="prezzoMin" placeholder="0.00" step="0.01" min="0" max="200" />
        <span class="price-separator">-</span>
        <input type="number" id="prezzoMax" placeholder="200.00" step="0.01" min="0" max="200" />
      </div>
    </div>
    
    <div class="filter-group">
      <label for="sortBy">Ordina per:</label>
      <select id="sortBy">
        <option value="default">Predefinito</option>
        <option value="prezzo-asc">Prezzo: Basso → Alto</option>
        <option value="prezzo-desc">Prezzo: Alto → Basso</option>
        <option value="nome-asc">Nome: A → Z</option>
        <option value="nome-desc">Nome: Z → A</option>
      </select>
    </div>
  </div>
</div>

<!-- Container per i risultati della ricerca -->
<div id="prodottiContainer">
  <!-- I prodotti verranno caricati qui via AJAX -->
</div>

<jsp:include page="footer.jsp" />


</body>
</html>
