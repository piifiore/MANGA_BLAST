package control;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;


@SuppressWarnings("/LogoutUserServlet")
public class LogoutUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Evita di crearne una nuova
        if (session != null) {
            session.invalidate(); // Elimina la sessione
        }
        response.sendRedirect("login.jsp"); // Torna alla pagina di login
    }
}

