package model;

import java.time.LocalDateTime;

public class Recensione {
    private int id;
    private String emailUtente;
    private String idProdotto;
    private String tipoProdotto; // "manga" o "funko"
    private int voto; // da 1 a 5 stelle
    private String commento;
    private LocalDateTime dataCreazione;
    private boolean attiva;
    
    // Costruttori
    public Recensione() {}
    
    public Recensione(String emailUtente, String idProdotto, String tipoProdotto, 
                     int voto, String commento) {
        this.emailUtente = emailUtente;
        this.idProdotto = idProdotto;
        this.tipoProdotto = tipoProdotto;
        this.voto = voto;
        this.commento = commento;
        this.dataCreazione = LocalDateTime.now();
        this.attiva = true;
    }
    
    // Getters e Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getEmailUtente() {
        return emailUtente;
    }
    
    public void setEmailUtente(String emailUtente) {
        this.emailUtente = emailUtente;
    }
    
    public String getIdProdotto() {
        return idProdotto;
    }
    
    public void setIdProdotto(String idProdotto) {
        this.idProdotto = idProdotto;
    }
    
    public String getTipoProdotto() {
        return tipoProdotto;
    }
    
    public void setTipoProdotto(String tipoProdotto) {
        this.tipoProdotto = tipoProdotto;
    }
    
    public int getVoto() {
        return voto;
    }
    
    public void setVoto(int voto) {
        this.voto = voto;
    }
    
    public String getCommento() {
        return commento;
    }
    
    public void setCommento(String commento) {
        this.commento = commento;
    }
    
    public LocalDateTime getDataCreazione() {
        return dataCreazione;
    }
    
    public void setDataCreazione(LocalDateTime dataCreazione) {
        this.dataCreazione = dataCreazione;
    }
    
    public boolean isAttiva() {
        return attiva;
    }
    
    public void setAttiva(boolean attiva) {
        this.attiva = attiva;
    }
    
    // Metodo per ottenere le stelle come stringa
    public String getStelle() {
        StringBuilder stelle = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= voto) {
                stelle.append("★");
            } else {
                stelle.append("☆");
            }
        }
        return stelle.toString();
    }
    
    // Metodo per ottenere le stelle vuote
    public String getStelleVuote() {
        StringBuilder stelle = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            stelle.append("☆");
        }
        return stelle.toString();
    }
}