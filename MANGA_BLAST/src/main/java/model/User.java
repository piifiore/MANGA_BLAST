package model;

public class User {
    private String email;
    private String password;
    private String via;
    private String numeroCivico;
    private String cap;

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getVia() { return via; }
    public void setVia(String via) { this.via = via; }

    public String getNumeroCivico() { return numeroCivico; }
    public void setNumeroCivico(String numeroCivico) { this.numeroCivico = numeroCivico; }

    public String getCap() { return cap; }
    public void setCap(String cap) { this.cap = cap; }
}