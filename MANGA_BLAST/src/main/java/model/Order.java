package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private String emailCliente;
    private Date dataOrdine;
    private BigDecimal totale;
    private String stato;
    private List<OrderItem> articoli;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmailCliente() { return emailCliente; }
    public void setEmailCliente(String emailCliente) { this.emailCliente = emailCliente; }

    public Date getDataOrdine() { return dataOrdine; }
    public void setDataOrdine(Date dataOrdine) { this.dataOrdine = dataOrdine; }

    public BigDecimal getTotale() { return totale; }
    public void setTotale(BigDecimal totale) { this.totale = totale; }

    public String getStato() { return stato; }
    public void setStato(String stato) { this.stato = stato; }

    public List<OrderItem> getArticoli() { return articoli; }
    public void setArticoli(List<OrderItem> articoli) { this.articoli = articoli; }
}