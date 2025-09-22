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

    public List<Funko> searchByQuery(String query) {
        List<Funko> risultati = new ArrayList<>();
        String sql = "SELECT * FROM funko WHERE LOWER(nome) LIKE ? OR LOWER(descrizione) LIKE ? OR LOWER(numeroSerie) LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String like = "%" + query.toLowerCase() + "%";
            stmt.setString(1, like);
            stmt.setString(2, like);
            stmt.setString(3, like);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Funko f = new Funko();
                f.setNumeroSerie(rs.getString("numeroSerie"));
                f.setNome(rs.getString("nome"));
                f.setDescrizione(rs.getString("descrizione"));
                f.setPrezzo(rs.getBigDecimal("prezzo"));
                f.setImmagine(rs.getString("immagine"));
                risultati.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return risultati;
    }

    public void addFunko(Funko f) {
        String query = "INSERT INTO funko (numeroSerie, nome, descrizione, prezzo, immagine, id_categoria) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, f.getNumeroSerie());
            stmt.setString(2, f.getNome());
            stmt.setString(3, f.getDescrizione());
            stmt.setBigDecimal(4, f.getPrezzo());
            stmt.setString(5, f.getImmagine());
            stmt.setObject(6, f.getIdCategoria());

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
    
    public List<Funko> searchFunkoWithCategory(String query, Integer categoriaId) {
        List<Funko> risultati = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT f.*, c.nome as categoria_nome, c.colore as categoria_colore FROM funko f ");
        sql.append("LEFT JOIN categorie c ON f.id_categoria = c.id WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (LOWER(f.nome) LIKE ? OR LOWER(f.descrizione) LIKE ? OR LOWER(f.numeroSerie) LIKE ?)");
            String like = "%" + query.toLowerCase() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        
        if (categoriaId != null) {
            sql.append(" AND f.id_categoria = ?");
            params.add(categoriaId);
        }
        
        sql.append(" ORDER BY f.nome");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Funko f = new Funko();
                f.setNumeroSerie(rs.getString("numeroSerie"));
                f.setNome(rs.getString("nome"));
                f.setDescrizione(rs.getString("descrizione"));
                f.setPrezzo(rs.getBigDecimal("prezzo"));
                f.setImmagine(rs.getString("immagine"));
                risultati.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return risultati;
    }

    public Funko doRetrieveByNumeroSerie(String numeroSerie) {
        Funko funko = null;
        String query = "SELECT * FROM funko WHERE numeroSerie = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, numeroSerie);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                funko = new Funko();
                funko.setNumeroSerie(rs.getString("numeroSerie"));
                funko.setNome(rs.getString("nome"));
                funko.setDescrizione(rs.getString("descrizione"));
                funko.setPrezzo(rs.getBigDecimal("prezzo"));
                funko.setImmagine(rs.getString("immagine"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return funko;
    }

    public List<Funko> searchFunko(String query, String fasciaPrezzo) {
        List<Funko> risultati = new ArrayList<>();

        String sql = "SELECT * FROM funko WHERE 1=1";

        if (query != null && !query.isEmpty()) {
            sql += " AND (nome LIKE ? OR NumeroSerie LIKE ?)";
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
                Funko f = new Funko();
                f.setNumeroSerie(rs.getString("NumeroSerie"));
                f.setNome(rs.getString("nome"));
                f.setPrezzo(BigDecimal.valueOf(rs.getDouble("prezzo")));
                f.setImmagine(rs.getString("immagine"));
                risultati.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return risultati;
    }

}
