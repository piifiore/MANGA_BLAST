package model;

import java.sql.*;
import model.ConPool;

public class UserDAO {

    public boolean isUser(String email, String password) {
        String query = "SELECT * FROM utenti WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isAdmin(String email, String password) {
        String query = "SELECT * FROM admin WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean emailExists(String email) {
        String query = "SELECT * FROM utenti WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void registerUser(String email, String password) {
        String query = "INSERT INTO utenti (email, password) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(2, email);
            stmt.setString(1, password);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User getUserByEmail(String email) {
        User u = null;
        String query = "SELECT * FROM utenti WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                u = new User();
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setVia(rs.getString("via"));
                u.setNumeroCivico(rs.getString("numero_civico"));
                u.setCap(rs.getString("cap"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return u;
    }

    public void updatePassword(String email, String nuovaPassword) {
        String query = "UPDATE utenti SET password = ? WHERE email = ?";
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, nuovaPassword);
            stmt.setString(2, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateIndirizzo(String email, String via, String numeroCivico, String cap) {
        String query = "UPDATE utenti SET via = ?, numero_civico = ?, cap = ? WHERE email = ?";
        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, via);
            stmt.setString(2, numeroCivico);
            stmt.setString(3, cap);
            stmt.setString(4, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateProfilo(String email, String nuovaPassword, String via, String numeroCivico, String cap) {
        String sql;
        boolean cambiaPassword = nuovaPassword != null && !nuovaPassword.isEmpty();

        if (cambiaPassword) {
            sql = "UPDATE utenti SET password = ?, via = ?, numero_civico = ?, cap = ? WHERE email = ?";
        } else {
            sql = "UPDATE utenti SET via = ?, numero_civico = ?, cap = ? WHERE email = ?";
        }

        try (Connection conn = ConPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (cambiaPassword) {
                stmt.setString(1, nuovaPassword);
                stmt.setString(2, via);
                stmt.setString(3, numeroCivico);
                stmt.setString(4, cap);
                stmt.setString(5, email);
            } else {
                stmt.setString(1, via);
                stmt.setString(2, numeroCivico);
                stmt.setString(3, cap);
                stmt.setString(4, email);
            }

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // (Facoltativo) Ottieni tutti gli admin
    public ResultSet getAllAdmins() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            return stmt.executeQuery("SELECT * FROM admin");
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}