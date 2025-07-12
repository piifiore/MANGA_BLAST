<%--
  Created by IntelliJ IDEA.
  User: Sorsovelenoso
  Date: 12/07/2025
  Time: 16:13
  To change this template use File | Settings | File Templates.
--%>
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
  <title>I tuoi ordini</title>
  <link rel="stylesheet" href="style/ordini.css">
</head>
<body>

<h1>🧾 I tuoi ordini</h1>

<%
  if (ordini == null || ordini.isEmpty()) {
%>
<p>Non hai ancora effettuato ordini 📭</p>
<%
} else {
  for (Ordine o : ordini) {
%>
<div class="ordine-box">
  <h3>📦 Ordine #<%= o.getId() %> - <%= o.getDataOra() %></h3>
  <p>Stato: <strong><%= o.getStato() %></strong></p>
  <p>Totale: <%= o.getTotale() %>€</p>
  <ul>
    <%
      for (model.ItemCarrello p : o.getProdotti()) {
    %>
    <li><%= p.getTitolo() %> (<%= p.getTipo() %>) — <%= p.getQuantita() %> x <%= p.getPrezzo() %>€</li>
    <%
      }
    %>
  </ul>
</div>
<%
    }
  }
%>

</body>
</html>