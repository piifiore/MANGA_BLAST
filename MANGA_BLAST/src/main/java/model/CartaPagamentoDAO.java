package model;

import java.sql.*;

public class CartaPagamentoDAO {

	public void upsertCarta(CartaPagamento carta) {
		String sql = "INSERT INTO carte_pagamento (email,intestatario,numero_maschera,last4,brand,scadenza_mese,scadenza_anno) " +
					"VALUES (?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE intestatario=VALUES(intestatario), numero_maschera=VALUES(numero_maschera), last4=VALUES(last4), brand=VALUES(brand), scadenza_mese=VALUES(scadenza_mese), scadenza_anno=VALUES(scadenza_anno)";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, carta.getEmail());
			ps.setString(2, carta.getIntestatario());
			ps.setString(3, carta.getNumeroMaschera());
			ps.setString(4, carta.getLast4());
			ps.setString(5, carta.getBrand());
			ps.setInt(6, carta.getScadenzaMese());
			ps.setInt(7, carta.getScadenzaAnno());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

}


