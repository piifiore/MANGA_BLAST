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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>👤 Area Profilo</title>
  <link rel="stylesheet" href="style/profilo.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="style/form-messages.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="style/reviews.css?v=<%= System.currentTimeMillis() %>">
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
  <script src="scripts/profilo.js"></script>
  <script src="scripts/reviews.js"></script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="profile-wrapper">
  <div class="profile-header">
    <h2>👤 Il tuo profilo</h2>
    <div class="user-info">
      <p><strong>Email:</strong> <%= user.getEmail() %></p>
      <p><strong>Indirizzo:</strong>
        <%
          String indirizzoFmt;
          if (user.getVia() == null || user.getVia().isEmpty()) {
              indirizzoFmt = "Nessun indirizzo inserito";
          } else {
              String nc = user.getNumeroCivico() != null ? user.getNumeroCivico() : "";
              String cap = user.getCap() != null ? user.getCap() : "";
              indirizzoFmt = user.getVia() + (nc.isEmpty()?"":" "+nc) + (cap.isEmpty()?"":" - "+cap);
          }
        %>
        <%= indirizzoFmt %>
      </p>
    </div>
  </div>

  <% if (request.getParameter("updateSuccess") != null) { %>
  <div class="success-msg">✅ Profilo aggiornato con successo!</div>
  <% } %>
  
  <% if (request.getParameter("error") != null) { %>
  <div class="error-msg">❌ <%= request.getParameter("error") %></div>
  <% } %>

  <!-- Tab Navigation -->
  <div class="profile-tabs">
    <button class="tab-button active" onclick="showTab('dati')">Modifica Dati</button>
    <button class="tab-button" onclick="showTab('pagamenti')">Metodi di Pagamento</button>
    <button class="tab-button" onclick="showTab('recensioni')">Le tue Recensioni</button>
  </div>

  <!-- Tab Content -->
  <div class="tab-content">
    
    <!-- Tab 1: Modifica Dati -->
    <div id="tab-dati" class="tab-panel active">
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

        <label for="via">Via</label>
        <input type="text" name="via" id="via" placeholder="Es. Via delle Rose" value="<%= user.getVia() != null ? user.getVia() : "" %>">

        <label for="numeroCivico">Numero Civico</label>
        <input type="text" name="numeroCivico" id="numeroCivico" placeholder="Es. 12A" value="<%= user.getNumeroCivico() != null ? user.getNumeroCivico() : "" %>">

        <label for="cap">CAP</label>
        <input type="text" name="cap" id="cap" placeholder="Es. 00100" value="<%= user.getCap() != null ? user.getCap() : "" %>">

        <button type="submit" id="btn-indirizzo"> 💾 Salva Modifiche </button>
      </form>
    </div>

    <!-- Tab 2: Metodi di Pagamento -->
    <div id="tab-pagamenti" class="tab-panel">
      <h3>💳 Carta di pagamento</h3>
      <%
        model.CartaPagamentoDAO cardDao = new model.CartaPagamentoDAO();
        model.CartaPagamento card = cardDao.getByEmail(user.getEmail());
      %>
      <% if (request.getParameter("updateCardSuccess") != null) { %>
      <div class="success-msg">✅ Carta aggiornata con successo!</div>
      <% } %>

      <% if (card != null) { %>
        <div class="info-box" style="margin-bottom: 1rem;">
          <p><strong>Carta salvata:</strong> <%= card.getBrand() != null ? card.getBrand() : "Carta" %> **** **** **** <%= card.getLast4() %></p>
          <p><strong>Intestatario:</strong> <%= card.getIntestatario() %></p>
          <p><strong>Scadenza:</strong> <%= String.format("%02d/%02d", card.getScadenzaMese(), (card.getScadenzaAnno()%100)) %></p>
        </div>
      <% } else { %>
        <p>Nessuna carta di pagamento salvata.</p>
      <% } %>

      <form action="AggiornaCartaPagamentoServlet" method="post" id="cartaForm">
        <input type="hidden" name="email" value="<%= user.getEmail() %>">

        <label for="numeroCarta">Numero Carta:</label>
        <input type="text" name="numeroCarta" id="numeroCarta" placeholder="1234 5678 9012 3456" maxlength="19">

        <label for="intestatario">Intestatario:</label>
        <input type="text" name="intestatario" id="intestatario" placeholder="Mario Rossi">

        <div class="form-row">
          <div class="form-group">
            <label for="scadenzaMese">Mese:</label>
            <select name="scadenzaMese" id="scadenzaMese">
              <option value="">Mese</option>
              <% for (int i = 1; i <= 12; i++) { %>
                <option value="<%= i %>" <%= (card != null && card.getScadenzaMese() == i) ? "selected" : "" %>><%= String.format("%02d", i) %></option>
              <% } %>
            </select>
          </div>

          <div class="form-group">
            <label for="scadenzaAnno">Anno:</label>
            <select name="scadenzaAnno" id="scadenzaAnno">
              <option value="">Anno</option>
              <% int currentYear = java.time.Year.now().getValue(); %>
              <% for (int i = currentYear; i <= currentYear + 10; i++) { %>
                <option value="<%= i %>" <%= (card != null && card.getScadenzaAnno() == i) ? "selected" : "" %>><%= i %></option>
              <% } %>
            </select>
          </div>

          <div class="form-group">
            <label for="cvv">CVV:</label>
            <input type="text" name="cvv" id="cvv" placeholder="123" maxlength="3">
          </div>
        </div>

        <button type="submit" id="btn-carta"> 💳 Salva Carta </button>
      </form>
    </div>

    <!-- Tab 3: Le tue Recensioni -->
    <div id="tab-recensioni" class="tab-panel">
      <h3>⭐ Le tue recensioni</h3>
      
      <div class="reviews-section">
        <div class="reviews-list" id="userReviewsContainer">
          <div class="empty-reviews">
            <h3>Caricamento recensioni...</h3>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="profile-links">
    <a href="carrello.jsp" class="profile-link">🛒 Vai al Carrello</a>
    <a href="preferiti.jsp" class="profile-link">❤️ Vai ai Preferiti</a>
    <a href="ordini-utente.jsp" class="profile-link">📦 Vai agli Ordini</a>
  </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>