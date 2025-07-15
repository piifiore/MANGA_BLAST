<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Funko" %>

<%
    List<Funko> risultati = (List<Funko>) request.getAttribute("risultatiFunko");
    if (risultati == null || risultati.isEmpty()) {
%>
<p>Nessun Funko trovato.</p>
<%
} else {
%>
<table>
    <tr>
        <th>Numero Serie</th>
        <th>Nome</th>
        <th>Descrizione</th>
        <th>Prezzo</th>
        <th>Immagine</th>
        <th>Azioni</th>
    </tr>
    <%
        for (Funko f : risultati) {
    %>
    <tr>
        <td><%= f.getNumeroSerie() %></td>
        <td><%= f.getNome() %></td>
        <td><%= f.getDescrizione() %></td>
        <td><%= f.getPrezzo() %> &euro;</td>
        <td><img src="<%= request.getContextPath() + "/" + f.getImmagine() %>" width="100"></td>
        <td>
            <form action="modifica-funko.jsp" method="get" style="display:inline;">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="Modifica">
            </form>
            <form action="EliminaFunkoServlet" method="post" style="display:inline;" onsubmit="return confirm('Eliminare questo Funko?');">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="Elimina">
            </form>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
    }
%>
