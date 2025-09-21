package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import model.*;
import java.io.*;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/RicercaProdottiServlet")
public class RicercaProdottiServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String query = request.getParameter("query");
        String tipo = request.getParameter("tipo");
        String prezzoMinStr = request.getParameter("prezzoMin");
        String prezzoMaxStr = request.getParameter("prezzoMax");
        String sortBy = request.getParameter("sortBy");

        BigDecimal prezzoMin = null;
        BigDecimal prezzoMax = null;

        try {
            if (prezzoMinStr != null && !prezzoMinStr.trim().isEmpty()) {
                prezzoMin = new BigDecimal(prezzoMinStr);
                // Limita il range a 0-200
                if (prezzoMin.compareTo(BigDecimal.ZERO) < 0) prezzoMin = BigDecimal.ZERO;
                if (prezzoMin.compareTo(new BigDecimal("200")) > 0) prezzoMin = new BigDecimal("200");
            }
            if (prezzoMaxStr != null && !prezzoMaxStr.trim().isEmpty()) {
                prezzoMax = new BigDecimal(prezzoMaxStr);
                // Limita il range a 0-200
                if (prezzoMax.compareTo(BigDecimal.ZERO) < 0) prezzoMax = BigDecimal.ZERO;
                if (prezzoMax.compareTo(new BigDecimal("200")) > 0) prezzoMax = new BigDecimal("200");
            }
        } catch (NumberFormatException e) {
            // Ignora valori non validi
        }

        final BigDecimal minFiltro = prezzoMin;
        final BigDecimal maxFiltro = prezzoMax;

        String requestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = requestedWith != null && requestedWith.equals("XMLHttpRequest");

        try {
            List<Manga> listaManga = new ArrayList<>();
            List<Funko> listaFunko = new ArrayList<>();

            if ("funko".equalsIgnoreCase(tipo)) {
                FunkoDAO funkoDAO = new FunkoDAO();
                listaFunko = funkoDAO.searchFunko(query, null);
                
                // Filtra per prezzo se specificato
                if (minFiltro != null || maxFiltro != null) {
                    listaFunko.removeIf(f -> {
                        if (f.getPrezzo() == null) return true;
                        if (minFiltro != null && f.getPrezzo().compareTo(minFiltro) < 0) return true;
                        if (maxFiltro != null && f.getPrezzo().compareTo(maxFiltro) > 0) return true;
                        return false;
                    });
                }
            } else if ("manga".equalsIgnoreCase(tipo)) {
                MangaDAO mangaDAO = new MangaDAO();
                listaManga = mangaDAO.searchManga(query, null);
                
                // Filtra per prezzo se specificato
                if (minFiltro != null || maxFiltro != null) {
                    listaManga.removeIf(m -> {
                        if (m.getPrezzo() == null) return true;
                        if (minFiltro != null && m.getPrezzo().compareTo(minFiltro) < 0) return true;
                        if (maxFiltro != null && m.getPrezzo().compareTo(maxFiltro) > 0) return true;
                        return false;
                    });
                }
            } else {
                // Se non è specificato un tipo, cerca in entrambi
                MangaDAO mangaDAO = new MangaDAO();
                FunkoDAO funkoDAO = new FunkoDAO();
                
                if ((query != null && !query.trim().isEmpty()) || minFiltro != null || maxFiltro != null) {
                    // Se c'è una query o un filtro prezzo, cerca in entrambi
                    listaManga = mangaDAO.searchManga(query, null);
                    listaFunko = funkoDAO.searchFunko(query, null);
                } else {
                    // Nessun filtro, mostra tutto
                    listaManga = mangaDAO.getAllManga();
                    listaFunko = funkoDAO.getAllFunko();
                }
                
                // Filtra per prezzo se specificato
                if (minFiltro != null || maxFiltro != null) {
                    listaManga.removeIf(m -> {
                        if (m.getPrezzo() == null) return true;
                        if (minFiltro != null && m.getPrezzo().compareTo(minFiltro) < 0) return true;
                        if (maxFiltro != null && m.getPrezzo().compareTo(maxFiltro) > 0) return true;
                        return false;
                    });
                    
                    listaFunko.removeIf(f -> {
                        if (f.getPrezzo() == null) return true;
                        if (minFiltro != null && f.getPrezzo().compareTo(minFiltro) < 0) return true;
                        if (maxFiltro != null && f.getPrezzo().compareTo(maxFiltro) > 0) return true;
                        return false;
                    });
                }
            }

            // Applica ordinamento se specificato
            if (sortBy != null && !sortBy.equals("default")) {
                sortProducts(listaManga, listaFunko, sortBy);
            }

            request.setAttribute("listaManga", listaManga);
            request.setAttribute("listaFunko", listaFunko);
            request.setAttribute("emailUser", request.getSession().getAttribute("user"));

            if (isAjax) {
                request.getRequestDispatcher("risultati-prodotti.jsp").forward(request, response);
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            response.setContentType("text/plain");
            e.printStackTrace(response.getWriter());
        }
    }
    
    private void sortProducts(List<Manga> mangaList, List<Funko> funkoList, String sortBy) {
        switch (sortBy) {
            case "prezzo-asc":
                mangaList.sort(Comparator.comparing(Manga::getPrezzo, Comparator.nullsLast(Comparator.naturalOrder())));
                funkoList.sort(Comparator.comparing(Funko::getPrezzo, Comparator.nullsLast(Comparator.naturalOrder())));
                break;
            case "prezzo-desc":
                mangaList.sort(Comparator.comparing(Manga::getPrezzo, Comparator.nullsLast(Comparator.reverseOrder())));
                funkoList.sort(Comparator.comparing(Funko::getPrezzo, Comparator.nullsLast(Comparator.reverseOrder())));
                break;
            case "nome-asc":
                mangaList.sort(Comparator.comparing(Manga::getNome, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER)));
                funkoList.sort(Comparator.comparing(Funko::getNome, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER)));
                break;
            case "nome-desc":
                mangaList.sort(Comparator.comparing(Manga::getNome, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed())));
                funkoList.sort(Comparator.comparing(Funko::getNome, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed())));
                break;
        }
    }
}
