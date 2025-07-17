<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.Manga" %>
<jsp:include page="header.jsp" />

<%
    String isbnParam = request.getParameter("ISBN");
    final long isbn = Long.parseLong(isbnParam);
    Manga manga = null;

    try {
        MangaDAO dao = new MangaDAO();
        manga = dao.getAllManga()
                .stream()
                .filter(m -> m.getISBN() == isbn)
                .findFirst()
                .orElse(null);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifica Manga</title>
    <link rel="stylesheet" href="style/modifica-manga.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<main class="modifica-container">
    <% if (manga == null) { %>
    <div class="not-found">
        <h2>Manga non trovato</h2>
        <a href="admin-prodotti.jsp" class="btn">Torna ai Prodotti</a>
    </div>
    <% } else { %>
    <h1>Modifica Manga</h1>

    <form action="ModificaMangaServlet" method="post" enctype="multipart/form-data" class="modifica-form">
        <input type="hidden" name="ISBN" value="<%= manga.getISBN() %>">

        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" value="<%= manga.getNome() %>" required>

        <label for="descrizione">Descrizione</label>
        <textarea id="descrizione" name="descrizione" rows="5" required><%= manga.getDescrizione() %></textarea>

        <label for="prezzo">Prezzo</label>
        <input type="number" id="prezzo" name="prezzo" value="<%= manga.getPrezzo() %>" step="0.01" min="0" required>

        <label for="immagine">Copertina</label>
        <input type="file" id="immagine" name="immagine">
        <p class="attuale">Attuale: <%= manga.getImmagine() %></p>

        <div class="form-actions">
            <input type="submit" value="Salva modifiche" class="btn">
            <a href="admin-prodotti.jsp" class="btn secondary">Annulla</a>
        </div>
    </form>
    <% } %>
</main>

<jsp:include page="footer.jsp" />
</body>
</html>
