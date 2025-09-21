package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.ItemCarrello;
import model.Ordine;
import model.OrdineDAO;
import model.CartaPagamento;
import model.CartaPagamentoDAO;

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

        // Salva/aggiorna carta di pagamento mascherata se presente dal form
        String metodo = request.getParameter("metodoPagamento");
        if ("carta".equalsIgnoreCase(metodo)) {
            String holder = request.getParameter("cardHolder");
            String number = request.getParameter("cardNumber");
            String expiry = request.getParameter("expiry");
            String cvv = request.getParameter("cvv"); // NON memorizzato

            if (number != null) {
                String digits = number.replaceAll("\\D+", "");
                String last4 = digits.length() >= 4 ? digits.substring(digits.length()-4) : digits;
                String brand = detectBrand(digits);

                int mese = 0, anno = 0;
                if (expiry != null && expiry.matches("(0[1-9]|1[0-2])/\\d{2}")) {
                    mese = Integer.parseInt(expiry.substring(0,2));
                    int yy = Integer.parseInt(expiry.substring(3,5));
                    anno = 2000 + yy;
                }

                CartaPagamento c = new CartaPagamento();
                c.setEmail(email);
                c.setIntestatario(holder);
                c.setNumero(digits);
                c.setLast4(last4);
                c.setBrand(brand);
                c.setScadenzaMese(mese);
                c.setScadenzaAnno(anno);
                
                try {
                    new CartaPagamentoDAO().upsertCarta(c);
                } catch (IllegalArgumentException e) {
                    // Carta scaduta - reindirizza alla pagina di pagamento con messaggio di errore
                    response.sendRedirect("metodo-pagamento.jsp?error=carta_scaduta");
                    return;
                }
            }
        }

        new OrdineDAO().salvaOrdine(ordine);

        session.removeAttribute("carrello");

        response.sendRedirect("ordini-utente.jsp");
    }

    // Riconoscimento molto basico del brand in base ai prefix
    private String detectBrand(String digits) {
        if (digits == null || digits.isEmpty()) return null;
        if (digits.startsWith("4")) return "Visa";
        if (digits.matches("5[1-5].*")) return "Mastercard";
        if (digits.matches("3[47].*")) return "Amex";
        if (digits.matches("6(?:011|5).*")) return "Discover";
        return "Carta";
    }
}