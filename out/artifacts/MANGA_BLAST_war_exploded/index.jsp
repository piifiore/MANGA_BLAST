<%@ page import="java.util.List" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Manga" %>
<%@ page import="model.Funko" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  String emailUser = (String) session.getAttribute("user");
  String nomeUser = "";

  if (emailUser != null && emailUser.contains("@")) {
    nomeUser = emailUser.substring(0, emailUser.indexOf("@"));
  }
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>MangaBlast</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/index.css">
</head>

<body>

<header class="header">
  <div class="logo">
    <a href="index.jsp" style="text-decoration:none;">🛍️ <strong>MangaBlast</strong></a>
  </div>
  <nav class="nav">
    <a href="index.jsp">Home</a>
    <a href="Carrello.jsp">Carrello</a>

    <% if (emailUser == null) { %>
    <a href="login.jsp">Login</a>
    <a href="signup.jsp">Registrati</a>
    <% } else { %>
    <a href="area-profilo.jsp">👤 <%= nomeUser %></a>
    <a href="logout.jsp">Logout</a>
    <% } %>
  </nav>
</header>

<%-- 🔔 Messaggio di benvenuto solo se loggato --%>
<% if (emailUser != null) { %>
<div class="welcome-message">
  <h2>👋 Ciao <%= nomeUser %>, benvenuto su MangaBlast!</h2>
</div>
<% } %>

<hr><hr><hr>

<%-- Qui puoi continuare con la visualizzazione prodotti o altre sezioni --%>

</body>
</html>