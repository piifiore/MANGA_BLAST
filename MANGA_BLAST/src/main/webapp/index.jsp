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

  MangaDAO mangaDAO = new MangaDAO();
  FunkoDAO funkoDAO = new FunkoDAO();
  List<Manga> listaManga = mangaDAO.getAllManga();
  List<Funko> listaFunko = funkoDAO.getAllFunko();
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>MangaBlast</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/index.css">
  <script src="scripts/index.js."></script>
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

<hr>

<h2 style="text-align:center;">Manga disponibili</h2>
<div class="product-grid">
  <% for (Manga m : listaManga) { %>
  <div class="product-card">
    <h3>
      <a href="${pageContext.request.contextPath}/scheda-prodotto.jsp?id=<%= m.getISBN() %>&tipo=manga">
        <%= m.getNome() %>
      </a>
    </h3>
    <a href="${pageContext.request.contextPath}/scheda-prodotto.jsp?id=<%= m.getISBN() %>&tipo=manga">
      <img src="${pageContext.request.contextPath}/<%= m.getImmagine() %>" alt="Copertina manga" />
    </a>
    <p>Prezzo: <strong><%= m.getPrezzo() %>€</strong></p>
    <button onclick="aggiungiCarrello('<%= m.getISBN() %>', 'manga', '<%= m.getNome() %>', '<%= m.getPrezzo() %>')">🛒 Aggiungi</button>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= m.getISBN() %>', 'manga')">❤️ Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>

<hr>

<h2 style="text-align:center;">Funko disponibili</h2>
<div class="product-grid">
  <% for (Funko f : listaFunko) { %>
  <div class="product-card">
    <h3>
      <a href="${pageContext.request.contextPath}/scheda-prodotto.jsp?id=<%= f.getNumeroSerie() %>&tipo=funko">
        <%= f.getNome() %>
      </a>
    </h3>
    <a href="${pageContext.request.contextPath}/scheda-prodotto.jsp?id=<%= f.getNumeroSerie() %>&tipo=funko">
      <img src="${pageContext.request.contextPath}/<%= f.getImmagine() %>" alt="Copertina funko" />
    </a>
    <p>Prezzo: <strong><%= f.getPrezzo() %>€</strong></p>
    <button onclick="aggiungiCarrello('<%= f.getNumeroSerie() %>', 'funko', '<%= f.getNome() %>', '<%= f.getPrezzo() %>')">🛒 Aggiungi</button>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= f.getNumeroSerie() %>', 'funko')">❤️ Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>

<jsp:include page="footer.jsp"></jsp:include>

</body>
</html>
