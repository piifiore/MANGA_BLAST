package model;

import java.sql.*;

public class UserDAO {

    // Verifica se esiste un utente normale con email e password
    public boolean isUser(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true se l'utente esiste
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Verifica se esiste un amministratore con email e password
    public boolean isAdmin(String email, String password) {
        String query = "SELECT * FROM admin WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true se l'admin esiste
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Controlla se una email è già registrata (per evitare duplicati)
    public boolean emailExists(String email) {
        String query = "SELECT * FROM utenti WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true se l'email è già registrata
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Registra un nuovo utente nel database
    public void registerUser(String email, String password) {
        String query = "INSERT INTO users (password, email) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
