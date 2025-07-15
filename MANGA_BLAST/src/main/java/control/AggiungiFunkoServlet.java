package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Funko;
import model.FunkoDAO;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/AggiungiFunkoServlet")
@MultipartConfig
public class AggiungiFunkoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String numeroSerie = request.getParameter("numeroSerie");
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

            // Gestione immagine opzionale
            Part filePart = request.getPart("immagine");
            String nuovoNome = "images/default.jpg";

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                nuovoNome = "images/" + UUID.randomUUID().toString() + "_" + fileName;

                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                filePart.write(uploadPath + File.separator + nuovoNome.substring("images/".length()));
            }

            Funko funko = new Funko();
            funko.setNumeroSerie(numeroSerie);
            funko.setNome(nome);
            funko.setDescrizione(descrizione);
            funko.setPrezzo(prezzo);
            funko.setImmagine(nuovoNome);

            new FunkoDAO().addFunko(funko);

            response.sendRedirect("admin-prodotti.jsp?aggiunto=funko");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-prodotti.jsp?erroreInserimento=true");
        }
    }
}
