<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="model.PreferitiDAO" %>
<jsp:include page="navbar.jsp" />

<%
  String emailUser = (String) session.getAttribute("user");
  if (emailUser == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<ItemCarrello> preferiti = new PreferitiDAO().getPreferitiByEmail(emailUser);
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>❤️ I Tuoi Preferiti</title>
  <link rel="stylesheet" href="style/preferiti.css">
  <style>
    .product-grid { display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; }
    .product-card {
      border: 1px solid #ccc;
      padding: 10px;
      width: 200px;
      text-align: center;
      border-radius: 8px;
      background: #f9f9f9;
    }
    .product-card img { max-width: 100%; height: auto; }
    .product-card h3 { font-size: 16px; margin-bottom: 5px; }
    .product-card button {
      margin: 5px 0;
      padding: 6px 10px;
      cursor: pointer;
    }
  </style>
</head>
<body>

<h1>🌟 Preferiti di <%= emailUser %></h1>

<% if (preferiti == null || preferiti.isEmpty()) { %>
<p>Non hai ancora aggiunto nulla ai preferiti 😢</p>
<a href="index.jsp">🔙 Torna allo shop</a>
<% } else { %>

<div class="product-grid">
  <% for (ItemCarrello p : preferiti) { %>
  <div class="product-card">
    <a href="scheda-prodotto.jsp?id=<%= p.getIdProdotto() %>&tipo=<%= p.getTipo() %>">
      <img src="<%= p.getImmagine() %>" alt="<%= p.getTitolo() %>" />
      <h3><%= p.getTitolo() %></h3>
    </a>
    <p><strong><%= p.getPrezzo() %>€</strong></p>

    <!-- Aggiungi al carrello -->
    <form action="AggiungiAlCarrelloServlet" method="post">
      <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
      <input type="hidden" name="tipo" value="<%= p.getTipo() %>">
      <input type="hidden" name="titolo" value="<%= p.getTitolo() %>">
      <input type="hidden" name="prezzo" value="<%= p.getPrezzo() %>">
      <button type="submit">🛒 Aggiungi al Carrello</button>
    </form>

    <!-- Rimuovi dai preferiti via AJAX -->
    <button onclick="rimuoviPreferito('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>')">🗑️ Rimuovi</button>
  </div>
  <% } %>
</div>

<% } %>

<script>
  function rimuoviPreferito(id, tipo) {
    fetch('RimuoviPreferitoServlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ id, tipo })
    })
            .then(() => {
              mostraBanner("🗑️ Rimosso dai preferiti!");
              setTimeout(() => location.reload(), 1000);
            });
  }

  function mostraBanner(msg) {
    let banner = document.createElement('div');
    banner.textContent = msg;
    banner.style.position = 'fixed';
    banner.style.top = '10px';
    banner.style.right = '10px';
    banner.style.background = '#9C27B0';
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
