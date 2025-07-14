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

    <!-- Rimuovi dai preferiti -->
    <form action="RimuoviPreferitoServlet" method="post">
      <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
      <input type="hidden" name="tipo" value="<%= p.getTipo() %>">
      <button type="submit">🗑️ Rimuovi</button>
    </form>
  </div>
  <% } %>
</div>

<% } %>

</body>
</html>
