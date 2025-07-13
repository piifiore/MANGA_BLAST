<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
  String utente = (String) session.getAttribute("user");
%>

<div class="navbar">
  <a href="index.jsp">🏠 Home</a>

  <% if (utente != null) { %>
  <a href="area-profilo.jsp">👤 Profilo</a>
  <a href="ordini-utente.jsp">📦 I miei ordini</a>
  <a href="logout.jsp">🔓 Logout</a>
  <% } else { %>
  <a href="login.jsp">🔑 Login</a>
  <% } %>

  <% if (utente != null && "admin@example.com".equals(utente)) { %>
  <a href="admin-dashboard.jsp">🛠️ Dashboard Admin</a>
  <a href="admin-ordini.jsp">📋 Gestione Ordini</a>
  <% } %>
</div>