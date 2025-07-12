package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.ItemCarrello;
import model.Ordine;
import model.OrdineDAO;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/ConfermaOrdineServlet")
public class ConfermaOrdineServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("user");
        List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");

        if (email == null || carrello == null || carrello.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        BigDecimal totale = BigDecimal.ZERO;
        for (ItemCarrello item : carrello) {
            totale = totale.add(item.getPrezzo().multiply(new BigDecimal(item.getQuantita())));
        }

        Ordine ordine = new Ordine();
        ordine.setEmailUtente(email);
        ordine.setDataOra(LocalDateTime.now());
        ordine.setTotale(totale);
        ordine.setStato("In attesa");
        ordine.setProdotti(carrello);

        new OrdineDAO().salvaOrdine(ordine);

        session.removeAttribute("carrello");

        response.sendRedirect("ordini-utente.jsp");
    }
}