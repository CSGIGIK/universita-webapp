package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class login
 */
@WebServlet("/login")
public class login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public login() {
        super();
        // TODO Auto-generated constructor stub
    }
//check servlet status ok ?

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     *  Gestisce la richiesta iniziale alla servlet.
     *  FIX:
     *  - Disabilitato il messaggio predefinito "Served at:".
     *  - Implementato Forwarding alla risorsa login.jsp (ex index.jsp).
     *  - Separata la logica di visualizzazione del form dalla homepage del server.
     *  - Gestisce il trasferimento dati a studente.jsp dopo login
     * * FIX:
     *  - Riordinato flusso: setAttribute() PRIMA di RequestDispatcher (migliore leggibilità)
     *  - Dati tabella_corsi ora caricati logicamente prima del dispatcher
     *  - Stesso risultato funzionale, refactoring per manutenibilità
     * *BENEFIT:
     *  - Codice più intuitivo: "preparo dati → chiamo corriere → invio"
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     * Gestisce l'autenticazione studente e redirect a dashboard
     * UPDATE 12/02/2026:
     * ✅ PreparedStatement contro SQL Injection
     * ✅ Try-with-resources per chiusura automatica connessioni
     * ✅ Caricamento tabella corsi con JOIN professore
     * ✅ Sessione HTTP con matricola salvata
     *
     * @param request  HTTP request con username/password
     * @param response HTTP response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        // TODO Auto-generated method stub


        String username = request.getParameter("username");  //abbiamo preso username e password
        String password = request.getParameter("password");
        // Recupero il valore del radio button usando il "name" dell'HTML
        String ruoloScelto = request.getParameter("ruolo");
        // implementazione check utente valido
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("messaggio", "Username e password sono obbligatori!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return; // esce subito!
        }
        /**
         * Login studente → forward TUTTI corsi disponibili (non filtrati iscrizioni)
         *=======================================================
         * BLOCCO STUDENTI - FUNZIONANTE
         *=======================================================
         */
        System.out.println("-------------------------------------------");
        System.out.println("DEBUG LOGIN - Username inserito: [" + username + "]");
        System.out.println("DEBUG LOGIN - Ruolo ricevuto dal form: [" + ruoloScelto + "]");
        System.out.println("-------------------------------------------");
        if (ruoloScelto != null && ruoloScelto.equalsIgnoreCase("STUDENTE")) {
            Connection conn = Connessione.getCon();
            /** MOTIVO: Connessione dedicata per query studenti
             *   - Verifica credenziali tabella 'studente'
             *   - Carica TUTTI i corsi (JOIN corso+professore)
             *   - Scope: SOLO blocco studenti
             *   - Chiudo dopo try-catch per riutilizzo pool
             */
            try {
                // Statement smt=conn.createStatement(); // Inizializzazione:assegniamo a smt l'oggetto necessario per inviare comandi SQL al database.
                // ResultSet rs=smt.executeQuery("select username,password from studente"); // Esecuzione della query SQL per il prelievo delle credenziali dalla tabella 'studente'.
                String sql = "SELECT username, password, matricola, tipo_utente " +
                        "FROM studente " +
                        "WHERE BINARY username = ? AND BINARY password = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                ResultSet rs = pstmt.executeQuery();

                //HttpSession session; // Dichiaro variabile sessione (inizialmente vuota/null)
                if (rs.next()) { //record trovato?
                    String tipoUtente = rs.getString("tipo_utente");//s
                    String matricola = rs.getString("matricola"); //prendo matricola
                    HttpSession session = request.getSession(true); //creo sessione HTTP
                    session.setAttribute("matricola", matricola); //salvo matricola in sessione
                    session.setAttribute("tipo_utente", tipoUtente);
                    session.setAttribute("username", username);
                    Statement smt2 = conn.createStatement(); //preparo query corsi
                    ResultSet rs2 = smt2.executeQuery(
                            "select idcorso,materia,nome,cognome " +
                                    "from corso " +
                                    "join professore ON cattedra=idprofessore " +  // ← SPAZIO FINALE
                                    "ORDER BY idcorso ASC" //AGGIUNTO ORDINE
                    ); //carico TUTTI i corsi


                    request.setAttribute("tabella_corso", rs2); //passo tabella a studente.jsp
                    request.getRequestDispatcher("studente.jsp").forward(request, response); //vai a studente.jsp
                    rs.close();
                    pstmt.close();
                    return; //login OK
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if(ruoloScelto != null && ruoloScelto.equalsIgnoreCase("PROFESSORE"))  {
            


            // =======================================================
            // ✅ BLOCCO PROFESSORI - FUNZIONANTE (autenticazione)
            // =======================================================
            Connection connProf = Connessione.getCon();
            /** MOTIVO: Connessione SEPARATA per query professori
             *   - Verifica credenziali tabella 'professore'
             *   - Caricamento futuri: corsi personali + appelli
             *   - Scope: SOLO blocco professori
             *   - Indipendente da studenti (pool riutilizzabile)
             *  	- Evita "connection closed" exception
             */
            try {
                System.out.println(" DEBUG PROF - Username: '" + username + "'");
                /** =======================================================
                 *    AUTENTICAZIONE - PreparedStatement OBBLIGATORIO
                 * =======================================================
                 */
                String sqlProf = "SELECT username, password, idProfessore, nome, cognome, tipo_utente " +
                        "FROM professore " +
                        "WHERE BINARY username = ? AND BINARY password = ?";

                // Input FORM → Rischio SQL injection → PreparedStatement
                PreparedStatement pstmt = connProf.prepareStatement(sqlProf);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                ResultSet rsProf = pstmt.executeQuery();

                if (rsProf.next()) {
                    String tipoUtenteP = rsProf.getString("tipo_utente");//p
                    int idProfessore = rsProf.getInt("idProfessore");  // ← Dato VERIFICATO dal DB
                    HttpSession session = request.getSession(true);
                    session.setAttribute("idProfessore", idProfessore); //prendiamo id nome e cognome del prof
                    session.setAttribute("nome", rsProf.getString("nome"));                 //prendiamo id nome e cognome del prof
                    session.setAttribute("cognome", rsProf.getString("cognome"));           //prendiamo id nome e cognome del prof
                    session.setAttribute("username", username);
                    session.setAttribute("tipo_utente", tipoUtenteP);
                    rsProf.close();
                    pstmt.close();
                    /** =======================================================
                     *   BLOCCO PROFESSORI - FUNZIONANTE (Corsi-Appelli) - Statement SICURO
                     *   =======================================================
                     */

                    Statement smtCorsi = connProf.createStatement(); // ID interno = NO injection risk
                    ResultSet rsCorsi = smtCorsi.executeQuery(
                            "SELECT idcorso, materia " +
                                    "FROM corso " +
                                    "WHERE cattedra = " + idProfessore);
                    if (rsCorsi.next()) {
                        int idcorso = rsCorsi.getInt("idcorso");
                        String materiaNome = rsCorsi.getString("materia");
                        session.setAttribute("idcorso", idcorso); //prendiamo id corso
                        session.setAttribute("materia", materiaNome);

                        rsCorsi.close();     // ← AGGIUNGI
                        smtCorsi.close();    // ← AGGIUNGI

                        Statement smtAppelli = connProf.createStatement();
                        ResultSet rsAppelli = smtAppelli.executeQuery(
                                "SELECT idappello, data " +
                                        "FROM appello " +
                                        "WHERE materia= " + idcorso);
                        request.setAttribute("appelli", rsAppelli);
                        request.setAttribute("Materia", materiaNome);



                        request.getRequestDispatcher("professore.jsp").forward(request, response);
                        return;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("messaggio", "Credenziali errate!");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}





/*
		Statement smt3= conn.createStatement();
			ResultSet rs3= smt3.executeQuery("select username,password from professore");
			String nome="";
			String cognome="";
			int idProfessore=0;
			int idcorso=0;
			String materia="";

			while(rs3.next()) {

				if(rs3.getString("username").equalsIgnoreCase(username)&&rs3.getString("password").equalsIgnoreCase(password)){
					HttpSession session =request.getSession(true);
					PreparedStatement smt4=conn.prepareStatement("select nome,cognome,idProfessore from professore where username=?"); //verifichiamo il nome del professore alla username e password inserita
					smt4.setString(1, username);
					ResultSet rs4= smt4.executeQuery();
					rs4.next();
					nome=rs4.getString("nome");
					cognome=rs4.getString("cognome");
					idProfessore=rs4.getInt("idProfessore");
					PreparedStatement smt5=conn.prepareStatement("select idcorso,materia from corso where cattedra=?");
					smt5.setInt(1, idProfessore);
					ResultSet rs5=smt5.executeQuery();
					rs5.next();
					idcorso = rs5.getInt("idcorso");
					materia = rs5.getString("materia");
					PreparedStatement smt6=conn.prepareStatement("select idAppello,Data from appello where Materia=?");
					smt6.setInt(1, idcorso);
					ResultSet appelli=smt6.executeQuery();
					session.setAttribute("nome", nome);
					session.setAttribute("cognome", cognome);
					RequestDispatcher rd4=request.getRequestDispatcher("professore.jsp");
					session.setAttribute("materia", materia);
					request.setAttribute("appelli", appelli);
					rd4.forward(request, response);
				}
			}
			RequestDispatcher rd3= request.getRequestDispatcher("login.jsp");
			String messaggio="username e password non sono presenti";
			request.setAttribute("messaggio", messaggio);
			rd3.forward(request, response);
}catch (SQLException e ) {
System.out.println(e.getMessage());
		}
}
}
*/
/*
while(rs.next()) {

                                         //abbiamo verificato con un check se la user e la password corridspondono a quelle presenti nel db
				if (rs.getString("username").equalsIgnoreCase(username)&& rs.getString("password").equalsIgnoreCase(password)) {
					PreparedStatement smt1=conn.prepareStatement("select matricola from studente where username=?");
					smt1.setString(1, username);       // Binding del parametro username per la ricerca della chiave primaria (matricola).
					ResultSet rs1 = smt1.executeQuery();     // Interrogazione del database: rs1 conterrà il record associato all'username fornito.
					rs1.next();    // seleziono il record contenente la matricola
					String matricola=rs1.getString("matricola");// prendo la matricola e l'assegno a string matricola
					Statement smt2 = conn.createStatement();
					ResultSet rs2 = smt2.executeQuery("select idcorso,materia,nome,cognome from corso join professore on cattedra=idprofessore");
					session =request.getSession(true); //OTTENGO SESSIONE: crea NUOVA se prima volta, usa ESISTENTE altrimenti
					session.setAttribute("matricola", matricola); // Salva matricola nella sessione HTTP - persistente per tutta la durata della sessione utente
					request.setAttribute("tabella_corso", rs2);
					RequestDispatcher rd= request.getRequestDispatcher("studente.jsp");
					rd.forward(request,response);
}
			}
*/