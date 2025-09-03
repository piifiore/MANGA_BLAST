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
</head>
<body>

<div class="checkout-wrapper">
  <h1>💳 Seleziona un metodo di pagamento</h1>

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
<script>
  (function(){
    var holder = document.getElementById('cardHolder');
    var number = document.getElementById('cardNumber');
    var expiry = document.getElementById('expiry');
    var cvv = document.getElementById('cvv');
    var autofill = document.getElementById('autofillBtn');

    if (holder) {
      holder.addEventListener('input', function(e){
        var v = e.target.value;
        v = v.replace(/[^A-Za-zÀ-ÖØ-öø-ÿ' ]+/g, '');
        v = v.replace(/\s{2,}/g, ' ');
        e.target.value = v;
      });
    }

    if (number) {
      number.addEventListener('input', function(e){
        var v = e.target.value.replace(/\D+/g, '').slice(0, 19);
        var parts = [];
        for (var i = 0; i < v.length; i += 4) parts.push(v.substring(i, i+4));
        e.target.value = parts.join(' ');
      });
    }

    if (expiry) {
      expiry.addEventListener('input', function(e){
        var v = e.target.value.replace(/\D+/g, '').slice(0, 4);
        if (v.length >= 1) {
          var mm = v.substring(0, Math.min(2, v.length));
          if (mm.length === 1 && mm > '1') { mm = '0' + mm; }
          if (mm.length === 2) {
            var n = parseInt(mm, 10);
            if (n === 0) mm = '01';
            if (n > 12) mm = '12';
          }
          var yy = v.substring(2);
          e.target.value = yy ? (mm + '/' + yy) : mm;
        } else {
          e.target.value = v;
        }
      });
    }

    if (cvv) {
      cvv.addEventListener('input', function(e){
        e.target.value = e.target.value.replace(/\D+/g, '').slice(0, 4);
      });
    }

    if (autofill) {
      autofill.addEventListener('click', function(){
        var ds = autofill.dataset;
        if (holder && ds.holder) holder.value = ds.holder;
        if (expiry && ds.expiry) expiry.value = ds.expiry;
        if (number) number.value = (ds.number || '').replace(/\D+/g, '').replace(/(.{4})/g, '$1 ').trim();
        if (cvv) { cvv.value=''; cvv.focus(); }
      });
    }
  })();
</script>

</div>

<jsp:include page="footer.jsp" />
</body>
</html>


