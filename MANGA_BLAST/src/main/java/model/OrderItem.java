package model;

import java.math.BigDecimal;

public class OrderItem {
    private String nomeProdotto;
    private int quantità;
    private BigDecimal prezzoUnitario;

    public String getNomeProdotto() { return nomeProdotto; }
    public void setNomeProdotto(String nomeProdotto) { this.nomeProdotto = nomeProdotto; }

    public int getQuantità() { return quantità; }
    public void setQuantità(int quantità) { this.quantità = quantità; }

    public BigDecimal getPrezzoUnitario() { return prezzoUnitario; }
    public void setPrezzoUnitario(BigDecimal prezzoUnitario) { this.prezzoUnitario = prezzoUnitario; }
}