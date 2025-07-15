package control;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import model.Ordine;
import model.OrdineDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/OrderManagementServlet")
public class OrderManagementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String stato = request.getParameter("stato");
        String sort = request.getParameter("sort");

        OrdineDAO dao = new OrdineDAO();
        List<Ordine> ordini = dao.getFilteredOrders(email, stato, sort);

        request.setAttribute("ordini", ordini);
        request.getRequestDispatcher("admin-ordini.jsp").forward(request, response);
    }
}
