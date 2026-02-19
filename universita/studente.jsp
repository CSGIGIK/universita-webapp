<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Area Studente - Portale Università</title>
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: 'Roboto', 'Open Sans', sans-serif;
        background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
        color: #e2e8f0;
        min-height: 100vh;
        padding: 20px;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        background: linear-gradient(145deg, #0f172a 0%, #1e293b 100%);
        border-radius: 20px;
        box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        border: 1px solid rgba(34,197,94,0.2);
        overflow: hidden;
    }

    /* HEADER ACCADEMICO ACCENTUATO VERDE */
    .header {
        background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 50%, #1e3a5f 100%);
        color: #f0fdf4;
        padding: 2.5rem 2rem;
        text-align: center;
        position: relative;
        border-bottom: 1px solid rgba(34,197,94,0.3);
    }

    .header h1 {
        font-size: 2.5em;
        font-weight: 700;
        margin-bottom: 1rem;
        letter-spacing: 1px;
        text-shadow: 0 2px 10px rgba(0,0,0,0.4);
    }

    .header .matricola {
        background: rgba(34,197,94,0.2);
        color: #dcfce7;
        display: inline-block;
        padding: 12px 25px;
        border-radius: 25px;
        font-weight: 600;
        border: 1px solid rgba(34,197,94,0.4);
        backdrop-filter: blur(10px);
    }

    /* NAVIGAZIONE */
    .nav {
        background: rgba(15,23,42,0.9);
        padding: 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid rgba(34,197,94,0.2);
        backdrop-filter: blur(20px);
    }

    .nav span {
        padding: 1rem 2.5rem;
        color: #34d399;
        font-weight: 500;
        font-size: 1.1em;
    }

    .nav-actions {
        padding: 1rem 2rem;
        display: flex;
        gap: 1rem;
    }

    .nav button {
        color: #f0fdf4;
        background: linear-gradient(135deg, rgba(34,197,94,0.2), rgba(16,185,129,0.2));
        border: 1px solid rgba(34,197,94,0.4);
        padding: 0.75rem 1.5rem;
        border-radius: 12px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
    }

    .nav button:hover {
        background: linear-gradient(135deg, #10b981, #059669);
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(16,185,129,0.4);
    }

    .content {
        padding: 3rem 2.5rem;
        max-width: 1000px;
        margin: 0 auto;
    }

    /* SEZIONI CON ACCENTI VERDI */
    .section-title {
        color: #f0fdf4;
        font-size: 2em;
        font-weight: 600;
        margin-bottom: 1.5rem;
        padding-bottom: 1rem;
        border-bottom: 3px solid #34d399;
        position: relative;
    }

    /* CORSI CON VERDE SOTTILE */
    .corsi-section {
        background: linear-gradient(135deg, rgba(59,130,246,0.15), rgba(34,197,94,0.08));
        padding: 2.5rem;
        border-radius: 16px;
        border-left: 5px solid #34d399;
        margin-bottom: 3rem;
        box-shadow: 0 10px 40px rgba(34,197,94,0.15);
        backdrop-filter: blur(10px);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 1.5rem;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        background: linear-gradient(145deg, #1e293b, #334155);
        border: 1px solid rgba(34,197,94,0.15);
    }

    th {
        background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 100%);
        color: #f0fdf4;
        padding: 1.25rem;
        text-align: left;
        font-weight: 600;
        font-size: 0.9em;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    td {
        padding: 1.25rem;
        color: #e2e8f0;
        border-bottom: 1px solid rgba(34,197,94,0.1);
        background: rgba(255,255,255,0.03);
    }

    tr:hover td {
        background: rgba(34,197,94,0.15);
    }

    .prenota-btn {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        border: none;
        padding: 0.75rem 1.5rem;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        font-size: 0.9em;
        text-transform: uppercase;
        transition: all 0.3s ease;
        box-shadow: 0 6px 20px rgba(16,185,129,0.4);
        width: auto;
        display: inline-block;
    }

    .prenota-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 30px rgba(16,185,129,0.5);
    }

    /* APPELLI CON VERDE SOTTILE */
    .appelli-section {
        background: linear-gradient(135deg, rgba(59,130,246,0.1), rgba(34,197,94,0.12));
        padding: 2.5rem;
        border-radius: 16px;
        border-left: 5px solid #10b981;
        box-shadow: 0 10px 40px rgba(34,197,94,0.15);
        backdrop-filter: blur(10px);
    }

    /* MESSAGGI */
    .success-msg {
        background: rgba(16,185,129,0.15);
        color: #dcfce7;
        padding: 1.5rem;
        border-radius: 12px;
        border-left: 5px solid #10b981;
        margin-bottom: 2rem;
        font-weight: 500;
        border: 1px solid rgba(16,185,129,0.3);
    }

    .error-msg {
        background: rgba(239,68,68,0.2);
        color: #fecaca;
        padding: 1.5rem;
        border-radius: 12px;
        border-left: 5px solid #ef4444;
        margin-bottom: 2rem;
        font-weight: 500;
        border: 1px solid rgba(239,68,68,0.4);
    }
    .flex-center{
        display: flex;
        justify-content: center;
        margin-bottom:20px;
    }
    /* RESPONSIVE */
    @media (max-width: 768px) {
        .container { margin: 1rem; border-radius: 15px; }
        .content { padding: 2rem 1.5rem; }
        .header h1 { font-size: 2em; }
        .nav { flex-direction: column; gap: 1rem; padding: 1rem; }
        .nav-actions { order: 3; width: 100%; justify-content: center; flex-direction: column; }
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
<p style="display:none;">Benvenuto: ${tipo_utente}</p>
<p style="display:none;">Username: ${username}</p>
<%
String matricola = (String)session.getAttribute("matricola");
ResultSet res = (ResultSet)request.getAttribute("tabella_corso");
ResultSet res1 = (ResultSet)request.getAttribute("elenco_appelli");
String materia = (String)request.getAttribute("materia");
String messaggio = (String)request.getAttribute("successo");
String errore = (String)request.getAttribute("errore");
String data = (String)request.getAttribute("data");
String materia2 = (String)request.getAttribute("materia2");

if(matricola == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="container">
    <div class="header">
        <h1>Area Studente</h1>
        <div class="matricola">Matricola: <%=matricola %></div>
    </div>

    <div class="nav">
        <span>Benvenuto, Studente!</span>
        <div class="nav-actions">
            <% if(res1 != null && materia != null) { %>
                <button type="button" onclick="window.history.go(-1)" class="prenota-btn">INDIETRO</button>
            <% } %>
            <form method="POST" action="Logout" style="display: inline;">
                <button type="submit" class="prenota-btn">Logout</button>
            </form>
        </div>
    </div>

    <div class="content">
        <% if(messaggio != null || errore != null) { %>
             <div class="flex-center">
                <button type="button" onclick="window.history.go(-1)" class="prenota-btn">INDIETRO</button>
             </div>
        <% } %>

        <% if(messaggio != null) { %>
            <div class="success-msg">
                <%=messaggio %>
                <% if(materia2 != null && data != null) { %>
                    <br><strong>Corso:</strong> <%=materia2 %> | <strong>Data:</strong> <%=data %>
                <% } %>
            </div>
        <% } %>
        <% if(errore != null) { %>
            <div class="error-msg"><%=errore %></div>
        <% } %>

        <% if(res != null) { %>
        <div class="corsi-section">
            <h2 class="section-title">Corsi Disponibili</h2>
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

        <% if(res1 != null && materia != null) { %>
        <div class="appelli-section">
            <h2 class="section-title">Appelli per "<%=materia %>"</h2>
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
                        <form action="Prenota" method="post" style="display: inline;">
                            <input type="hidden" name="idAppello" value="<%=res1.getInt("idAppello")%>">
                            <input type="hidden" name="materiaNome" value="<%=materia%>">
                            <button type="submit" class="prenota-btn" style="background: linear-gradient(135deg, #059669, #047857); width: 100%;">
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
