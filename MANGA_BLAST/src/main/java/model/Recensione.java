package model;

import java.time.LocalDateTime;

public class Recensione {
    private int id;
    private int idProdotto;
    private String tipoProdotto;
    private String emailUtente;
    private int rating;
    private String titolo;
    private String commento;
    private LocalDateTime dataRecensione;
    private boolean moderata;
    private boolean attiva;
    private int likeCount;
    private int dislikeCount;
    
    // Costruttori
    public Recensione() {}
    
    public Recensione(int idProdotto, String tipoProdotto, String emailUtente, 
                     int rating, String titolo, String commento) {
        this.idProdotto = idProdotto;
        this.tipoProdotto = tipoProdotto;
        this.emailUtente = emailUtente;
        this.rating = rating;
        this.titolo = titolo;
        this.commento = commento;
        this.dataRecensione = LocalDateTime.now();
        this.moderata = false;
        this.attiva = true;
        this.likeCount = 0;
        this.dislikeCount = 0;
    }
    
    // Getter e Setter
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getIdProdotto() {
        return idProdotto;
    }
    
    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }
    
    public String getTipoProdotto() {
        return tipoProdotto;
    }
    
    public void setTipoProdotto(String tipoProdotto) {
        this.tipoProdotto = tipoProdotto;
    }
    
    public String getEmailUtente() {
        return emailUtente;
    }
    
    public void setEmailUtente(String emailUtente) {
        this.emailUtente = emailUtente;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getTitolo() {
        return titolo;
    }
    
    public void setTitolo(String titolo) {
        this.titolo = titolo;
    }
    
    public String getCommento() {
        return commento;
    }
    
    public void setCommento(String commento) {
        this.commento = commento;
    }
    
    public LocalDateTime getDataRecensione() {
        return dataRecensione;
    }
    
    public void setDataRecensione(LocalDateTime dataRecensione) {
        this.dataRecensione = dataRecensione;
    }
    
    public boolean isModerata() {
        return moderata;
    }
    
    public void setModerata(boolean moderata) {
        this.moderata = moderata;
    }
    
    public boolean isAttiva() {
        return attiva;
    }
    
    public void setAttiva(boolean attiva) {
        this.attiva = attiva;
    }
    
    public int getLikeCount() {
        return likeCount;
    }
    
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
    
    public int getDislikeCount() {
        return dislikeCount;
    }
    
    public void setDislikeCount(int dislikeCount) {
        this.dislikeCount = dislikeCount;
    }
    
    // Metodi di utilità
    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    public String getFormattedDate() {
        if (dataRecensione == null) return "";
        return dataRecensione.toString().substring(0, 10);
    }
    
    @Override
    public String toString() {
        return "Recensione{" +
                "id=" + id +
                ", idProdotto=" + idProdotto +
                ", tipoProdotto='" + tipoProdotto + '\'' +
                ", emailUtente='" + emailUtente + '\'' +
                ", rating=" + rating +
                ", titolo='" + titolo + '\'' +
                ", dataRecensione=" + dataRecensione +
                '}';
    }
}
