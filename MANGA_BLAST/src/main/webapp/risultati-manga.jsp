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
                <input type="submit" value="✏️ Modifica" class="btn btn-edit">
            </form>
            <form action="EliminaMangaServlet" method="post" style="display:inline;" onsubmit="return confirm('Eliminare questo manga?');">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
                <input type="submit" value="🗑️ Elimina" class="btn btn-delete">
            </form>
        </td>
    </tr>
    <%
        }
    %>
</table>
<% } %>

<!-- Card manga per mobile/tablet -->
<div class="manga-cards-mobile">
<%
    if (risultati != null && !risultati.isEmpty()) {
        for (Manga m : risultati) {
%>
    <div class="manga-card">
        <div class="manga-card-row"><strong>ISBN:</strong> <%= m.getISBN() %></div>
        <div class="manga-card-row"><strong>Nome:</strong> <%= m.getNome() %></div>
        <div class="manga-card-row"><strong>Descrizione:</strong> <%= m.getDescrizione() %></div>
        <div class="manga-card-row"><strong>Prezzo:</strong> <%= m.getPrezzo() %> &euro;</div>
        <div class="manga-card-row"><strong>Immagine:</strong><br><img src="<%= request.getContextPath() + "/" + m.getImmagine() %>" width="100"></div>
        <div class="manga-card-row">
            <form action="modifica-manga.jsp" method="get" style="display:inline;">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
                <input type="submit" value="✏️ Modifica" class="btn btn-edit">
            </form>
            <form action="EliminaMangaServlet" method="post" style="display:inline;" onsubmit="return confirm('Eliminare questo manga?');">
                <input type="hidden" name="ISBN" value="<%= m.getISBN() %>">
                <input type="submit" value="🗑️ Elimina" class="btn btn-delete">
            </form>
        </div>
    </div>
<%  }
   }
%>
</div>
