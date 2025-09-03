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
        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = request.getParameter("email");
        String stato = request.getParameter("stato");
        String sort = request.getParameter("sort");
        String dataDa = request.getParameter("dataDa");
        String dataA = request.getParameter("dataA");

        OrdineDAO dao = new OrdineDAO();
        List<Ordine> ordini;

        boolean hasFilter = (email != null && !email.trim().isEmpty()) ||
                (stato != null && !stato.trim().isEmpty()) ||
                (sort != null && !sort.trim().isEmpty()) ||
                (dataDa != null && !dataDa.trim().isEmpty()) ||
                (dataA != null && !dataA.trim().isEmpty());

        if (hasFilter) {
            ordini = dao.getFilteredOrders(email, stato, sort, dataDa, dataA);
        } else {
            ordini = dao.getAllOrders();
        }

        request.setAttribute("ordini", ordini);
        String requestedWith = request.getHeader("X-Requested-With");
        if (requestedWith != null && requestedWith.equals("XMLHttpRequest")) {
            // Se è richiesto lo stato "Archiviato", usa la tabella degli ordini archiviati
            if ("Archiviato".equals(stato)) {
                request.getRequestDispatcher("tabella-ordini-archiviati.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("tabella-ordini.jsp").forward(request, response);
            }
        } else {
            request.getRequestDispatcher("admin-ordini.jsp").forward(request, response);
        }
    }
}
