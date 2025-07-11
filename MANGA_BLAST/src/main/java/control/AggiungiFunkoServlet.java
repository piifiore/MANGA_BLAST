package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import model.Funko;
import model.FunkoDAO;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;

@WebServlet("/AggiungiFunkoServlet")
@MultipartConfig
public class AggiungiFunkoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String numeroSerie = request.getParameter("numeroSerie");
            String nome = request.getParameter("nome");
            String descrizione = request.getParameter("descrizione");
            BigDecimal prezzo = BigDecimal.ZERO;
            try {
                prezzo = new BigDecimal(request.getParameter("prezzo"));
                if (prezzo.compareTo(BigDecimal.ZERO) < 0) {
                    throw new NumberFormatException("Prezzo negativo non valido");
                }
            } catch (NumberFormatException e) {
                // Puoi gestire l'errore come preferisci:
                // - mostri un messaggio
                // - torni alla pagina con un parametro `?errorePrezzo=true`
                e.printStackTrace();
                response.sendRedirect("admin-prodotti.jsp?errorePrezzo=true");
                return;
            }

            Part filePart = request.getPart("immagine");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);

            Funko f = new Funko();
            f.setNumeroSerie(numeroSerie);
            f.setNome(nome);
            f.setDescrizione(descrizione);
            f.setPrezzo(prezzo);
            f.setImmagine(fileName);

            FunkoDAO dao = new FunkoDAO();
            dao.addFunko(f);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}