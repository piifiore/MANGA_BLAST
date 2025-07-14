package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ItemCarrello;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/AggiornaQuantitaCarrelloServlet")
public class AggiornaQuantitaCarrelloServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String tipo = request.getParameter("tipo");
        String deltaStr = request.getParameter("delta");

        int delta;
        try {
            delta = Integer.parseInt(deltaStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        HttpSession session = request.getSession();
        List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");

        if (carrello == null) {
            carrello = new ArrayList<>();
        }

        boolean rimosso = false;
        int nuovaQuantita = 0;

        Iterator<ItemCarrello> iterator = carrello.iterator();
        while (iterator.hasNext()) {
            ItemCarrello item = iterator.next();

            if (item.getTipo().equals(tipo) && item.getIdProdotto().equals(id)) {
                int quantitaAttuale = item.getQuantita();
                nuovaQuantita = quantitaAttuale + delta;

                if (nuovaQuantita <= 0) {
                    iterator.remove();
                    rimosso = true;
                } else {
                    item.setQuantita(nuovaQuantita);
                }

                break;
            }
        }

        session.setAttribute("carrello", carrello);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Costruiamo il JSON manualmente
        out.print("{");
        out.print("\"rimosso\": " + rimosso + ",");
        out.print("\"nuovaQuantita\": " + nuovaQuantita);
        out.print("}");
        out.flush();
    }
}
