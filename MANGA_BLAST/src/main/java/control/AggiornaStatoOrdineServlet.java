package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.OrdineDAO;

import java.io.IOException;

@WebServlet("/AggiornaStatoOrdineServlet")
public class AggiornaStatoOrdineServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Recupera parametri inviati dal form
            int idOrdine = Integer.parseInt(request.getParameter("id"));
            String nuovoStato = request.getParameter("stato");

            // Aggiorna stato ordine nel DB
            OrdineDAO dao = new OrdineDAO();
            dao.updateOrderStatus(idOrdine, nuovoStato);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Reindirizza alla pagina degli ordini admin
        response.sendRedirect("admin-ordini.jsp");
    }
}