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
<div class="ordini-filtri">
    <div>
        <label for="searchEmail">Filtra per email utente:</label>
        <input type="text" id="searchEmail" name="searchEmail" placeholder="Email utente...">
    </div>
    <div>
        <label for="filterStato">Stato ordine:</label>
        <select id="filterStato" name="filterStato">
            <option value="">Tutti</option>
            <option value="In attesa">In attesa</option>
            <option value="Spedito">Spedito</option>
            <option value="Consegnato">Consegnato</option>
            <option value="Archiviato">Archiviato</option>
        </select>
    </div>
    <div>
        <label for="dataDa">Data ordine da:</label>
        <input type="date" id="dataDa" name="dataDa">
    </div>
    <div>
        <label for="dataA">Data ordine a:</label>
        <input type="date" id="dataA" name="dataA">
    </div>
    <div>
        <label for="ordina">Ordina per:</label>
        <select id="ordina" name="ordina">
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
    <hr>
    <h2>📁 Ordini Archiviati</h2>
    <div id="ordiniArchiviatiContainer"></div>
</div>

</body>
<script src="scripts/admin-ordini.js"></script>
</html>
