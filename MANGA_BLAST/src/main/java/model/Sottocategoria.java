package model;

public class Sottocategoria {
    private int id;
    private int idCategoria;
    private String nome;
    private String descrizione;
    private boolean attiva;
    private String dataCreazione;

    public Sottocategoria() {}

    public Sottocategoria(int id, int idCategoria, String nome, String descrizione, boolean attiva, String dataCreazione) {
        this.id = id;
        this.idCategoria = idCategoria;
        this.nome = nome;
        this.descrizione = descrizione;
        this.attiva = attiva;
        this.dataCreazione = dataCreazione;
    }

    // Getters
    public int getId() { return id; }
    public int getIdCategoria() { return idCategoria; }
    public String getNome() { return nome; }
    public String getDescrizione() { return descrizione; }
    public boolean isAttiva() { return attiva; }
    public String getDataCreazione() { return dataCreazione; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }
    public void setNome(String nome) { this.nome = nome; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }
    public void setAttiva(boolean attiva) { this.attiva = attiva; }
    public void setDataCreazione(String dataCreazione) { this.dataCreazione = dataCreazione; }
}
