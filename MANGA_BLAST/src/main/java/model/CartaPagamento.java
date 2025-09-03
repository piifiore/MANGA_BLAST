package model;

public class CartaPagamento {

	private String email;
	private String intestatario;
	private String numero;
	private String last4;
	private String brand;
	private int scadenzaMese;
	private int scadenzaAnno;

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getIntestatario() {
		return intestatario;
	}

	public void setIntestatario(String intestatario) {
		this.intestatario = intestatario;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}

	public String getLast4() {
		return last4;
	}

	public void setLast4(String last4) {
		this.last4 = last4;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public int getScadenzaMese() {
		return scadenzaMese;
	}

	public void setScadenzaMese(int scadenzaMese) {
		this.scadenzaMese = scadenzaMese;
	}

	public int getScadenzaAnno() {
		return scadenzaAnno;
	}

	public void setScadenzaAnno(int scadenzaAnno) {
		this.scadenzaAnno = scadenzaAnno;
	}
}


