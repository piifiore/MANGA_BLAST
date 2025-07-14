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
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/index.jsp">Home</a> &raquo;
    <a href="${pageContext.request.contextPath}/index.jsp#<%= tipo %>">Prodotti <%= tipo %></a> &raquo;
    <span>Scheda</span>
</div>

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

    <form action="AggiungiAlCarrelloServlet" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="hidden" name="tipo" value="<%= tipo %>">
        <input type="hidden" name="titolo" value="<%= nome %>">
        <input type="hidden" name="prezzo" value="<%= prezzo %>">
        <button type="submit">🛒 Aggiungi al carrello</button>
    </form>

    <% if (emailUser != null) { %>
    <button onclick="aggiungiPreferiti('<%= id %>', '<%= tipo %>')">❤️ Aggiungi ai preferiti</button>
    <% } %>

    <div class="contatto">
        <p>❓ Domande su questo prodotto?</p>
        <a href="mailto:info@mangablast.it?subject=Richiesta informazioni su <%= nome %>" class="contattaci-btn">
            ✉️ Contattaci
        </a>
    </div>
    <% } else { %>
    <p style="color:red;">🚫 Prodotto non trovato</p>
    <% } %>
</div>

<script>
    function aggiungiPreferiti(idProdotto, tipo) {
        fetch('AggiungiPreferitoServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ idProdotto, tipo })
        })
            .then(res => res.text())
            .then(text => {
                if (text.trim() === "aggiunto") {
                    mostraBanner("❤️ Aggiunto ai preferiti!");
                } else if (text.trim() === "esiste") {
                    mostraBanner("⚠️ Già presente nei preferiti!");
                }
            });
    }

    function mostraBanner(msg) {
        let banner = document.createElement('div');
        banner.textContent = msg;
        banner.style.position = 'fixed';
        banner.style.top = '10px';
        banner.style.right = '10px';
        banner.style.background = msg.includes("⚠️") ? '#FFC107' : '#E91E63';
        banner.style.color = '#fff';
        banner.style.padding = '10px 20px';
        banner.style.fontWeight = 'bold';
        banner.style.borderRadius = '5px';
        banner.style.zIndex = '1000';
        banner.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
        document.body.appendChild(banner);
        setTimeout(() => banner.remove(), 2000);
    }
</script>

</body>
</html>
