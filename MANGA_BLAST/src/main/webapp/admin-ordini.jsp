<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.util.*" %>
<jsp:include page="header.jsp" />
<%
    String emailAdmin = (String) session.getAttribute("admin");
    if (emailAdmin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Ordini</title>
    <link rel="stylesheet" href="css/admin-ordini.css">
    <script src="scripts/admin-ordini.js"></script>
</head>
<body>


<h1>📦 Gestione Ordini</h1>

<div class="filters">
    <label>Email cliente:</label>
    <input type="text" id="searchEmail">
    <label>Stato:</label>
    <select id="filterStato">
        <option value="">-- Tutti --</option>
        <option value="In attesa">In attesa</option>
        <option value="Spedito">Spedito</option>
        <option value="Consegnato">Consegnato</option>
    </select>
    <label>Ordina per:</label>
    <select id="ordina">
        <option value="data_desc">Data ↓</option>
        <option value="data_asc">Data ↑</option>
        <option value="totale_desc">Totale ↓</option>
        <option value="totale_asc">Totale ↑</option>
    </select>
</div>

<div id="ordiniContainer">
    <!-- Risultati AJAX -->
</div>



</body>
</html>