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
        String tipo = request.getParameter("tipo");       // "manga" o "funko"
        String titolo = request.getParameter("titolo");
        String prezzoStr = request.getParameter("prezzo");

        // ✅ Validazione input base
        if (idProdotto == null || tipo == null || titolo == null || prezzoStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti.");
            return;
        }

        BigDecimal prezzo;
        try {
            prezzo = new BigDecimal(prezzoStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Prezzo non valido.");
            return;
        }

        // ✅ Carrello in sessione, anche per utenti anonimi
        HttpSession session = request.getSession();
        List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
        if (carrello == null) carrello = new ArrayList<>();

        // 🔄 Controlla se l'articolo è già presente
        boolean trovato = false;
        for (ItemCarrello item : carrello) {
            if (item.getIdProdotto().equals(idProdotto) && item.getTipo().equals(tipo)) {
                item.setQuantita(item.getQuantita() + 1);
                trovato = true;
                break;
            }
        }

        // ➕ Se non trovato, aggiungilo
        if (!trovato) {
            carrello.add(new ItemCarrello(idProdotto, tipo, titolo, prezzo, 1));
        }

        // 🔐 Salva in sessione
        session.setAttribute("carrello", carrello);

        // 🔔 Risposta plain-text (usata da JavaScript)
        response.setContentType("text/plain");
        response.getWriter().write("aggiunto");
    }
}
