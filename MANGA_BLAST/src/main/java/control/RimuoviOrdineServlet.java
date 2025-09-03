package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OrdineDAO;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/RimuoviOrdineServlet")
public class RimuoviOrdineServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idOrdineStr = request.getParameter("id");
        boolean success = false;
        String message = "";
        
        if (idOrdineStr != null && !idOrdineStr.trim().isEmpty()) {
            try {
                int idOrdine = Integer.parseInt(idOrdineStr);
                OrdineDAO dao = new OrdineDAO();
                success = dao.deleteOrder(idOrdine);
                
                if (success) {
                    message = "Ordine rimosso con successo";
                } else {
                    message = "Errore durante la rimozione dell'ordine";
                }
            } catch (NumberFormatException e) {
                message = "ID ordine non valido";
            } catch (Exception e) {
                message = "Errore durante la rimozione: " + e.getMessage();
            }
        } else {
            message = "ID ordine mancante";
        }

        // Controlla se è una richiesta AJAX
        String requestedWith = request.getHeader("X-Requested-With");
        if (requestedWith != null && requestedWith.equals("XMLHttpRequest")) {
            // Risposta JSON per AJAX
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            PrintWriter out = response.getWriter();
            String jsonResponse = String.format(
                "{\"success\": %s, \"message\": \"%s\"}", 
                success, 
                message.replace("\"", "\\\"")
            );
            out.print(jsonResponse);
            out.flush();
        } else {
            // Redirect normale per richieste non-AJAX
            response.sendRedirect("admin-ordini.jsp");
        }
    }
}
