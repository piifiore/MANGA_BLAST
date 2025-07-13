<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.math.BigDecimal" %>
<jsp:include page="navbar.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>🛒 Il Tuo Carrello</title>
  <link rel="stylesheet" href="style/carrello.css">
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
  %>
  <tr>
    <td><%= p.getTitolo() %></td>
    <td><%= p.getPrezzo() %>€</td>
    <td><%= p.getQuantita() %></td>
    <td><%= subtotale %>€</td>
  </tr>
  <%
    }
  %>
  </tbody>
</table>

<h3>💸 Totale: <%= totale %>€</h3>

<form action="checkout.jsp" method="get">
  <button type="submit">✅ Procedi al Checkout</button>
</form>
<%
  }
%>

</body>
</html>