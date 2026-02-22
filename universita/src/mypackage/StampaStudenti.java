package mypackage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * Servlet implementation class StampaStudenti
 */
@WebServlet("/StampaStudenti")
public class StampaStudenti extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public StampaStudenti() {
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

    /**
     * "Quando il professore inserisce un ID Appello nel form e clicca 'Visualizza Studenti', la servlet:
     * <p>
     * Legge ID_appello dal form HTML (es: "5")
     * <p>
     * Recupera dal DB:
     * <p>
     * 📅 Data e Materia dell'appello (es: "PROG", "2026-02-20")
     * <p>
     * 📚 Nome completo materia (es: "PROG" → "Programmazione Web")
     * <p>
     * 👥 Lista studenti prenotati per quell'appello
     * <p>
     * Invia tutto alla dashboard.jsp che mostra la tabella studenti"
     */


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idAppelloStr = request.getParameter("ID_appello");
        // VALIDAZIONE

        int idAppello;
        try {
            idAppello = Integer.parseInt(idAppelloStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID non valido");
            request.getRequestDispatcher("professore.jsp").forward(request, response);
            return;
        }

        Connection con = Connessione.getCon();
        try {
			/* QUERY SPIEGATA

             SELECT a.Data, -- Appello: data esame
           a.Materia, -- Appello: codice materia (FK)
           c.Materia -- Corso: nome materia completa ← CAMBIATO!
            FROM appello a
            LEFT JOIN corso c ON a.Materia = c.idcorso
            WHERE a.idAppello=?
            */

            PreparedStatement stm = con.prepareStatement("select a.Data ,a.Materia , c.Cattedra AS nomeMateria from appello a LEFT JOIN corso c ON a.Materia = c.idcorso WHERE a.idAppello=?");
            stm.setInt(1, idAppello);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                String nomeMateria = rs.getString("nomeMateria");
                String dataMateria = rs.getString("Data");
                request.setAttribute("Materia", nomeMateria);
                request.setAttribute("Data", dataMateria);
                //  mandiamo a professore.jsp studenti
                PreparedStatement stm2 = con.prepareStatement(
                        "SELECT s.nome, s.cognome, s.Matricola " +
                                "FROM studente s " +
                                "JOIN prenotazione p ON s.Matricola = p.stud_prenotato " +
                                "WHERE p.app_prenotato = ?");
                stm2.setInt(1, idAppello);
                ResultSet rsStudenti = stm2.executeQuery();
                request.setAttribute("elenco_studenti", rsStudenti);  //  JSP while(rs.next())

                request.getRequestDispatcher("professore.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Appello non trovato");
                request.getRequestDispatcher("professore.jsp").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Errore DB: " + e.getMessage());  //  Invece di vuoto
            request.getRequestDispatcher("professore.jsp").forward(request, response);
        }


    }
}



	/*
		String idAppello= request.getParameter("ID_appello");
		Connection conn=Connessione.getCon();

		try {
			/*PreparedStatement smt1=conn.prepareStatement("select stud_prenotato from prenotazione where app_prenotato=CAST(? AS UNSIGNED INTEGER)");
			smt1.setString(1, idAppello);
			ResultSet rs1=smt1.executeQuery();
			while(rs1.next()) {


//		String stud=rs1.getString(1);*/
//		PreparedStatement smt= conn.prepareStatement("select distinct Materia,Data from appello where idAppello=CAST(? AS UNSIGNED INTEGER)");
//		smt.setString(1, idAppello);
//		ResultSet rs=smt.executeQuery();
//		rs.next();
//		String Materia= rs.getString("Materia");
//		String Data= rs.getString("Data");
//		PreparedStatement smt2= conn.prepareStatement("select distinct Materia from corso where idcorso=CAST(? AS UNSIGNED INTEGER)");
//		smt2.setString(1, Materia);
//		ResultSet rs2= smt2.executeQuery();
//		rs2.next();
//		String nomeMateria= rs2.getString(1);
//		PreparedStatement smt1= conn.prepareStatement("select distinct nome,cognome,Matricola from studente join (appello join prenotazione on CAST(? AS UNSIGNED INTEGER)=app_prenotato) on Matricola=stud_prenotato");
//		smt1.setString(1, idAppello);
//		ResultSet rs1=smt1.executeQuery();
//		RequestDispatcher rd= request.getRequestDispatcher("professore.jsp");
//		request.setAttribute("Materia",nomeMateria);
//		request.setAttribute("Data",Data);
//		request.setAttribute("elenco_studenti", rs1);
//		rd.forward(request, response);
//
//
//
//
//
//
//	} catch (SQLException e) {
//
//		e.printStackTrace();
//	}







