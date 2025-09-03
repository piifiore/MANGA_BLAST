<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Logout soft: rimuove solo le info di autenticazione, mantiene carrello/preferiti
  session.removeAttribute("user");
  session.removeAttribute("admin");
  response.sendRedirect("login.jsp");
%>