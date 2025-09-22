package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Recensione;
import model.RecensioneDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/RecensioniServlet")
public class RecensioniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecensioneDAO recensioneDAO = new RecensioneDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idProdotto = request.getParameter("idProdotto");
        String tipoProdotto = request.getParameter("tipoProdotto");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action) {
                case "getRecensioni":
                    List<Recensione> recensioni = recensioneDAO.getRecensioniByProdotto(
                        Integer.parseInt(idProdotto), tipoProdotto);
                    out.print(convertToJson(recensioni));
                    break;
                    
                case "getStatistiche":
                    RecensioneDAO.StatisticheRecensioni stats = recensioneDAO.getStatisticheRecensioni(
                        Integer.parseInt(idProdotto), tipoProdotto);
                    out.print(convertStatsToJson(stats));
                    break;
                    
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"Azione non valida\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Errore del server: " + e.getMessage() + "\"}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String emailUtente = (String) request.getSession().getAttribute("user");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        if (emailUtente == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Utente non autenticato\"}");
            return;
        }
        
        try {
            switch (action) {
                case "addRecensione":
                    addRecensione(request, response, emailUtente);
                    break;
                    
                case "updateRecensione":
                    updateRecensione(request, response, emailUtente);
                    break;
                    
                case "deleteRecensione":
                    deleteRecensione(request, response, emailUtente);
                    break;
                    
                case "likeRecensione":
                    likeRecensione(request, response, emailUtente);
                    break;
                    
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"Azione non valida\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Errore del server: " + e.getMessage() + "\"}");
        }
    }
    
    private void addRecensione(HttpServletRequest request, HttpServletResponse response, String emailUtente) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        
        int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
        String tipoProdotto = request.getParameter("tipoProdotto");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String titolo = request.getParameter("titolo");
        String commento = request.getParameter("commento");
        
        // Validazione
        if (rating < 1 || rating > 5) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Rating deve essere tra 1 e 5\"}");
            return;
        }
        
        Recensione recensione = new Recensione();
        recensione.setIdProdotto(idProdotto);
        recensione.setTipoProdotto(tipoProdotto);
        recensione.setEmailUtente(emailUtente);
        recensione.setRating(rating);
        recensione.setTitolo(titolo);
        recensione.setCommento(commento);
        
        boolean success = recensioneDAO.addRecensione(recensione);
        
        if (success) {
            out.print("{\"success\": true, \"message\": \"Recensione aggiunta con successo\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            out.print("{\"error\": \"Recensione già esistente per questo prodotto\"}");
        }
    }
    
    private void updateRecensione(HttpServletRequest request, HttpServletResponse response, String emailUtente) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        
        int idRecensione = Integer.parseInt(request.getParameter("idRecensione"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String titolo = request.getParameter("titolo");
        String commento = request.getParameter("commento");
        
        boolean success = recensioneDAO.updateRecensione(idRecensione, emailUtente, rating, titolo, commento);
        
        if (success) {
            out.print("{\"success\": true, \"message\": \"Recensione aggiornata con successo\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\": \"Non autorizzato a modificare questa recensione\"}");
        }
    }
    
    private void deleteRecensione(HttpServletRequest request, HttpServletResponse response, String emailUtente) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        
        int idRecensione = Integer.parseInt(request.getParameter("idRecensione"));
        
        boolean success = recensioneDAO.deleteRecensione(idRecensione, emailUtente);
        
        if (success) {
            out.print("{\"success\": true, \"message\": \"Recensione eliminata con successo\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\": \"Non autorizzato a eliminare questa recensione\"}");
        }
    }
    
    private void likeRecensione(HttpServletRequest request, HttpServletResponse response, String emailUtente) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        
        int idRecensione = Integer.parseInt(request.getParameter("idRecensione"));
        String tipo = request.getParameter("tipo"); // "like" o "dislike"
        
        boolean success = recensioneDAO.toggleLike(idRecensione, emailUtente, tipo);
        
        if (success) {
            out.print("{\"success\": true, \"message\": \"Like aggiornato\"}");
        } else {
            out.print("{\"error\": \"Errore nell'aggiornamento del like\"}");
        }
    }
    
    private String convertToJson(List<Recensione> recensioni) {
        StringBuilder json = new StringBuilder("[");
        
        for (int i = 0; i < recensioni.size(); i++) {
            Recensione r = recensioni.get(i);
            json.append("{");
            json.append("\"id\":").append(r.getId()).append(",");
            json.append("\"emailUtente\":\"").append(r.getEmailUtente()).append("\",");
            json.append("\"rating\":").append(r.getRating()).append(",");
            json.append("\"titolo\":\"").append(escapeJson(r.getTitolo())).append("\",");
            json.append("\"commento\":\"").append(escapeJson(r.getCommento())).append("\",");
            json.append("\"dataRecensione\":\"").append(r.getDataRecensione()).append("\",");
            json.append("\"likeCount\":").append(r.getLikeCount()).append(",");
            json.append("\"dislikeCount\":").append(r.getDislikeCount());
            json.append("}");
            
            if (i < recensioni.size() - 1) {
                json.append(",");
            }
        }
        
        json.append("]");
        return json.toString();
    }
    
    private String convertStatsToJson(RecensioneDAO.StatisticheRecensioni stats) {
        return "{" +
            "\"totaleRecensioni\":" + stats.getTotaleRecensioni() + "," +
            "\"ratingMedio\":" + stats.getRatingMedio() + "," +
            "\"ratingMinimo\":" + stats.getRatingMinimo() + "," +
            "\"ratingMassimo\":" + stats.getRatingMassimo() + "," +
            "\"recensioni5Stelle\":" + stats.getRecensioni5Stelle() + "," +
            "\"recensioni4Stelle\":" + stats.getRecensioni4Stelle() + "," +
            "\"recensioni3Stelle\":" + stats.getRecensioni3Stelle() + "," +
            "\"recensioni2Stelle\":" + stats.getRecensioni2Stelle() + "," +
            "\"recensioni1Stella\":" + stats.getRecensioni1Stella() +
        "}";
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }
}
