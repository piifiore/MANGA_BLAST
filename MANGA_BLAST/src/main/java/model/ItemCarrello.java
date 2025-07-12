package model;

import java.math.BigDecimal;

public class ItemCarrello {
    private String idProdotto;
    private String tipo; // "manga" o "funko"
    private String titolo;
    private BigDecimal prezzo;
    private int quantita;

    public ItemCarrello(String idProdotto, String tipo, String titolo, BigDecimal prezzo, int quantita) {
        this.idProdotto = idProdotto;
        this.tipo = tipo;
        this.titolo = titolo;
        this.prezzo = prezzo;
        this.quantita = quantita;
    }

    public String getIdProdotto() { return idProdotto; }
    public String getTipo() { return tipo; }
    public String getTitolo() { return titolo; }
    public BigDecimal getPrezzo() { return prezzo; }
    public int getQuantita() { return quantita; }

    public void setQuantita(int quantita) { this.quantita = quantita; }
}