package model;

import java.sql.*;
import java.util.*;

public class CarrelloDAO {

    public List<ProdottoCarrello> getCarrelloUtente(int utenteId) {
        List<ProdottoCarrello> carrello = new ArrayList<>();
        String query = "SELECT * FROM carrello WHERE utente_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, utenteId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ProdottoCarrello pc = new ProdottoCarrello();
                pc.setProdottoId(rs.getInt("prodotto_id"));
                pc.setQuantita(rs.getInt("quantita"));
                carrello.add(pc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carrello;
    }

    public boolean aggiungiAlCarrello(int utenteId, int prodottoId, int quantita) {
        String query = "INSERT INTO carrello (utente_id, prodotto_id, quantita) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, utenteId);
            stmt.setInt(2, prodottoId);
            stmt.setInt(3, quantita);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean svuotaCarrello(int utenteId) {
        String query = "DELETE FROM carrello WHERE utente_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, utenteId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

