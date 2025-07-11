package model;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class FunkoDAO {

    public List<Funko> getAllFunko() {
        List<Funko> list = new ArrayList<>();
        String query = "SELECT * FROM funko";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Funko f = new Funko();
                f.setNumeroSerie(rs.getString("numeroSerie"));
                f.setNome(rs.getString("nome"));
                f.setDescrizione(rs.getString("descrizione"));
                f.setPrezzo(rs.getBigDecimal("prezzo"));
                f.setImmagine(rs.getString("immagine"));
                list.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addFunko(Funko f) {
        String query = "INSERT INTO funko (numeroSerie, nome, descrizione, prezzo, immagine) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, f.getNumeroSerie());
            stmt.setString(2, f.getNome());
            stmt.setString(3, f.getDescrizione());
            stmt.setBigDecimal(4, f.getPrezzo());
            stmt.setString(5, f.getImmagine());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateFunko(Funko f) {
        String query = "UPDATE funko SET nome = ?, descrizione = ?, prezzo = ?, immagine = ? WHERE numeroSerie = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, f.getNome());
            stmt.setString(2, f.getDescrizione());
            stmt.setBigDecimal(3, f.getPrezzo());
            stmt.setString(4, f.getImmagine());
            stmt.setString(5, f.getNumeroSerie());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteFunko(String numeroSerie) {
        String query = "DELETE FROM funko WHERE numeroSerie = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, numeroSerie);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}