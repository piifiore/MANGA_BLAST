<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>

<%
    String tipo = (String) session.getAttribute("verificaTipo");
    String action = (String) session.getAttribute("verificaAction");
    
    if (tipo == null || action == null) {
        response.sendRedirect("admin-prodotti.jsp");
        return;
    }
    
    Map<String, String[]> data = null;
    if ("manga".equals(tipo)) {
        data = (Map<String, String[]>) session.getAttribute("mangaData");
    } else if ("funko".equals(tipo)) {
        data = (Map<String, String[]>) session.getAttribute("funkoData");
    }
    
    if (data == null) {
        response.sendRedirect("admin-prodotti.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verifica Prodotto - MangaBlast</title>
    <link rel="stylesheet" href="style/verifica-prodotto.css?v=<%= System.currentTimeMillis() %>">
    <jsp:include page="header.jsp" />
</head>
<body>
    <div class="verifica-container">
        <div class="verifica-header">
            <h1>🔍 Verifica Dati Prodotto</h1>
            <p>Controlla i dati inseriti prima di procedere con l'aggiunta</p>
        </div>
        
        <div class="verifica-content">
            <div class="dati-section">
                <h2>📋 Dati Inseriti</h2>
                
                <% if ("manga".equals(tipo)) { %>
                    <div class="dati-grid">
                        <div class="dato-item">
                            <label>ISBN:</label>
                            <span class="dato-value"><%= data.get("ISBN")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Nome:</label>
                            <span class="dato-value"><%= data.get("nome")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Descrizione:</label>
                            <span class="dato-value"><%= data.get("descrizione")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Prezzo:</label>
                            <span class="dato-value">€<%= data.get("prezzo")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Categoria:</label>
                            <span class="dato-value"><%= data.get("id_categoria")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Sottocategoria:</label>
                            <span class="dato-value"><%= data.get("id_sottocategoria")[0] %></span>
                        </div>
                    </div>
                <% } else if ("funko".equals(tipo)) { %>
                    <div class="dati-grid">
                        <div class="dato-item">
                            <label>Numero Serie:</label>
                            <span class="dato-value"><%= data.get("numeroSerie")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Nome:</label>
                            <span class="dato-value"><%= data.get("nome")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Descrizione:</label>
                            <span class="dato-value"><%= data.get("descrizione")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Prezzo:</label>
                            <span class="dato-value">€<%= data.get("prezzo")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Categoria:</label>
                            <span class="dato-value"><%= data.get("id_categoria")[0] %></span>
                        </div>
                        <div class="dato-item">
                            <label>Sottocategoria:</label>
                            <span class="dato-value"><%= data.get("id_sottocategoria")[0] %></span>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <div class="validazione-section">
                <h2>✅ Validazione</h2>
                <div id="validazione-risultati">
                    <!-- I risultati della validazione verranno inseriti qui via JavaScript -->
                </div>
            </div>
            
            <div class="azioni-section">
                <h2>🎯 Azioni</h2>
                <div class="azioni-buttons">
                    <button type="button" class="btn-confirm" onclick="confermaAggiunta()">
                        ✅ Conferma e Aggiungi
                    </button>
                    <button type="button" class="btn-modify" onclick="modificaDati()">
                        ✏️ Modifica Dati
                    </button>
                    <button type="button" class="btn-cancel" onclick="annullaOperazione()">
                        ❌ Annulla
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="scripts/verifica-prodotto.js"></script>
</body>
</html>
