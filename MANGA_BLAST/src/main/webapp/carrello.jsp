<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.math.BigDecimal" %>
<jsp:include page="navbar.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>🛒 Il Tuo Carrello</title>
  <link rel="stylesheet" href="style/carrello.css">
  <style>
    .quantita-controls button {
      padding: 4px 8px;
      margin: 0 4px;
      font-weight: bold;
      font-size: 14px;
      cursor: pointer;
    }
    td a {
      text-decoration: none;
      color: #333;
    }
    td a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

<h1>🛍️ Carrello</h1>

<%
  List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
  BigDecimal totale = BigDecimal.ZERO;

  if (carrello == null || carrello.isEmpty()) {
%>
<p>Il tuo carrello è vuoto 😢</p>
<%
} else {
%>
<table>
  <thead>
  <tr>
    <th>Prodotto</th>
    <th>Prezzo</th>
    <th>Quantità</th>
    <th>Totale</th>
  </tr>
  </thead>
  <tbody>
  <%
    for (ItemCarrello p : carrello) {
      BigDecimal subtotale = p.getPrezzo().multiply(new BigDecimal(p.getQuantita()));
      totale = totale.add(subtotale);
      String key = p.getIdProdotto() + p.getTipo();
  %>
  <tr>
    <td>
      <a href="scheda-prodotto.jsp?id=<%= p.getIdProdotto() %>&tipo=<%= p.getTipo() %>">
        <%= p.getTitolo() %>
      </a>
    </td>
    <td><%= p.getPrezzo() %>€</td>
    <td class="quantita-controls">
      <button onclick="modificaQuantita('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>', -1)">−</button>
      <span id="qta-<%= key %>"><%= p.getQuantita() %></span>
      <button onclick="modificaQuantita('<%= p.getIdProdotto() %>', '<%= p.getTipo() %>', 1)">+</button>
    </td>
    <td id="subtotale-<%= key %>" data-prezzo="<%= p.getPrezzo() %>"><%= subtotale %>€</td>
  </tr>
  <%
    }
  %>
  </tbody>
</table>

<h3>💸 Totale: <span id="totaleCarrello"><%= totale %></span>€</h3>

<form action="checkout.jsp" method="get">
  <button type="submit">✅ Procedi al Checkout</button>
</form>
<%
  }
%>

<script>
  function modificaQuantita(id, tipo, delta) {
    fetch('AggiornaQuantitaCarrelloServlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({ id, tipo, delta })
    })
            .then(res => res.json())
            .then(data => {
              const key = id + tipo;
              if (data.rimosso) {
                mostraBanner("🗑️ Prodotto rimosso dal carrello!");
                setTimeout(() => location.reload(), 1000);
              } else {
                document.getElementById("qta-" + key).textContent = data.nuovaQuantita;
                const prezzo = parseFloat(document.getElementById("subtotale-" + key).getAttribute("data-prezzo"));
                const subtotale = prezzo * data.nuovaQuantita;
                document.getElementById("subtotale-" + key).textContent = subtotale.toFixed(2) + "€";
                aggiornaTotale();
              }
            });
  }

  function aggiornaTotale() {
    let totale = 0;
    document.querySelectorAll("[id^='subtotale-']").forEach(td => {
      const text = td.textContent.replace("€", "").trim();
      const value = parseFloat(text);
      if (!isNaN(value)) totale += value;
    });
    document.getElementById("totaleCarrello").textContent = totale.toFixed(2);
  }

  function mostraBanner(msg) {
    const banner = document.createElement("div");
    banner.textContent = msg;
    banner.style.position = "fixed";
    banner.style.top = "10px";
    banner.style.right = "10px";
    banner.style.background = "#F44336"; // Rosso per rimozione
    banner.style.color = "#fff";
    banner.style.padding = "10px 20px";
    banner.style.fontWeight = "bold";
    banner.style.borderRadius = "5px";
    banner.style.zIndex = "1000";
    banner.style.boxShadow = "0 2px 6px rgba(0,0,0,0.2)";
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2000);
  }
</script>

</body>
</html>
