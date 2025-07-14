package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.PreferitiDAO;

import java.io.IOException;

@WebServlet("/AggiungiPreferitoServlet")
public class AggiungiPreferitoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("user");

        if (email == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String tipo = request.getParameter("tipo");
        String idProdotto = request.getParameter("idProdotto");

        if (tipo == null || idProdotto == null || tipo.isEmpty() || idProdotto.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        PreferitiDAO dao = new PreferitiDAO();
        boolean esiste = dao.isPreferito(email, tipo, idProdotto);

        response.setContentType("text/plain");

        if (esiste) {
            response.getWriter().write("esiste");
        } else {
            dao.aggiungiPreferito(email, tipo, idProdotto);
            response.getWriter().write("aggiunto");
        }

        response.getWriter().flush();
    }
}
