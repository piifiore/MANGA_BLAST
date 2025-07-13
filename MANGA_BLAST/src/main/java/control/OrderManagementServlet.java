package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.*;
import java.io.*;
import java.util.*;

@WebServlet("/OrderManagementServlet")
public class OrderManagementServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String stato = request.getParameter("stato");
        String sort = request.getParameter("sort");

        OrdineDAO dao = new OrdineDAO(); // ✅ nome corretto
        List<Ordine> ordini = dao.getFilteredOrders(email, stato, sort); // ✅ metodo previsto nel DAO

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (ordini == null || ordini.isEmpty()) {
            out.println("<p style='color:red;'>📭 Nessun ordine trovato</p>");
            return;
        }

        out.println("<table><tr><th>ID</th><th>Email</th><th>Data</th><th>Totale</th><th>Stato</th><th>Dettagli</th></tr>");
        for (Ordine o : ordini) {
            out.println("<tr>"
                    + "<td>" + o.getId() + "</td>"
                    + "<td>" + o.getEmailUtente() + "</td>"
                    + "<td>" + o.getDataOra() + "</td>"
                    + "<td>" + o.getTotale() + " €</td>"
                    + "<td>"
                    + "<form action='AggiornaStatoOrdineServlet' method='post' class='status-form'>"
                    + "<input type='hidden' name='id' value='" + o.getId() + "'>"
                    + "<select name='stato' class='status-select'>"
                    + "<option " + ("In attesa".equals(o.getStato()) ? "selected" : "") + ">In attesa</option>"
                    + "<option " + ("Spedito".equals(o.getStato()) ? "selected" : "") + ">Spedito</option>"
                    + "<option " + ("Consegnato".equals(o.getStato()) ? "selected" : "") + ">Consegnato</option>"
                    + "</select>"
                    + "<input type='submit' value='✔️'>"
                    + "</form>"
                    + "</td>"
                    + "<td><div class='detail-box'>");

            for (ItemCarrello item : o.getProdotti()) {
                out.println(item.getQuantita() + " x " + item.getTitolo() + " — " + item.getPrezzo() + " €<br>");
            }

            out.println("</div></td></tr>");
        }
        out.println("</table>");
    }
}