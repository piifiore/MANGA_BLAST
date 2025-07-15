<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Manga" %>

<%
    List<Manga> risultati = (List<Manga>) request.getAttribute("risultatiManga");
%>

<%
    if (risultati == null || risultati.isEmpty()) {
%>
<p>Nessun manga trovato.</p>
<%
} else {
%>
<table>
    <tr>
        <th>ISBN</th>
        <th>Nome</th>
        <th>Descrizione</th>
        <th>Prezzo</th>
        <th>Immagine</th>
        <th>Azioni</th>
    </tr>
    <%
        for (Manga m : risultati) {
    %>
    <tr>
        <td><%= m.getISBN() %></td>
        <td><%= m.getNome() %></td>
        <td><%= m.getDescrizione() %></td>
        <td><%= m.getPrezzo() %> &euro;</td>
        <td><img src="<%= request.getContextPath() + "/" + m.getImmagine() %>" width="100"></td>
        <td>
            <form action="modifica-manga.jsp" method="get" style="display:inline;">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
                <input type="submit" value="Modifica">
            </form>
            <form action="EliminaMangaServlet" method="post" style="display:inline;" onsubmit="return confirm('Eliminare questo manga?');">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
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
