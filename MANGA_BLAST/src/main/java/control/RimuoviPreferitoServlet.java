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
            response.sendRedirect("login.jsp");
            return;
        }

        String tipo = request.getParameter("tipo");
        String idProdotto = request.getParameter("id");

        if (tipo == null || idProdotto == null || tipo.isEmpty() || idProdotto.isEmpty()) {
            response.sendRedirect("preferiti.jsp");
            return;
        }

        PreferitiDAO dao = new PreferitiDAO();
        dao.rimuoviPreferito(email, tipo, idProdotto);

        // Reindirizza alla pagina dei preferiti
        response.sendRedirect("preferiti.jsp");
    }
}
