package model;

import java.math.BigDecimal;

public class Funko {
    private String numeroSerie;
    private String nome;
    private String descrizione;
    private BigDecimal prezzo;
    private String immagine;
    private int quantita;
    private Integer idCategoria;
    private Integer idSottocategoria;

    public String getNumeroSerie() { return numeroSerie; }
    public void setNumeroSerie(String numeroSerie) { this.numeroSerie = numeroSerie; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public BigDecimal getPrezzo() { return prezzo; }
    public void setPrezzo(BigDecimal prezzo) { this.prezzo = prezzo; }

    public String getImmagine() { return immagine; }
    public void setImmagine(String immagine) { this.immagine = immagine; }

    public int getQuantita() { return quantita; }
    public void setQuantita(int quantita) { this.quantita = quantita; }

    public Integer getIdCategoria() { return idCategoria; }
    public void setIdCategoria(Integer idCategoria) { this.idCategoria = idCategoria; }

    public Integer getIdSottocategoria() { return idSottocategoria; }
    public void setIdSottocategoria(Integer idSottocategoria) { this.idSottocategoria = idSottocategoria; }
}