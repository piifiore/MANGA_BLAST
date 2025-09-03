<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Ordini</title>
    <link rel="stylesheet" href="style/admin-ordini.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<h1>Ordini ricevuti</h1>

<!-- FILTRI ORDINI -->
<div class="ordini-filtri" style="margin-bottom: 2rem; display: flex; gap: 1rem; flex-wrap: wrap; align-items: flex-end;">
    <div>
        <label for="searchEmail">Filtra per email utente:</label><br>
        <input type="text" id="searchEmail" name="searchEmail" placeholder="Email utente..." style="padding: 0.4rem; border-radius: 6px; border: 1px solid #ccc;">
    </div>
    <div>
        <label for="filterStato">Stato ordine:</label><br>
        <select id="filterStato" name="filterStato" style="padding: 0.4rem; border-radius: 6px; border: 1px solid #ccc;">
            <option value="">Tutti</option>
            <option value="In attesa">In attesa</option>
            <option value="Spedito">Spedito</option>
            <option value="Consegnato">Consegnato</option>
            <option value="Archiviato">Archiviato</option>
        </select>
    </div>
    <div>
        <label for="dataDa">Data ordine da:</label><br>
        <input type="date" id="dataDa" name="dataDa" style="padding: 0.4rem; border-radius: 6px; border: 1px solid #ccc;">
    </div>
    <div>
        <label for="dataA">Data ordine a:</label><br>
        <input type="date" id="dataA" name="dataA" style="padding: 0.4rem; border-radius: 6px; border: 1px solid #ccc;">
    </div>
    <div>
        <label for="ordina">Ordina per:</label><br>
        <select id="ordina" name="ordina" style="padding: 0.4rem; border-radius: 6px; border: 1px solid #ccc;">
            <option value="">ID ordine</option>
            <option value="data">Data</option>
            <option value="totale">Totale</option>
        </select>
    </div>
</div>

<!-- CONTAINER ORDINI -->
<div id="ordiniContainer"></div>

<!-- SEZIONE ORDINI ARCHIVIATI -->
<div id="ordiniArchiviatiSection">
    <hr style="margin: 3rem 0; border: 1px solid #ddd;">
    <h2 style="color: #666; text-align: center; margin-bottom: 2rem;">📁 Ordini Archiviati</h2>
    <div id="ordiniArchiviatiContainer"></div>
</div>

</body>
<script src="scripts/admin-ordini.js"></script>
</html>
