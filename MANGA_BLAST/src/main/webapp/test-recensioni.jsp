<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.RecensioneDAO" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Test Recensioni</title>
</head>
<body>
    <h1>Test Sistema Recensioni</h1>
    
    <%
    try {
        out.println("<h2>Test Connessione Database</h2>");
        
        RecensioneDAO dao = new RecensioneDAO();
        out.println("<p>✅ RecensioneDAO creato con successo</p>");
        
        // Test con parametri di esempio
        String idProdotto = "1234567890123"; // ISBN di esempio
        String tipoProdotto = "manga";
        
        out.println("<p>Test parametri: idProdotto=" + idProdotto + ", tipoProdotto=" + tipoProdotto + "</p>");
        
        List<model.Recensione> recensioni = dao.getRecensioniByProdotto(idProdotto, tipoProdotto);
        out.println("<p>✅ Query eseguita con successo</p>");
        out.println("<p>Numero recensioni trovate: " + recensioni.size() + "</p>");
        
        double mediaVoti = dao.getMediaVoti(idProdotto, tipoProdotto);
        out.println("<p>Media voti: " + mediaVoti + "</p>");
        
        int numeroRecensioni = dao.getNumeroRecensioni(idProdotto, tipoProdotto);
        out.println("<p>Numero recensioni: " + numeroRecensioni + "</p>");
        
        out.println("<h2>✅ Tutti i test superati!</h2>");
        
    } catch (Exception e) {
        out.println("<h2>❌ Errore durante il test</h2>");
        out.println("<p><strong>Errore:</strong> " + e.getMessage() + "</p>");
        out.println("<p><strong>Stack trace:</strong></p>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
    %>
    
    <h2>Test Servlet</h2>
    <p><a href="GestioneRecensioniServlet?action=getRecensioni&idProdotto=1234567890123&tipoProdotto=manga">Test Servlet GET</a></p>
    
    <h2>Test JavaScript</h2>
    <button onclick="testAjax()">Test AJAX</button>
    <div id="result"></div>
    
    <script>
    function testAjax() {
        const params = new URLSearchParams({
            action: 'getRecensioni',
            idProdotto: '1234567890123',
            tipoProdotto: 'manga'
        });
        
        fetch('GestioneRecensioniServlet?' + params)
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            return response.text();
        })
        .then(text => {
            console.log('Response text:', text);
            document.getElementById('result').innerHTML = '<pre>' + text + '</pre>';
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('result').innerHTML = '<p style="color: red;">Errore: ' + error.message + '</p>';
        });
    }
    </script>
</body>
</html>
