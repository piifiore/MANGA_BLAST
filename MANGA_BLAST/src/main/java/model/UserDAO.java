package model;

import java.sql.*;

/**
 *        NON LA DOVETE TOCCARE
 * Questa classe si occupa di creare user secondo lo standar DAO che ci permetono di
 * gestire il DB in modo camodo separandolo dalla logica delle servlet con quella di buisness
 *
 */


public class UserDAO {
    public boolean emailExists(String email) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM utenti WHERE email = ?")) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Se esiste un risultato, l'email è già registrata
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //Metodo che registra l'utente nel DB
    public void registerUser(String email, String password) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO utenti (email, password) VALUES (?, ?)")) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


