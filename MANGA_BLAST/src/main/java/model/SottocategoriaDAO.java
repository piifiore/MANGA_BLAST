package model;

import java.sql.*;
import java.util.*;

public class SottocategoriaDAO {
    
    public List<Sottocategoria> getAllSottocategorie() {
        List<Sottocategoria> sottocategorie = new ArrayList<>();
        String query = "SELECT * FROM sottocategorie WHERE attiva = TRUE ORDER BY id_categoria, nome";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Sottocategoria sottocategoria = new Sottocategoria(
                    rs.getInt("id"),
                    rs.getInt("id_categoria"),
                    rs.getString("nome"),
                    rs.getString("descrizione"),
                    rs.getBoolean("attiva"),
                    rs.getString("data_creazione")
                );
                sottocategorie.add(sottocategoria);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return sottocategorie;
    }
    
    public List<Sottocategoria> getSottocategorieByCategoria(int categoriaId) {
        List<Sottocategoria> sottocategorie = new ArrayList<>();
        String query = "SELECT * FROM sottocategorie WHERE id_categoria = ? AND attiva = TRUE ORDER BY nome";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, categoriaId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Sottocategoria sottocategoria = new Sottocategoria(
                        rs.getInt("id"),
                        rs.getInt("id_categoria"),
                        rs.getString("nome"),
                        rs.getString("descrizione"),
                        rs.getBoolean("attiva"),
                        rs.getString("data_creazione")
                    );
                    sottocategorie.add(sottocategoria);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return sottocategorie;
    }
    
    public Sottocategoria getSottocategoriaById(int id) {
        String query = "SELECT * FROM sottocategorie WHERE id = ? AND attiva = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Sottocategoria(
                        rs.getInt("id"),
                        rs.getInt("id_categoria"),
                        rs.getString("nome"),
                        rs.getString("descrizione"),
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
    
    public boolean addSottocategoria(Sottocategoria sottocategoria) {
        String query = "INSERT INTO sottocategorie (id_categoria, nome, descrizione, attiva, data_creazione) VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, sottocategoria.getIdCategoria());
            ps.setString(2, sottocategoria.getNome());
            ps.setString(3, sottocategoria.getDescrizione());
            ps.setBoolean(4, sottocategoria.isAttiva());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateSottocategoria(Sottocategoria sottocategoria) {
        String query = "UPDATE sottocategorie SET id_categoria = ?, nome = ?, descrizione = ?, attiva = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, sottocategoria.getIdCategoria());
            ps.setString(2, sottocategoria.getNome());
            ps.setString(3, sottocategoria.getDescrizione());
            ps.setBoolean(4, sottocategoria.isAttiva());
            ps.setInt(5, sottocategoria.getId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteSottocategoria(int id) {
        String query = "UPDATE sottocategorie SET attiva = FALSE WHERE id = ?";
        
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
