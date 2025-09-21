package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserDAO;
import model.CarrelloDAO;
import model.ItemCarrello;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        HttpSession session = request.getSession();

        session.removeAttribute("user");
        session.removeAttribute("admin");

        if (dao.isAdmin(email, password)) {
            session.setAttribute("admin", email);
            response.sendRedirect("index.jsp");

        } else if (dao.isUser(email, password)) {
            session.setAttribute("user", email);

            // Gestisci migrazione carrello guest -> database
            List<ItemCarrello> carrelloGuest = (List<ItemCarrello>) session.getAttribute("carrello");
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            
            // Crea il carrello dell'utente se non esiste
            carrelloDAO.creaCarrelloUtente(email);
            
            if (carrelloGuest != null && !carrelloGuest.isEmpty()) {
                // Migra il carrello guest nel database (somma le quantità se esistono già)
                for (ItemCarrello item : carrelloGuest) {
                    carrelloDAO.aggiungiItem(email, item.getTipo(), item.getIdProdotto(), item.getQuantita());
                }
            }
            
            // Carica carrello dal database e sostituisci quello in sessione
            List<ItemCarrello> carrelloDB = carrelloDAO.getCarrelloUtente(email);
            if (carrelloDB != null && !carrelloDB.isEmpty()) {
                session.setAttribute("carrello", carrelloDB);
            } else {
                // Se non c'è carrello nel DB, rimuovi quello guest
                session.removeAttribute("carrello");
            }

            response.sendRedirect("index.jsp");

        } else {
            request.setAttribute("errorMessage", "Credenziali non valide!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}