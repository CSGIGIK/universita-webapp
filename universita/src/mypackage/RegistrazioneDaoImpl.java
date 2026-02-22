package mypackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegistrazioneDaoImpl implements RegistrazioneDAOInterface {
    //  Questa riga dice: "La mia classe IMPLEMENTA l'interfaccia"
    // Significa: "Devo avere tutti i metodi dell'interfaccia"
    // Quindi
    @Override
    public boolean registra(RegistrazioneDTO utente) throws Exception {
        try(Connection conn = Connessione.getCon()){
        String sqlRegStud = "INSERT IGNORE INTO studente (Matricola,username,password,tipo_utente,nome,cognome) VALUES (?,?,?,?,?,?)";
       try (PreparedStatement pstmtStud = conn.prepareStatement(sqlRegStud)){
        pstmtStud.setInt(1, utente.getMatricola());
        pstmtStud.setString(2, utente.getUsername());
        pstmtStud.setString(3, utente.getPassword());
        pstmtStud.setString(4, utente.getTipo_utente());
        pstmtStud.setString(5, utente.getNome());
        pstmtStud.setString(6, utente.getCognome());
        int righe =  pstmtStud.executeUpdate();
        return righe > 0;
       }}catch(SQLException e){
            System.out.println("ops");
            return(false);

        }
    }
}
