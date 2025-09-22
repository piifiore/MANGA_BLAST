<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Manga" %>
<%@ page import="model.Funko" %>

<%
  List<Manga> listaManga = (List<Manga>) request.getAttribute("listaManga");
  List<Funko> listaFunko = (List<Funko>) request.getAttribute("listaFunko");
  String emailUser = (String) request.getAttribute("emailUser");
  String emailAdmin = (String) request.getSession().getAttribute("admin");
%>

<% if (listaManga != null && !listaManga.isEmpty()) { %>
<h2 style="text-align:center; margin-top:2rem;">Manga disponibili</h2>
<div class="product-grid">
  <% for (Manga m : listaManga) { %>
  <div class="product-card" data-id="<%= m.getISBN() %>">
    <h3>
      <a href="scheda-prodotto.jsp?id=<%= m.getISBN() %>&tipo=manga"><%= m.getNome() %></a>
    </h3>
    <a href="scheda-prodotto.jsp?id=<%= m.getISBN() %>&tipo=manga">
      <img src="<%= m.getImmagine() %>" alt="Copertina manga" />
    </a>
    <p>Prezzo: <strong><%= m.getPrezzo() %>€</strong></p>
    <% if (emailAdmin == null) { %>
    <button onclick="aggiungiCarrello('<%= m.getISBN() %>', 'manga', '<%= m.getNome() %>', '<%= m.getPrezzo() %>')">Aggiungi</button>
    <% } %>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= m.getISBN() %>', 'manga')">Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>
<% } %>

<% if (listaFunko != null && !listaFunko.isEmpty()) { %>
<h2 style="text-align:center; margin-top:2rem;">Funko disponibili</h2>
<div class="product-grid">
  <% for (Funko f : listaFunko) { %>
  <div class="product-card" data-id="<%= f.getNumeroSerie() %>">
    <h3>
      <a href="scheda-prodotto.jsp?id=<%= f.getNumeroSerie() %>&tipo=funko"><%= f.getNome() %></a>
    </h3>
    <a href="scheda-prodotto.jsp?id=<%= f.getNumeroSerie() %>&tipo=funko">
      <img src="<%= f.getImmagine() %>" alt="Funko <%= f.getNome() %>" />
    </a>
    <p>Prezzo: <strong><%= f.getPrezzo() %>€</strong></p>
    <% if (emailAdmin == null) { %>
    <button onclick="aggiungiCarrello('<%= f.getNumeroSerie() %>', 'funko', '<%= f.getNome() %>', '<%= f.getPrezzo() %>')">Aggiungi</button>
    <% } %>
    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= f.getNumeroSerie() %>', 'funko')">Preferiti</button>
    <% } %>
  </div>
  <% } %>
</div>
<% } %>

<% if ((listaManga == null || listaManga.isEmpty()) && (listaFunko == null || listaFunko.isEmpty())) { %>
<div style="text-align: center; margin: 3rem 0; color: #b0b0b0;">
  <h3>🔍 Nessun prodotto trovato</h3>
  <p>Prova a modificare i filtri di ricerca</p>
</div>
<% } %>
