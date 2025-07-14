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
    <form action="AggiungiAlCarrelloServlet" method="post">
      <input type="hidden" name="id" value="<%= m.getISBN() %>">
      <input type="hidden" name="tipo" value="manga">
      <input type="hidden" name="titolo" value="<%= m.getNome() %>">
      <input type="hidden" name="prezzo" value="<%= m.getPrezzo() %>">
      <button type="submit">🛒 Aggiungi</button>
    </form>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= m.getISBN() %>', 'manga')">❤️ Preferiti</button>
    <% } %>
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
    <form action="AggiungiAlCarrelloServlet" method="post">
      <input type="hidden" name="id" value="<%= f.getNumeroSerie() %>">
      <input type="hidden" name="tipo" value="funko">
      <input type="hidden" name="titolo" value="<%= f.getNome() %>">
      <input type="hidden" name="prezzo" value="<%= f.getPrezzo() %>">
      <button type="submit">🛒 Aggiungi</button>
    </form>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= f.getNumeroSerie() %>', 'funko')">❤️ Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>

<script>
  function aggiungiPreferiti(idProdotto, tipo) {
    fetch('AggiungiPreferitoServlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ idProdotto, tipo })
    })
            .then(res => res.text())
            .then(text => {
              console.log("Risposta ricevuta:", `"${text}"`); // 🔍 Debug visivo in console

              if (text.trim() === "aggiunto") {
                mostraBanner("❤️ Aggiunto ai preferiti!");
              } else if (text.trim() === "esiste") {
                mostraBanner("⚠️ Già presente nei preferiti!");
              }
            });
  }

  function mostraBanner(msg) {
    let banner = document.createElement('div');
    banner.textContent = msg;
    banner.style.position = 'fixed';
    banner.style.top = '10px';
    banner.style.right = '10px';
    banner.style.background = msg.includes("⚠️") ? '#FFC107' : '#E91E63';
    banner.style.color = '#fff';
    banner.style.padding = '10px 20px';
    banner.style.fontWeight = 'bold';
    banner.style.borderRadius = '5px';
    banner.style.zIndex = '1000';
    banner.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2000);
  }
</script>

</body>
</html>
