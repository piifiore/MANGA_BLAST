package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarrelloDAO {

    public void aggiungiItem(String email, String tipo, String idProdotto, int quantita) {
        String sql = "INSERT INTO carrelli (email, tipo, id_prodotto, quantita) VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE quantita = quantita + ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, tipo);
            ps.setString(3, idProdotto);
            ps.setInt(4, quantita);
            ps.setInt(5, quantita);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void aggiornaQuantita(String email, String tipo, String idProdotto, int quantita) {
        String sql = "UPDATE carrelli SET quantita = ? WHERE email = ? AND tipo = ? AND id_prodotto = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantita);
            ps.setString(2, email);
            ps.setString(3, tipo);
            ps.setString(4, idProdotto);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void rimuoviItem(String email, String tipo, String idProdotto) {
        String sql = "DELETE FROM carrelli WHERE email = ? AND tipo = ? AND id_prodotto = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, tipo);
            ps.setString(3, idProdotto);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ItemCarrello> getCarrelloUtente(String email) {
        List<ItemCarrello> lista = new ArrayList<>();
        String sql = """
            SELECT c.tipo, c.id_prodotto, c.quantita,
                   CASE WHEN c.tipo = 'manga' THEN m.titolo ELSE f.nome END AS titolo,
                   CASE WHEN c.tipo = 'manga' THEN m.prezzo ELSE f.prezzo END AS prezzo
            FROM carrelli c
            LEFT JOIN manga m ON c.id_prodotto = m.ISBN AND c.tipo = 'manga'
            LEFT JOIN funko f ON c.id_prodotto = f.numeroSerie AND c.tipo = 'funko'
            WHERE c.email = ?
        """;
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ItemCarrello item = new ItemCarrello(
                            rs.getString("id_prodotto"),
                            rs.getString("tipo"),
                            rs.getString("titolo"),
                            rs.getBigDecimal("prezzo"),
                            rs.getInt("quantita")
                    );
                    lista.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}