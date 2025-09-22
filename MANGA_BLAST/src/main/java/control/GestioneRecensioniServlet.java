package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import model.*;
import java.io.*;
import java.util.*;

@WebServlet("/GestioneRecensioniServlet")
public class GestioneRecensioniServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        
        // Log per debugging
        System.out.println("GestioneRecensioniServlet - Action: " + action);
        System.out.println("GestioneRecensioniServlet - Method: " + request.getMethod());
        System.out.println("GestioneRecensioniServlet - Content-Type: " + request.getContentType());
        
        // Log di tutti i parametri ricevuti
        System.out.println("GestioneRecensioniServlet - Tutti i parametri ricevuti:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + ": " + paramValue);
        }
        
        // Controlla se action è null
        if (action == null) {
            System.out.println("GestioneRecensioniServlet - Action è null, restituisco errore");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"Parametro 'action' mancante\"}");
            return;
        }
        
        try {
            switch (action) {
                case "getRecensioni":
                    getRecensioni(request, response);
                    break;
                case "addRecensione":
                    addRecensione(request, response);
                    break;
                case "getRecensioniUtente":
                    getRecensioniUtente(request, response);
                    break;
                case "updateRecensione":
                    updateRecensione(request, response);
                    break;
                case "deleteRecensione":
                    deleteRecensione(request, response);
                    break;
                case "getProductName":
                    getProductName(request, response);
                    break;
                case "test":
                    testConnection(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non riconosciuta");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("GestioneRecensioniServlet - Errore: " + e.getMessage());
            e.printStackTrace(System.err);
            
            // Restituisci JSON anche in caso di errore
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
    
    // Ottiene le recensioni per un prodotto specifico
    private void getRecensioni(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idProdotto = request.getParameter("idProdotto");
        String tipoProdotto = request.getParameter("tipoProdotto");
        
        System.out.println("getRecensioni - idProdotto: " + idProdotto + ", tipoProdotto: " + tipoProdotto);
        
        if (idProdotto == null || tipoProdotto == null) {
            System.out.println("getRecensioni - Parametri mancanti");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti");
            return;
        }
        
        RecensioneDAO recensioneDAO = new RecensioneDAO();
        List<Recensione> recensioni = recensioneDAO.getRecensioniByProdotto(idProdotto, tipoProdotto);
        double mediaVoti = recensioneDAO.getMediaVoti(idProdotto, tipoProdotto);
        int numeroRecensioni = recensioneDAO.getNumeroRecensioni(idProdotto, tipoProdotto);
        
        // Verifica se l'utente ha già recensito
        String emailUtente = (String) request.getSession().getAttribute("user");
        boolean hasReviewed = false;
        Recensione userReview = null;
        
        if (emailUtente != null) {
            hasReviewed = recensioneDAO.hasUserReviewed(emailUtente, idProdotto, tipoProdotto);
            if (hasReviewed) {
                userReview = recensioneDAO.getRecensioneByUserAndProdotto(emailUtente, idProdotto, tipoProdotto);
            }
        }
        
        // Prepara la risposta JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"recensioni\": [");
        
        for (int i = 0; i < recensioni.size(); i++) {
            Recensione rec = recensioni.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"id\": ").append(rec.getId()).append(",");
            json.append("\"emailUtente\": \"").append(rec.getEmailUtente()).append("\",");
            json.append("\"voto\": ").append(rec.getVoto()).append(",");
            json.append("\"commento\": \"").append(rec.getCommento().replace("\"", "\\\"")).append("\",");
            json.append("\"dataCreazione\": \"").append(rec.getDataCreazione().toString()).append("\"");
            json.append("}");
        }
        
        json.append("],");
        json.append("\"mediaVoti\": ").append(mediaVoti).append(",");
        json.append("\"numeroRecensioni\": ").append(numeroRecensioni).append(",");
        json.append("\"hasReviewed\": ").append(hasReviewed);
        
        if (userReview != null) {
            json.append(",");
            json.append("\"userReview\": {");
            json.append("\"id\": ").append(userReview.getId()).append(",");
            json.append("\"voto\": ").append(userReview.getVoto()).append(",");
            json.append("\"commento\": \"").append(userReview.getCommento().replace("\"", "\\\"")).append("\"");
            json.append("}");
        }
        
        json.append("}");
        
        response.getWriter().write(json.toString());
    }
    
    // Aggiunge una nuova recensione
    private void addRecensione(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("addRecensione - Inizio metodo");
        
        HttpSession session = request.getSession(false);
        String emailUtente = (session != null) ? (String) session.getAttribute("user") : null;
        
        System.out.println("addRecensione - emailUtente: " + emailUtente);
        System.out.println("addRecensione - Session: " + session);
        System.out.println("addRecensione - Session attributes: " + (session != null ? session.getAttributeNames() : "null"));
        
        if (emailUtente == null) {
            System.out.println("addRecensione - Utente non autenticato");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }
        
        String idProdotto = request.getParameter("idProdotto");
        String tipoProdotto = request.getParameter("tipoProdotto");
        String votoStr = request.getParameter("voto");
        String commento = request.getParameter("commento");
        
        System.out.println("addRecensione - Parametri ricevuti:");
        System.out.println("  idProdotto: " + idProdotto);
        System.out.println("  tipoProdotto: " + tipoProdotto);
        System.out.println("  votoStr: " + votoStr);
        System.out.println("  commento: " + commento);
        
        // Log di tutti i parametri per debug
        System.out.println("addRecensione - Tutti i parametri:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + ": " + paramValue);
        }
        
        if (idProdotto == null || tipoProdotto == null || votoStr == null) {
            System.out.println("addRecensione - Parametri mancanti");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti");
            return;
        }
        
        int voto;
        try {
            voto = Integer.parseInt(votoStr);
            if (voto < 1 || voto > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Voto deve essere tra 1 e 5");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Voto non valido");
            return;
        }
        
        RecensioneDAO recensioneDAO = new RecensioneDAO();
        
        // Verifica se l'utente ha già recensito
        if (recensioneDAO.hasUserReviewed(emailUtente, idProdotto, tipoProdotto)) {
            response.sendError(HttpServletResponse.SC_CONFLICT, "Hai già recensito questo prodotto");
            return;
        }
        
        System.out.println("addRecensione - Creazione oggetto Recensione");
        Recensione recensione = new Recensione(emailUtente, idProdotto, tipoProdotto, voto, commento);
        System.out.println("addRecensione - Recensione creata: " + recensione);
        
        System.out.println("addRecensione - Chiamata a recensioneDAO.addRecensione");
        boolean success = recensioneDAO.addRecensione(recensione);
        System.out.println("addRecensione - Risultato addRecensione: " + success);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            System.out.println("addRecensione - Invio risposta di successo");
            response.getWriter().write("{\"success\": true, \"message\": \"Recensione aggiunta con successo\"}");
        } else {
            System.out.println("addRecensione - Invio risposta di errore");
            response.getWriter().write("{\"success\": false, \"message\": \"Errore nell'aggiunta della recensione\"}");
        }
    }
    
    // Ottiene le recensioni di un utente
    private void getRecensioniUtente(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("getRecensioniUtente - Inizio metodo");
        
        HttpSession session = request.getSession(false);
        String emailUtente = (session != null) ? (String) session.getAttribute("user") : null;
        
        System.out.println("getRecensioniUtente - emailUtente: " + emailUtente);
        System.out.println("getRecensioniUtente - Session: " + session);
        
        if (emailUtente == null) {
            System.out.println("getRecensioniUtente - Utente non autenticato");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }
        
        System.out.println("getRecensioniUtente - Chiamata a recensioneDAO.getRecensioniByUtente");
        RecensioneDAO recensioneDAO = new RecensioneDAO();
        List<Recensione> recensioni = recensioneDAO.getRecensioniByUtente(emailUtente);
        System.out.println("getRecensioniUtente - Trovate " + recensioni.size() + " recensioni");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"recensioni\": [");
        
        for (int i = 0; i < recensioni.size(); i++) {
            Recensione rec = recensioni.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"id\": ").append(rec.getId()).append(",");
            json.append("\"emailUtente\": \"").append(rec.getEmailUtente()).append("\",");
            json.append("\"idProdotto\": \"").append(rec.getIdProdotto()).append("\",");
            json.append("\"tipoProdotto\": \"").append(rec.getTipoProdotto()).append("\",");
            json.append("\"voto\": ").append(rec.getVoto()).append(",");
            json.append("\"commento\": \"").append(rec.getCommento().replace("\"", "\\\"")).append("\",");
            json.append("\"dataCreazione\": \"").append(rec.getDataCreazione().toString()).append("\"");
            json.append("}");
        }
        
        json.append("]");
        json.append("}");
        
        response.getWriter().write(json.toString());
    }
    
    // Aggiorna una recensione esistente
    private void updateRecensione(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        String emailUtente = (session != null) ? (String) session.getAttribute("user") : null;
        
        if (emailUtente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }
        
        String idStr = request.getParameter("id");
        String votoStr = request.getParameter("voto");
        String commento = request.getParameter("commento");
        
        if (idStr == null || votoStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti");
            return;
        }
        
        int id, voto;
        try {
            id = Integer.parseInt(idStr);
            voto = Integer.parseInt(votoStr);
            if (voto < 1 || voto > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Voto deve essere tra 1 e 5");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri non validi");
            return;
        }
        
        RecensioneDAO recensioneDAO = new RecensioneDAO();
        Recensione recensione = new Recensione();
        recensione.setId(id);
        recensione.setEmailUtente(emailUtente);
        recensione.setVoto(voto);
        recensione.setCommento(commento);
        
        boolean success = recensioneDAO.updateRecensione(recensione);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            response.getWriter().write("{\"success\": true, \"message\": \"Recensione aggiornata con successo\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Errore nell'aggiornamento della recensione\"}");
        }
    }
    
    // Elimina una recensione
    private void deleteRecensione(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        String emailUtente = (session != null) ? (String) session.getAttribute("user") : null;
        
        if (emailUtente == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Utente non autenticato");
            return;
        }
        
        String idStr = request.getParameter("id");
        
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID recensione mancante");
            return;
        }
        
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID non valido");
            return;
        }
        
        RecensioneDAO recensioneDAO = new RecensioneDAO();
        boolean success = recensioneDAO.deleteRecensione(id, emailUtente);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            response.getWriter().write("{\"success\": true, \"message\": \"Recensione eliminata con successo\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Errore nell'eliminazione della recensione\"}");
        }
    }
    
    // Ottiene il nome di un prodotto
    private void getProductName(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idProdotto = request.getParameter("idProdotto");
        String tipoProdotto = request.getParameter("tipoProdotto");
        
        if (idProdotto == null || tipoProdotto == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti");
            return;
        }
        
        String nomeProdotto = "Prodotto non trovato";
        
        try {
            if ("manga".equals(tipoProdotto)) {
                MangaDAO mangaDAO = new MangaDAO();
                Manga manga = mangaDAO.doRetrieveByISBN(Long.parseLong(idProdotto));
                if (manga != null) {
                    nomeProdotto = manga.getNome();
                }
            } else if ("funko".equals(tipoProdotto)) {
                FunkoDAO funkoDAO = new FunkoDAO();
                Funko funko = funkoDAO.doRetrieveByNumeroSerie(idProdotto);
                if (funko != null) {
                    nomeProdotto = funko.getNome();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true, \"nome\": \"" + nomeProdotto.replace("\"", "\\\"") + "\"}");
    }
    
    // Test di connessione
    private void testConnection(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("testConnection - Test di connessione");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Test connessione database
            model.DBConnection.getConnection();
            response.getWriter().write("{\"success\": true, \"message\": \"Servlet funzionante e database connesso\"}");
        } catch (Exception e) {
            System.err.println("testConnection - Errore: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
