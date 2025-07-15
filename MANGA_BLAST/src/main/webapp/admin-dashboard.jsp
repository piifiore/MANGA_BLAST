<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />
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
  <title>🔧 Admin Dashboard</title>
  <link rel="stylesheet" href="css/admin-dashboard.css?v=<%= System.currentTimeMillis() %>">
  <script src="scripts/admin-dashboard.js"></script>
</head>
<body>

<div class="dashboard-container">
  <h1>🔧 Admin Dashboard</h1>
  <p class="welcome-msg">Benvenuto <strong><%= nomeAdmin %></strong>, gestisci facilmente prodotti e ordini dal pannello qui sotto.</p>

  <div class="card-area">
    <a href="admin-prodotti.jsp" class="admin-card">
      <div class="card-icon">🛒</div>
      <h3>Gestione Prodotti</h3>
      <p>Visualizza, modifica e aggiungi prodotti al catalogo.</p>
    </a>

    <a href="admin-ordini.jsp" class="admin-card">
      <div class="card-icon">📦</div>
      <h3>Gestione Ordini</h3>
      <p>Monitora gli ordini ricevuti e aggiorna lo stato di spedizione.</p>
    </a>
  </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
