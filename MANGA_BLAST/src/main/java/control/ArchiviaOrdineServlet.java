package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OrdineDAO;

import java.io.IOException;

@WebServlet("/ArchiviaOrdineServlet")
public class ArchiviaOrdineServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idOrdineStr = request.getParameter("id");
        if (idOrdineStr != null && !idOrdineStr.trim().isEmpty()) {
            try {
                int idOrdine = Integer.parseInt(idOrdineStr);
                OrdineDAO dao = new OrdineDAO();
                dao.updateOrderStatus(idOrdine, "Archiviato");
            } catch (NumberFormatException e) {
                // ID non valido
            }
        }

        response.sendRedirect("admin-ordini.jsp");
    }
}
