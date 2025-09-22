package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/VerificaProdottoServlet")
public class VerificaProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String emailAdmin = (String) session.getAttribute("admin");
        
        // Verifica che sia un admin
        if (emailAdmin == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String tipo = request.getParameter("tipo");
        String action = request.getParameter("action");
        
        if (tipo == null || action == null) {
            response.sendRedirect("admin-prodotti.jsp");
            return;
        }
        
        // Salva i dati del form in sessione per la verifica
        if ("manga".equals(tipo)) {
            session.setAttribute("mangaData", request.getParameterMap());
        } else if ("funko".equals(tipo)) {
            session.setAttribute("funkoData", request.getParameterMap());
        }
        
        // Salva anche il tipo e l'azione
        session.setAttribute("verificaTipo", tipo);
        session.setAttribute("verificaAction", action);
        
        // Reindirizza alla pagina di verifica
        response.sendRedirect("verifica-prodotto.jsp?tipo=" + tipo + "&action=" + action);
    }
}
