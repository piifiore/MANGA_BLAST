package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserDAO;

import java.io.IOException;

@WebServlet("/AggiornaProfiloUtenteServlet")
public class AggiornaProfiloUtenteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Recupera email dell'utente dalla sessione
        String email = (String) request.getSession().getAttribute("user");

        // Parametri inviati dal form
        String nuovaPassword = request.getParameter("password");
        String nuovoIndirizzo = request.getParameter("indirizzo");

        // Esegui aggiornamento solo se email presente
        if (email != null && nuovoIndirizzo != null) {
            UserDAO dao = new UserDAO();
            dao.updateProfilo(email, nuovaPassword, nuovoIndirizzo);
        }

        // Torna alla pagina profilo
        response.sendRedirect("area-profilo.jsp");
    }
}