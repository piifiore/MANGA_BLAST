package model;

import java.sql.*;
import java.util.*;

public class OrdineDAO {

    public boolean creaOrdine(int utenteId, List<ProdottoCarrello> prodotti, double totale, String indirizzoSpedizione) {
        String queryOrdine = "INSERT INTO ordini (utente_id, data, totale, indirizzo_spedizione) VALUES (?, NOW(), ?, ?)";
        String queryDettaglio = "INSERT INTO ordine_dettaglio (ordine_id, prodotto_id, quantita, prezzo_unitario) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Inserisci ordine
            try (PreparedStatement stmtOrdine = conn.prepareStatement(queryOrdine, Statement.RETURN_GENERATED_KEYS)) {
                stmtOrdine.setInt(1, utenteId);
                stmtOrdine.setDouble(2, totale);
                stmtOrdine.setString(3, indirizzoSpedizione);
                stmtOrdine.executeUpdate();

                ResultSet keys = stmtOrdine.getGeneratedKeys();
                if (keys.next()) {
                    int ordineId = keys.getInt(1);

                    // Inserisci dettagli
                    try (PreparedStatement stmtDettaglio = conn.prepareStatement(queryDettaglio)) {
                        for (ProdottoCarrello pc : prodotti) {
                            stmtDettaglio.setInt(1, ordineId);
                            stmtDettaglio.setInt(2, pc.getProdottoId());
                            stmtDettaglio.setInt(3, pc.getQuantita());
                            stmtDettaglio.setDouble(4, pc.getPrezzoUnitario());
                            stmtDettaglio.addBatch();
                        }
                        stmtDettaglio.executeBatch();
                    }
                }

                conn.commit();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Ordine> getOrdiniByUtente(int utenteId) {
        List<Ordine> ordini = new ArrayList<>();
        String query = "SELECT * FROM ordini WHERE utente_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, utenteId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Ordine o = new Ordine();
                o.setId(rs.getInt("id"));
                o.setData(rs.getDate("data"));
                o.setTotale(rs.getDouble("totale"));
                o.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                ordini.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ordini;
    }
}
