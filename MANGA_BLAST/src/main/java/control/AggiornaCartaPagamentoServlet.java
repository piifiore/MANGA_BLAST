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

		String holder = request.getParameter("cardHolder");
		String number = request.getParameter("cardNumber");
		String expiry = request.getParameter("expiry");

		if (number != null) {
			String digits = number.replaceAll("\\D+", "");
			String last4 = digits.length() >= 4 ? digits.substring(digits.length()-4) : digits;
			int mese = 0, anno = 0;
			if (expiry != null && expiry.matches("(0[1-9]|1[0-2])/\\d{2}")) {
				mese = Integer.parseInt(expiry.substring(0,2));
				int yy = Integer.parseInt(expiry.substring(3,5));
				anno = 2000 + yy;
			}

			CartaPagamento c = new CartaPagamento();
			c.setEmail(email);
			c.setIntestatario(holder);
			c.setNumero(digits);
			c.setLast4(last4);
			c.setBrand(detectBrand(digits));
			c.setScadenzaMese(mese);
			c.setScadenzaAnno(anno);
			new CartaPagamentoDAO().upsertCarta(c);
		}

		response.sendRedirect("area-profilo.jsp?updateCardSuccess=1");
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


