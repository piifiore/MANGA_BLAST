<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.math.BigDecimal" %>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>💳 Metodo di pagamento</title>
  <link rel="stylesheet" href="style/checkout.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="style/form-messages.css?v=<%= System.currentTimeMillis() %>">
  <script src="scripts/payment-validation.js"></script>
</head>
<body>

<%
  // Gestione messaggi di errore
  String error = request.getParameter("error");
%>

<div class="checkout-wrapper">
  <h1>💳 Seleziona un metodo di pagamento</h1>

  <%
    // Mostra messaggio di errore se presente
    if ("carta_scaduta".equals(error)) {
  %>
  <div class="error-message" style="background: #ff4444; color: white; padding: 15px; border-radius: 8px; margin: 20px 0; text-align: center; font-weight: bold;">
    ⚠️ Errore: La carta di pagamento inserita è scaduta. Inserisci una carta valida per procedere con l'acquisto.
  </div>
  <%
    }
  %>

  <%
    String emailUser = (String) session.getAttribute("user");
    if (emailUser == null) {
      response.sendRedirect("login.jsp");
      return;
    }

    List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
    BigDecimal totale = BigDecimal.ZERO;
    if (carrello == null || carrello.isEmpty()) {
  %>
  <p class="empty-msg">⚠️ Il carrello è vuoto. Non puoi completare il pagamento.</p>
  <div class="link-area">
    <a href="index.jsp" class="btn secondary">⬅️ Torna allo shop</a>
  </div>
  <%
    } else {
      for (ItemCarrello p : carrello) {
        BigDecimal subtotale = p.getPrezzo().multiply(new BigDecimal(p.getQuantita()));
        totale = totale.add(subtotale);
      }
  %>

  <h3 class="totale">💰 Totale ordine: <%= totale %>€</h3>

  <%
    model.CartaPagamento savedCard = new model.CartaPagamentoDAO().getByEmail(emailUser);
    if (savedCard != null) {
  %>
    <div class="saved-card" style="margin-bottom: 16px; background:#241F3C; border:1px solid rgba(255,255,255,0.1); padding:12px; border-radius:8px;">
      <div><strong>Carta salvata:</strong> <%= savedCard.getBrand() != null ? savedCard.getBrand() : "Carta" %> **** **** **** <%= savedCard.getLast4() %></div>
      <div>Intestatario: <%= savedCard.getIntestatario() %></div>
      <div>Scadenza: <%= String.format("%02d/%02d", savedCard.getScadenzaMese(), (savedCard.getScadenzaAnno()%100)) %></div>
      <button type="button" class="btn" id="autofillBtn" style="margin-top:8px;"
              data-holder="<%= savedCard.getIntestatario() %>"
              data-expiry="<%= String.format("%02d/%02d", savedCard.getScadenzaMese(), (savedCard.getScadenzaAnno()%100)) %>"
              data-number="<%= savedCard.getNumero() %>">⚡ Compila con carta salvata</button>
    </div>
  <%
    }
  %>

  <form action="ConfermaOrdineServlet" method="post" class="payment-form">
    <input type="hidden" name="metodoPagamento" value="carta">

    <fieldset>
      <legend>Dati carta di credito</legend>

      <div class="form-row">
        <label for="cardHolder">Nome intestatario</label><br>
        <input id="cardHolder" name="cardHolder" type="text" autocomplete="cc-name" placeholder="Mario Rossi" pattern="[A-Za-zÀ-ÖØ-öø-ÿ' ]{2,60}" maxlength="60" required>
      </div>

      <div class="form-row" style="margin-top:8px;">
        <label for="cardNumber">Numero carta</label><br>
        <input id="cardNumber" name="cardNumber" type="text" inputmode="numeric" autocomplete="cc-number" placeholder="#### #### #### ####" pattern="(?:\d{4} ?){3,4}" maxlength="23" required>
      </div>

      <div class="form-row" style="margin-top:8px;">
        <label for="expiry">Scadenza (MM/YY)</label><br>
        <input id="expiry" name="expiry" type="text" inputmode="numeric" autocomplete="cc-exp" placeholder="MM/YY" pattern="(0[1-9]|1[0-2])\/\d{2}" maxlength="5" required>
      </div>

      <div class="form-row" style="margin-top:8px;">
        <label for="cvv">CVV</label><br>
        <input id="cvv" name="cvv" type="password" inputmode="numeric" autocomplete="cc-csc" maxlength="4" pattern="\d{3,4}" placeholder="***" required>
      </div>
    </fieldset>

    <div class="link-area" style="margin-top:16px;">
      <a href="checkout.jsp" class="btn secondary">⬅️ Torna al riepilogo</a>
      <button type="submit" class="btn confirm">✅ Conferma e paga</button>
    </div>
  </form>
  <%
    }
  %>

</div>

<jsp:include page="footer.jsp" />
</body>
</html>


