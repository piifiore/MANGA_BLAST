<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MangaDAO, model.FunkoDAO, model.Manga, model.Funko" %>
<%
    String tipo = request.getParameter("tipo");
    String id = request.getParameter("id");

    Object prodotto = null;
    String errore = null;

    try {
        if ("manga".equals(tipo)) {
            MangaDAO dao = new MangaDAO();
            prodotto = dao.doRetrieveByISBN(Long.parseLong(id));
        } else if ("funko".equals(tipo)) {
            FunkoDAO dao = new FunkoDAO();
            prodotto = dao.doRetrieveByNumeroSerie(id);
        } else {
            errore = "Tipo prodotto non valido";
        }
    } catch (Exception e) {
        errore = "ID prodotto non valido";
        e.printStackTrace();
    }
%>
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
    <% } else if (prodotto != null) { %>
    <h2><%= tipo.equals("manga") ? ((Manga) prodotto).getNome() : ((Funko) prodotto).getNome() %></h2>

    <img
            src="${pageContext.request.contextPath}/<%= tipo.equals("manga") ? ((Manga) prodotto).getImmagine() : ((Funko) prodotto).getImmagine() %>"
            alt="Immagine prodotto"
            width="300"
    />

    <p><strong>Descrizione:</strong> <%= tipo.equals("manga") ? ((Manga) prodotto).getDescrizione() : ((Funko) prodotto).getDescrizione() %></p>
    <p><strong>Prezzo:</strong> <%= tipo.equals("manga") ? ((Manga) prodotto).getPrezzo() : ((Funko) prodotto).getPrezzo() %> €</p>

    <button onclick="aggiungiCarrello('<%= id %>', '<%= tipo %>', '<%= tipo.equals("manga") ? ((Manga) prodotto).getNome() : ((Funko) prodotto).getNome() %>', <%= tipo.equals("manga") ? ((Manga) prodotto).getPrezzo() : ((Funko) prodotto).getPrezzo() %>)">
        🛒 Aggiungi al carrello
    </button>

    <div class="contatto">
        <p>❓ Domande su questo prodotto?</p>
        <a href="mailto:info@mangablast.it?subject=Richiesta informazioni su <%= tipo.equals("manga") ? ((Manga) prodotto).getNome() : ((Funko) prodotto).getNome() %>" class="contattaci-btn">
            ✉️ Contattaci
        </a>
    </div>
    <% } else { %>
    <p style="color:red;">🚫 Prodotto non trovato</p>
    <% } %>
</div>

<script>
    function aggiungiCarrello(id, tipo, titolo, prezzo) {
        fetch('AggiungiAlCarrelloServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                id: id,
                tipo: tipo,
                titolo: titolo,
                prezzo: prezzo
            })
        })
            .then(response => response.text())
            .then(text => {
                if (text === 'aggiunto') {
                    mostraBanner("✅ Aggiunto al carrello!");
                }
            });
    }

    function mostraBanner(msg) {
        let banner = document.createElement('div');
        banner.textContent = msg;
        banner.style.position = 'fixed';
        banner.style.top = '10px';
        banner.style.right = '10px';
        banner.style.background = '#4CAF50';
        banner.style.color = '#fff';
        banner.style.padding = '10px';
        banner.style.borderRadius = '5px';
        banner.style.zIndex = '1000';
        document.body.appendChild(banner);
        setTimeout(() => banner.remove(), 2000);
    }
</script>

</body>
</html>
