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
      <%
        String indirizzoFmt;
        if (user.getVia() == null || user.getVia().isEmpty()) {
            indirizzoFmt = "🚫 Nessun indirizzo inserito";
        } else {
            String nc = user.getNumeroCivico() != null ? user.getNumeroCivico() : "";
            String cap = user.getCap() != null ? user.getCap() : "";
            indirizzoFmt = user.getVia() + (nc.isEmpty()?"":" "+nc) + (cap.isEmpty()?"":" - "+cap);
        }
      %>
      <%= indirizzoFmt %>
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

    <label for="via">Via</label>
    <input type="text" name="via" id="via" placeholder="Es. Via delle Rose" value="<%= user.getVia() != null ? user.getVia() : "" %>">

    <label for="numeroCivico">Numero Civico</label>
    <input type="text" name="numeroCivico" id="numeroCivico" placeholder="Es. 12A" value="<%= user.getNumeroCivico() != null ? user.getNumeroCivico() : "" %>">

    <label for="cap">CAP</label>
    <input type="text" name="cap" id="cap" placeholder="Es. 00100" value="<%= user.getCap() != null ? user.getCap() : "" %>">

    <button type="submit" id="btn-indirizzo"> 💾 Salva Modifiche </button>

  </form>

  <hr>

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
    <div class="info-box" style="margin-bottom: 1rem;">🚫 Nessuna carta salvata</div>
  <% } %>

  <form action="AggiornaCartaPagamentoServlet" method="post" class="payment-form" style="margin-top: 12px;">
    <fieldset>
      <legend>Aggiungi o aggiorna carta</legend>

      <div class="form-row">
        <label for="cardHolder">Nome intestatario</label><br>
        <input id="cardHolder" name="cardHolder" type="text" autocomplete="cc-name" placeholder="Mario Rossi" pattern="[A-Za-zÀ-ÖØ-öø-ÿ' ]{2,60}" maxlength="60" value="<%= card != null ? card.getIntestatario() : "" %>" required>
      </div>

      <div class="form-row" style="margin-top:8px;">
        <label for="cardNumber">Numero carta</label><br>
        <input id="cardNumber" name="cardNumber" type="text" inputmode="numeric" autocomplete="cc-number" placeholder="#### #### #### ####" pattern="(?:\d{4} ?){3,4}" maxlength="23" value="<%= card != null ? card.getNumero().replaceAll("(.{4})", "$1 ").trim() : "" %>" required>
      </div>

      <div class="form-row" style="margin-top:8px;">
        <label for="expiry">Scadenza (MM/YY)</label><br>
        <input id="expiry" name="expiry" type="text" inputmode="numeric" autocomplete="cc-exp" placeholder="MM/YY" pattern="(0[1-9]|1[0-2])\/\d{2}" maxlength="5" value="<%= card != null ? String.format("%02d/%02d", card.getScadenzaMese(), (card.getScadenzaAnno()%100)) : "" %>" required>
      </div>

      <div class="link-area" style="margin-top:16px;">
        <button type="submit" class="btn">💾 Salva carta</button>
      </div>
    </fieldset>
  </form>

  <div class="link-area">
    <a href="ordini-utente.jsp" class="btn">📦 I miei ordini</a>
    <a href="index.jsp" class="btn secondary">🔙 Torna alla Home</a>
  </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
