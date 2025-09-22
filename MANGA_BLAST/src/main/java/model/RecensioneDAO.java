package model;

import model.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class RecensioneDAO {
    
    // Aggiunge una nuova recensione
    public boolean addRecensione(Recensione recensione) {
        String query = "INSERT INTO recensioni (email_utente, id_prodotto, tipo_prodotto, rating, commento, data_recensione, attiva) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("RecensioneDAO.addRecensione - Inizio");
        System.out.println("RecensioneDAO.addRecensione - Query: " + query);
        System.out.println("RecensioneDAO.addRecensione - Recensione: " + recensione.getEmailUtente() + ", " + recensione.getIdProdotto() + ", " + recensione.getTipoProdotto());
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            System.out.println("RecensioneDAO.addRecensione - Connessione ottenuta");
            
            stmt.setString(1, recensione.getEmailUtente());
            stmt.setString(2, recensione.getIdProdotto());
            stmt.setString(3, recensione.getTipoProdotto());
            stmt.setInt(4, recensione.getVoto());
            stmt.setString(5, recensione.getCommento());
            stmt.setTimestamp(6, Timestamp.valueOf(recensione.getDataCreazione()));
            stmt.setBoolean(7, recensione.isAttiva());
            
            System.out.println("RecensioneDAO.addRecensione - Parametri impostati, eseguo query");
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("RecensioneDAO.addRecensione - Query eseguita, righe affette: " + rowsAffected);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("RecensioneDAO.addRecensione - Errore SQL: " + e.getMessage());
            System.err.println("RecensioneDAO.addRecensione - SQL State: " + e.getSQLState());
            System.err.println("RecensioneDAO.addRecensione - Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    // Ottiene tutte le recensioni per un prodotto specifico
    public List<Recensione> getRecensioniByProdotto(String idProdotto, String tipoProdotto) {
        List<Recensione> recensioni = new ArrayList<>();
        String query = "SELECT * FROM recensioni WHERE id_prodotto = ? AND tipo_prodotto = ? AND attiva = true ORDER BY data_recensione DESC";
        
        System.out.println("RecensioneDAO.getRecensioniByProdotto - idProdotto: " + idProdotto + ", tipoProdotto: " + tipoProdotto);
        System.out.println("RecensioneDAO.getRecensioniByProdotto - Query: " + query);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            System.out.println("RecensioneDAO.getRecensioniByProdotto - Connessione ottenuta");
            
            stmt.setString(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                recensioni.add(mapResultSetToRecensione(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return recensioni;
    }
    
    // Ottiene tutte le recensioni di un utente
    public List<Recensione> getRecensioniByUtente(String emailUtente) {
        List<Recensione> recensioni = new ArrayList<>();
        String query = "SELECT * FROM recensioni WHERE email_utente = ? AND attiva = true ORDER BY data_recensione DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, emailUtente);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                recensioni.add(mapResultSetToRecensione(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return recensioni;
    }
    
    // Verifica se un utente ha già recensito un prodotto
    public boolean hasUserReviewed(String emailUtente, String idProdotto, String tipoProdotto) {
        String query = "SELECT COUNT(*) FROM recensioni WHERE email_utente = ? AND id_prodotto = ? AND tipo_prodotto = ? AND attiva = true";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, emailUtente);
            stmt.setString(2, idProdotto);
            stmt.setString(3, tipoProdotto);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Ottiene la recensione di un utente per un prodotto specifico
    public Recensione getRecensioneByUserAndProdotto(String emailUtente, String idProdotto, String tipoProdotto) {
        String query = "SELECT * FROM recensioni WHERE email_utente = ? AND id_prodotto = ? AND tipo_prodotto = ? AND attiva = true";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, emailUtente);
            stmt.setString(2, idProdotto);
            stmt.setString(3, tipoProdotto);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRecensione(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Calcola la media dei voti per un prodotto
    public double getMediaVoti(String idProdotto, String tipoProdotto) {
        String query = "SELECT AVG(rating) FROM recensioni WHERE id_prodotto = ? AND tipo_prodotto = ? AND attiva = true";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                double media = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : media;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    // Conta il numero di recensioni per un prodotto
    public int getNumeroRecensioni(String idProdotto, String tipoProdotto) {
        String query = "SELECT COUNT(*) FROM recensioni WHERE id_prodotto = ? AND tipo_prodotto = ? AND attiva = true";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Aggiorna una recensione esistente
    public boolean updateRecensione(Recensione recensione) {
        String query = "UPDATE recensioni SET rating = ?, commento = ? WHERE id = ? AND email_utente = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, recensione.getVoto());
            stmt.setString(2, recensione.getCommento());
            stmt.setInt(3, recensione.getId());
            stmt.setString(4, recensione.getEmailUtente());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Elimina una recensione (soft delete)
    public boolean deleteRecensione(int idRecensione, String emailUtente) {
        String query = "UPDATE recensioni SET attiva = false WHERE id = ? AND email_utente = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, idRecensione);
            stmt.setString(2, emailUtente);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Metodo helper per mappare ResultSet a Recensione
    private Recensione mapResultSetToRecensione(ResultSet rs) throws SQLException {
        Recensione recensione = new Recensione();
        recensione.setId(rs.getInt("id"));
        recensione.setEmailUtente(rs.getString("email_utente"));
        recensione.setIdProdotto(rs.getString("id_prodotto"));
        recensione.setTipoProdotto(rs.getString("tipo_prodotto"));
        recensione.setVoto(rs.getInt("rating"));
        recensione.setCommento(rs.getString("commento"));
        
        Timestamp timestamp = rs.getTimestamp("data_recensione");
        if (timestamp != null) {
            recensione.setDataCreazione(timestamp.toLocalDateTime());
        }
        
        recensione.setAttiva(rs.getBoolean("attiva"));
        return recensione;
    }
    
    // Ottiene tutte le recensioni (per admin)
    public List<Recensione> getAllRecensioni() {
        List<Recensione> recensioni = new ArrayList<>();
        String query = "SELECT * FROM recensioni ORDER BY data_recensione DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                recensioni.add(mapResultSetToRecensione(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return recensioni;
    }
    
    // Modera una recensione (approva/rifiuta)
    public boolean moderateRecensione(int idRecensione, boolean approva) {
        String query = "UPDATE recensioni SET attiva = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setBoolean(1, approva);
            stmt.setInt(2, idRecensione);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Elimina una recensione (per admin)
    public boolean deleteRecensioneAdmin(int idRecensione) {
        String query = "DELETE FROM recensioni WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, idRecensione);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Ottiene statistiche recensioni per un prodotto
    public Map<String, Object> getStatisticheProdotto(String idProdotto, String tipoProdotto) {
        Map<String, Object> stats = new HashMap<>();
        String query = "SELECT " +
                      "AVG(rating) as media_voti, " +
                      "COUNT(*) as numero_recensioni, " +
                      "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as cinque_stelle, " +
                      "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as quattro_stelle, " +
                      "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as tre_stelle, " +
                      "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as due_stelle, " +
                      "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as una_stella " +
                      "FROM recensioni WHERE id_prodotto = ? AND tipo_prodotto = ? AND attiva = true";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("mediaVoti", rs.getDouble("media_voti"));
                stats.put("numeroRecensioni", rs.getInt("numero_recensioni"));
                stats.put("cinqueStelle", rs.getInt("cinque_stelle"));
                stats.put("quattroStelle", rs.getInt("quattro_stelle"));
                stats.put("treStelle", rs.getInt("tre_stelle"));
                stats.put("dueStelle", rs.getInt("due_stelle"));
                stats.put("unaStella", rs.getInt("una_stella"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return stats;
    }
}