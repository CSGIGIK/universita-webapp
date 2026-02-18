
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Dashboard Professore</title>
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh; padding: 20px;
    }

    .container {
        max-width: 1200px; margin: 0 auto;
        background: rgba(255,255,255,0.95);
        border-radius: 15px;
        box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        overflow: hidden;
        backdrop-filter: blur(10px);
    }

    /* HEADER CON MATRICOLA */
    .header {
        background: #2c3e50;
        color: white; padding: 30px 40px;
        text-align: center; position: relative;
    }
    .header h1 {
        font-size: 2.2em;
        font-weight: 800;
        margin-bottom: 15px;
    }
    .header .matricola {
        background: #34495e;
        display: inline-block;
        padding: 12px 25px;
        border-radius: 25px;
        font-weight: bold;
        font-size: 1.1em;
        box-shadow: 0 5px 15px rgba(52,73,94,0.4);
    }

    /* NAVIGAZIONE */
    .nav {
        background: #ecf0f1;
        padding: 20px 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .nav a {
        color: white;
        text-decoration: none;
        padding: 12px 25px;
        background: #3498db;
        border-radius: 8px;
        font-weight: bold;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(52,152,219,0.3);
        display: inline-block;
    }
    .nav a:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(52,152,219,0.4);
    }
    .logout {
        background: rgba(255,255,255,0.95);
        color: #2c3e50 !important;
        padding: 12px 30px;
        border-radius: 25px;
        font-weight: bold;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }
    .logout:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.3);
    }

    .content { padding: 40px; }

    /* SEZIONE CORSI (ADATTATA) */
    .corsi-section { margin-bottom: 40px; }
    .section-title {
        color: #2c3e50;
        font-size: 2em;
        margin-bottom: 25px;
        padding-bottom: 12px;
        border-bottom: 4px solid #3498db;
        position: relative;
    }

    /* TABELLE */
    table {
        width: 100%; border-collapse: collapse;
        margin-top: 20px; border-radius: 12px;
        overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        background: white;
    }
    th {
        background: linear-gradient(45deg, #f39c12, #e67e22);
        color: white; padding: 18px 20px;
        text-align: left; font-weight: bold;
    }
    td {
        padding: 18px 20px; color: #2c3e50;
        border-bottom: 1px solid #ecf0f1;
    }
    tr:hover td {
        background: rgba(243,156,18,0.1);
        transform: translateY(-1px);
    }
    .prenota-btn {
        background: #27ae60;
        color: white; border: none;
        padding: 10px 20px; border-radius: 8px;
        cursor: pointer; font-weight: bold;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(39,174,96,0.3);
    }
    .prenota-btn:hover {
        background: #219a52;
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(39,174,96,0.4);
    }

    /* MATERIA INFO */
    .materia-info {
        background: rgba(52,152,219,0.1);
        padding: 35px; border-radius: 15px;
        margin-bottom: 30px; text-align: center;
        border: 2px solid rgba(52,152,219,0.3);
        box-shadow: 0 10px 25px rgba(52,152,219,0.15);
    }

    /* FORM */
    .form-group {
        background: white;
        padding: 35px; border-radius: 15px;
        margin-top: 25px; text-align: center;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }
    .form-group input[type="number"] {
        padding: 15px 20px;
        border: 2px solid rgba(243,156,18,0.3);
        border-radius: 10px; width: 180px;
        margin-right: 15px; font-size: 16px;
    }
    .form-group input[type="number"]:focus {
        border-color: #f39c12;
        outline: none; box-shadow: 0 0 0 3px rgba(243,156,18,0.2);
    }
    .form-group input[type="submit"] {
        background: linear-gradient(45deg, #f39c12, #e67e22);
        color: white; padding: 15px 40px;
        border: none; border-radius: 50px;
        font-size: 1.1em; font-weight: bold;
        cursor: pointer; box-shadow: 0 10px 20px rgba(243,156,18,0.3);
    }
    .form-group input[type="submit"]:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 30px rgba(243,156,18,0.4);
    }

    /* STUDENTI SECTION */
    .studenti-section {
        background: rgba(39,174,96,0.1);
        padding: 35px; border-radius: 15px;
        margin-top: 30px; box-shadow: 0 10px 25px rgba(39,174,96,0.15);
        border: 1px solid rgba(39,174,96,0.3);
    }

    /* MESSAGGI */
    .success-msg {
        background: #d4edda; color: #155724;
        padding: 20px; border-radius: 10px;
        border-left: 5px solid #28a745; margin-bottom: 20px;
    }
    .error-msg {
        background: #f8d7da; color: #721c24;
        padding: 20px; border-radius: 10px;
        border-left: 5px solid #dc3545; margin-bottom: 20px;
    }
</style>
</head>
<body>
<%
if (session.getAttribute("tipo_utente") == null || !"p".equals(session.getAttribute("tipo_utente"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<p>Benvenuto: ${tipo_utente}</p>
<p>Username: ${username}</p>
<%
String nome = (String)session.getAttribute("nome");
String cognome = (String)session.getAttribute("cognome");
String materia = (String)session.getAttribute("materia");
ResultSet appelli = (ResultSet)request.getAttribute("appelli");
ResultSet elenco = (ResultSet)request.getAttribute("elenco_studenti");
String nomeMateria = (String)request.getAttribute("Materia");
String Data = (String)request.getAttribute("Data");
%>

<% if(nome == null && cognome == null) {
    response.sendRedirect("index.jsp");
    return;
} %>

<div class="container">
    <div class="header">
        <h1>Bentornato Prof. <%=nome%> <%=cognome%></h1>
        <div style="display: flex; justify-content: right; margin-bottom: 20px;">
        <a href="logout.jsp" class="logout">Logout</a>

        </div>
    </div>

    <div class="content">
        <% if(appelli != null) { %>
        <div class="section">
            <div class="materia-info">
                <h2>Materia: <%=materia%></h2>
                <p>Appelli disponibili</p>


                   <-- WIP -->

                  <div class="gestione-appelli">
                      <a href="gestioneAppelli.jsp">
                           Gestisci Appelli
                      </a>
                  </div>

                   <-- WIP -->
                   <form action = "CancellaAppello" method = "post" >
                           <button type = "submit" class= "logout" > cancella appello  </button>
                   </form>



                <!--  BOTTONI  -->
                <div class="form-group">
                    <% if(appelli != null && appelli.first()) { %>
                        <% do { %>
                        <form action="StampaStudenti" method="post" style="display:inline-block; margin: 5px;">
                            <input type="hidden" name="ID_appello" value="<%=appelli.getInt(1)%>">
                            <input type="submit" value="Appello <%=appelli.getDate("data")%>" class="prenota-btn">
                        </form>
                        <% } while(appelli.next()); %>
                    <% } else { %>
                        <p>Nessun appello disponibile</p>
                    <% } %>
                </div>
            </div>
        <% } %>

        <% if(elenco != null) { %>
         <div style="display: flex; justify-content: center; margin-bottom: 20px;">
             <button type="button" onclick="window.history.go(-1)" class="logout">INDIETRO</button>

         </div>
        <div class="section studenti-section">
            <h2>Studenti Prenotati</h2>
            <p>Per esame <strong><%=materia != null ? materia : "N/D"%></strong> in data <strong><%=Data != null ? Data : "N/D"%></strong></p> <!-- 🔧 FIX: Gestione null per evitare "Per esame null"  -->

            <table>
                <tr>
                    <th>Nome</th>
                    <th>Cognome</th>
                    <th>Matricola</th>
                </tr>
                <%
                while(elenco.next()) {
                %>
                <tr>
                    <td><%=elenco.getString("nome")%></td>
                    <td><%=elenco.getString("cognome")%></td>
                    <td><%=elenco.getString("Matricola")%></td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>

    </div>


</div>
</body>
</html>