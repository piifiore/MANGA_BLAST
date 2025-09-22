<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Test Servlet</title>
</head>
<body>
    <h1>Test Servlet Recensioni</h1>
    
    <h2>Test 1: Verifica se il servlet è accessibile</h2>
    <p><a href="GestioneRecensioniServlet" target="_blank">Test GET senza parametri</a></p>
    
    <h2>Test 2: Test con parametri</h2>
    <p><a href="GestioneRecensioniServlet?action=getRecensioni&idProdotto=123&tipoProdotto=manga" target="_blank">Test GET con parametri</a></p>
    
    <h2>Test 3: Test POST</h2>
    <form action="GestioneRecensioniServlet" method="post" target="_blank">
        <input type="hidden" name="action" value="addRecensione">
        <input type="hidden" name="idProdotto" value="123">
        <input type="hidden" name="tipoProdotto" value="manga">
        <input type="hidden" name="voto" value="5">
        <input type="hidden" name="commento" value="Test recensione">
        <button type="submit">Test POST</button>
    </form>
    
    <h2>Test 4: Test JavaScript</h2>
    <button onclick="testAjax()">Test AJAX</button>
    <div id="result"></div>
    
    <script>
    function testAjax() {
        console.log('Test AJAX iniziato');
        
        const params = new URLSearchParams({
            action: 'getRecensioni',
            idProdotto: '123',
            tipoProdotto: 'manga'
        });
        
        console.log('URL:', 'GestioneRecensioniServlet?' + params);
        
        fetch('GestioneRecensioniServlet?' + params)
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response ok:', response.ok);
            console.log('Response headers:', response.headers);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
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
