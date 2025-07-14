<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Manga" %>
<%@ page import="model.Funko" %>
<jsp:include page="navbar.jsp" />

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
</head>

<body>

<header class="header">
  
</header>

<% if (emailUser != null) { %>
<div class="welcome-message">
  <h2>👋 Ciao <%= nomeUser %>, benvenuto su MangaBlast!</h2>
</div>
<% } %>

<hr>

<h2 style="text-align:center;">📚 Manga disponibili</h2>
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
    <button onclick="aggiungiCarrello('<%= m.getISBN() %>', 'manga', '<%= m.getNome() %>', <%= m.getPrezzo() %>)">
      🛒 Aggiungi
    </button>
  </div>
  <% } %>
</div>


<hr>

<h2 style="text-align:center;">🧸 Funko disponibili</h2>
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
    <button onclick="aggiungiCarrello('<%= f.getNumeroSerie() %>', 'funko', '<%= f.getNome() %>', <%= f.getPrezzo() %>)">
      🛒 Aggiungi
    </button>
  </div>
  <% } %>
</div>


<!-- JavaScript AJAX per aggiunta al carrello -->
<script>
  function aggiungiCarrello(id, tipo, titolo, prezzo) {
    fetch('AggiungiAlCarrelloServlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        id: id,
        tipo: tipo,
        titolo: titolo,
        prezzo: prezzo
      })
    })
            .then(response => response.text())
            .then(text => {
              if (text === 'aggiunto') {
                mostraBanner("✅ Aggiunto al carrello!");
              }
            });
  }

  function mostraBanner(msg) {
    let banner = document.createElement('div');
    banner.textContent = msg;
    banner.style.position = 'fixed';
    banner.style.top = '10px';
    banner.style.right = '10px';
    banner.style.background = '#4CAF50';
    banner.style.color = '#fff';
    banner.style.padding = '10px';
    banner.style.borderRadius = '5px';
    banner.style.zIndex = '1000';
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2000);
  }
</script>

</body>
</html>