
//il DTO DATA TRANSFER OBJECT e la fotocopia dei campi del database. DTO = "MAPPATURA CAMPi DB"

package mypackage;

public class RegistrazioneDTO {
    // Matricola, username, password, tipo_utente, nome, cognome
    private Integer Matricola;    // int NOT NULL PK
    private String username;      // varchar(10)
    private String password;      // varchar(20) ← OK!
    private String nome;          // varchar(45)
    private String cognome;       // varchar(45)
    private String tipo_utente ;         // "studente"/


    public void setMatricola(Integer matricola) {
        this.Matricola = matricola;
    }


    public void setUsername(String username) {
        this.username = username;
    }


    public void setPassword(String password) {
        this.password = password;
    }


    public void setNome(String nome) {
        this.nome = nome;
    }


    public void setCognome(String cognome) {
        this.cognome = cognome;
    }


    public void setTipo_utente(String tipo_utente) {
        this.tipo_utente = tipo_utente;
    }


    public Integer getMatricola() {
        return Matricola;
    }


    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getNome() {
        return nome;
    }

    public String getCognome() {
        return cognome;
    }

    public String getTipo_utente() {
        return tipo_utente;
    }

}



