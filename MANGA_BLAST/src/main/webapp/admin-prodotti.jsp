<meta charset="UTF-8">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Manga,model.MangaDAO" %>
<%@ page import="model.Funko,model.FunkoDAO" %>

<jsp:include page="header.jsp" />

<%
    List<Manga> risultatiManga = (List<Manga>) request.getAttribute("risultatiManga");
    List<Funko> risultatiFunko = (List<Funko>) request.getAttribute("risultatiFunko");

    if (risultatiManga == null) {
        MangaDAO daoM = new MangaDAO();
        risultatiManga = daoM.getAllManga();
        request.setAttribute("risultatiManga", risultatiManga);
    }

    if (risultatiFunko == null) {
        FunkoDAO daoF = new FunkoDAO();
        risultatiFunko = daoF.getAllFunko();
        request.setAttribute("risultatiFunko", risultatiFunko);
    }

    String aggiunto = request.getParameter("aggiunto");
    String errorePrezzo = request.getParameter("errorePrezzo");
    String erroreInserimento = request.getParameter("erroreInserimento");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - Prodotti</title>
    <link rel="stylesheet" href="style/admin-prodotti-stile.css">
</head>
<body>

<% if (aggiunto != null) { %>
<div style="background-color:#d4edda;color:#155724;padding:10px;margin-bottom:10px;border:1px solid #c3e6cb;">
    ✔ <%= aggiunto.equals("manga") ? "Manga" : "Funko" %> aggiunto correttamente!
</div>
<% } else if (errorePrezzo != null) { %>
<div style="background-color:#f8d7da;color:#721c24;padding:10px;margin-bottom:10px;border:1px solid #f5c6cb;">
    ⚠️ Il prezzo inserito non è valido.
</div>
<% } else if (erroreInserimento != null) { %>
<div style="background-color:#f8d7da;color:#721c24;padding:10px;margin-bottom:10px;border:1px solid #f5c6cb;">
    ⚠️ Errore durante l'inserimento del prodotto.
</div>
<% } %>

<div class="section">
    <h2>Gestione Manga</h2>

    <form action="CercaProdottiServlet" method="get">
        <input type="hidden" name="tipo" value="manga">
        <table class="filtro-table">
            <tr><td><label>Cerca:</label></td><td><input type="text" name="query" placeholder="Titolo, descrizione, ISBN"></td></tr>
            <tr><td><label>Prezzo minimo:</label></td><td><input type="number" name="min" step="0.01" min="0"></td></tr>
            <tr><td><label>Prezzo massimo:</label></td><td><input type="number" name="max" step="0.01" min="0"></td></tr>
            <tr>
                <td><label>Ordina:</label></td>
                <td>
                    <select name="sort">
                        <option value="">--</option>
                        <option value="asc">Prezzo crescente</option>
                        <option value="desc">Prezzo decrescente</option>
                    </select>
                </td>
            </tr>
            <tr><td colspan="2"><input type="submit" value="Cerca Manga"></td></tr>
        </table>
    </form>

    <p><strong><%= risultatiManga.size() %> manga trovati</strong></p>
    <jsp:include page="risultati-manga.jsp" />

    <form action="AggiungiMangaServlet" method="post" enctype="multipart/form-data">
        <h3>Aggiungi Manga</h3>
        <table class="form-table">
            <tr><td><label>ISBN:</label></td><td><input type="text" name="ISBN" required></td></tr>
            <tr><td><label>Nome:</label></td><td><input type="text" name="nome" required></td></tr>
            <tr><td><label>Descrizione:</label></td><td><textarea name="descrizione" required></textarea></td></tr>
            <tr><td><label>Prezzo:</label></td><td><input type="number" name="prezzo" step="0.01" min="0" required></td></tr>
            <tr><td><label>Immagine:</label></td><td><input type="file" name="immagine"></td></tr>
            <tr><td colspan="2"><input type="submit" value="Aggiungi Manga"></td></tr>
        </table>
    </form>
</div>

<hr>

<div class="section">
    <h2>Gestione Funko</h2>

    <form action="CercaProdottiServlet" method="get">
        <input type="hidden" name="tipo" value="funko">
        <table class="filtro-table">
            <tr><td><label>Cerca:</label></td><td><input type="text" name="query" placeholder="Titolo, descrizione, serie"></td></tr>
            <tr><td><label>Prezzo minimo:</label></td><td><input type="number" name="min" step="0.01" min="0"></td></tr>
            <tr><td><label>Prezzo massimo:</label></td><td><input type="number" name="max" step="0.01" min="0"></td></tr>
            <tr>
                <td><label>Ordina:</label></td>
                <td>
                    <select name="sort">
                        <option value="">--</option>
                        <option value="asc">Prezzo crescente</option>
                        <option value="desc">Prezzo decrescente</option>
                    </select>
                </td>
            </tr>
            <tr><td colspan="2"><input type="submit" value="Cerca Funko"></td></tr>
        </table>
    </form>

    <p><strong><%= risultatiFunko.size() %> funko trovati</strong></p>
    <jsp:include page="risultati-funko.jsp" />

    <form action="AggiungiFunkoServlet" method="post" enctype="multipart/form-data">
        <h3>Aggiungi Funko</h3>
        <table class="form-table">
            <tr><td><label>Numero serie:</label></td><td><input type="text" name="numeroSerie" required></td></tr>
            <tr><td><label>Nome:</label></td><td><input type="text" name="nome" required></td></tr>
            <tr><td><label>Descrizione:</label></td><td><textarea name="descrizione" required></textarea></td></tr>
            <tr><td><label>Prezzo:</label></td><td><input type="number" name="prezzo" step="0.01" min="0" required></td></tr>
            <tr><td><label>Immagine:</label></td><td><input type="file" name="immagine"></td></tr>
            <tr><td colspan="2"><input type="submit" value="Aggiungi Funko"></td></tr>
        </table>
    </form>
</div>

</body>
</html>
