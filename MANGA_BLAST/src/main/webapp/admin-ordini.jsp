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
    <link rel="stylesheet" href="style/admin-ordini.css">
</head>
<body>

<h1>📋 Ordini ricevuti</h1>

<%
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("ordini");
    if (ordini == null || ordini.isEmpty()) {
%>
<p>📭 Nessun ordine trovato.</p>
<%
} else {
%>
<table>
    <tr>
        <th>ID</th>
        <th>Email</th>
        <th>Data</th>
        <th>Totale</th>
        <th>Stato</th>
        <th>Dettagli</th>
    </tr>
    <%
        for (Ordine o : ordini) {
    %>
    <tr>
        <td><%= o.getId() %></td>
        <td><%= o.getEmailUtente() %></td>
        <td><%= o.getDataOra() %></td>
        <td><%= o.getTotale() %> €</td>
        <td>
            <form action="AggiornaStatoOrdineServlet" method="post">
                <input type="hidden" name="id" value="<%= o.getId() %>">
                <select name="stato">
                    <option <%= "In attesa".equals(o.getStato()) ? "selected" : "" %>>In attesa</option>
                    <option <%= "Spedito".equals(o.getStato()) ? "selected" : "" %>>Spedito</option>
                    <option <%= "Consegnato".equals(o.getStato()) ? "selected" : "" %>>Consegnato</option>
                </select>
                <input type="submit" value="✔️">
            </form>
        </td>
        <td>
            <ul>
                <%
                    for (ItemCarrello p : o.getProdotti()) {
                %>
                <li><%= p.getQuantita() %> x <%= p.getTitolo() %> — <%= p.getPrezzo() %> €</li>
                <%
                    }
                %>
            </ul>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
    }
%>

</body>
</html>
