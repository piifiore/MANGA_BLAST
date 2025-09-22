package model;

public class Categoria {
    private int id;
    private String nome;
    private String descrizione;
    private String immagine;
    private String colore;
    private boolean attiva;
    private String dataCreazione;

    public Categoria() {}

    public Categoria(int id, String nome, String descrizione, String immagine, String colore, boolean attiva, String dataCreazione) {
        this.id = id;
        this.nome = nome;
        this.descrizione = descrizione;
        this.immagine = immagine;
        this.colore = colore;
        this.attiva = attiva;
        this.dataCreazione = dataCreazione;
    }

    // Getters
    public int getId() { return id; }
    public String getNome() { return nome; }
    public String getDescrizione() { return descrizione; }
    public String getImmagine() { return immagine; }
    public String getColore() { return colore; }
    public boolean isAttiva() { return attiva; }
    public String getDataCreazione() { return dataCreazione; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setNome(String nome) { this.nome = nome; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }
    public void setImmagine(String immagine) { this.immagine = immagine; }
    public void setColore(String colore) { this.colore = colore; }
    public void setAttiva(boolean attiva) { this.attiva = attiva; }
    public void setDataCreazione(String dataCreazione) { this.dataCreazione = dataCreazione; }
}
