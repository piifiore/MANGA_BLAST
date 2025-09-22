<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="model.PreferitiDAO" %>

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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>❤️ I tuoi Preferiti</title>
  <link rel="stylesheet" href="style/preferiti.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="style/toast.css?v=<%= System.currentTimeMillis() %>">
  <script src="scripts/toast.js" defer></script>
  <script src="scripts/preferiti.js" defer></script>
</head>
<body>
<jsp:include page="header.jsp" />

<h1>🌟 Preferiti di <%= emailUser %></h1>

<% if (preferiti == null || preferiti.isEmpty()) { %>
<p>Non hai ancora aggiunto nulla ai preferiti 😢</p>
<a href="index.jsp">🔙 Torna allo shop</a>
<% } else { %>
<div class="product-grid">
  <% for (ItemCarrello p : preferiti) { %>
  <div class="product-card" data-id="<%= p.getIdProdotto() %>">
    <a href="scheda-prodotto.jsp?id=<%= p.getIdProdotto() %>&tipo=<%= p.getTipo() %>">
      <img src="<%= p.getImmagine() %>" alt="<%= p.getTitolo() %>" />
      <h3><%= p.getTitolo() %></h3>
    </a>
    <p><strong><%= p.getPrezzo() %>€</strong></p>

    <!-- Aggiunta al carrello -->
    <button onclick="aggiungiCarrello('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>', '<%= p.getTitolo() %>', '<%= p.getPrezzo() %>')">🛒 Aggiungi al Carrello</button>

    <!-- Rimozione preferito -->
    <button onclick="rimuoviPreferito('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>')">🗑️ Rimuovi</button>
  </div>
  <% } %>
</div>
<% } %>

<jsp:include page="footer.jsp" />
</body>
</html>
