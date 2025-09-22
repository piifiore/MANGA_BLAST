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

    public List<Manga> searchByQuery(String query) {
        List<Manga> risultati = new ArrayList<>();
        String sql = "SELECT * FROM manga WHERE LOWER(nome) LIKE ? OR LOWER(descrizione) LIKE ? OR CAST(ISBN AS CHAR) LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String like = "%" + query.toLowerCase() + "%";
            stmt.setString(1, like);
            stmt.setString(2, like);
            stmt.setString(3, like);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Manga m = new Manga();
                m.setISBN(rs.getLong("ISBN"));
                m.setNome(rs.getString("nome"));
                m.setDescrizione(rs.getString("descrizione"));
                m.setPrezzo(rs.getBigDecimal("prezzo"));
                m.setImmagine(rs.getString("immagine"));
                risultati.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return risultati;
    }

    public void addManga(Manga manga) {
        String query = "INSERT INTO manga (ISBN, nome, descrizione, prezzo, immagine, id_categoria, id_sottocategoria) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setLong(1, manga.getISBN());
            stmt.setString(2, manga.getNome());
            stmt.setString(3, manga.getDescrizione());
            stmt.setBigDecimal(4, manga.getPrezzo());
            stmt.setString(5, manga.getImmagine());
            stmt.setObject(6, manga.getIdCategoria());
            stmt.setObject(7, manga.getIdSottocategoria());

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
    
    public List<Manga> searchMangaWithCategory(String query, Integer categoriaId) {
        List<Manga> risultati = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT m.*, c.nome as categoria_nome, c.colore as categoria_colore FROM manga m ");
        sql.append("LEFT JOIN categorie c ON m.id_categoria = c.id WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (LOWER(m.nome) LIKE ? OR LOWER(m.descrizione) LIKE ? OR CAST(m.ISBN AS CHAR) LIKE ?)");
            String like = "%" + query.toLowerCase() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        
        if (categoriaId != null) {
            sql.append(" AND m.id_categoria = ?");
            params.add(categoriaId);
        }
        
        sql.append(" ORDER BY m.nome");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Manga m = new Manga();
                m.setISBN(rs.getLong("ISBN"));
                m.setNome(rs.getString("nome"));
                m.setDescrizione(rs.getString("descrizione"));
                m.setPrezzo(rs.getBigDecimal("prezzo"));
                m.setImmagine(rs.getString("immagine"));
                risultati.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return risultati;
    }

    public Manga doRetrieveByISBN(long isbn) {
        Manga manga = null;
        String query = "SELECT * FROM manga WHERE ISBN = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setLong(1, isbn);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                manga = new Manga();
                manga.setISBN(rs.getLong("ISBN"));
                manga.setNome(rs.getString("nome"));
                manga.setDescrizione(rs.getString("descrizione"));
                manga.setPrezzo(rs.getBigDecimal("prezzo"));
                manga.setImmagine(rs.getString("immagine"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return manga;
    }

    public List<Manga> searchManga(String query, String fasciaPrezzo) {
        List<Manga> risultati = new ArrayList<>();

        String sql = "SELECT * FROM manga WHERE 1=1";

        if (query != null && !query.isEmpty()) {
            sql += " AND (nome LIKE ? OR CAST(ISBN AS CHAR) LIKE ?)";
        }

        if (fasciaPrezzo != null) {
            switch (fasciaPrezzo) {
                case "low":
                    sql += " AND prezzo <= 10";
                    break;
                case "medium":
                    sql += " AND prezzo > 10 AND prezzo <= 25";
                    break;
                case "high":
                    sql += " AND prezzo > 25";
                    break;
            }
        }

        try (Connection conn = ConPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (query != null && !query.isEmpty()) {
                String keyword = "%" + query + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Manga m = new Manga();
                m.setISBN(rs.getLong("ISBN"));
                m.setNome(rs.getString("nome"));
                m.setPrezzo(BigDecimal.valueOf(rs.getDouble("prezzo")));
                m.setImmagine(rs.getString("immagine"));
                risultati.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return risultati;
    }


}
