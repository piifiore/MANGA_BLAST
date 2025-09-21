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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta charset="UTF-8">
  <title>MangaBlast</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/index.css?v=<%= System.currentTimeMillis() %>">
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
      <label for="searchQuery">🔍 Cerca prodotti:</label>
      <input type="text" id="searchQuery" placeholder="Nome o codice prodotto..." />
    </div>
    
    <div class="filter-group">
      <label for="filterTipo">📚 Categoria:</label>
      <select id="filterTipo">
        <option value="">Tutti i prodotti</option>
        <option value="manga">Manga</option>
        <option value="funko">Funko</option>
      </select>
    </div>
    
    <div class="filter-group price-range-group">
      <label>💰 Range di prezzo (€):</label>
      <div class="price-inputs">
        <input type="number" id="prezzoMin" placeholder="0.00" step="0.01" min="0" max="200" />
        <span class="price-separator">-</span>
        <input type="number" id="prezzoMax" placeholder="200.00" step="0.01" min="0" max="200" />
      </div>
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
