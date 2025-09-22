<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Test Basic</title>
</head>
<body>
    <h1>Test Basic</h1>
    
    <h2>Test 1: Verifica se il servlet risponde</h2>
    <p><a href="GestioneRecensioniServlet" target="_blank">Test GET</a></p>
    
    <h2>Test 2: Test con action=test</h2>
    <p><a href="GestioneRecensioniServlet?action=test" target="_blank">Test GET con action=test</a></p>
    
    <h2>Test 3: Test JavaScript semplice</h2>
    <button onclick="testBasic()">Test Basic AJAX</button>
    <div id="result"></div>
    
    <script>
    function testBasic() {
        console.log('Test Basic AJAX iniziato');
        
        fetch('GestioneRecensioniServlet')
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response ok:', response.ok);
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
