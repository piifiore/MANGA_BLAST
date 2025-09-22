package model;

import java.sql.*;
import java.time.LocalDate;
import java.time.YearMonth;

public class CartaPagamentoDAO {

	/**
	 * Verifica se una carta di pagamento è scaduta
	 * @param carta la carta da verificare
	 * @return true se la carta è scaduta, false altrimenti
	 */
	public boolean isCartaScaduta(CartaPagamento carta) {
		YearMonth scadenzaCarta = YearMonth.of(carta.getScadenzaAnno(), carta.getScadenzaMese());
		YearMonth oggi = YearMonth.now();
		return scadenzaCarta.isBefore(oggi);
	}

	public boolean upsertCarta(CartaPagamento carta) {
		// Verifica se la carta è scaduta prima di salvarla
		if (isCartaScaduta(carta)) {
			System.err.println("Tentativo di salvare carta scaduta per email: " + carta.getEmail());
			return false;
		}
		
		String sql = "INSERT INTO carte_pagamento (email,intestatario,numero,last4,brand,scadenza_mese,scadenza_anno) " +
					"VALUES (?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE intestatario=VALUES(intestatario), numero=VALUES(numero), last4=VALUES(last4), brand=VALUES(brand), scadenza_mese=VALUES(scadenza_mese), scadenza_anno=VALUES(scadenza_anno)";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, carta.getEmail());
			ps.setString(2, carta.getIntestatario());
			ps.setString(3, carta.getNumero());
			ps.setString(4, carta.getLast4());
			ps.setString(5, carta.getBrand());
			ps.setInt(6, carta.getScadenzaMese());
			ps.setInt(7, carta.getScadenzaAnno());
			
			int rowsAffected = ps.executeUpdate();
			System.out.println("Carta salvata per email: " + carta.getEmail() + " - Righe affette: " + rowsAffected);
			return rowsAffected > 0;
		} catch (SQLException e) {
			System.err.println("Errore nel salvataggio carta per email: " + carta.getEmail());
			e.printStackTrace();
			return false;
		}
	}

    public CartaPagamento getByEmail(String email) {
        String sql = "SELECT email,intestatario,numero,last4,brand,scadenza_mese,scadenza_anno FROM carte_pagamento WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CartaPagamento c = new CartaPagamento();
                    c.setEmail(rs.getString("email"));
                    c.setIntestatario(rs.getString("intestatario"));
                    c.setNumero(rs.getString("numero"));
                    c.setLast4(rs.getString("last4"));
                    c.setBrand(rs.getString("brand"));
                    c.setScadenzaMese(rs.getInt("scadenza_mese"));
                    c.setScadenzaAnno(rs.getInt("scadenza_anno"));
                    
                    // Verifica se la carta è scaduta
                    if (isCartaScaduta(c)) {
                        System.out.println("Carta scaduta trovata per email: " + email + " - non restituita");
                        return null;
                    }
                    
                    return c;
                }
            }
        } catch (SQLException e) {
            // Log dell'errore e ritorna null invece di lanciare eccezione
            System.err.println("Errore nel recupero carta pagamento per email: " + email);
            e.printStackTrace();
            return null;
        }
        return null;
    }

}


