package model;

import java.math.BigDecimal;

public class ItemCarrello {
    private String idProdotto;
    private String tipo; // "manga" o "funko"
    private String titolo;
    private BigDecimal prezzo;
    private String immagine;
    private int quantita;

    // Costruttore completo con immagine
    public ItemCarrello(String idProdotto, String tipo, String titolo, BigDecimal prezzo, int quantita, String immagine) {
        this.idProdotto = idProdotto;
        this.tipo = tipo;
        this.titolo = titolo;
        this.prezzo = prezzo;
        this.quantita = quantita;
        this.immagine = immagine;
    }

    // Costruttore base senza immagine
    public ItemCarrello(String idProdotto, String tipo, String titolo, BigDecimal prezzo, int quantita) {
        this(idProdotto, tipo, titolo, prezzo, quantita, null);
    }

    public String getIdProdotto() { return idProdotto; }
    public String getTipo() { return tipo; }
    public String getTitolo() { return titolo; }
    public BigDecimal getPrezzo() { return prezzo; }
    public int getQuantita() { return quantita; }
    public String getImmagine() { return immagine; }

    public void setQuantita(int quantita) { this.quantita = quantita; }
    public void setImmagine(String immagine) { this.immagine = immagine; }
}
