package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import model.FunkoDAO;

@WebServlet("/EliminaFunkoServlet")
public class EliminaFunkoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String numeroSerie = request.getParameter("numeroSerie");
            FunkoDAO dao = new FunkoDAO();
            dao.deleteFunko(numeroSerie);
        } catch (Exception e) {
            e.printStackTrace(); // Puoi sostituire con logger in produzione
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}