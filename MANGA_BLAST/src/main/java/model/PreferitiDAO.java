package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PreferitiDAO {

    public void aggiungiPreferito(String email, String tipo, String idProdotto) {
        String sql = "INSERT IGNORE INTO preferiti (email_utente, tipo, id_prodotto) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, tipo);
            ps.setString(3, idProdotto);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void rimuoviPreferito(String email, String tipo, String idProdotto) {
        String sql = "DELETE FROM preferiti WHERE email_utente = ? AND tipo = ? AND id_prodotto = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, tipo);
            ps.setString(3, idProdotto);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ItemCarrello> getPreferitiByEmail(String email) {
        List<ItemCarrello> preferiti = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Manga preferiti
            String sqlManga = "SELECT m.ISBN, m.nome, m.prezzo, m.immagine FROM preferiti p JOIN manga m ON p.id_prodotto = m.ISBN WHERE p.email_utente = ? AND p.tipo = 'manga'";
            try (PreparedStatement ps = conn.prepareStatement(sqlManga)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    preferiti.add(new ItemCarrello(
                            String.valueOf(rs.getLong("ISBN")),
                            "manga",
                            rs.getString("nome"),
                            rs.getBigDecimal("prezzo"),
                            1,
                            rs.getString("immagine")
                    ));
                }
            }

            // Funko preferiti
            String sqlFunko = "SELECT f.NumeroSerie, f.nome, f.prezzo, f.immagine FROM preferiti p JOIN funko f ON p.id_prodotto = f.NumeroSerie WHERE p.email_utente = ? AND p.tipo = 'funko'";
            try (PreparedStatement ps = conn.prepareStatement(sqlFunko)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    preferiti.add(new ItemCarrello(
                            rs.getString("NumeroSerie"),
                            "funko",
                            rs.getString("nome"),
                            rs.getBigDecimal("prezzo"),
                            1,
                            rs.getString("immagine")
                    ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return preferiti;
    }

    public boolean isPreferito(String email, String tipo, String idProdotto) {
        String sql = "SELECT 1 FROM preferiti WHERE email_utente = ? AND tipo = ? AND id_prodotto = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, tipo);
            ps.setString(3, idProdotto);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
