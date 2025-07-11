package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserDAO;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        HttpSession session = request.getSession();

        if (dao.isAdmin(email, password)) {
            session.setAttribute("admin", email);
            response.sendRedirect("admin-dashboard.jsp");
        } else if (dao.isUser(email, password)) {
            session.setAttribute("user", email);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("errorMessage", "Credenziali non valide!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }


}
