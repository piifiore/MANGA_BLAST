package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Manga;
import model.MangaDAO;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/AggiungiMangaServlet")
@MultipartConfig
public class AggiungiMangaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            long isbn = Long.parseLong(request.getParameter("ISBN"));
            String nome = request.getParameter("nome");
            String descrizione = request.getParameter("descrizione");
            BigDecimal prezzo;

            try {
                prezzo = new BigDecimal(request.getParameter("prezzo"));
                if (prezzo.compareTo(BigDecimal.ZERO) < 0) {
                    throw new NumberFormatException("Prezzo negativo non valido");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("admin-prodotti.jsp?errorePrezzo=true");
                return;
            }

            // Gestione file immagine (opzionale)
            Part filePart = request.getPart("immagine");
            String nuovoNome = "images/default.jpg"; // Immagine di default

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                nuovoNome = "images/" + UUID.randomUUID().toString() + "_" + fileName;

                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                filePart.write(uploadPath + File.separator + nuovoNome.substring("images/".length()));
            }

            Manga manga = new Manga();
            manga.setISBN(isbn);
            manga.setNome(nome);
            manga.setDescrizione(descrizione);
            manga.setPrezzo(prezzo);
            manga.setImmagine(nuovoNome);

            new MangaDAO().addManga(manga);

            response.sendRedirect("admin-prodotti.jsp?aggiunto=manga");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-prodotti.jsp?erroreInserimento=true");
        }
    }
}
