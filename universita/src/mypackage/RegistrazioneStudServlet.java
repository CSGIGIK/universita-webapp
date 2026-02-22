package mypackage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/RegistrazioneS")

public class RegistrazioneStudServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/formRegS.jsp").forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
// Andiamo a prendere i dati del form
        Integer Matricola = Integer.parseInt(request.getParameter("Matricola")); // prendiamo la stringa del form e la trasformiamo in intero:Dto Integer matricola
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String tipo_utente = "s";

        //Creiamo oggetto RegistrazioneDTO Che contiene i dati dell utente riempimo il pacco
        RegistrazioneDTO dto = new RegistrazioneDTO(Matricola,username,password,nome,cognome,tipo_utente);
        RegistrazioneDaoImpl dao = new RegistrazioneDaoImpl();
        try {
        boolean successo = dao.registra(dto);
        if(successo){
            response.sendRedirect("login.jsp?reg=ok");
        }else {
            response.sendRedirect("login.jsp?reg=error");
        }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }


}
