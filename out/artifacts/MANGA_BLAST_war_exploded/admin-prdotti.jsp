<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MangaDAO" %>
<%@ page import="model.Manga" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Funko" %>

<%
    MangaDAO mangaDAO = new MangaDAO();
    List<Manga> listaManga = mangaDAO.getAllManga();

    FunkoDAO funkoDAO = new FunkoDAO();
    List<Funko> listaFunko = funkoDAO.getAllFunko();
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - Prodotti</title>
</head>
<body>

<h1>🔧 Pannello di Gestione Prodotti</h1>

<hr>
<h2>📚 Gestione Manga</h2>

<table border="1" cellpadding="10">
    <tr>
        <th>ISBN</th>
        <th>Nome</th>
        <th>Descrizione</th>
        <th>Prezzo</th>
        <th>Immagine</th>
        <th>Azioni</th>
    </tr>

    <% if (listaManga.isEmpty()) { %>
    <tr><td colspan="6">📭 Nessun manga presente nel catalogo</td></tr>
    <% } else {
        for (Manga m : listaManga) { %>
    <tr>
        <td><%= m.getISBN() %></td>
        <td><%= m.getNome() %></td>
        <td><%= m.getDescrizione() %></td>
        <td><%= m.getPrezzo() %> €</td>
        <td><img src="images/<%= m.getImmagine() %>" width="100"></td>
        <td>
            <form action="ModificaMangaServlet" method="get" style="display:inline;">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
                <input type="submit" value="Modifica">
            </form>
            <form action="EliminaMangaServlet" method="post" style="display:inline;">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
                <input type="submit" value="Elimina" onclick="return confirm('Eliminare questo manga?')">
            </form>
        </td>
    </tr>
    <% } } %>
</table>

<h3>➕ Aggiungi nuovo Manga</h3>
<form action="AggiungiMangaServlet" method="post" enctype="multipart/form-data">
    <label>ISBN:</label><br>
    <input type="text" name="ISBN" required><br>

    <label>Nome:</label><br>
    <input type="text" name="nome" required><br>

    <label>Descrizione:</label><br>
    <textarea name="descrizione" rows="4" cols="40" required></textarea><br>

    <label>Prezzo:</label><br>
    <input type="text" name="prezzo" required><br>

    <label>Immagine:</label><br>
    <input type="file" name="immagine"><br><br>

    <input type="submit" value="Aggiungi Manga">
</form>

<hr>
<h2>👽 Gestione Funko</h2>

<table border="1" cellpadding="10">
    <tr>
        <th>Numero Serie</th>
        <th>Nome</th>
        <th>Descrizione</th>
        <th>Prezzo</th>
        <th>Immagine</th>
        <th>Azioni</th>
    </tr>

    <% if (listaFunko.isEmpty()) { %>
    <tr><td colspan="6">📭 Nessun Funko nel catalogo</td></tr>
    <% } else {
        for (Funko f : listaFunko) { %>
    <tr>
        <td><%= f.getNumeroSerie() %></td>
        <td><%= f.getNome() %></td>
        <td><%= f.getDescrizione() %></td>
        <td><%= f.getPrezzo() %> €</td>
        <td><img src="images/<%= f.getImmagine() %>" width="100"></td>
        <td>
            <form action="ModificaFunkoServlet" method="get" style="display:inline;">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="Modifica">
            </form>
            <form action="EliminaFunkoServlet" method="post" style="display:inline;">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="Elimina" onclick="return confirm('Eliminare questo Funko?')">
            </form>
        </td>
    </tr>
    <% } } %>
</table>

<h3>➕ Aggiungi nuovo Funko</h3>
<form action="AggiungiFunkoServlet" method="post" enctype="multipart/form-data">
    <label>Numero Serie:</label><br>
    <input type="text" name="numeroSerie" required><br>

    <label>Nome:</label><br>
    <input type="text" name="nome" required><br>

    <label>Descrizione:</label><br>
    <textarea name="descrizione" rows="4" cols="40" required></textarea><br>

    <label>Prezzo:</label><br>
    <input type="text" name="prezzo" required><br>

    <label>Immagine:</label><br>
    <input type="file" name="immagine"><br><br>

    <input type="submit" value="Aggiungi Funko">
</form>

</body>
</html>