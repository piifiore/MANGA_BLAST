package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.MangaDAO;
import java.io.IOException;

@WebServlet("/EliminaMangaServlet")
public class EliminaMangaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String isbnParam = request.getParameter("ISBN");
            if (isbnParam != null && !isbnParam.isEmpty()) {
                long isbn = Long.parseLong(isbnParam);
                MangaDAO dao = new MangaDAO();
                dao.deleteManga(isbn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}
