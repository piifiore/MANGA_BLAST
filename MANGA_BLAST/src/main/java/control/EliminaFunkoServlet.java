package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.FunkoDAO;
import java.io.IOException;

@WebServlet("/EliminaFunkoServlet")
public class EliminaFunkoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String numeroSerie = request.getParameter("numeroSerie");
            if (numeroSerie != null && !numeroSerie.isEmpty()) {
                FunkoDAO dao = new FunkoDAO();
                dao.deleteFunko(numeroSerie);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}
