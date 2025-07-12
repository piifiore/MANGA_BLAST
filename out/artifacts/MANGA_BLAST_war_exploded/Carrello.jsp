<%@ page import="model.CarrelloDAO" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
  String email = (String) session.getAttribute("user");
  List<ItemCarrello> carrello;

  if (email != null) {
    carrello = new CarrelloDAO().getCarrelloUtente(email);
  } else {
    carrello = (List<ItemCarrello>) session.getAttribute("carrello");
  }

  BigDecimal totale = BigDecimal.ZERO;
%>

<h2>🛒 Il tuo Carrello</h2>

<% if (carrello == null || carrello.isEmpty()) { %>
<p>Il carrello è vuoto. <a href="index.jsp">🔙 Torna al catalogo</a></p>
<% } else { %>
<table border="1" cellpadding="8" cellspacing="0">
  <tr>
    <th>Tipo</th>
    <th>Titolo</th>
    <th>Quantità</th>
    <th>Prezzo</th>
    <th>Subtotale</th>
  </tr>
  <% for (ItemCarrello item : carrello) {
    BigDecimal subtotale = item.getPrezzo().multiply(BigDecimal.valueOf(item.getQuantita()));
    totale = totale.add(subtotale);
  %>
  <tr>
    <td><%= item.getTipo().toUpperCase() %></td>
    <td><%= item.getTitolo() %></td>
    <td>
      <form action="AggiornaQuantitaItemServlet" method="post" style="display:inline;">
        <input type="hidden" name="id" value="<%= item.getIdProdotto() %>">
        <input type="hidden" name="tipo" value="<%= item.getTipo() %>">
        <button name="azione" value="-" style="width:30px;">–</button>
        <span style="margin:0 8px;"><%= item.getQuantita() %></span>
        <button name="azione" value="+" style="width:30px;">+</button>
      </form>
    </td>
    <td><%= item.getPrezzo() %>€</td>
    <td><%= subtotale %>€</td>
  </tr>
  <% } %>
  <tr>
    <td colspan="4"><strong>TOTALE</strong></td>
    <td><strong><%= totale %>€</strong></td>
  </tr>
</table>
<p><a href="index.jsp">🔙 Continua lo shopping</a></p>
<% } %>