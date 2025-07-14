<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
  String utente = (String) session.getAttribute("user");
  String admin = (String) session.getAttribute("admin");

  boolean isUser = utente != null;
  boolean isAdmin = admin != null;
%>

<div class="navbar">

  <% if (isUser) { %>
  <a href="index.jsp">Home</a>
  <a href="Carrello.jsp">Carrello<%= session.getAttribute("quantitaCarrello") %></a>
  <a href="area-profilo.jsp">Profilo</a>
  <a href="ordini-utente.jsp">I miei ordini</a>
  <a href="logout.jsp">🔓 Logout</a>

  <% } else if (isAdmin) { %>
  <a href="admin-dashboard.jsp">Dashboard Admin</a>
  <a href="admin-ordini.jsp">Gestione Ordini</a>
  <a href="logout.jsp">🔓 Logout</a>

  <% } else { %>
  <a href="index.jsp">Home</a>
  <a href="login.jsp">🔑 Login</a>
  <% } %>

</div>