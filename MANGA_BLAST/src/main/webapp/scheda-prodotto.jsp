<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MangaDAO, model.FunkoDAO, model.Manga, model.Funko" %>
<%
    String tipo = request.getParameter("tipo");
    String id = request.getParameter("id");

    Object prodotto = null;
    String errore = null;

    try {
        if ("manga".equals(tipo)) {
            prodotto = new MangaDAO().doRetrieveByISBN(Long.parseLong(id));
        } else if ("funko".equals(tipo)) {
            prodotto = new FunkoDAO().doRetrieveByNumeroSerie(id);
        } else {
            errore = "Tipo prodotto non valido";
        }
    } catch (Exception e) {
        errore = "ID prodotto non valido";
        e.printStackTrace();
    }

    String emailUser = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Scheda Prodotto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/scheda.css">
    <script src="scripts/scheda-prodotto.js"></script>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="scheda">
    <% if (errore != null) { %>
    <p style="color:red;">🚫 Errore: <%= errore %></p>
    <% } else if (prodotto != null) {
        String nome = tipo.equals("manga") ? ((Manga) prodotto).getNome() : ((Funko) prodotto).getNome();
        String descrizione = tipo.equals("manga") ? ((Manga) prodotto).getDescrizione() : ((Funko) prodotto).getDescrizione();
        String immagine = tipo.equals("manga") ? ((Manga) prodotto).getImmagine() : ((Funko) prodotto).getImmagine();
        String prezzo = tipo.equals("manga") ? ((Manga) prodotto).getPrezzo().toString() : ((Funko) prodotto).getPrezzo().toString();
    %>
    <h2><%= nome %></h2>
    <img src="${pageContext.request.contextPath}/<%= immagine %>" alt="Immagine prodotto" width="300" />
    <p><strong>Descrizione:</strong> <%= descrizione %></p>
    <p><strong>Prezzo:</strong> <%= prezzo %> €</p>

    <button onclick="aggiungiCarrello('<%= id %>', '<%= tipo %>', '<%= nome %>', '<%= prezzo %>')">🛒 Aggiungi al carrello</button>

    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= id %>', '<%= tipo %>')">❤️ Aggiungi ai preferiti</button>
    <% } %>
    <% } else { %>
    <p style="color:red;">🚫 Prodotto non trovato</p>
    <% } %>
</div>



</body>
</html>
