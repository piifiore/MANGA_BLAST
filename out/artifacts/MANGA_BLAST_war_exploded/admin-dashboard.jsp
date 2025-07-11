<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 40px;
    }

    .welcome {
      font-size: 22px;
      margin-bottom: 30px;
    }

    .btn-area {
      margin-top: 20px;
    }

    .admin-btn {
      padding: 12px 24px;
      font-size: 16px;
      background-color: #0077cc;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }

    .admin-btn:hover {
      background-color: #005fa3;
    }
  </style>
</head>
<body>

<div class="welcome">
  👋 Ciao <strong><%= nomeAdmin %></strong>, benvenuto nella tua dashboard da amministratore!
</div>

<div class="btn-area">
  <form action="admin-prodotti.jsp" method="get">
    <input type="submit" value="🛒 Gestione Prodotti" class="admin-btn">
  </form>
</div>

</body>
</html>