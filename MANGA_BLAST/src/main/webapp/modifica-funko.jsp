<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.FunkoDAO" %>
<%@ page import="model.Funko" %>
<jsp:include page="header.jsp" />

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
  <link rel="stylesheet" href="style/modifica-funko.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<main class="modifica-container">
  <% if (funko == null) { %>
  <div class="not-found">
    <h2>Funko non trovato</h2>
    <a href="admin-prodotti.jsp" class="btn">Torna ai Prodotti</a>
  </div>
  <% } else { %>
  <h1>Modifica Funko</h1>

  <form action="ModificaFunkoServlet" method="post" enctype="multipart/form-data" class="modifica-form">
    <input type="hidden" name="numeroSerie" value="<%= funko.getNumeroSerie() %>">

    <label for="nome">Nome</label>
    <input type="text" id="nome" name="nome" value="<%= funko.getNome() %>" required>

    <label for="descrizione">Descrizione</label>
    <textarea id="descrizione" name="descrizione" rows="5" required><%= funko.getDescrizione() %></textarea>

    <label for="prezzo">Prezzo</label>
    <input type="number" id="prezzo" name="prezzo" value="<%= funko.getPrezzo() %>" step="0.01" min="0" required>

    <label for="immagine">Immagine</label>
    <input type="file" id="immagine" name="immagine">
    <p class="attuale">Attuale: <%= funko.getImmagine() %></p>

    <div class="form-actions">
      <input type="submit" value="Salva modifiche" class="btn">
      <a href="admin-prodotti.jsp" class="btn secondary">Annulla</a>
    </div>
  </form>
  <% } %>
</main>

<jsp:include page="footer.jsp" />
</body>
</html>
