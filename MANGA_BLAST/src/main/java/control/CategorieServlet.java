package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import java.io.*;
import java.util.*;

@WebServlet("/CategorieServlet")
public class CategorieServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            List<Categoria> categorie = categoriaDAO.getAllCategorie();
            
            // Assicurati che la lista non sia null
            if (categorie == null) {
                categorie = new ArrayList<>();
            }
            
            // Restituisci sempre JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String json = "{\"success\": true, \"categorie\": " + 
                new com.google.gson.Gson().toJson(categorie) + "}";
            
            response.getWriter().write(json);
            
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"error\": \"" + 
                e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
