<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserDAO" %>
<%@ page import="model.User" %>

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
  <title>👤 Area Profilo</title>
  <link rel="stylesheet" href="style/profilo.css?v=<%= System.currentTimeMillis() %>">
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
  <script src="scripts/profilo.js"></script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="profile-wrapper">
  <h2>👤 Il tuo profilo</h2>

  <% if (request.getParameter("updateSuccess") != null) { %>
  <div class="success-msg">✅ Profilo aggiornato con successo!</div>
  <% } %>

  <div class="info-box">
    <p><strong>Email:</strong> <%= user.getEmail() %></p>
    <p><strong>Indirizzo:</strong>
      <%= user.getIndirizzo() == null || user.getIndirizzo().isEmpty()
              ? "🚫 Nessun indirizzo inserito"
              : user.getIndirizzo() %>
    </p>
  </div>

  <hr>

  <h3>✏️ Modifica dati</h3>

  <form action="AggiornaProfiloUtenteServlet" method="post" id="profiloForm">
    <input type="hidden" name="email" value="<%= user.getEmail() %>">

    <label for="nuovaPassword">Nuova Password:</label>
    <div class="password-wrapper">
      <input type="password" name="nuovaPassword" id="nuovaPassword" placeholder="••••••••">
      <span class="password-toggle-icon" onclick="togglePassword('nuovaPassword', this)">
          <i class="fas fa-eye"></i>
        </span>
    </div>

    <label for="indirizzo">Indirizzo:</label>
    <textarea name="indirizzo" id="indirizzo" rows="4" placeholder="Inserisci il tuo indirizzo..."><%= user.getIndirizzo() %></textarea>

    <button type="submit">💾 Salva Modifiche</button>
  </form>

  <div class="link-area">
    <a href="ordini-utente.jsp" class="btn">📦 I miei ordini</a>
    <a href="index.jsp" class="btn secondary">🔙 Torna alla Home</a>
  </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
