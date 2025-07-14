<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="model.PreferitiDAO" %>
<jsp:include page="header.jsp" />

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
  <script src="scripts/preferiti.js"></script>


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



</body>
</html>
