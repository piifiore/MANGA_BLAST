<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.ItemCarrello" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Ordini</title>
    <link rel="stylesheet" href="style/admin-ordini.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<h1>Ordini ricevuti</h1>

<%
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("ordini");
    if (ordini == null || ordini.isEmpty()) {
%>
<p class="empty-message">Nessun ordine trovato.</p>
<%
} else {
%>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Email</th>
        <th>Data</th>
        <th>Totale</th>
        <th>Stato</th>
        <th>Dettagli</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (Ordine o : ordini) {
    %>
    <tr>
        <td><%= o.getId() %></td>
        <td><%= o.getEmailUtente() %></td>
        <td><%= o.getDataOra().toString().replace("T", " ") %></td>
        <td><%= o.getTotale() %> €</td>
        <td>
            <form action="AggiornaStatoOrdineServlet" method="post" class="stato-form">
                <input type="hidden" name="id" value="<%= o.getId() %>">
                <select name="stato" class="stato-select <%= o.getStato().toLowerCase().replace(" ", "-") %>">
                    <option value="In attesa" <%= "In attesa".equals(o.getStato()) ? "selected" : "" %>>In attesa</option>
                    <option value="Spedito" <%= "Spedito".equals(o.getStato()) ? "selected" : "" %>>Spedito</option>
                    <option value="Consegnato" <%= "Consegnato".equals(o.getStato()) ? "selected" : "" %>>Consegnato</option>
                </select>
                <input type="submit" value="Aggiorna">
            </form>
        </td>
        <td>
            <ul>
                <%
                    for (ItemCarrello p : o.getProdotti()) {
                %>
                <li><%= p.getQuantita() %> x <%= p.getTitolo() %> - <%= p.getPrezzo() %> €</li>
                <%
                    }
                %>
            </ul>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<%
    }
%>

</body>
</html>
