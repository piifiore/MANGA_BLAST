package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
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

        BigDecimal min = BigDecimal.ZERO;
        BigDecimal max = new BigDecimal("999999");

        try {
            if (minStr != null && !minStr.isEmpty()) min = new BigDecimal(minStr);
            if (maxStr != null && !maxStr.isEmpty()) max = new BigDecimal(maxStr);
        } catch (NumberFormatException e) {
            // Ignora e usa default
        }

        final BigDecimal minFiltro = min;
        final BigDecimal maxFiltro = max;

        try {
            if ("manga".equals(tipo)) {
                MangaDAO dao = new MangaDAO();
                List<Manga> risultati = (query != null && !query.isBlank())
                        ? dao.searchByQuery(query)
                        : dao.getAllManga();

                risultati.removeIf(m -> m.getPrezzo() == null ||
                        m.getPrezzo().compareTo(minFiltro) < 0 ||
                        m.getPrezzo().compareTo(maxFiltro) > 0);

                if ("asc".equals(sort)) {
                    risultati.sort(Comparator.comparing(Manga::getPrezzo));
                } else if ("desc".equals(sort)) {
                    risultati.sort(Comparator.comparing(Manga::getPrezzo).reversed());
                }

                request.setAttribute("risultatiManga", risultati);
                // Carica anche la lista Funko completa per mostrare entrambi
                FunkoDAO daoF = new FunkoDAO();
                request.setAttribute("risultatiFunko", daoF.getAllFunko());

                RequestDispatcher dispatcher = request.getRequestDispatcher("admin-prodotti.jsp");
                dispatcher.forward(request, response);

            } else if ("funko".equals(tipo)) {
                FunkoDAO dao = new FunkoDAO();
                List<Funko> risultati = (query != null && !query.isBlank())
                        ? dao.searchByQuery(query)
                        : dao.getAllFunko();

                risultati.removeIf(f -> f.getPrezzo() == null ||
                        f.getPrezzo().compareTo(minFiltro) < 0 ||
                        f.getPrezzo().compareTo(maxFiltro) > 0);

                if ("asc".equals(sort)) {
                    risultati.sort(Comparator.comparing(Funko::getPrezzo));
                } else if ("desc".equals(sort)) {
                    risultati.sort(Comparator.comparing(Funko::getPrezzo).reversed());
                }

                request.setAttribute("risultatiFunko", risultati);
                // Carica anche la lista Manga completa per mostrare entrambi
                MangaDAO daoM = new MangaDAO();
                request.setAttribute("risultatiManga", daoM.getAllManga());

                RequestDispatcher dispatcher = request.getRequestDispatcher("admin-prodotti.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            response.setContentType("text/plain");
            e.printStackTrace(response.getWriter());
        }
    }
}
