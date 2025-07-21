package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.List;

import model.Ordine;
import model.OrdineDAO;

@WebServlet("/AggiornaStatoOrdineServlet")
public class AggiornaStatoOrdineServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Leggi i parametri dal form
        int idOrdine = Integer.parseInt(request.getParameter("id"));
        String nuovoStato = request.getParameter("stato");

        // Aggiorna lo stato nel DB
        OrdineDAO dao = new OrdineDAO();
        dao.updateOrderStatus(idOrdine, nuovoStato);

        // Recupera tutti gli ordini aggiornati per visualizzarli
        List<Ordine> ordiniAggiornati = dao.getFilteredOrders(null, null, null, null, null);
        request.setAttribute("ordini", ordiniAggiornati);

        String requestedWith = request.getHeader("X-Requested-With");
        if (requestedWith != null && requestedWith.equals("XMLHttpRequest")) {
            request.getRequestDispatcher("tabella-ordini.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("admin-ordini.jsp").forward(request, response);
        }
    }
}
