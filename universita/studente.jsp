<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Studente - Portale Università</title>
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px;
    }
    .container {
        max-width: 1200px;
        margin: 0 auto;
        background: white;
        border-radius: 15px;
        box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    .header {
        background: #2c3e50;
        color: white;
        padding: 20px;
        text-align: center;
    }
    .header h1 { font-size: 2em; margin-bottom: 10px; }
    .header .matricola {
        background: #34495e;
        display: inline-block;
        padding: 8px 20px;
        border-radius: 25px;
        font-weight: bold;
    }
    .nav {
        background: #ecf0f1;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .nav a {
        color: #2c3e50;
        text-decoration: none;
        padding: 10px 20px;
        background: #3498db;
        color: white;
        border-radius: 5px;
        transition: background 0.3s;
    }
    .nav a:hover { background: #2980b9; }

    .content { padding: 30px; }

    /* SEZIONE CORSI */
    .corsi-section { margin-bottom: 40px; }
    .section-title {
        color: #2c3e50;
        font-size: 1.5em;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 3px solid #3498db;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        border-radius: 10px;
        overflow: hidden;
    }
    th {
        background: #3498db;
        color: white;
        padding: 15px;
        text-align: left;
    }
    td {
        padding: 15px;
        border-bottom: 1px solid #ecf0f1;
    }
    tr:hover { background: #f8f9fa; }
    .prenota-btn {
        background: #27ae60;
        color: white;
        border: none;
        padding: 8px 15px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
    }

    /* SEZIONE APPELLI */
    .appelli-section {
        background: #e8f5e8;
        padding: 25px;
        border-radius: 10px;
        border-left: 5px solid #27ae60;
    }
    .success-msg {
        background: #d4edda;
        color: #155724;
        padding: 15px;
        border-radius: 8px;
        border-left: 5px solid #28a745;
        margin-bottom: 20px;
    }
    .error-msg {
        background: #f8d7da;
        color: #721c24;
        padding: 15px;
        border-radius: 8px;
        border-left: 5px solid #dc3545;
    }
</style>
</head>
<body>
<%
if (session.getAttribute("tipo_utente") == null || !"s".equals(session.getAttribute("tipo_utente"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<p>Benvenuto: ${tipo_utente}</p>
<p>Username: ${username}</p>
<%
String matricola = (String)session.getAttribute("matricola");
ResultSet res = (ResultSet)request.getAttribute("tabella_corso");
ResultSet res1 = (ResultSet)request.getAttribute("elenco_appelli");
String materia = (String)request.getAttribute("materia");
String messaggio = (String)request.getAttribute("successo");
String errore = (String)request.getAttribute("errore");
String data = (String)request.getAttribute("data");
String materia2 = (String)request.getAttribute("materia2");

// CHECK SESSIONE
if(matricola == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="container">
    <!-- HEADER -->
    <div class="header">
        <h1> Area Studente</h1>
        <div class="matricola">Matricola: <%=matricola %></div>
    </div>

    <!-- NAVIGAZIONE -->
    <div class="nav">
        <span>Benvenuto, Studente!</span>
       <div style="display: flex; gap: 10px;">
               <a href="logout.jsp" class="prenota-btn">Logout</a>
               <% if(res1 != null && materia != null) { %>
                   <button type="button" onclick="window.history.go(-1)" class="prenota-btn">INDIETRO</button>
               <% } %>
           </div>
    </div>

    <!-- CONTENUTO -->
    <div class="content">

        <!-- MESSAGGI SUCCESSO/ERRORE -->
        <% if(messaggio != null) { %>
        <button type="button" onclick="window.history.go(-1)" class="prenota-btn">INDIETRO</button>
            <div class="success-msg">
                 <%=messaggio %>
                <% if(materia2 != null && data != null) { %>
                    <br><strong>Corso:</strong> <%=materia2 %> | <strong>Data:</strong> <%=data %>
                <% } %>
            </div>
        <% } %>
        <% if(errore != null) { %>
            <button type="button" onclick="window.history.go(-1)" class="prenota-btn">INDIETRO</button>
            <div class="error-msg"><%=errore %></div>
        <% } %>

        <!-- SEZIONE 1: ELENCO CORSI -->
        <% if(res != null) { %>

        <div class="corsi-section">
            <h2 class="section-title"> Corsi Disponibili</h2>
            <table>
                <tr>
                    <th>ID Corso</th>
                    <th>Materia</th>
                    <th>Docente</th>
                    <th>Prenota Esame</th>
                </tr>
                <% while(res.next()) { %>
                <tr>
                    <td><strong><%=res.getInt("idcorso") %></strong></td>
                    <td><%=res.getString("materia") %></td>
                    <td><%=res.getString("nome") %> <%=res.getString("cognome") %></td>
                    <td>
                        <form action="Prenotazione" method="post" style="display: inline;">
                            <input type="hidden" name="materia" value="<%=res.getInt("idcorso")%>">
                            <button type="submit" class="prenota-btn">Prenota</button>

                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>

        <!-- SEZIONE 2: APPELLI DISPONIBILI -->
        <% if(res1 != null && materia != null) { %>

        <div class="appelli-section">
            <h2 class="section-title"> Appelli per "<%=materia %>"</h2>

            <table>
                <tr>
                    <th>ID Appello</th>
                    <th>Data Esame</th>
                    <th>Prenotazione</th>
                </tr>
                <% while(res1.next()) { %>
                <tr>
                    <td><strong><%=res1.getInt("idAppello") %></strong></td>
                    <td><%=res1.getDate("Data") %></td>
                    <td>
                        <!-- FORM PRENOTAZIONE DEFINITIVA -->
                        <form action="Prenota" method="post" style="display: inline;">
                            <input type="hidden" name="idAppello" value="<%=res1.getInt("idAppello")%>">
                            <input type="hidden" name="materiaNome" value="<%=materia%>">
                            <button type="submit" class="prenota-btn" style="background: #e74c3c; width: 100%;">
                            CONFERMA PRENOTAZIONE
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>

    </div>
</div>

</body>
</html>