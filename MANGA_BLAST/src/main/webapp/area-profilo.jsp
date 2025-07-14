<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserDAO" %>
<%@ page import="model.User" %>
<jsp:include page="header.jsp" />
<%
  String emailUtente = (String) session.getAttribute("user");
  if (emailUtente == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  UserDAO dao = new UserDAO();
  User user = dao.getUserByEmail(emailUtente);
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Area Profilo</title>
</head>
<body>

<h2>👤 Il tuo Profilo</h2>
<% if (request.getParameter("updateSuccess") != null) { %>
<p style="color:green;">✅ Profilo aggiornato con successo!</p>
<% } %>

<p><strong>Email:</strong> <%= user.getEmail() %></p>

<p><strong>Indirizzo:</strong>
  <%= user.getIndirizzo() == null || user.getIndirizzo().isEmpty()
          ? "🚫 Nessun indirizzo inserito"
          : user.getIndirizzo() %>
</p>

<hr>
<h3>✏️ Modifica Dati</h3>

<form action="AggiornaProfiloUtenteServlet" method="post">
  <input type="hidden" name="email" value="<%= user.getEmail() %>">

  <label>Nuova Password:</label><br>
  <input type="password" name="nuovaPassword"><br><br>

  <label>Indirizzo:</label><br>
  <textarea name="indirizzo" rows="4" cols="50"><%= user.getIndirizzo() %></textarea><br><br>

  <input type="submit" value="💾 Salva Modifiche">
</form>

<a href="ordini-utente.jsp" class="btn">📦 I miei ordini</a>

<p><a href="index.jsp">🔙 Torna alla Home</a></p>

</body>
</html>