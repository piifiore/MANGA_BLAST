package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import model.*;
import java.io.*;
import java.util.*;

@WebServlet("/IndexServlet")
public class IndexServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Carica le categorie per i filtri
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            List<Categoria> categorie = categoriaDAO.getAllCategorie();
            request.setAttribute("categorie", categorie);
            
            // Carica alcuni prodotti per la visualizzazione iniziale
            MangaDAO mangaDAO = new MangaDAO();
            FunkoDAO funkoDAO = new FunkoDAO();
            
            List<Manga> listaManga = mangaDAO.getAllManga();
            List<Funko> listaFunko = funkoDAO.getAllFunko();
            
            // Limita a 6 prodotti per tipo per la homepage
            if (listaManga.size() > 6) {
                listaManga = listaManga.subList(0, 6);
            }
            if (listaFunko.size() > 6) {
                listaFunko = listaFunko.subList(0, 6);
            }
            
            request.setAttribute("listaManga", listaManga);
            request.setAttribute("listaFunko", listaFunko);
            request.setAttribute("emailUser", request.getSession().getAttribute("user"));
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            response.setContentType("text/plain");
            e.printStackTrace(response.getWriter());
        }
    }
}
