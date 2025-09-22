package model;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class RecensioneDAO {
    
    public static class StatisticheRecensioni {
        private int totaleRecensioni;
        private double ratingMedio;
        private int ratingMinimo;
        private int ratingMassimo;
        private int recensioni5Stelle;
        private int recensioni4Stelle;
        private int recensioni3Stelle;
        private int recensioni2Stelle;
        private int recensioni1Stella;
        
        // Costruttore
        public StatisticheRecensioni() {}
        
        // Getter e Setter
        public int getTotaleRecensioni() { return totaleRecensioni; }
        public void setTotaleRecensioni(int totaleRecensioni) { this.totaleRecensioni = totaleRecensioni; }
        
        public double getRatingMedio() { return ratingMedio; }
        public void setRatingMedio(double ratingMedio) { this.ratingMedio = ratingMedio; }
        
        public int getRatingMinimo() { return ratingMinimo; }
        public void setRatingMinimo(int ratingMinimo) { this.ratingMinimo = ratingMinimo; }
        
        public int getRatingMassimo() { return ratingMassimo; }
        public void setRatingMassimo(int ratingMassimo) { this.ratingMassimo = ratingMassimo; }
        
        public int getRecensioni5Stelle() { return recensioni5Stelle; }
        public void setRecensioni5Stelle(int recensioni5Stelle) { this.recensioni5Stelle = recensioni5Stelle; }
        
        public int getRecensioni4Stelle() { return recensioni4Stelle; }
        public void setRecensioni4Stelle(int recensioni4Stelle) { this.recensioni4Stelle = recensioni4Stelle; }
        
        public int getRecensioni3Stelle() { return recensioni3Stelle; }
        public void setRecensioni3Stelle(int recensioni3Stelle) { this.recensioni3Stelle = recensioni3Stelle; }
        
        public int getRecensioni2Stelle() { return recensioni2Stelle; }
        public void setRecensioni2Stelle(int recensioni2Stelle) { this.recensioni2Stelle = recensioni2Stelle; }
        
        public int getRecensioni1Stella() { return recensioni1Stella; }
        public void setRecensioni1Stella(int recensioni1Stella) { this.recensioni1Stella = recensioni1Stella; }
    }
    
    public boolean addRecensione(Recensione recensione) {
        String sql = "INSERT INTO recensioni (id_prodotto, tipo_prodotto, email_utente, rating, titolo, commento, data_recensione) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, recensione.getIdProdotto());
            stmt.setString(2, recensione.getTipoProdotto());
            stmt.setString(3, recensione.getEmailUtente());
            stmt.setInt(4, recensione.getRating());
            stmt.setString(5, recensione.getTitolo());
            stmt.setString(6, recensione.getCommento());
            stmt.setTimestamp(7, Timestamp.valueOf(recensione.getDataRecensione()));
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Errore nell'aggiunta della recensione: " + e.getMessage());
            return false;
        }
    }
    
    public List<Recensione> getRecensioniByProdotto(int idProdotto, String tipoProdotto) {
        List<Recensione> recensioni = new ArrayList<>();
        String sql = "SELECT r.*, " +
                    "COALESCE(SUM(CASE WHEN rl.tipo = 'like' THEN 1 ELSE 0 END), 0) as like_count, " +
                    "COALESCE(SUM(CASE WHEN rl.tipo = 'dislike' THEN 1 ELSE 0 END), 0) as dislike_count " +
                    "FROM recensioni r " +
                    "LEFT JOIN recensioni_like rl ON r.id = rl.id_recensione " +
                    "WHERE r.id_prodotto = ? AND r.tipo_prodotto = ? AND r.attiva = TRUE " +
                    "GROUP BY r.id " +
                    "ORDER BY r.data_recensione DESC";
        
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Recensione recensione = new Recensione();
                    recensione.setId(rs.getInt("id"));
                    recensione.setIdProdotto(rs.getInt("id_prodotto"));
                    recensione.setTipoProdotto(rs.getString("tipo_prodotto"));
                    recensione.setEmailUtente(rs.getString("email_utente"));
                    recensione.setRating(rs.getInt("rating"));
                    recensione.setTitolo(rs.getString("titolo"));
                    recensione.setCommento(rs.getString("commento"));
                    recensione.setDataRecensione(rs.getTimestamp("data_recensione").toLocalDateTime());
                    recensione.setModerata(rs.getBoolean("moderata"));
                    recensione.setAttiva(rs.getBoolean("attiva"));
                    recensione.setLikeCount(rs.getInt("like_count"));
                    recensione.setDislikeCount(rs.getInt("dislike_count"));
                    
                    recensioni.add(recensione);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel recupero delle recensioni: " + e.getMessage());
        }
        
        return recensioni;
    }
    
    public StatisticheRecensioni getStatisticheRecensioni(int idProdotto, String tipoProdotto) {
        StatisticheRecensioni stats = new StatisticheRecensioni();
        String sql = "SELECT " +
                    "COUNT(*) as totale_recensioni, " +
                    "AVG(rating) as rating_medio, " +
                    "MIN(rating) as rating_minimo, " +
                    "MAX(rating) as rating_massimo, " +
                    "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as recensioni_5_stelle, " +
                    "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as recensioni_4_stelle, " +
                    "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as recensioni_3_stelle, " +
                    "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as recensioni_2_stelle, " +
                    "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as recensioni_1_stella " +
                    "FROM recensioni " +
                    "WHERE id_prodotto = ? AND tipo_prodotto = ? AND attiva = TRUE";
        
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.setTotaleRecensioni(rs.getInt("totale_recensioni"));
                    stats.setRatingMedio(rs.getDouble("rating_medio"));
                    stats.setRatingMinimo(rs.getInt("rating_minimo"));
                    stats.setRatingMassimo(rs.getInt("rating_massimo"));
                    stats.setRecensioni5Stelle(rs.getInt("recensioni_5_stelle"));
                    stats.setRecensioni4Stelle(rs.getInt("recensioni_4_stelle"));
                    stats.setRecensioni3Stelle(rs.getInt("recensioni_3_stelle"));
                    stats.setRecensioni2Stelle(rs.getInt("recensioni_2_stelle"));
                    stats.setRecensioni1Stella(rs.getInt("recensioni_1_stella"));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel recupero delle statistiche: " + e.getMessage());
        }
        
        return stats;
    }
    
    public boolean updateRecensione(int idRecensione, String emailUtente, int rating, String titolo, String commento) {
        String sql = "UPDATE recensioni SET rating = ?, titolo = ?, commento = ? " +
                    "WHERE id = ? AND email_utente = ? AND attiva = TRUE";
        
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, rating);
            stmt.setString(2, titolo);
            stmt.setString(3, commento);
            stmt.setInt(4, idRecensione);
            stmt.setString(5, emailUtente);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Errore nell'aggiornamento della recensione: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteRecensione(int idRecensione, String emailUtente) {
        String sql = "UPDATE recensioni SET attiva = FALSE WHERE id = ? AND email_utente = ?";
        
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idRecensione);
            stmt.setString(2, emailUtente);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Errore nell'eliminazione della recensione: " + e.getMessage());
            return false;
        }
    }
    
    public boolean toggleLike(int idRecensione, String emailUtente, String tipo) {
        String deleteSql = "DELETE FROM recensioni_like WHERE id_recensione = ? AND email_utente = ?";
        String insertSql = "INSERT INTO recensioni_like (id_recensione, email_utente, tipo) VALUES (?, ?, ?)";
        
        try (Connection conn = ConPool.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                 PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                
                // Rimuovi like/dislike esistente
                deleteStmt.setInt(1, idRecensione);
                deleteStmt.setString(2, emailUtente);
                deleteStmt.executeUpdate();
                
                // Aggiungi nuovo like/dislike
                insertStmt.setInt(1, idRecensione);
                insertStmt.setString(2, emailUtente);
                insertStmt.setString(3, tipo);
                insertStmt.executeUpdate();
                
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel toggle del like: " + e.getMessage());
            return false;
        }
    }
    
    public boolean hasUserReviewed(int idProdotto, String tipoProdotto, String emailUtente) {
        String sql = "SELECT COUNT(*) FROM recensioni " +
                    "WHERE id_prodotto = ? AND tipo_prodotto = ? AND email_utente = ? AND attiva = TRUE";
        
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idProdotto);
            stmt.setString(2, tipoProdotto);
            stmt.setString(3, emailUtente);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel controllo recensione utente: " + e.getMessage());
            return false;
        }
    }
}
