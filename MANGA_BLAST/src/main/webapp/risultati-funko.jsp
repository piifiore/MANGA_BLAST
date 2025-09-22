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
                <input type="submit" value="✏️ Modifica" class="btn btn-edit">
            </form>
            <form action="EliminaFunkoServlet" method="post" style="display:inline;" onsubmit="return confirm('Eliminare questo Funko?');">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="🗑️ Elimina" class="btn btn-delete">
            </form>
        </td>
    </tr>
    <%
        }
    %>
</table>
<% } %>

<!-- Card funko per mobile/tablet -->
<div class="funko-cards-mobile">
<%
    if (risultati != null && !risultati.isEmpty()) {
        for (Funko f : risultati) {
%>
    <div class="funko-card">
        <div class="funko-card-row"><strong>Numero Serie:</strong> <%= f.getNumeroSerie() %></div>
        <div class="funko-card-row"><strong>Nome:</strong> <%= f.getNome() %></div>
        <div class="funko-card-row"><strong>Descrizione:</strong> <%= f.getDescrizione() %></div>
        <div class="funko-card-row"><strong>Prezzo:</strong> <%= f.getPrezzo() %> &euro;</div>
        <div class="funko-card-row"><strong>Immagine:</strong><br><img src="<%= request.getContextPath() + "/" + f.getImmagine() %>" width="100"></div>
        <div class="funko-card-row">
            <form action="modifica-funko.jsp" method="get" style="display:inline;">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="✏️ Modifica" class="btn btn-edit">
            </form>
            <form action="EliminaFunkoServlet" method="post" style="display:inline;" onsubmit="return confirm('Eliminare questo Funko?');">
                <input type="hidden" name="numeroSerie" value="<%= f.getNumeroSerie() %>">
                <input type="submit" value="🗑️ Elimina" class="btn btn-delete">
            </form>
        </div>
    </div>
<%  }
   }
%>
</div>
