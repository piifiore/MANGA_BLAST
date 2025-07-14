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
            response.sendRedirect("login.jsp");
            return;
        }

        String tipo = request.getParameter("tipo");
        String idProdotto = request.getParameter("idProdotto");

        if (tipo == null || idProdotto == null || tipo.isEmpty() || idProdotto.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        PreferitiDAO dao = new PreferitiDAO();

        boolean esiste = dao.isPreferito(email, tipo, idProdotto);

        if (esiste) {
            response.getWriter().write("esiste");
            response.getWriter().flush();
        } else {
            dao.aggiungiPreferito(email, tipo, idProdotto);
            response.getWriter().write("aggiunto");
            response.getWriter().flush();
        }
    }
}
