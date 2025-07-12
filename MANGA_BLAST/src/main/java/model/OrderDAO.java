package model;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class OrderDAO {

    public List<Order> getFilteredOrders(String email, String stato, String sort) {
        List<Order> ordini = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM orders WHERE 1=1 ");

        if (email != null && !email.isEmpty()) {
            query.append("AND emailCliente LIKE ? ");
        }
        if (stato != null && !stato.isEmpty()) {
            query.append("AND stato = ? ");
        }

        switch (sort) {
            case "data_asc":
                query.append("ORDER BY dataOrdine ASC");
                break;
            case "data_desc":
                query.append("ORDER BY dataOrdine DESC");
                break;
            case "totale_asc":
                query.append("ORDER BY totale ASC");
                break;
            case "totale_desc":
                query.append("ORDER BY totale DESC");
                break;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            int index = 1;
            if (email != null && !email.isEmpty()) {
                stmt.setString(index++, "%" + email + "%");
            }
            if (stato != null && !stato.isEmpty()) {
                stmt.setString(index++, stato);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setEmailCliente(rs.getString("emailCliente"));
                o.setDataOrdine(rs.getTimestamp("dataOrdine"));
                o.setTotale(rs.getBigDecimal("totale"));
                o.setStato(rs.getString("stato"));
                o.setArticoli(getItemsByOrderId(o.getId()));
                ordini.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordini;
    }

    public List<OrderItem> getItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String query = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setNomeProdotto(rs.getString("nomeProdotto"));
                item.setQuantità(rs.getInt("quantita"));
                item.setPrezzoUnitario(rs.getBigDecimal("prezzoUnitario"));
                items.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    public void updateOrderStatus(int orderId, String nuovoStato) {
        String query = "UPDATE orders SET stato = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, nuovoStato);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}