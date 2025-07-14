package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CarrelloDAO;
import model.ItemCarrello;

import java.io.IOException;
import java.util.List;

@WebServlet("/AggiornaQuantitaItemServlet")
public class AggiornaQuantitaItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String tipo = request.getParameter("tipo");
        String azione = request.getParameter("azione"); // "+" o "-"
        HttpSession session = request.getSession();

        String email = (String) session.getAttribute("user");

        if (email != null) {
            // Utente loggato → DB
            CarrelloDAO dao = new CarrelloDAO();
            List<ItemCarrello> carrello = dao.getCarrelloUtente(email);
            for (ItemCarrello item : carrello) {
                if (item.getIdProdotto().equals(id) && item.getTipo().equals(tipo)) {
                    int q = item.getQuantita();
                    if (azione.equals("-")) {
                        if (q <= 1) {
                            dao.rimuoviItem(email, tipo, id);
                        } else {
                            dao.aggiornaQuantita(email, tipo, id, q - 1);
                        }
                    } else if (azione.equals("+")) {
                        dao.aggiornaQuantita(email, tipo, id, q + 1);
                    }
                    break;
                }
            }
        } else {
            // Utente anonimo → sessione
            List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
            if (carrello != null) {
                for (ItemCarrello item : carrello) {
                    if (item.getIdProdotto().equals(id) && item.getTipo().equals(tipo)) {
                        int q = item.getQuantita();
                        if (azione.equals("-")) {
                            if (q <= 1) {
                                carrello.remove(item);
                            } else {
                                item.setQuantita(q - 1);
                            }
                        } else if (azione.equals("+")) {
                            item.setQuantita(q + 1);
                        }
                        break;
                    }
                }
                session.setAttribute("carrello", carrello);
            }
        }

        response.sendRedirect("carrello.jsp");
    }
}