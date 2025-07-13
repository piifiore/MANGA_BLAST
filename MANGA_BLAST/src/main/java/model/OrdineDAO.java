package model;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {

    public void salvaOrdine(Ordine ordine) {
        Connection conn = null;
        PreparedStatement ordineStmt = null;
        PreparedStatement mangaStmt = null;
        PreparedStatement funkoStmt = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlOrdine = "INSERT INTO ordini (email, totale, data, stato) VALUES (?, ?, ?, ?)";
            ordineStmt = conn.prepareStatement(sqlOrdine, Statement.RETURN_GENERATED_KEYS);
            ordineStmt.setString(1, ordine.getEmailUtente());
            ordineStmt.setBigDecimal(2, ordine.getTotale());
            ordineStmt.setTimestamp(3, Timestamp.valueOf(ordine.getDataOra()));
            ordineStmt.setString(4, ordine.getStato());
            ordineStmt.executeUpdate();

            ResultSet rs = ordineStmt.getGeneratedKeys();
            int idOrdine = -1;
            if (rs.next()) {
                idOrdine = rs.getInt(1);
            }

            String sqlManga = "INSERT INTO ordine_include_manga (id_ordine, ISBN) VALUES (?, ?)";
            String sqlFunko = "INSERT INTO ordine_include_funko (id_ordine, NumeroSerie) VALUES (?, ?)";
            mangaStmt = conn.prepareStatement(sqlManga);
            funkoStmt = conn.prepareStatement(sqlFunko);

            for (ItemCarrello item : ordine.getProdotti()) {
                String tipo = item.getTipo();
                String idProdotto = item.getIdProdotto();

                if ("manga".equalsIgnoreCase(tipo)) {
                    mangaStmt.setInt(1, idOrdine);
                    mangaStmt.setLong(2, Long.parseLong(idProdotto));
                    mangaStmt.addBatch();
                } else if ("funko".equalsIgnoreCase(tipo)) {
                    funkoStmt.setInt(1, idOrdine);
                    funkoStmt.setString(2, idProdotto);
                    funkoStmt.addBatch();
                }
            }

            mangaStmt.executeBatch();
            funkoStmt.executeBatch();
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ignore) {}
        } finally {
            try {
                if (ordineStmt != null) ordineStmt.close();
                if (mangaStmt != null) mangaStmt.close();
                if (funkoStmt != null) funkoStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignore) {}
        }
    }

    public List<Ordine> getOrdiniByEmail(String email) {
        List<Ordine> ordini = new ArrayList<>();

        String sqlOrdini = "SELECT * FROM ordini WHERE email = ? ORDER BY data DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOrdini)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Ordine o = new Ordine();
                o.setId(rs.getInt("id_ordine"));
                o.setEmailUtente(rs.getString("email"));
                o.setTotale(rs.getBigDecimal("totale"));
                o.setDataOra(rs.getTimestamp("data").toLocalDateTime());
                o.setStato(rs.getString("stato"));

                o.setProdotti(getProdottiOrdine(conn, o.getId()));
                ordini.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordini;
    }

    private List<ItemCarrello> getProdottiOrdine(Connection conn, int idOrdine) throws SQLException {
        List<ItemCarrello> prodotti = new ArrayList<>();

        // Manga
        String sqlManga = "SELECT m.ISBN, m.nome, m.prezzo FROM ordine_include_manga oim JOIN manga m ON oim.ISBN = m.ISBN WHERE oim.id_ordine = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlManga)) {
            ps.setInt(1, idOrdine);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                prodotti.add(new ItemCarrello(
                        String.valueOf(rs.getLong("ISBN")),
                        "manga",
                        rs.getString("nome"),
                        rs.getBigDecimal("prezzo"),
                        1
                ));
            }
        }

        // Funko
        String sqlFunko = "SELECT f.NumeroSerie, f.nome, f.prezzo FROM ordine_include_funko oif JOIN funko f ON oif.NumeroSerie = f.NumeroSerie WHERE oif.id_ordine = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlFunko)) {
            ps.setInt(1, idOrdine);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                prodotti.add(new ItemCarrello(
                        rs.getString("NumeroSerie"),
                        "funko",
                        rs.getString("nome"),
                        rs.getBigDecimal("prezzo"),
                        1
                ));
            }
        }

        return prodotti;
    }

    public void updateOrderStatus(int idOrdine, String nuovoStato) {
        String sql = "UPDATE ordini SET stato = ? WHERE id_ordine = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nuovoStato);
            ps.setInt(2, idOrdine);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Ordine> getFilteredOrders(String email, String stato, String sort) {
        List<Ordine> ordini = new ArrayList<>();

        StringBuilder query = new StringBuilder("SELECT * FROM ordini WHERE 1=1");
        List<Object> parametri = new ArrayList<>();

        if (email != null && !email.trim().isEmpty()) {
            query.append(" AND email LIKE ?");
            parametri.add("%" + email.trim() + "%");
        }

        if (stato != null && !stato.trim().isEmpty()) {
            query.append(" AND stato = ?");
            parametri.add(stato.trim());
        }

        if (sort != null && sort.equals("data")) {
            query.append(" ORDER BY data DESC");
        } else if (sort != null && sort.equals("totale")) {
            query.append(" ORDER BY totale DESC");
        } else {
            query.append(" ORDER BY id_ordine DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < parametri.size(); i++) {
                ps.setObject(i + 1, parametri.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ordine o = new Ordine();
                o.setId(rs.getInt("id_ordine"));
                o.setEmailUtente(rs.getString("email"));
                o.setTotale(rs.getBigDecimal("totale"));
                o.setDataOra(rs.getTimestamp("data").toLocalDateTime());
                o.setStato(rs.getString("stato"));

                o.setProdotti(getProdottiOrdine(conn, o.getId()));
                ordini.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordini;
    }
}