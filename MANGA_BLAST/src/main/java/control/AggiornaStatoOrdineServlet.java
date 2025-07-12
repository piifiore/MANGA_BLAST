package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OrderDAO;

import java.io.IOException;

@WebServlet("/AggiornaStatoOrdineServlet")
public class AggiornaStatoOrdineServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nuovoStato = request.getParameter("stato");

            OrderDAO dao = new OrderDAO();
            dao.updateOrderStatus(id, nuovoStato);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Ricarica pagina ordini (refresh AJAX incluso)
        response.sendRedirect("admin-ordini.jsp");
    }
}