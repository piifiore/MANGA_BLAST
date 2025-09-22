package model;

import java.sql.*;
import java.util.*;

public class CategoriaDAO {
    
    public List<Categoria> getAllCategorie() {
        List<Categoria> categorie = new ArrayList<>();
        String query = "SELECT * FROM categorie WHERE attiva = TRUE ORDER BY nome";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Categoria categoria = new Categoria(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getString("descrizione"),
                    rs.getString("immagine"),
                    rs.getString("colore"),
                    rs.getBoolean("attiva"),
                    rs.getString("data_creazione")
                );
                categorie.add(categoria);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categorie;
    }
    
    public List<Categoria> getCategorieByTipo(String tipo) {
        List<Categoria> categorie = new ArrayList<>();
        String query = "";
        
        if ("manga".equalsIgnoreCase(tipo)) {
            query = "SELECT DISTINCT c.* FROM categorie c " +
                   "INNER JOIN manga m ON c.id = m.id_categoria " +
                   "WHERE c.attiva = TRUE ORDER BY c.nome";
        } else if ("funko".equalsIgnoreCase(tipo)) {
            query = "SELECT DISTINCT c.* FROM categorie c " +
                   "INNER JOIN funko f ON c.id = f.id_categoria " +
                   "WHERE c.attiva = TRUE ORDER BY c.nome";
        } else {
            return getAllCategorie();
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Categoria categoria = new Categoria(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getString("descrizione"),
                    rs.getString("immagine"),
                    rs.getString("colore"),
                    rs.getBoolean("attiva"),
                    rs.getString("data_creazione")
                );
                categorie.add(categoria);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categorie;
    }
    
    public Categoria getCategoriaById(int id) {
        String query = "SELECT * FROM categorie WHERE id = ? AND attiva = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Categoria(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getString("descrizione"),
                        rs.getString("immagine"),
                        rs.getString("colore"),
                        rs.getBoolean("attiva"),
                        rs.getString("data_creazione")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addCategoria(Categoria categoria) {
        String query = "INSERT INTO categorie (nome, descrizione, immagine, colore, attiva, data_creazione) VALUES (?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, categoria.getNome());
            ps.setString(2, categoria.getDescrizione());
            ps.setString(3, categoria.getImmagine());
            ps.setString(4, categoria.getColore());
            ps.setBoolean(5, categoria.isAttiva());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateCategoria(Categoria categoria) {
        String query = "UPDATE categorie SET nome = ?, descrizione = ?, colore = ?, attiva = ? WHERE id = ?";
        
        // Logging rimosso per semplificare
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, categoria.getNome());
            ps.setString(2, categoria.getDescrizione());
            ps.setString(3, categoria.getColore());
            ps.setBoolean(4, categoria.isAttiva());
            ps.setInt(5, categoria.getId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteCategoria(int id) {
        String query = "UPDATE categorie SET attiva = FALSE WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
