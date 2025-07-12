package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ItemCarrello;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AggiungiAlCarrelloServlet")
public class AggiungiAlCarrelloServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idProdotto = request.getParameter("id");
        String tipo = request.getParameter("tipo"); // "manga" o "funko"
        String titolo = request.getParameter("titolo");
        BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));

        HttpSession session = request.getSession();
        List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
        if (carrello == null) carrello = new ArrayList<>();

        boolean trovato = false;
        for (ItemCarrello item : carrello) {
            if (item.getIdProdotto().equals(idProdotto) && item.getTipo().equals(tipo)) {
                item.setQuantita(item.getQuantita() + 1);
                trovato = true;
                break;
            }
        }

        if (!trovato) {
            carrello.add(new ItemCarrello(idProdotto, tipo, titolo, prezzo, 1));
        }

        session.setAttribute("carrello", carrello);
        response.sendRedirect("Carrello.jsp");
    }
}