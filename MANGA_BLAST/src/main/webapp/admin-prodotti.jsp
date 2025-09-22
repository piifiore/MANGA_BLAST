<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Manga, model.MangaDAO" %>
<%@ page import="model.Funko, model.FunkoDAO" %>
<%@ page import="model.Categoria, model.CategoriaDAO" %>

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

    // Carica le categorie per i form
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    List<Categoria> categorie = categoriaDAO.getAllCategorie();
    request.setAttribute("categorie", categorie);

    String aggiunto = request.getParameter("aggiunto");
    String errorePrezzo = request.getParameter("errorePrezzo");
    String erroreInserimento = request.getParameter("erroreInserimento");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🛒 Admin - Prodotti</title>
    <link rel="stylesheet" href="style/admin-prodotti-stile.css?v=<%= System.currentTimeMillis() %>">
    <script src="scripts/admin-prodotti.js"></script>
</head>
<body>

<div class="admin-prodotti-wrapper">

    <div class="admin-navigation">
        <h1>🛒 Gestione Prodotti</h1>
        <div class="admin-links">
            <a href="admin-prodotti.jsp" class="admin-link active">📦 Prodotti</a>
            <a href="GestioneCategorieServlet" class="admin-link">🏷️ Categorie</a>
        </div>
    </div>

    <% if (aggiunto != null) { %>
    <div class="success-msg">✔ <%= aggiunto.equals("manga") ? "Manga" : "Funko" %> aggiunto correttamente!</div>
    <% } else if (errorePrezzo != null) { %>
    <div class="error-msg">⚠️ Il prezzo inserito non è valido.</div>
    <% } else if (erroreInserimento != null) { %>
    <div class="error-msg">⚠️ Errore durante l'inserimento del prodotto.</div>
    <% } %>

    <section>
        <h2>Ricerca Manga</h2>

        <form action="CercaProdottiServlet" method="get" class="search-form">
            <input type="hidden" name="tipo" value="manga">

            <div class="form-group">
                <label for="queryManga">Cerca:</label>
                <input type="text" name="query" id="queryManga" placeholder="Titolo, descrizione, ISBN">
            </div>

            <div class="form-group">
                <label for="minManga">Prezzo minimo:</label>
                <input type="number" name="min" id="minManga" step="0.01" min="0">
            </div>

            <div class="form-group">
                <label for="maxManga">Prezzo massimo:</label>
                <input type="number" name="max" id="maxManga" step="0.01" min="0">
            </div>

            <div class="form-group">
                <label for="sortManga">Ordina:</label>
                <select name="sort" id="sortManga">
                    <option value="">--</option>
                    <option value="asc">Prezzo crescente</option>
                    <option value="desc">Prezzo decrescente</option>
                </select>
            </div>

            <button type="submit">🔍 Cerca Manga</button>
        </form>
        <p class="link-area">
            <a href="admin-prodotti.jsp" class="btn secondary">🔄 Reimposta filtri Manga</a>
        </p>
        <h2>Elenco Manga</h2>
        <p><strong><%= risultatiManga.size() %> manga disponibili</strong></p>
        <div id="ajax-manga-grid">
            <jsp:include page="risultati-manga.jsp" />
        </div>

        <h3>Aggiungi Manga</h3>
        <form action="AggiungiMangaServlet" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="isbn">ISBN:</label>
                <input type="text" name="ISBN" id="isbn" required>
            </div>
            <div class="form-group">
                <label for="nomeManga">Nome:</label>
                <input type="text" name="nome" id="nomeManga" required>
            </div>
            <div class="form-group">
                <label for="descrizioneManga">Descrizione:</label>
                <textarea name="descrizione" id="descrizioneManga" required></textarea>
            </div>
            <div class="form-group">
                <label for="prezzoManga">Prezzo:</label>
                <input type="number" name="prezzo" id="prezzoManga" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label for="imgManga">Immagine:</label>
                <input type="file" name="immagine" id="imgManga">
            </div>
            <div class="form-group">
                <label for="categoriaManga">Categoria:</label>
                <select name="id_categoria" id="categoriaManga">
                    <option value="">Seleziona categoria</option>
                    <% 
                    List<Categoria> categorieManga = (List<Categoria>) request.getAttribute("categorie");
                    if (categorieManga != null) {
                        for (Categoria categoria : categorieManga) {
                            // Mostra tutte le categorie (Horror, Fantasy, Romance)
                    %>
                    <option value="<%= categoria.getId() %>" style="color: <%= categoria.getColore() %>">
                        <%= categoria.getNome() %>
                    </option>
                    <% 
                        }
                    }
                    %>
                </select>
            </div>
            <button type="submit">Aggiungi Manga</button>
        </form>
    </section>

    <hr>

    <section>
        <h2>Ricerca Funko</h2>

        <form action="CercaProdottiServlet" method="get" class="search-form">
            <input type="hidden" name="tipo" value="funko">

            <div class="form-group">
                <label for="queryFunko">Cerca:</label>
                <input type="text" name="query" id="queryFunko" placeholder="Titolo, descrizione, serie">
            </div>

            <div class="form-group">
                <label for="minFunko">Prezzo minimo:</label>
                <input type="number" name="min" id="minFunko" step="0.01" min="0">
            </div>

            <div class="form-group">
                <label for="maxFunko">Prezzo massimo:</label>
                <input type="number" name="max" id="maxFunko" step="0.01" min="0">
            </div>

            <div class="form-group">
                <label for="sortFunko">Ordina:</label>
                <select name="sort" id="sortFunko">
                    <option value="">--</option>
                    <option value="asc">Prezzo crescente</option>
                    <option value="desc">Prezzo decrescente</option>
                </select>
            </div>

            <button type="submit">Cerca Funko</button>
        </form>
        <p class="link-area">
            <a href="admin-prodotti.jsp" class="btn secondary">🔄 Reimposta filtri Funko</a>
        </p>
        <h2>Elenco Funko</h2>
        <p><strong><%= risultatiFunko.size() %> funko disponibili</strong></p>
        <div id="ajax-funko-grid">
            <jsp:include page="risultati-funko.jsp" />
        </div>

        <h3>Aggiungi Funko</h3>
        <form action="AggiungiFunkoServlet" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="numeroSerie">Numero Serie:</label>
                <input type="text" name="numeroSerie" id="numeroSerie" required>
            </div>
            <div class="form-group">
                <label for="nomeFunko">Nome:</label>
                <input type="text" name="nome" id="nomeFunko" required>
            </div>
            <div class="form-group">
                <label for="descrizioneFunko">Descrizione:</label>
                <textarea name="descrizione" id="descrizioneFunko" required></textarea>
            </div>
            <div class="form-group">
                <label for="prezzoFunko">Prezzo:</label>
                <input type="number" name="prezzo" id="prezzoFunko" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label for="imgFunko">Immagine:</label>
                <input type="file" name="immagine" id="imgFunko">
            </div>
            <div class="form-group">
                <label for="categoriaFunko">Categoria:</label>
                <select name="id_categoria" id="categoriaFunko">
                    <option value="">Seleziona categoria</option>
                    <% 
                    List<Categoria> categorieFunko = (List<Categoria>) request.getAttribute("categorie");
                    if (categorieFunko != null) {
                        for (Categoria categoria : categorieFunko) {
                            // Mostra tutte le categorie (Horror, Fantasy, Romance)
                    %>
                    <option value="<%= categoria.getId() %>" style="color: <%= categoria.getColore() %>">
                        <%= categoria.getNome() %>
                    </option>
                    <% 
                        }
                    }
                    %>
                </select>
            </div>
            <button type="submit">Aggiungi Funko</button>
        </form>
    </section>

</div>

<jsp:include page="footer.jsp" />
</body>
</html>
