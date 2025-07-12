<%@ page import="java.util.List" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Manga" %>
<%@ page import="model.Funko" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
  <div class="logo">
    <a href="index.jsp" style="text-decoration:none;">🛍️ <strong>MangaBlast</strong></a>
  </div>
  <nav class="nav">
    <a href="Carrello.jsp">Carrello</a>
    <% if (emailUser == null) { %>
    <a href="login.jsp">Login</a>
    <a href="signup.jsp">Registrati</a>
    <% } else { %>
    <a href="area-profilo.jsp">👤 <%= nomeUser %></a>
    <a href="logout.jsp">Logout</a>
    <% } %>
  </nav>
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
    <h3><%= m.getNome() %></h3>
    <img src="<%= m.getImmagine() %>" alt="Copertina manga" style="width:150px;height:auto;">
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
    <h3><%= f.getNome() %></h3>
    <img src="<%= f.getImmagine() %>" alt="Immagine funko" style="width:150px;height:auto;">
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