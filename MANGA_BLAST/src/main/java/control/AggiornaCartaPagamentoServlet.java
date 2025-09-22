package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartaPagamento;
import model.CartaPagamentoDAO;

import java.io.IOException;

@WebServlet("/AggiornaCartaPagamentoServlet")
public class AggiornaCartaPagamentoServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String email = (String) session.getAttribute("user");
		if (email == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// Ottieni i parametri dal form
		String numeroCarta = request.getParameter("numeroCarta");
		String intestatario = request.getParameter("intestatario");
		String scadenzaMeseStr = request.getParameter("scadenzaMese");
		String scadenzaAnnoStr = request.getParameter("scadenzaAnno");
		String cvv = request.getParameter("cvv");

		// Validazione parametri
		if (numeroCarta == null || intestatario == null || scadenzaMeseStr == null || 
			scadenzaAnnoStr == null || cvv == null) {
			response.sendRedirect("area-profilo.jsp?error=Parametri mancanti");
			return;
		}

		// Pulisci il numero carta
		String digits = numeroCarta.replaceAll("\\D+", "");
		if (digits.length() < 13 || digits.length() > 19) {
			response.sendRedirect("area-profilo.jsp?error=Numero carta non valido");
			return;
		}

		// Validazione scadenza
		int mese, anno;
		try {
			mese = Integer.parseInt(scadenzaMeseStr);
			anno = Integer.parseInt(scadenzaAnnoStr);
		} catch (NumberFormatException e) {
			response.sendRedirect("area-profilo.jsp?error=Data scadenza non valida");
			return;
		}

		// Controlla se la carta è scaduta
		java.time.LocalDate oggi = java.time.LocalDate.now();
		java.time.LocalDate scadenza = java.time.LocalDate.of(anno, mese, 1).withDayOfMonth(
			java.time.LocalDate.of(anno, mese, 1).lengthOfMonth()
		);
		
		if (scadenza.isBefore(oggi)) {
			response.sendRedirect("area-profilo.jsp?error=La carta è scaduta");
			return;
		}

		// Validazione CVV
		if (cvv.length() < 3 || cvv.length() > 4) {
			response.sendRedirect("area-profilo.jsp?error=CVV non valido");
			return;
		}

		// Validazione intestatario
		if (intestatario.trim().length() < 2) {
			response.sendRedirect("area-profilo.jsp?error=Intestatario non valido");
			return;
		}

		// Crea e salva la carta
		String last4 = digits.substring(digits.length()-4);
		
		CartaPagamento c = new CartaPagamento();
		c.setEmail(email);
		c.setIntestatario(intestatario.trim());
		c.setNumero(digits);
		c.setLast4(last4);
		c.setBrand(detectBrand(digits));
		c.setScadenzaMese(mese);
		c.setScadenzaAnno(anno);
		
		// Salva nel database
		CartaPagamentoDAO dao = new CartaPagamentoDAO();
		boolean success = dao.upsertCarta(c);
		
		if (success) {
			response.sendRedirect("area-profilo.jsp?updateCardSuccess=1");
		} else {
			response.sendRedirect("area-profilo.jsp?error=Errore nel salvataggio della carta");
		}
	}

	private String detectBrand(String digits) {
		if (digits == null || digits.isEmpty()) return null;
		if (digits.startsWith("4")) return "Visa";
		if (digits.matches("5[1-5].*")) return "Mastercard";
		if (digits.matches("3[47].*")) return "Amex";
		if (digits.matches("6(?:011|5).*")) return "Discover";
		return "Carta";
	}
}


