package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import model.*;
import java.io.*;
import java.util.*;
import java.util.ArrayList;

@WebServlet("/GestioneCategorieServlet")
public class GestioneCategorieServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        
        String action = request.getParameter("action");
        String requestedWith = request.getHeader("X-Requested-With");
        String contentType = request.getHeader("Content-Type");
        boolean isAjax = (requestedWith != null && requestedWith.equals("XMLHttpRequest")) || 
                        (contentType != null && contentType.contains("application/x-www-form-urlencoded"));
        
        try {
            if (action == null) {
                // Se non c'è action, carica la pagina di gestione (solo per admin)
                if (admin == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                loadGestioneCategoriePage(request, response);
                return;
            }
            
            switch (action) {
                case "getCategorie":
                    // getCategorie è accessibile a tutti gli utenti
                    getCategorie(request, response, isAjax);
                    break;
                case "addCategoria":
                case "updateCategoria":
                case "deleteCategoria":
                    // Le operazioni di modifica richiedono privilegi admin
                    if (admin == null) {
                        if (isAjax) {
                            response.setContentType("application/json");
                            response.getWriter().write("{\"success\": false, \"error\": \"Accesso negato\"}");
                        } else {
                            response.sendRedirect("login.jsp");
                        }
                        return;
                    }
                    if (action.equals("addCategoria")) {
                        addCategoria(request, response, isAjax);
                    } else if (action.equals("updateCategoria")) {
                        updateCategoria(request, response, isAjax);
                    } else if (action.equals("deleteCategoria")) {
                        deleteCategoria(request, response, isAjax);
                    }
                    break;
                default:
                    // Azione non riconosciuta
                    if (admin == null) {
                        response.sendRedirect("login.jsp");
                        return;
                    }
                    loadGestioneCategoriePage(request, response);
                    break;
            }
        } catch (Exception e) {
            // Per le operazioni AJAX, restituisci sempre JSON anche in caso di errore
            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            } else {
                e.printStackTrace();
                response.sendRedirect("login.jsp");
            }
        }
    }
    
    private void loadGestioneCategoriePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            
            List<Categoria> categorie = categoriaDAO.getAllCategorie();
            
            // Assicurati che le liste non siano null
            if (categorie == null) {
                categorie = new ArrayList<>();
            }
            
            request.setAttribute("categorie", categorie);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("gestione-categorie.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // In caso di errore, carica comunque la pagina con liste vuote
            request.setAttribute("categorie", new ArrayList<>());
            request.setAttribute("error", "Errore nel caricamento dei dati: " + e.getMessage());
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("gestione-categorie.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void getCategorie(HttpServletRequest request, HttpServletResponse response, boolean isAjax) throws Exception {
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        List<Categoria> categorie = categoriaDAO.getAllCategorie();
        
        if (isAjax) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"categorie\": " + 
                new com.google.gson.Gson().toJson(categorie) + "}");
        } else {
            request.setAttribute("categorie", categorie);
            request.getRequestDispatcher("gestione-categorie.jsp").forward(request, response);
        }
    }
    
    
    private void addCategoria(HttpServletRequest request, HttpServletResponse response, boolean isAjax) throws Exception {
        String nome = request.getParameter("nome");
        String descrizione = request.getParameter("descrizione");
        String colore = request.getParameter("colore");
        
        if (nome == null || nome.trim().isEmpty()) {
            throw new IllegalArgumentException("Il nome della categoria è obbligatorio");
        }
        
        Categoria categoria = new Categoria();
        categoria.setNome(nome.trim());
        categoria.setDescrizione(descrizione != null ? descrizione.trim() : "");
        categoria.setColore(colore != null ? colore.trim() : "#FF6B35");
        categoria.setAttiva(true);
        
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        boolean success = categoriaDAO.addCategoria(categoria);
        
        // Per le operazioni POST, restituisci sempre JSON
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + 
            (success ? "" : ", \"error\": \"Errore nell'aggiunta della categoria\"") + "}");
    }
    
    private void updateCategoria(HttpServletRequest request, HttpServletResponse response, boolean isAjax) throws Exception {
        String idStr = request.getParameter("id");
        String nome = request.getParameter("nome");
        String descrizione = request.getParameter("descrizione");
        String colore = request.getParameter("colore");
        String attivaStr = request.getParameter("attiva");
        
        // Logging rimosso per semplificare
        
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID categoria obbligatorio");
        }
        
        int id = Integer.parseInt(idStr);
        Categoria categoria = new Categoria();
        categoria.setId(id);
        categoria.setNome(nome != null ? nome.trim() : "");
        categoria.setDescrizione(descrizione != null ? descrizione.trim() : "");
        categoria.setColore(colore != null ? colore.trim() : "#FF6B35");
        categoria.setAttiva("true".equals(attivaStr));
        
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        boolean success = categoriaDAO.updateCategoria(categoria);
        
        // Per le operazioni POST, restituisci sempre JSON
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + 
            (success ? "" : ", \"error\": \"Errore nell'aggiornamento della categoria\"") + "}");
    }
    
    private void deleteCategoria(HttpServletRequest request, HttpServletResponse response, boolean isAjax) throws Exception {
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID categoria obbligatorio");
        }
        
        int id = Integer.parseInt(idStr);
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        boolean success = categoriaDAO.deleteCategoria(id);
        
        // Per le operazioni POST, restituisci sempre JSON
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + 
            (success ? "" : ", \"error\": \"Errore nell'eliminazione della categoria\"") + "}");
    }
    
}
