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
        PreparedStatement dettagliStmt = null;

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
                System.out.println("✅ Ordine inserito con ID: " + idOrdine);
            } else {
                System.err.println("❌ Nessun ID generato per l'ordine");
            }

            String sqlManga = "INSERT INTO ordine_include_manga (id_ordine, ISBN, quantita) VALUES (?, ?, ?)";
            String sqlFunko = "INSERT INTO ordine_include_funko (id_ordine, NumeroSerie, quantita) VALUES (?, ?, ?)";
            mangaStmt = conn.prepareStatement(sqlManga);
            funkoStmt = conn.prepareStatement(sqlFunko);
            String sqlDettagli = "INSERT INTO ordine_dettagli (id_ordine, tipo, id_prodotto, nome, prezzo, quantita) VALUES (?, ?, ?, ?, ?, ?)";
            dettagliStmt = conn.prepareStatement(sqlDettagli);

            for (ItemCarrello item : ordine.getProdotti()) {
                String tipo = item.getTipo();
                String idProdotto = item.getIdProdotto();
                int quantita = item.getQuantita();
                String nome = item.getTitolo();
                java.math.BigDecimal prezzo = item.getPrezzo();

                dettagliStmt.setInt(1, idOrdine);
                dettagliStmt.setString(2, tipo);
                dettagliStmt.setString(3, idProdotto);
                dettagliStmt.setString(4, nome);
                dettagliStmt.setBigDecimal(5, prezzo);
                dettagliStmt.setInt(6, quantita);
                dettagliStmt.addBatch();

                System.out.println("🛍️ Salvataggio prodotto: " + item.getTitolo() + " [tipo: " + tipo + "] quantita: " + quantita);

                if ("manga".equalsIgnoreCase(tipo)) {
                    try {
                        long isbn = Long.parseLong(idProdotto);
                        mangaStmt.setInt(1, idOrdine);
                        mangaStmt.setLong(2, isbn);
                        mangaStmt.setInt(3, quantita);
                        mangaStmt.addBatch();
                        System.out.println("📚 Manga salvato: ISBN " + isbn);
                    } catch (NumberFormatException e) {
                        System.err.println("⚠️ Errore parsing ISBN: " + idProdotto);
                    }
                } else if ("funko".equalsIgnoreCase(tipo)) {
                    funkoStmt.setInt(1, idOrdine);
                    funkoStmt.setString(2, idProdotto);
                    funkoStmt.setInt(3, quantita);
                    funkoStmt.addBatch();
                    System.out.println("🧸 Funko salvato: " + idProdotto);
                }
            }

            mangaStmt.executeBatch();
            funkoStmt.executeBatch();
            dettagliStmt.executeBatch();
            conn.commit();
            System.out.println("✅ Batch eseguito con successo");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ignore) {}
            System.err.println("❌ Rollback eseguito");
        } finally {
            try {
                if (ordineStmt != null) ordineStmt.close();
                if (mangaStmt != null) mangaStmt.close();
                if (funkoStmt != null) funkoStmt.close();
                if (dettagliStmt != null) dettagliStmt.close();
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

                o.setProdotti(getDettagliOrdineStorico(conn, o.getId()));
                ordini.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordini;
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

    public List<Ordine> getFilteredOrders(String email, String stato, String sort, String dataDa, String dataA) {
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

        if (dataDa != null && !dataDa.trim().isEmpty()) {
            query.append(" AND DATE(data) >= ?");
            parametri.add(dataDa.trim());
        }
        if (dataA != null && !dataA.trim().isEmpty()) {
            query.append(" AND DATE(data) <= ?");
            parametri.add(dataA.trim());
        }

        if ("data".equals(sort)) {
            query.append(" ORDER BY data DESC");
        } else if ("totale".equals(sort)) {
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

                o.setProdotti(getDettagliOrdineStorico(conn, o.getId()));
                ordini.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordini;
    }

    public List<Ordine> getAllOrders() {
        List<Ordine> ordini = new ArrayList<>();

        String sqlOrdini = "SELECT * FROM ordini ORDER BY data DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOrdini)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ordine o = new Ordine();
                o.setId(rs.getInt("id_ordine"));
                o.setEmailUtente(rs.getString("email"));
                o.setTotale(rs.getBigDecimal("totale"));
                o.setDataOra(rs.getTimestamp("data").toLocalDateTime());
                o.setStato(rs.getString("stato"));

                o.setProdotti(getDettagliOrdineStorico(conn, o.getId()));
                ordini.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordini;
    }

    public List<ItemCarrello> getDettagliOrdineStorico(Connection conn, int idOrdine) throws SQLException {
        List<ItemCarrello> prodotti = new ArrayList<>();
        String sql = "SELECT tipo, id_prodotto, nome, prezzo, quantita FROM ordine_dettagli WHERE id_ordine = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idOrdine);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                prodotti.add(new ItemCarrello(
                    rs.getString("id_prodotto"),
                    rs.getString("tipo"),
                    rs.getString("nome"),
                    rs.getBigDecimal("prezzo"),
                    rs.getInt("quantita")
                ));
            }
        }
        return prodotti;
    }


}
