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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
<h2 style="text-align:center;">📚 Manga disponibili</h2>
<div class="product-grid">
  <% for (Manga m : listaManga) { %>
  <div class="product-card">
    <h3><%= m.getNome() %></h3>
    <img src="${pageContext.request.contextPath}/<%= m.getImmagine() %>" alt="Copertina manga" />
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
    <img src="${pageContext.request.contextPath}/<%= f.getImmagine() %>" alt="Copertina manga" />
    <p>Prezzo: <strong><%= f.getPrezzo() %>€</strong></p>
    <button onclick="aggiungiCarrello('<%= f.getNumeroSerie() %>', 'funko', '<%= f.getNome() %>', <%= f.getPrezzo() %>)">
      🛒 Aggiungi
    </button>
=======

<hr>

=======

<hr>

>>>>>>> Stashed changes
<h2 style="text-align:center;">🧸 Funko disponibili</h2>e
  <div>
    <% for (Funko f : listaFunko) { %>
    <div>
      <h3><%= f.getNome() %></h3>
      <img src="<%= f.getImmagine() %>" alt="Immagine funko" style="width:150px;height:auto;">
      <p>Prezzo: <strong><%= f.getPrezzo() %>€</strong></p>
      <button onclick="aggiungiCarrello('<%= f.getNumeroSerie() %>', 'funko', '<%= f.getNome() %>', <%= f.getPrezzo() %>)">
        🛒 Aggiungi
      </button>
    </div>
    <% } %>
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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


<h2 style="text-align:center;">📚 Manga disponibili</h2>

<div style="display:flex; justify-content: space-between; text-align: center; border:3px solid yellow; margin-right:150px; margin-left:150px;"> <%-- div superiore--%>
  <div style="border: 5px solid red; width:250px; height: 300px;"> <%-- div1 --%> </div>
  <div style="border: 5px solid orange; width:250px; height: 300px;"> <%-- div2 --%>
        <div style="display:flex; text-align: center;" >
          <% for (Manga m : listaManga) { %>
          <div>
            <h3><%= m.getNome() %></h3>
            <img src="<%= m.getImmagine() %>" alt="Copertina manga" style="width:150px;height:auto;">
            <p>Prezzo: <strong><%= m.getPrezzo() %>€</strong></p>
            <button onclick="aggiungiCarrello('<%= m.getISBN() %>', 'manga', '<%= m.getNome() %>', <%= m.getPrezzo() %>)">
              🛒 Aggiungi
            </button>
          </div>
          <% } %>
        </div>
  </div>

  <div style="border: 5px solid purple; width:250px; height: 300px;"> <%-- div3--%> <p>PRODOTTO2</p> </div>
</div>






<br> <br> <br> <br>

<div style="display:flex; justify-content: space-between; text-align: center; border:7px solid cyan;margin-right:150px; margin-left:150px;">
  <div style="border: 5px solid brown; width:250px; height: 300px;"> <%-- div4--%>
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


  </div>

  <div style="border: 5px solid pink; width:250px; height: 300px;"> <%-- div4--%> <p>PRODOTTO4</p> </div>
  <div style="border: 5px solid violet; width:250px; height: 300px;"> <%-- div4--%> <p>PRODOTTO5</p> </div>
</div>



</body>
</html>