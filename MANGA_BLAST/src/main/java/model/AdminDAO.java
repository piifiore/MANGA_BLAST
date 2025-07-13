package model;

import java.sql.*;

public class AdminDAO {

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

    // (Facoltativo) Visualizza tutti gli admin registrati
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
