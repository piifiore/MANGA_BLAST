package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import java.io.*;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/CercaProdottiServlet")
public class CercaProdottiServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tipo = request.getParameter("tipo");
        String query = request.getParameter("query");
        String sort = request.getParameter("sort");
        String minStr = request.getParameter("min");
        String maxStr = request.getParameter("max");

        BigDecimal min = (minStr != null && !minStr.isEmpty()) ? new BigDecimal(minStr) : BigDecimal.ZERO;
        BigDecimal max = (maxStr != null && !maxStr.isEmpty()) ? new BigDecimal(maxStr) : new BigDecimal("999999");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if ("manga".equals(tipo)) {
            MangaDAO dao = new MangaDAO();
            List<Manga> risultati = query != null && !query.isEmpty()
                    ? dao.searchByNomeDescrizioneOrIsbn(query)
                    : dao.getAllManga();

            risultati.removeIf(m -> m.getPrezzo().compareTo(min) < 0 || m.getPrezzo().compareTo(max) > 0);

            if ("asc".equals(sort)) {
                risultati.sort(Comparator.comparing(Manga::getPrezzo));
            } else if ("desc".equals(sort)) {
                risultati.sort(Comparator.comparing(Manga::getPrezzo).reversed());
            }

            if (risultati.isEmpty()) {
                out.println("<p style='color:red;'>📭 Nessun manga trovato</p>");
                return;
            }

            out.println("<table><tr><th>ISBN</th><th>Nome</th><th>Descrizione</th><th>Prezzo</th><th>Immagine</th><th>Azioni</th></tr>");
            for (Manga m : risultati) {
                out.println("<tr>"
                        + "<td>" + m.getISBN() + "</td>"
                        + "<td>" + m.getNome() + "</td>"
                        + "<td>" + m.getDescrizione() + "</td>"
                        + "<td>" + m.getPrezzo() + " €</td>"
                        + "<td><img src='" + request.getContextPath() + "/" + m.getImmagine() + "' width='100'></td>"
                        + "<td>"
                        + "<form action='modifica-manga.jsp' method='get' style='display:inline;'>"
                        + "<input type='hidden' name='ISBN' value='" + m.getISBN() + "'>"
                        + "<input type='submit' value='Modifica'>"
                        + "</form> "
                        + "<form action='EliminaMangaServlet' method='post' style='display:inline;'>"
                        + "<input type='hidden' name='ISBN' value='" + m.getISBN() + "'>"
                        + "<input type='submit' value='Elimina' onclick=\"return confirm('Eliminare questo manga?')\">"
                        + "</form>"
                        + "</td></tr>");
            }
            out.println("</table>");
        }

        else if ("funko".equals(tipo)) {
            FunkoDAO dao = new FunkoDAO();
            List<Funko> risultati = query != null && !query.isEmpty()
                    ? dao.searchByNomeDescrizioneOrNumeroSerie(query)
                    : dao.getAllFunko();

            risultati.removeIf(f -> f.getPrezzo().compareTo(min) < 0 || f.getPrezzo().compareTo(max) > 0);

            if ("asc".equals(sort)) {
                risultati.sort(Comparator.comparing(Funko::getPrezzo));
            } else if ("desc".equals(sort)) {
                risultati.sort(Comparator.comparing(Funko::getPrezzo).reversed());
            }

            if (risultati.isEmpty()) {
                out.println("<p style='color:red;'>📭 Nessun Funko trovato</p>");
                return;
            }

            out.println("<table><tr><th>Serie</th><th>Nome</th><th>Descrizione</th><th>Prezzo</th><th>Immagine</th><th>Azioni</th></tr>");
            for (Funko f : risultati) {
                out.println("<tr>"
                        + "<td>" + f.getNumeroSerie() + "</td>"
                        + "<td>" + f.getNome() + "</td>"
                        + "<td>" + f.getDescrizione() + "</td>"
                        + "<td>" + f.getPrezzo() + " €</td>"
                        + "<td><img src='" + request.getContextPath() + "/" + f.getImmagine() + "' width='100'></td>"
                        + "<td>"
                        + "<form action='modifica-funko.jsp' method='get' style='display:inline;'>"
                        + "<input type='hidden' name='numeroSerie' value='" + f.getNumeroSerie() + "'>"
                        + "<input type='submit' value='Modifica'>"
                        + "</form> "
                        + "<form action='EliminaFunkoServlet' method='post' style='display:inline;'>"
                        + "<input type='hidden' name='numeroSerie' value='" + f.getNumeroSerie() + "'>"
                        + "<input type='submit' value='Elimina' onclick=\"return confirm('Eliminare questo Funko?')\">"
                        + "</form>"
                        + "</td></tr>");
            }
            out.println("</table>");
        }
    }
}
