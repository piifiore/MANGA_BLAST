<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="navbar.jsp" />
<%
  String emailAdmin = (String) session.getAttribute("admin");
  String nomeAdmin = "";

  if (emailAdmin == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  if (emailAdmin.contains("@")) {
    nomeAdmin = emailAdmin.substring(0, emailAdmin.indexOf("@"));
  }
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Dashboard Amministratore</title>
  <link rel="stylesheet" href="css/admin-dashboard.css">
</head>
<body>

<div class="welcome">
  👋 Ciao <strong><%= nomeAdmin %></strong>, benvenuto nella tua dashboard da amministratore!
</div>

<div class="btn-area">
  <form action="admin-prodotti.jsp" method="get">
    <input type="submit" value="🛒 Gestione Prodotti" class="admin-btn">
  </form>
  <form action="admin-ordini.jsp" method="get">
    <input type="submit" value="📦 Gestione Ordini" class="admin-btn">
  </form>
</div>

</body>
</html>