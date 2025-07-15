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

            List<ItemCarrello> carrelloAnonimo = (List<ItemCarrello>) session.getAttribute("carrello");
            if (carrelloAnonimo != null && !carrelloAnonimo.isEmpty()) {
                CarrelloDAO carrelloDAO = new CarrelloDAO();
                for (ItemCarrello item : carrelloAnonimo) {
                    carrelloDAO.aggiungiItem(email, item.getTipo(), item.getIdProdotto(), item.getQuantita());
                }
                session.removeAttribute("carrello");
            }

            response.sendRedirect("index.jsp");

        } else {
            request.setAttribute("errorMessage", "Credenziali non valide!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}