package model;

import java.sql.*;

public class CartaPagamentoDAO {

	public void upsertCarta(CartaPagamento carta) {
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
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException(e);
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


