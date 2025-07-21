package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import model.Funko;
import model.FunkoDAO;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;

@WebServlet("/ModificaFunkoServlet")
@MultipartConfig
public class ModificaFunkoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String numeroSerie = request.getParameter("numeroSerie");
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

            FunkoDAO dao = new FunkoDAO();
            Funko funko = dao.getAllFunko()
                    .stream()
                    .filter(f -> f.getNumeroSerie().equals(numeroSerie))
                    .findFirst()
                    .orElse(null);

            if (funko != null) {
                funko.setNome(nome);
                funko.setDescrizione(descrizione);
                funko.setPrezzo(prezzo);
                if (immagine != null) funko.setImmagine(immagine);

                dao.updateFunko(funko);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-prodotti.jsp");
    }
}