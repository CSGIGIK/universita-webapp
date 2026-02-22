package mypackage;
/**
 * CASSETTO OBBLIGATORIO REGISTRAZIONE
 *
 * Questa interfaccia è il PUNTO UNICO dove tutto il progetto deve passare
 * per registrare studenti. Funziona così:
 *
 * 1. CHIUNQUE vuole registrare → deve usare registra(RegistrazioneDTO)
 * 2. RegistrazioneDTO = i 6 campi ESATTAMENTE come li vuole il DB
 * 3. Niente vie traverse, niente codice SQL sparso nei servlet
 *
 * VANTAGGIO: domani cambio DB? Cambio SOLO l'implementazione.
 * Aggiungo validazioni? Cambio SOLO l'implementazione.
 *
 * Il compilatore fa la POLIZIA: se passi dati sbagliati → ERRORE IMMEDIATO.
 *
 * È il CASSETTO CENTRALIZZATO: tutto passa di qui, stesso formato, stesso metodo.

 * 19 feb 2026 - Prima interfaccia DAO del progetto
 */
public interface RegistrazioneDAOInterface {
    boolean registra(RegistrazioneDTO utente) throws Exception;
}

/**
 SCATOLA VUOTA = RegistrazioneDTO (6 campi)

 INTERFACCIA = Magazziniere (PROMESSA):
 public boolean registra(RegistrazioneDTO scatola);

 IMPLEMENTAZIONE = Fruttivendolo (DA FARE):
 DaoRegistrazioneImpl → apre MySQL → fa INSERT → true/false

 FLUSSO:
 1. FORM → dati utente
 2. SERVLET → RIEMPIE scatola
 3. SERVLET → magazziniere.registra(scatola)
 4. FRUTTIVENDOLO → MySQL → true/false
 5. SERVLET → if(true) login.jsp else errore.jsp
 */
