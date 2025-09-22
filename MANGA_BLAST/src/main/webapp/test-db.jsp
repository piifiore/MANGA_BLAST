<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Test Database</title>
</head>
<body>
    <h1>Test Connessione Database</h1>
    
    <%
    try {
        out.println("<h2>Test Connessione</h2>");
        
        Connection conn = DBConnection.getConnection();
        out.println("<p>✅ Connessione al database riuscita</p>");
        
        // Test se la tabella recensioni esiste
        DatabaseMetaData metaData = conn.getMetaData();
        ResultSet tables = metaData.getTables(null, null, "recensioni", null);
        
        if (tables.next()) {
            out.println("<p>✅ Tabella 'recensioni' esiste</p>");
            
            // Mostra la struttura della tabella
            out.println("<h3>Struttura tabella recensioni:</h3>");
            out.println("<table border='1'>");
            out.println("<tr><th>Campo</th><th>Tipo</th><th>Null</th><th>Chiave</th></tr>");
            
            ResultSet columns = metaData.getColumns(null, null, "recensioni", null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String columnType = columns.getString("TYPE_NAME");
                String nullable = columns.getString("IS_NULLABLE");
                String key = columns.getString("COL_KEY");
                
                out.println("<tr>");
                out.println("<td>" + columnName + "</td>");
                out.println("<td>" + columnType + "</td>");
                out.println("<td>" + nullable + "</td>");
                out.println("<td>" + key + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Test query semplice
            out.println("<h3>Test Query</h3>");
            PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM recensioni");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                out.println("<p>Numero di recensioni nella tabella: " + count + "</p>");
            }
            rs.close();
            stmt.close();
            
        } else {
            out.println("<p>❌ Tabella 'recensioni' NON esiste</p>");
            out.println("<p>Devi eseguire lo script SQL per creare la tabella</p>");
        }
        
        // Test se la tabella utenti esiste
        tables = metaData.getTables(null, null, "utenti", null);
        if (tables.next()) {
            out.println("<p>✅ Tabella 'utenti' esiste</p>");
        } else {
            out.println("<p>❌ Tabella 'utenti' NON esiste</p>");
        }
        
        conn.close();
        out.println("<p>✅ Connessione chiusa</p>");
        
    } catch (Exception e) {
        out.println("<h2>❌ Errore durante il test</h2>");
        out.println("<p><strong>Errore:</strong> " + e.getMessage() + "</p>");
        out.println("<p><strong>Stack trace:</strong></p>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
    %>
    
    <h2>Prossimi Passi</h2>
    <ul>
        <li>Se la tabella 'recensioni' non esiste, esegui: <code>source src/main/db/setup_recensioni.sql;</code></li>
        <li>Se ci sono errori di connessione, controlla la configurazione del database</li>
        <li>Se tutto è OK, testa il servlet: <a href="test-recensioni.jsp">Test Recensioni</a></li>
    </ul>
</body>
</html>
