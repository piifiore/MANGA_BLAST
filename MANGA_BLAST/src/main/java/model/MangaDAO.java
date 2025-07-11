package model;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class MangaDAO {

    public List<Manga> getAllManga() {
        List<Manga> list = new ArrayList<>();
        String query = "SELECT * FROM manga";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Manga m = new Manga();
                m.setISBN(rs.getLong("ISBN"));
                m.setNome(rs.getString("nome"));
                m.setDescrizione(rs.getString("descrizione"));
                m.setPrezzo(rs.getBigDecimal("prezzo"));
                m.setImmagine(rs.getString("immagine"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addManga(Manga manga) {
        String query = "INSERT INTO manga (ISBN, nome, descrizione, prezzo, immagine) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setLong(1, manga.getISBN());
            stmt.setString(2, manga.getNome());
            stmt.setString(3, manga.getDescrizione());
            stmt.setBigDecimal(4, manga.getPrezzo());
            stmt.setString(5, manga.getImmagine());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateManga(Manga manga) {
        String query = "UPDATE manga SET nome = ?, descrizione = ?, prezzo = ?, immagine = ? WHERE ISBN = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, manga.getNome());
            stmt.setString(2, manga.getDescrizione());
            stmt.setBigDecimal(3, manga.getPrezzo());
            stmt.setString(4, manga.getImmagine());
            stmt.setLong(5, manga.getISBN());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteManga(long isbn) {
        String query = "DELETE FROM manga WHERE ISBN = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setLong(1, isbn);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}