package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Prenota
 */
@WebServlet("/Prenota")
public class Prenota extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Prenota() {
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
/*	Studente.jsp clicca "CONFERMA" → Prenota.java
1. Prende idAppello dalla form
2. Prende matricola dalla sessione
3. INSERT in tabella prenotazione
4. Recupera Data e Materia per messaggio conferma
5. Mostra "Prenotazione OK!" verde
*/
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Recupera parametri CORRETTI da studente.jsp
        String idAppelloStr = request.getParameter("idAppello");// nome dentro studente.jsp
        HttpSession session = request.getSession(); // vediamo cosa ha salvato in sessione l'utente
        String matricola = (String) session.getAttribute("matricola"); // prendiamoci la matricola salvata nella sessione tramite login
        // TODO Auto-generated method stub
        Connection conn = Connessione.getCon(); // Connessione al database (pool condiviso) forzati
        int idAppello = Integer.parseInt(idAppelloStr);// ci serve dopo per riempire la query


        try {
            // Implementazione 14/02/2026 VERIFICA DUPLICATI PRIMA DI INSERT
            //  VERIFICA DUPLICATI - Conta prenotazioni esistenti per matricola+appello
				/*
					La query COUNT(*):
					- Cerca tutte le righe che corrispondono a matricola+appello
					- Conta quante ne trova (0, 1)
					- Crea 1 SOLA riga con quel numero dentro
				*/
            PreparedStatement checkDup = conn.prepareStatement("select COUNT(*) from prenotazione where stud_prenotato=? AND app_prenotato=?");// Conta prenotazioni esistenti per matricola+appello (VERIFICA DUPLICATI)
            checkDup.setString(1, matricola);
            checkDup.setInt(2, idAppello);
            ResultSet rsCheckDup = checkDup.executeQuery();// Esegue query e salva risultato (numero duplicati)
            // se nella riga creta il risultto e maggiore di 0 allora
            if (rsCheckDup.next() && rsCheckDup.getInt(1) > 0) {// ResultSet: INDICI PARTONO DA 1
                request.setAttribute("errore", "Sei gia prenotato per questo appello");
                request.getRequestDispatcher("studente.jsp").forward(request, response);
                return;
            } // continua normalmente se appello non prenotato
            rsCheckDup.close();
            checkDup.close();


            // inseriamo la prenotazione tramite matricola e idAppello rispettivamente pk di stud e pk di app
            PreparedStatement smt1 = conn.prepareStatement(" INSERT IGNORE INTO prenotazione(stud_prenotato,app_prenotato) VALUES (?,?)");
            smt1.setString(1, matricola);//riempiamo il punto interrogativo
            smt1.setInt(2, idAppello);//riempiamo il secondo
            smt1.executeUpdate();// udpate perche e una insert
            smt1.close();


            //inizio recupura data per messaggio conferma
            PreparedStatement smt2 = conn.prepareStatement("SELECT Data FROM appello WHERE idAppello = ?");// prepariamo query data+ messa conferma
            smt2.setInt(1, idAppello);// riempiamo il punto interrogativo della query
            ResultSet rsData = smt2.executeQuery();// execute
            String dataScelta = ""; // dichiaro fuori serve request.setAttribute("data", dataScelta);
            if (rsData.next()) {// se record trovato
                dataScelta = rsData.getString("Data"); // impacchetto la data sotto forma di colonna

            } else {
                // Appello non trovato
                request.setAttribute("errore", "Appello non trovato!");//stud jsp nome errore
                request.getRequestDispatcher("studente.jsp").forward(request, response);
                return;
            }//fine recupera data

            rsData.close();
            smt2.close();


            PreparedStatement smt3 = conn.prepareStatement("SELECT c.Materia FROM appello a JOIN corso c ON a.Materia = c.idcorso WHERE a.idAppello=?");//preparo la query
            smt3.setInt(1, idAppello);//riempio il punto interrogativo
            ResultSet rsMateria = smt3.executeQuery();//eseguo e salvo sotto forma di righe colonne
            String nomeMateria = "Sconosciuta"; // Check sicurezz inizializzo valore generalizzato

            if (rsMateria.next()) {// se trovi record allora:
                nomeMateria = rsMateria.getString("Materia");//modifica sconosciuto in nomemaateria
            }

            rsMateria.close();
            smt3.close();


            request.setAttribute("successo", "Prenotazione confermata!");
            request.setAttribute("data", dataScelta);
            request.setAttribute("materia2", nomeMateria);
            request.getRequestDispatcher("studente.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new RuntimeException(e);

        }


    }

}

		/*
		HttpSession session= request.getSession();

		String appello = request.getParameter("appello");
		String matricola=(String) session.getAttribute("matricola");
		Connection conn= Connessione.getCon();
		try {
			PreparedStatement smt2 = conn.prepareStatement("insert into prenotazione (stud_prenotato,app_prenotato) values (CAST(? AS UNSIGNED INTEGER),CAST(? AS UNSIGNED INTEGER))");
			smt2.setString(1, matricola);
			smt2.setString(2,appello);
			smt2.executeUpdate();
			PreparedStatement recuperoData = conn.prepareStatement("select data from appello where idAppello=CAST(? AS UNSIGNED INTEGER)");
			recuperoData.setString(1, appello);
			ResultSet data=recuperoData.executeQuery();
			data.next();
			String dataScelta=data.getString(1);
			PreparedStatement recuperoMateria=conn.prepareStatement("select materia from corso where idcorso=CAST(? AS UNSIGNED INTEGER)");
			recuperoMateria.setString(1, appello);
			ResultSet materia=recuperoMateria.executeQuery();
			materia.next();
			String nomeMateria=materia.getString(1);
			RequestDispatcher rd1=request.getRequestDispatcher("studente.jsp");
			request.setAttribute("data", dataScelta);
			request.setAttribute("materia2", nomeMateria);
			rd1.forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		 */

