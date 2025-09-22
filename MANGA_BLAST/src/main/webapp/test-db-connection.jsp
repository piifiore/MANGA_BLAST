<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Test Database Connection</title>
</head>
<body>
    <h1>Test Database Connection</h1>
    
    <%
        Connection conn = null;
        try {
            out.println("<h2>1. Test Connessione</h2>");
            conn = DBConnection.getConnection();
            if (conn != null) {
                out.println("<p style='color: green;'>✅ Connessione al database riuscita!</p>");
            } else {
                out.println("<p style='color: red;'>❌ Connessione al database fallita!</p>");
            }
            
            out.println("<h2>2. Test Query Semplice</h2>");
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SELECT 1 FROM DUAL");
                out.println("<p style='color: green;'>✅ Query di test eseguita con successo!</p>");
            }
            
            out.println("<h2>3. Test Tabella Recensioni</h2>");
            try (Statement stmt = conn.createStatement()) {
                ResultSet rs = stmt.executeQuery("SHOW TABLES LIKE 'recensioni'");
                if (rs.next()) {
                    out.println("<p style='color: green;'>✅ Tabella 'recensioni' esiste!</p>");
                    
                    // Test struttura tabella
                    out.println("<h3>Struttura Tabella Recensioni:</h3>");
                    ResultSet rs2 = stmt.executeQuery("DESCRIBE recensioni");
                    out.println("<table border='1'><tr><th>Campo</th><th>Tipo</th><th>Null</th><th>Key</th><th>Default</th></tr>");
                    while (rs2.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs2.getString("Field") + "</td>");
                        out.println("<td>" + rs2.getString("Type") + "</td>");
                        out.println("<td>" + rs2.getString("Null") + "</td>");
                        out.println("<td>" + rs2.getString("Key") + "</td>");
                        out.println("<td>" + rs2.getString("Default") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                    
                } else {
                    out.println("<p style='color: red;'>❌ Tabella 'recensioni' NON esiste!</p>");
                    out.println("<p>Devi eseguire lo script setup_recensioni.sql</p>");
                }
            }
            
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ Errore SQL: " + e.getMessage() + "</p>");
            out.println("<p>SQL State: " + e.getSQLState() + "</p>");
            out.println("<p>Error Code: " + e.getErrorCode() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Errore generico: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    out.println("<p>Connessione chiusa.</p>");
                } catch (SQLException e) {
                    out.println("<p style='color: red;'>❌ Errore nella chiusura: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
    
    <h2>4. Test RecensioneDAO</h2>
    <%
        try {
            model.RecensioneDAO dao = new model.RecensioneDAO();
            out.println("<p style='color: green;'>✅ RecensioneDAO istanziato con successo!</p>");
            
            // Test metodo getRecensioniByProdotto
            java.util.List<model.Recensione> recensioni = dao.getRecensioniByProdotto("123", "manga");
            out.println("<p style='color: green;'>✅ Metodo getRecensioniByProdotto eseguito (trovate " + recensioni.size() + " recensioni)</p>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Errore RecensioneDAO: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
    
</body>
</html>
