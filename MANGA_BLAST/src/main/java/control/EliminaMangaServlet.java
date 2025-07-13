package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MangaDAO;

import java.io.IOException;

@WebServlet("/EliminaMangaServlet")
public class EliminaMangaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            long isbn = Long.parseLong(request.getParameter("ISBN"));
            MangaDAO dao = new MangaDAO();
            dao.deleteManga(isbn);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}