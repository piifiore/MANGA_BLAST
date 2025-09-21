package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarrelloDAO {

    public void aggiungiItem(String email, String tipo, String idProdotto, int quantita) {
        String sql;
        if ("manga".equals(tipo)) {
            sql = "INSERT INTO carrello_contiene_manga (email, ISBN, quantita) VALUES (?, ?, ?) " +
                  "ON DUPLICATE KEY UPDATE quantita = quantita + ?";
        } else if ("funko".equals(tipo)) {
            sql = "INSERT INTO carrello_contiene_funko (email, NumeroSerie, quantita) VALUES (?, ?, ?) " +
                  "ON DUPLICATE KEY UPDATE quantita = quantita + ?";
        } else {
            return; // Tipo non valido
        }
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, idProdotto);
            ps.setInt(3, quantita);
            ps.setInt(4, quantita);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void aggiornaQuantita(String email, String tipo, String idProdotto, int quantita) {
        String sql;
        if ("manga".equals(tipo)) {
            sql = "UPDATE carrello_contiene_manga SET quantita = ? WHERE email = ? AND ISBN = ?";
        } else if ("funko".equals(tipo)) {
            sql = "UPDATE carrello_contiene_funko SET quantita = ? WHERE email = ? AND NumeroSerie = ?";
        } else {
            return; // Tipo non valido
        }
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantita);
            ps.setString(2, email);
            ps.setString(3, idProdotto);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void rimuoviItem(String email, String tipo, String idProdotto) {
        String sql;
        if ("manga".equals(tipo)) {
            sql = "DELETE FROM carrello_contiene_manga WHERE email = ? AND ISBN = ?";
        } else if ("funko".equals(tipo)) {
            sql = "DELETE FROM carrello_contiene_funko WHERE email = ? AND NumeroSerie = ?";
        } else {
            return; // Tipo non valido
        }
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, idProdotto);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ItemCarrello> getCarrelloUtente(String email) {
        List<ItemCarrello> lista = new ArrayList<>();
        
        // Query per manga
        String sqlManga = """
            SELECT 'manga' as tipo, c.ISBN as id_prodotto, c.quantita, m.nome as titolo, m.prezzo
            FROM carrello_contiene_manga c
            JOIN manga m ON c.ISBN = m.ISBN
            WHERE c.email = ?
        """;
        
        // Query per funko
        String sqlFunko = """
            SELECT 'funko' as tipo, c.NumeroSerie as id_prodotto, c.quantita, f.nome as titolo, f.prezzo
            FROM carrello_contiene_funko c
            JOIN funko f ON c.NumeroSerie = f.NumeroSerie
            WHERE c.email = ?
        """;
        
        try (Connection con = ConPool.getConnection()) {
            // Carica manga
            try (PreparedStatement ps = con.prepareStatement(sqlManga)) {
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
            }
            
            // Carica funko
            try (PreparedStatement ps = con.prepareStatement(sqlFunko)) {
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public void creaCarrelloUtente(String email) {
        String sql = "INSERT IGNORE INTO carrelli (email) VALUES (?)";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}