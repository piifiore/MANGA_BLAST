<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.OrdineDAO" %>
<%@ page import="model.Ordine" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />

<%
  String emailUser = (String) session.getAttribute("user");
  if (emailUser == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  OrdineDAO dao = new OrdineDAO();
  List<Ordine> ordini = dao.getOrdiniByEmail(emailUser);
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>🧾 I tuoi Ordini</title>
  <link rel="stylesheet" href="style/ordini.css?v=<%= System.currentTimeMillis() %>">
  <script src="scripts/ordini.js"></script>
</head>
<body>

<div class="ordini-wrapper">
  <h1>🧾 I tuoi ordini</h1>

  <% if (ordini == null || ordini.isEmpty()) { %>
  <p class="empty-msg">📭 Nessun ordine effettuato finora</p>
  <% } else {
    for (Ordine o : ordini) { %>
  <div class="ordine-box">
    <h3>📦 Ordine #<%= o.getId() %> - <%= o.getDataOra() %></h3>
    <p>Stato: <strong><%= o.getStato() %></strong></p>
    <p>Totale: <%= o.getTotale() %>€</p>
    <ul>
      <% for (model.ItemCarrello p : o.getProdotti()) { %>
      <li><%= p.getTitolo() %> (<%= p.getTipo() %>) — <%= p.getQuantita() %> x <%= p.getPrezzo() %>€</li>
      <% } %>
    </ul>
  </div>
  <%   }
  } %>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
