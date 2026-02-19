import mypackage.RegistrazioneDTO;
import mypackage.RegistrazioneDaoImpl;

public class TESTREG {
    public static void main(String[] args) throws Exception {
        RegistrazioneDTO utente1 = new RegistrazioneDTO();
        utente1.setMatricola(34567);
        utente1.setUsername("TEST");
        utente1.setPassword("123");
        utente1.setTipo_utente("S");
        utente1.setNome("Gigi");
        utente1.setCognome("Prova");

        RegistrazioneDaoImpl dao = new RegistrazioneDaoImpl();
        System.out.println("PRIMO: " + dao.registra(utente1));  // true?

        System.out.println("SECONDO: " + dao.registra(utente1)); // false?
    }
}
