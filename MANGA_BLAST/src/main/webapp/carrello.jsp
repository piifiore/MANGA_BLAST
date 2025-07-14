<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.math.BigDecimal" %>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>🛒 Il Tuo Carrello</title>
  <link rel="stylesheet" href="style/carrello.css">
  <script src="scripts/carrello.js"></script>

</head>
<body>

<h1>🛍️ Carrello</h1>

<%
  List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
  BigDecimal totale = BigDecimal.ZERO;

  if (carrello == null || carrello.isEmpty()) {
%>
<p>Il tuo carrello è vuoto 😢</p>
<%
} else {
%>
<table>
  <thead>
  <tr>
    <th>Prodotto</th>
    <th>Prezzo</th>
    <th>Quantità</th>
    <th>Totale</th>
  </tr>
  </thead>
  <tbody>
  <%
    for (ItemCarrello p : carrello) {
      BigDecimal subtotale = p.getPrezzo().multiply(new BigDecimal(p.getQuantita()));
      totale = totale.add(subtotale);
      String key = p.getIdProdotto() + p.getTipo();
  %>
  <tr>
    <td>
      <a href="scheda-prodotto.jsp?id=<%= p.getIdProdotto() %>&tipo=<%= p.getTipo() %>">
        <%= p.getTitolo() %>
      </a>
    </td>
    <td><%= p.getPrezzo() %>€</td>
    <td class="quantita-controls">
      <button onclick="modificaQuantita('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>', -1)">−</button>
      <span id="qta-<%= key %>"><%= p.getQuantita() %></span>
      <button onclick="modificaQuantita('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>', 1)">+</button>
    </td>
    <td id="subtotale-<%= key %>" data-prezzo="<%= p.getPrezzo() %>"><%= subtotale %>€</td>
  </tr>
  <%
    }
  %>
  </tbody>
</table>

<h3>💸 Totale: <span id="totaleCarrello"><%= totale %></span>€</h3>

<form action="checkout.jsp" method="get">
  <button type="submit">✅ Procedi al Checkout</button>
</form>
<%
  }
%>



</body>
</html>
