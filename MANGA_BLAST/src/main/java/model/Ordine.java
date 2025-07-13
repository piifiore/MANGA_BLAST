package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Ordine {
    private int id;
    private String emailUtente;
    private LocalDateTime dataOra;
    private BigDecimal totale;
    private String stato; // es: "In attesa", "Spedito", "Consegnato"
    private List<ItemCarrello> prodotti;

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmailUtente() { return emailUtente; }
    public void setEmailUtente(String emailUtente) { this.emailUtente = emailUtente; }

    public LocalDateTime getDataOra() { return dataOra; }
    public void setDataOra(LocalDateTime dataOra) { this.dataOra = dataOra; }

    public BigDecimal getTotale() { return totale; }
    public void setTotale(BigDecimal totale) { this.totale = totale; }

    public String getStato() { return stato; }
    public void setStato(String stato) { this.stato = stato; }

    public List<ItemCarrello> getProdotti() { return prodotti; }
    public void setProdotti(List<ItemCarrello> prodotti) { this.prodotti = prodotti; }
}