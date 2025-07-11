<%@ page import="java.util.List" %>
<%@ page import="model.ProdottoDAO" %>
<%@ page import="model.Prodotto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  ProdottoDAO dao = new ProdottoDAO();
  List<Prodotto> prodotti = dao.getAllProdotti();

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
<%--<%@ include file="includes/header.jsp" %>--%>
<header class="header">
  <div class="logo">🛍️ E-Shop</div>
  <nav class="nav">
    <a href="index.jsp">Home</a>
    <a href="carrello.jsp">Carrello</a>
    <% if (emailUser == null) { %>
    <a href="login.jsp">Login</a>
    <a href="signup.jsp">Registrati</a>
    <% } else { %>
    <span>👤 <%= emailUser %></span>
    <a href="LogoutUserServlet">Logout</a>
    <% } %>
  </nav>
</header>

<%-- 🔔 Messaggio di benvenuto solo dopo login --%>
<% if (nomeUser != null && !nomeUser.isEmpty()) { %>
<div class="welcome-message">
  <h2>👋 Ciao <%= nomeUser %>, benvenuto su MangaBlast!</h2>
</div>
<% } %>

<hr><hr><hr>

<%--<%@ include file="includes/footer.jsp" %>--%>
</body>
</html>