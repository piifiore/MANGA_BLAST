<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.math.BigDecimal" %>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>✅ Checkout</title>
  <link rel="stylesheet" href="style/checkout.css">
</head>
<body>

<h1>📦 Riepilogo Ordine</h1>

<%
  String emailUser = (String) session.getAttribute("user");
  if (emailUser == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
  BigDecimal totale = BigDecimal.ZERO;

  if (carrello == null || carrello.isEmpty()) {
%>
<p>⚠️ Il carrello è vuoto. Non puoi completare l'ordine.</p>
<a href="index.jsp">⬅️ Torna allo shop</a>
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

<h3>💰 Totale ordine: <%= totale %>€</h3>

<form action="ConfermaOrdineServlet" method="post">
  <button type="submit">📬 Conferma Ordine</button>
</form>
<%
  }
%>

</body>
</html>