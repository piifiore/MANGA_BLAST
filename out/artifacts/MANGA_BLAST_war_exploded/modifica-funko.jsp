<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="navbar.jsp" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Funko" %>

<%
  String numeroSerieParam = request.getParameter("numeroSerie");
  final String numeroSerie = numeroSerieParam;
  Funko funko = null;

  try {
    FunkoDAO dao = new FunkoDAO();
    funko = dao.getAllFunko()
            .stream()
            .filter(f -> f.getNumeroSerie().equals(numeroSerie))
            .findFirst()
            .orElse(null);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Modifica Funko</title>
</head>
<body>

<%
  if (funko == null) {
%>
<h2>📛 Funko non trovato</h2>
<p><a href="admin-prodotti.jsp">⬅ Torna alla dashboard</a></p>
<%
} else {
%>

<h2>✏️ Modifica Funko - Serie <%= funko.getNumeroSerie() %></h2>

<form action="ModificaFunkoServlet" method="post" enctype="multipart/form-data">
  <input type="hidden" name="numeroSerie" value="<%= funko.getNumeroSerie() %>">

  <label for="nome">Nome:</label><br>
  <input type="text" id="nome" name="nome" value="<%= funko.getNome() %>" required><br>

  <label for="descrizione">Descrizione:</label><br>
  <textarea id="descrizione" name="descrizione" rows="4" cols="40" required><%= funko.getDescrizione() %></textarea><br>

  <label for="prezzo">Prezzo:</label><br>
  <input type="number" id="prezzo" name="prezzo" value="<%= funko.getPrezzo() %>" step="0.01" min="0" required><br>

  <label for="immagine">Immagine:</label><br>
  <input type="file" id="immagine" name="immagine"><br>
  <small>Attuale: <%= funko.getImmagine() %></small><br><br>

  <input type="submit" value="Salva modifiche">
</form>

<p><a href="admin-prodotti.jsp">⬅ Torna alla dashboard</a></p>

<%
  }
%>

</body>
</html>