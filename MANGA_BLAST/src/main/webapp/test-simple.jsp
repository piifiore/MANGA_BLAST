<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.RecensioneDAO" %>
<%@ page import="model.Recensione" %>
<%@ page import="java.time.LocalDateTime" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Test Semplice Recensioni</title>
</head>
<body>
    <h1>Test Semplice Sistema Recensioni</h1>
    
    <%
    try {
        out.println("<h2>Test 1: Creazione RecensioneDAO</h2>");
        RecensioneDAO dao = new RecensioneDAO();
        out.println("<p>✅ RecensioneDAO creato</p>");
        
        out.println("<h2>Test 2: Creazione Recensione</h2>");
        Recensione recensione = new Recensione();
        recensione.setEmailUtente("test@example.com");
        recensione.setIdProdotto("1234567890123");
        recensione.setTipoProdotto("manga");
        recensione.setVoto(5);
        recensione.setCommento("Test recensione");
        recensione.setDataCreazione(LocalDateTime.now());
        recensione.setAttiva(true);
        out.println("<p>✅ Recensione creata</p>");
        
        out.println("<h2>Test 3: Verifica se utente ha già recensito</h2>");
        boolean hasReviewed = dao.hasUserReviewed("test@example.com", "1234567890123", "manga");
        out.println("<p>Utente ha già recensito: " + hasReviewed + "</p>");
        
        out.println("<h2>Test 4: Aggiunta recensione</h2>");
        boolean success = dao.addRecensione(recensione);
        out.println("<p>Recensione aggiunta: " + success + "</p>");
        
        out.println("<h2>Test 5: Recupero recensioni</h2>");
        java.util.List<Recensione> recensioni = dao.getRecensioniByProdotto("1234567890123", "manga");
        out.println("<p>Numero recensioni trovate: " + recensioni.size() + "</p>");
        
        out.println("<h2>✅ Tutti i test completati!</h2>");
        
    } catch (Exception e) {
        out.println("<h2>❌ Errore durante il test</h2>");
        out.println("<p><strong>Errore:</strong> " + e.getMessage() + "</p>");
        out.println("<p><strong>Tipo errore:</strong> " + e.getClass().getName() + "</p>");
        out.println("<p><strong>Stack trace:</strong></p>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
    %>
    
    <h2>Test Servlet</h2>
    <p><a href="GestioneRecensioniServlet?action=getRecensioni&idProdotto=1234567890123&tipoProdotto=manga">Test GET recensioni</a></p>
    
    <h2>Test POST</h2>
    <form action="GestioneRecensioniServlet" method="post">
        <input type="hidden" name="action" value="addRecensione">
        <input type="hidden" name="idProdotto" value="1234567890123">
        <input type="hidden" name="tipoProdotto" value="manga">
        <input type="hidden" name="voto" value="4">
        <input type="hidden" name="commento" value="Test recensione via form">
        <button type="submit">Test Aggiungi Recensione</button>
    </form>
</body>
</html>
