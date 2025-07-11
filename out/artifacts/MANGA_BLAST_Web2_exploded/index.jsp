<%@ page import="java.util.List" %>
<%@ page import="model.ProdottoDAO" %>
<%@ page import="model.Prodotto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  ProdottoDAO dao = new ProdottoDAO();
  List<Prodotto> prodotti = dao.getAllProdotti();

  String utente = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>MangaBlast</title>
  <link rel="stylesheet" href="style/index.css">
</head>



<body>
<%--<%@ include file="includes/header.jsp" %>--%>
  <header class="header">
    <div class="logo">🛍️ E-Shop</div>
    <nav class="nav">
      <a href="index.jsp">Home</a>
      <a href="carrello.jsp">Carrello</a>
      <% if (utente == null) { %>
      <a href="login.jsp">Login</a>
      <a href="signup.jsp">Registrati</a>
      <% } else { %>
      <span>👤 <%= utente %></span>
      <a href="LogoutUserServlet">Logout</a>
      <% } %>
    </nav>
  </header>

  <hr>
  <hr>
  <hr>




<%--<%@ include file="includes/footer.jsp" %>--%>
</body>
</html>


