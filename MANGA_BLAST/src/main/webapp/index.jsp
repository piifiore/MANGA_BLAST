<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Manga" %>
<%@ page import="model.Funko" %>

<%
  String emailUser = (String) session.getAttribute("user");
  String nomeUser = "";
  if (emailUser != null && emailUser.contains("@")) {
    nomeUser = emailUser.substring(0, emailUser.indexOf("@"));
  }

  String query = request.getParameter("query");
  String tipo = request.getParameter("tipo");
  String prezzo = request.getParameter("prezzo");

  MangaDAO mangaDAO = new MangaDAO();
  FunkoDAO funkoDAO = new FunkoDAO();
  List<Manga> listaManga;
  List<Funko> listaFunko;

  if ("funko".equalsIgnoreCase(tipo)) {
    listaManga = java.util.Collections.emptyList();
    listaFunko = funkoDAO.searchFunko(query, prezzo);
  } else if ("manga".equalsIgnoreCase(tipo)) {
    listaManga = mangaDAO.searchManga(query, prezzo);
    listaFunko = java.util.Collections.emptyList();
  } else {
    listaManga = (query != null || prezzo != null) ? mangaDAO.searchManga(query, prezzo) : mangaDAO.getAllManga();
    listaFunko = (query != null || prezzo != null) ? funkoDAO.searchFunko(query, prezzo) : funkoDAO.getAllFunko();
  }
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>MangaBlast</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/index.css">
  <script src="scripts/index.js"></script>
  <script src="scripts/scheda-prodotto.js"></script>
  <script src="scripts/preferiti.js"></script>
</head>

<body>
<header>
  <jsp:include page="header.jsp" />
</header>

<% if (emailUser != null) { %>
<div class="welcome-message">
  <h2>👋 Ciao <%= nomeUser %>, benvenuto su MangaBlast!</h2>
</div>
<% } %>

<!-- 🔍 Form di ricerca -->
<div class="search-box">
  <form method="get" action="index.jsp">
    <input type="text" name="query" placeholder="Cerca per nome o codice..." value="<%= query != null ? query : "" %>" />
    <select name="tipo">
      <option value="">Tutti</option>
      <option value="manga" <%= "manga".equals(tipo) ? "selected" : "" %>>Manga</option>
      <option value="funko" <%= "funko".equals(tipo) ? "selected" : "" %>>Funko</option>
    </select>
    <select name="prezzo">
      <option value="">Prezzo</option>
      <option value="low" <%= "low".equals(prezzo) ? "selected" : "" %>>Fino a 10€</option>
      <option value="medium" <%= "medium".equals(prezzo) ? "selected" : "" %>>10€ - 25€</option>
      <option value="high" <%= "high".equals(prezzo) ? "selected" : "" %>>Oltre 25€</option>
    </select>
    <input type="submit" value="🔎 Cerca" />
  </form>
</div>

<hr>

<% if (!listaManga.isEmpty()) { %>
<h2 style="text-align:center;">Manga disponibili</h2>
<div class="product-grid">
  <% for (Manga m : listaManga) { %>
  <div class="product-card">
    <h3>
      <a href="scheda-prodotto.jsp?id=<%= m.getISBN() %>&tipo=manga"><%= m.getNome() %></a>
    </h3>
    <a href="scheda-prodotto.jsp?id=<%= m.getISBN() %>&tipo=manga">
      <img src="<%= m.getImmagine() %>" alt="Copertina manga" />
    </a>
    <p>Prezzo: <strong><%= m.getPrezzo() %>€</strong></p>
    <button onclick="aggiungiCarrello('<%= m.getISBN() %>', 'manga', '<%= m.getNome() %>', '<%= m.getPrezzo() %>')">🛒 Aggiungi</button>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= m.getISBN() %>', 'manga')">❤️ Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>
<% } %>

<% if (!listaFunko.isEmpty()) { %>
<hr>
<h2 style="text-align:center;">Funko disponibili</h2>
<div class="product-grid">
  <% for (Funko f : listaFunko) { %>
  <div class="product-card">
    <h3>
      <a href="scheda-prodotto.jsp?id=<%= f.getNumeroSerie() %>&tipo=funko"><%= f.getNome() %></a>
    </h3>
    <a href="scheda-prodotto.jsp?id=<%= f.getNumeroSerie() %>&tipo=funko">
      <img src="<%= f.getImmagine() %>" alt="Copertina funko" />
    </a>
    <p>Prezzo: <strong><%= f.getPrezzo() %>€</strong></p>
    <button onclick="aggiungiCarrello('<%= f.getNumeroSerie() %>', 'funko', '<%= f.getNome() %>', '<%= f.getPrezzo() %>')">🛒 Aggiungi</button>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= f.getNumeroSerie() %>', 'funko')">❤️ Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>
<% } %>

<jsp:include page="footer.jsp" />
</body>
</html>
