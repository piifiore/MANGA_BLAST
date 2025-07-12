<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - Prodotti</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 40px; }
        h2 { margin-top: 40px; }
        input[type="text"], input[type="number"], select {
            padding: 8px;
            margin: 5px;
            font-size: 14px;
        }
        table { margin-top: 20px; width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }
        img { max-width: 100px; }
        form.inline { display: inline; }
        .section { margin-bottom: 60px; }
    </style>
</head>
<body>

<h1>🔧 Pannello di Gestione Prodotti</h1>

<!-- ================= Manga ================= -->
<div class="section">
    <h2>📚 Gestione Manga</h2>

    <input type="text" id="mangaSearch" placeholder="🔎 Cerca per nome, descrizione o ISBN...">
    <label>Prezzo minimo:</label>
    <input type="number" id="mangaMin" min="0">
    <label>Prezzo massimo:</label>
    <input type="number" id="mangaMax" min="0">
    <label>Ordina per prezzo:</label>
    <select id="mangaSort">
        <option value="">--</option>
        <option value="asc">Crescente</option>
        <option value="desc">Decrescente</option>
    </select>

    <div id="mangaResults"></div>

    <h3>➕ Aggiungi nuovo Manga</h3>
    <form action="AggiungiMangaServlet" method="post" enctype="multipart/form-data">
        <label>ISBN:</label><br>
        <input type="text" name="ISBN" required><br>
        <label>Nome:</label><br>
        <input type="text" name="nome" required><br>
        <label>Descrizione:</label><br>
        <textarea name="descrizione" rows="4" cols="40" required></textarea><br>
        <label>Prezzo:</label><br>
        <input type="number" name="prezzo" step="0.01" min="0" required><br>
        <label>Immagine:</label><br>
        <input type="file" name="immagine"><br><br>
        <input type="submit" value="Aggiungi Manga">
    </form>
</div>

<!-- ================= Funko ================= -->
<div class="section">
    <h2>👽 Gestione Funko</h2>

    <input type="text" id="funkoSearch" placeholder="🔎 Cerca per nome, descrizione o numero serie...">
    <label>Prezzo minimo:</label>
    <input type="number" id="funkoMin" min="0">
    <label>Prezzo massimo:</label>
    <input type="number" id="funkoMax" min="0">
    <label>Ordina per prezzo:</label>
    <select id="funkoSort">
        <option value="">--</option>
        <option value="asc">Crescente</option>
        <option value="desc">Decrescente</option>
    </select>

    <div id="funkoResults"></div>

    <h3>➕ Aggiungi nuovo Funko</h3>
    <form action="AggiungiFunkoServlet" method="post" enctype="multipart/form-data">
        <label>Numero Serie:</label><br>
        <input type="text" name="numeroSerie" required><br>
        <label>Nome:</label><br>
        <input type="text" name="nome" required><br>
        <label>Descrizione:</label><br>
        <textarea name="descrizione" rows="4" cols="40" required></textarea><br>
        <label>Prezzo:</label><br>
        <input type="number" name="prezzo" step="0.01" min="0" required><br>
        <label>Immagine:</label><br>
        <input type="file" name="immagine"><br><br>
        <input type="submit" value="Aggiungi Funko">
    </form>
</div>

<script>
    function ajaxSearch(tipo) {
        const query = document.getElementById(tipo + "Search").value;
        const min = document.getElementById(tipo + "Min").value;
        const max = document.getElementById(tipo + "Max").value;
        const sort = document.getElementById(tipo + "Sort").value;

        const xhr = new XMLHttpRequest();
        xhr.open("GET", "CercaProdottiServlet?tipo=" + tipo +
            "&query=" + encodeURIComponent(query) +
            "&min=" + min +
            "&max=" + max +
            "&sort=" + sort, true);
        xhr.onload = function() {
            if (xhr.status === 200) {
                document.getElementById(tipo + "Results").innerHTML = xhr.responseText;
            }
        };
        xhr.send();
    }

    // Event listeners
    ["Search", "Min", "Max", "Sort"].forEach(field => {
        document.getElementById("manga" + field).addEventListener("input", () => ajaxSearch("manga"));
        document.getElementById("funko" + field).addEventListener("input", () => ajaxSearch("funko"));
    });

    // Load all on start
    window.addEventListener("load", function() {
        ajaxSearch("manga");
        ajaxSearch("funko");
    });
</script>

</body>
</html>