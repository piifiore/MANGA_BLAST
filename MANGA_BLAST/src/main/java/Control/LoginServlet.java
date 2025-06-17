package Control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginForm")
public class LoginServlet extends HttpServlet {

protected void doPost(HttpServletRequest request, HttpServletResponse response){

    String username = request.getParameter("username");
    String password = request.getParameter("password");




}

}
