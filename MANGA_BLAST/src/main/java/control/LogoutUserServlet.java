package control;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/LogoutUserServlet")
public class LogoutUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Evita di crearne una nuova
        if (session != null) {
            // Pulisci completamente la sessione per evitare problemi di duplicazione
            session.invalidate();
        }

        // Opzionale: invalida eventuali cookie di sessione auth se presenti (non rimuove dati in sessione)
        // response.addCookie(new Cookie("auth", "") {{ setMaxAge(0); setPath("/"); }});

        response.sendRedirect("login.jsp"); // Torna alla pagina di login
    }
}

