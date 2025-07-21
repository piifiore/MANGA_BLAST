package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import model.Manga;
import model.MangaDAO;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;

@WebServlet("/ModificaMangaServlet")
@MultipartConfig
public class ModificaMangaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            long isbn = Long.parseLong(request.getParameter("ISBN"));
            String nome = request.getParameter("nome");
            String descrizione = request.getParameter("descrizione");
            BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));

            Part filePart = request.getPart("immagine");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String immagine = fileName.isEmpty() ? null : fileName;

            if (immagine != null) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
            }

            MangaDAO dao = new MangaDAO();
            Manga manga = dao.getAllManga()
                    .stream()
                    .filter(m -> m.getISBN() == isbn)
                    .findFirst()
                    .orElse(null);

            if (manga != null) {
                manga.setNome(nome);
                manga.setDescrizione(descrizione);
                manga.setPrezzo(prezzo);
                if (immagine != null) manga.setImmagine(immagine);

                dao.updateManga(manga);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}