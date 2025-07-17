<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
  String utente = (String) session.getAttribute("user");
  String admin = (String) session.getAttribute("admin");

  boolean isUser = utente != null;
  boolean isAdmin = admin != null;
%>

<link rel="stylesheet" href="style/header.css?v=<%= System.currentTimeMillis() %>">
<script src="scripts/header.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<header class="main-header">
  <div class="logo" onclick="location.href='index.jsp'">🎌 MangaBlast</div>

  <nav class="navbar">
    <% if (isUser) { %>
    <a href="index.jsp">Home</a>
    <a href="carrello.jsp">Carrello</a>
    <a href="preferiti.jsp">Preferiti</a>
    <a href="area-profilo.jsp">Profilo</a>
    <a href="ordini-utente.jsp">Ordini</a>
    <a href="logout.jsp">Logout</a>

    <% } else if (isAdmin) { %>
    <a href="OrderManagementServlet">Ordini</a>
    <a href="admin-prodotti.jsp">Prodotti</a>
    <a href="logout.jsp">Logout</a>

    <% } else { %>
    <a href="index.jsp">Home</a>
    <a href="login.jsp">Login</a>
    <a href="signup.jsp">Sign Up</a>
    <% } %>
  </nav>

  <!-- 🍔 Hamburger per mobile -->
  <div class="hamburger" onclick="toggleMenu()">☰</div>
</header>
