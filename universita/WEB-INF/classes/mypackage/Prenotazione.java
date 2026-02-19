package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class Prenotazione
 */
@WebServlet("/Prenotazione")
public class Prenotazione extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Prenotazione() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        // 1. RECUPERA idcorso dalla studente.jsp (form "Prenota")
        String idCorsoStr = request.getParameter("materia");  // Legge parametro POST materia=1
        Connection conn = Connessione.getCon();               // Ottiene connessione dal pool
        int idCorso = Integer.parseInt(idCorsoStr);           // Converte "1" -> 1 (int)

        try {
            // 2. QUERY 1: Nome materia dal corso
            PreparedStatement smt1 = conn.prepareStatement("SELECT Materia " + "FROM corso " + "WHERE idcorso=?");     // Cerca materia per idcorso
            smt1.setInt(1, idCorso);                              // Imposta parametro idcorso
            ResultSet rs1 = smt1.executeQuery();                  // Esegue query corso

            if (rs1.next()) {                                     // Verifica corso esiste
                String materia = rs1.getString("Materia");        // Salva nome materia (es. "Analisi I")

                // 3. QUERY 2: Appelli associati alla materia
                PreparedStatement smt2 = conn.prepareStatement("SELECT idAppello, Data " + "FROM appello " + "WHERE Materia=?");  // Cerca appelli per FK Materia
                smt2.setInt(1, idCorso);                          // Usa stesso idcorso (FK)
                ResultSet rsAppelli = smt2.executeQuery();        // Esegue query appelli

                // 4. PREPARA DATI per visualizzazione JSP
                request.setAttribute("materia", materia);         // Titolo sezione: "Appelli per 'Analisi I'"
                request.setAttribute("elenco_appelli", rsAppelli); // Dati tabella appelli


                // Forward: mostra studente.jsp con appelli
                request.getRequestDispatcher("studente.jsp").forward(request, response);
                //return; // ← OPZIONALE (fine metodo naturale)
            } else {
                // Corso non trovato nel database
                request.setAttribute("errore", "Corso non trovato!");
                request.getRequestDispatcher("studente.jsp").forward(request, response);
                return; // ← OBBLIGATORIO (ferma esecuzione)
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);                        // Gestione errore SQL
        }
    }
}


/*
CODICE ORIGINALE - FUNZIONANTE IN PARTE

String materia=request.getParameter("materia");
   // Recupera parametro "materia" dalla JSP (idcorso come String)

Connection conn= Connessione.getCon();
   // Ottiene connessione al database dal Connection Pool

try {
    PreparedStatement smt1=conn.prepareStatement("select materia from corso where idcorso=CAST(? AS UNSIGNED INTEGER)");
       // Query 1: cerca nome materia nel corso usando CAST per conversione
    smt1.setString(1, materia);
       // Imposta parametro idcorso (String) nella query
    ResultSet rs1 = smt1.executeQuery();
       // Esegue query e ottiene risultati
    rs1.next();
       // Posiziona cursore sul primo record
    String nomeMateria=rs1.getString(1);
       // Salva nome materia (prima colonna)

    PreparedStatement smt= conn.prepareStatement("select idAppello,Data from appello where materia=CAST(? AS UNSIGNED INTEGER)");
       // Query 2: cerca appelli per quella materia usando CAST
    smt.setString(1,materia);
       // Imposta parametro idcorso nella seconda query
    ResultSet rs= smt.executeQuery();
       // Esegue query appelli
       // Risultato: rs contiene idAppello + Data per tutti gli appelli

    RequestDispatcher rd=request.getRequestDispatcher("studente.jsp");
       // Prepara redirect verso studente.jsp
    request.setAttribute("materia", nomeMateria);
       // Invia nome materia alla JSP (titolo sezione)
    request.setAttribute("elenco_appelli", rs);
       // Invia ResultSet appelli alla JSP (tabella verde)
    rd.forward(request, response);
       // Forward: esegue studente.jsp con dati caricati

}catch (SQLException e) {
    System.out.println(e.getMessage());
       // Gestione errore: solo logga in console
}
   // RISULTATO: Mostra appelli per corso selezionato
*/


	
	
	
	

	


