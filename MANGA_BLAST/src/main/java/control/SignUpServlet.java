package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserDAO;

import java.io.IOException;


@WebServlet("/SignUpServlet")

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
            response.sendRedirect("login.jsp?signupSuccess=true");
        }
    }



}
