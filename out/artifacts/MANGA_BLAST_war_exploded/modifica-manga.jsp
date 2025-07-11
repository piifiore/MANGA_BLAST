<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.Manga" %>

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
    <title>Modifica Manga</title>
</head>
<body>

<%
    if (manga == null) {
%>
<h2>📛 Manga non trovato</h2>
<p><a href="admin-prodotti.jsp">⬅ Torna alla dashboard</a></p>
<%
} else {
%>

<h2>✏️ Modifica Manga - ISBN <%= manga.getISBN() %></h2>

<form action="ModificaMangaServlet" method="post" enctype="multipart/form-data">
    <input type="hidden" name="ISBN" value="<%= manga.getISBN() %>">

    <label for="nome">Nome:</label><br>
    <input type="text" id="nome" name="nome" value="<%= manga.getNome() %>" required><br>

    <label for="descrizione">Descrizione:</label><br>
    <textarea id="descrizione" name="descrizione" rows="4" cols="40" required><%= manga.getDescrizione() %></textarea><br>

    <label for="prezzo">Prezzo:</label><br>
    <input type="number" id="prezzo" name="prezzo" value="<%= manga.getPrezzo() %>" step="0.01" min="0" required><br>

    <label for="immagine">Immagine:</label><br>
    <input type="file" id="immagine" name="immagine"><br>
    <small>Attuale: <%= manga.getImmagine() %></small><br><br>

    <input type="submit" value="Salva modifiche">
</form>

<p><a href="admin-prodotti.jsp">⬅ Torna alla dashboard</a></p>

<%
    }
%>

</body>
</html>