package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ItemCarrello;
import model.CarrelloDAO;

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
        String emailUser = (String) session.getAttribute("user");
        
        boolean rimosso = false;
        int nuovaQuantita = 0;
        
        if (emailUser != null) {
            // 👤 Utente loggato: aggiorna nel database
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            List<ItemCarrello> carrello = carrelloDAO.getCarrelloUtente(emailUser);
            
            // Trova l'item e calcola la nuova quantità
            for (ItemCarrello item : carrello) {
                if (item.getTipo().equals(tipo) && item.getIdProdotto().equals(id)) {
                    int quantitaAttuale = item.getQuantita();
                    nuovaQuantita = quantitaAttuale + delta;
                    
                    if (nuovaQuantita <= 0) {
                        // Rimuovi dal database
                        carrelloDAO.rimuoviItem(emailUser, tipo, id);
                        rimosso = true;
                    } else {
                        // Aggiorna nel database
                        carrelloDAO.aggiornaQuantita(emailUser, tipo, id, nuovaQuantita);
                    }
                    break;
                }
            }
            
            // Aggiorna il carrello in sessione
            List<ItemCarrello> carrelloAggiornato = carrelloDAO.getCarrelloUtente(emailUser);
            session.setAttribute("carrello", carrelloAggiornato);
            
        } else {
            // 👻 Guest: aggiorna solo in sessione
            List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");

            if (carrello == null) {
                carrello = new ArrayList<>();
            }

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
        }

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
