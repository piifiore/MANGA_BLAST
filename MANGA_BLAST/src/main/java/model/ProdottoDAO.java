package model;

import java.sql.*;
import java.util.*;

public class ProdottoDAO {

    public List<Prodotto> getAllProdotti() {
        List<Prodotto> prodotti = new ArrayList<>();
        String query = "SELECT * FROM prodotti";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {


            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setDescrizione(rs.getString("descrizione"));
                p.setDisponibile(rs.getBoolean("disponibile"));
                prodotti.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prodotti;
    }

    public boolean insertProdotto(Prodotto p) {
        String query = "INSERT INTO prodotti (nome, prezzo, descrizione, disponibile) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, p.getNome());
            stmt.setDouble(2, p.getPrezzo());
            stmt.setString(3, p.getDescrizione());
            stmt.setBoolean(4, p.isDisponibile());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
