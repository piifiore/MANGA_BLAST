package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.PreferitiDAO;

import java.io.IOException;

@WebServlet("/RimuoviPreferitoServlet")
public class RimuoviPreferitoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("user");

        if (email == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String tipo = request.getParameter("tipo");
        String idProdotto = request.getParameter("id");

        if (tipo == null || idProdotto == null || tipo.isEmpty() || idProdotto.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        PreferitiDAO dao = new PreferitiDAO();
        dao.rimuoviPreferito(email, tipo, idProdotto);

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("text/plain");
        response.getWriter().write("rimosso");
        response.getWriter().flush();
    }
}
