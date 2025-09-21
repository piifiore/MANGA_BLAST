package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserDAO;
import model.CarrelloDAO;
import model.ItemCarrello;

import java.io.IOException;
import java.util.List;

@WebServlet("/signup")

public class SignUpServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        UserDAO userDAO = new UserDAO();

        if (userDAO.emailExists(email))
        {
            request.setAttribute("errore", "Email già in uso");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } else{
            userDAO.registerUser(password, email);
            
            // Salva carrello guest nel database per il nuovo account
            HttpSession session = request.getSession();
            
            List<ItemCarrello> carrelloGuest = (List<ItemCarrello>) session.getAttribute("carrello");
            if (carrelloGuest != null && !carrelloGuest.isEmpty()) {
                CarrelloDAO carrelloDAO = new CarrelloDAO();
                
                // Crea il carrello dell'utente
                carrelloDAO.creaCarrelloUtente(email);
                
                // Migra il carrello guest nel database
                for (ItemCarrello item : carrelloGuest) {
                    carrelloDAO.aggiungiItem(email, item.getTipo(), item.getIdProdotto(), item.getQuantita());
                }
                // Non rimuovere il carrello dalla sessione, verrà gestito al login
            }
            
            response.sendRedirect("login.jsp?signupSuccess=true");
        }
    }
}
