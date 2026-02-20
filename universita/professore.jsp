<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard Professore</title>
<style>
    * { 
        margin: 0; 
        padding: 0; 
        box-sizing: border-box; 
    }
    
    body {
        font-family: 'Roboto', 'Open Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
        color: #e2e8f0;
        line-height: 1.6;
        min-height: 100vh;
    }

    .container {
        max-width: 1200px;
        margin: 2rem auto;
        background: linear-gradient(145deg, #0f172a 0%, #1e293b 100%);
        min-height: calc(100vh - 4rem);
        border-radius: 20px;
        box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        border: 1px solid rgba(148, 163, 184, 0.2);
        overflow: hidden;
    }

    /* HEADER ACCADEMICO */
    .header {
        background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 50%, #1e3a5f 100%);
        color: #f8fafc;
        padding: 3rem 2.5rem;
        text-align: center;
        position: relative;
        border-bottom: 1px solid rgba(148, 163, 184, 0.3);
    }

    .header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(45deg, transparent 30%, rgba(59,130,246,0.1) 50%, transparent 70%);
        animation: shimmer 3s infinite;
    }

    @keyframes shimmer {
        0% { transform: translateX(-100%); }
        100% { transform: translateX(100%); }
    }

    .header h1 {
        font-size: 2.8em;
        font-weight: 700;
        margin-bottom: 0.5rem;
        letter-spacing: 1px;
        text-shadow: 0 2px 10px rgba(0,0,0,0.5);
        position: relative;
        z-index: 1;
    }

    .header .saluto {
        font-size: 1.3em;
        opacity: 0.95;
        margin-bottom: 1.5rem;
        font-weight: 400;
        position: relative;
        z-index: 1;
    }

    /* NAVIGAZIONE UNIVERSITARIA */
    .nav {
        background: rgba(15, 23, 42, 0.9);
        padding: 0;
        border-bottom: 1px solid rgba(148, 163, 184, 0.2);
        display: flex;
        justify-content: flex-end;
        align-items: center;
        backdrop-filter: blur(20px);
    }

    .nav-actions {
        padding: 1.5rem 2.5rem;
        display: flex;
        width: 100%;           /* ← AGGIUNGI QUESTO */
        justify-content: space-between;  /* ← AGGIUNGI QUESTO */
        align-items: center;
        gap: 1rem;
    }

    .nav a, .nav button {
        color: #e2e8f0;
        text-decoration: none;
        padding: 0.75rem 1.75rem;
        background: linear-gradient(135deg, rgba(59,130,246,0.2), rgba(99,102,241,0.2));
        border: 1px solid rgba(59,130,246,0.4);
        border-radius: 12px;
        font-weight: 500;
        font-size: 0.95em;
        transition: all 0.3s ease;
        white-space: nowrap;
        backdrop-filter: blur(10px);
        position: relative;
        overflow: hidden;
    }

    /* LOGOUT ROSSO SU HOVER */
    .nav button {
        background: linear-gradient(135deg, rgba(239,68,68,0.3), rgba(248,113,113,0.3));
        border-color: rgba(239,68,68,0.5);
    }

    .nav button:hover {
        background: linear-gradient(135deg, #ef4444, #dc2626) !important;
        color: white !important;
        border-color: #ef4444 !important;
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(239,68,68,0.5);
    }

    /* GESTISCI APPELLI BLU SU HOVER */
    .nav a:hover {
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
        border-color: #3b82f6;
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(59,130,246,0.4);
    }

    .btn-primary {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        color: white;
        border: 1px solid rgba(16,185,129,0.5);
        box-shadow: 0 6px 20px rgba(16,185,129,0.3);
    }

    .btn-primary:hover {
        box-shadow: 0 12px 30px rgba(16,185,129,0.5);
    }

    .content {
        padding: 3rem 2.5rem;
        max-width: 1000px;
        margin: 0 auto;
        background: rgba(30, 41, 59, 0.3);
    }

    /* SEZIONI ACCADEMICHE */
    .section {
        margin-bottom: 3rem;
    }

    .section-title {
        color: #f8fafc;
        font-size: 2em;
        font-weight: 600;
        margin-bottom: 1.5rem;
        padding-bottom: 1rem;
        border-bottom: 3px solid transparent;
        background: linear-gradient(90deg, #3b82f6, #10b981, #f59e0b);
        background-clip: text;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        position: relative;
    }

    /* MATERIA INFO */
    .materia-info {
        background: linear-gradient(135deg, rgba(59,130,246,0.2) 0%, rgba(99,102,241,0.15) 100%);
        padding: 2.5rem;
        border-radius: 16px;
        margin-bottom: 2rem;
        border: 1px solid rgba(59,130,246,0.3);
        box-shadow: 0 10px 40px rgba(59,130,246,0.2);
        backdrop-filter: blur(10px);
        border-left: 5px solid #3b82f6;
    }

    .materia-info h2 {
        color: #f8fafc;
        font-size: 1.8em;
        margin-bottom: 1rem;
        font-weight: 600;
        text-shadow: 0 1px 3px rgba(0,0,0,0.3);
    }

    .materia-info p {
        color: #cbd5e1;
        font-size: 1.1em;
        margin-bottom: 2rem;
        opacity: 0.9;
    }

    /* TABELLE ACCADEMICHE */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 1.5rem;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        background: linear-gradient(145deg, #1e293b, #334155);
        font-size: 0.95em;
        border: 1px solid rgba(148, 163, 184, 0.2);
    }

    th {
        background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 100%);
        color: #f8fafc;
        padding: 1.25rem;
        text-align: left;
        font-weight: 600;
        font-size: 0.9em;
        text-transform: uppercase;
        letter-spacing: 1px;
        border-bottom: 1px solid rgba(148, 163, 184, 0.3);
    }

    td {
        padding: 1.25rem;
        color: #e2e8f0;
        border-bottom: 1px solid rgba(148, 163, 184, 0.15);
        vertical-align: middle;
        background: rgba(255,255,255,0.03);
    }

    tr:hover td {
        background: rgba(59,130,246,0.2);
        transform: scale(1.01);
        transition: all 0.2s ease;
    }

    .prenota-btn {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        color: white;
        border: none;
        padding: 0.75rem 1.5rem;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        font-size: 0.9em;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        box-shadow: 0 6px 20px rgba(16,185,129,0.4);
        text-decoration: none;
        display: inline-block;
    }

    .prenota-btn:hover {
        background: linear-gradient(135deg, #059669 0%, #047857 100%);
        transform: translateY(-3px);
        box-shadow: 0 12px 30px rgba(16,185,129,0.5);
    }

    /* STUDENTI SECTION */
    .studenti-section {
        background: linear-gradient(135deg, rgba(16,185,129,0.2) 0%, rgba(34,197,94,0.15) 100%);
        padding: 2.5rem;
        border-radius: 16px;
        border: 1px solid rgba(16,185,129,0.4);
        box-shadow: 0 10px 40px rgba(16,185,129,0.25);
        backdrop-filter: blur(10px);
        border-left: 5px solid #10b981;
    }

    .studenti-section h2 {
        color: #f8fafc;
        font-size: 1.8em;
        margin-bottom: 1rem;
        font-weight: 600;
    }

    /* FORM */
    .form-group {
        background: linear-gradient(145deg, rgba(30,41,59,0.8), rgba(51,65,85,0.8));
        padding: 2.5rem;
        border-radius: 16px;
        margin: 2rem 0;
        text-align: center;
        box-shadow: 0 10px 40px rgba(0,0,0,0.4);
        border: 1px solid rgba(148, 163, 184, 0.2);
        backdrop-filter: blur(15px);
    }

    .form-group input[type="number"] {
        padding: 1rem 1.25rem;
        border: 2px solid rgba(59,130,246,0.5);
        border-radius: 10px;
        width: 220px;
        margin: 0 0.5rem;
        font-size: 16px;
        font-family: inherit;
        background: rgba(15,23,42,0.9);
        color: #f8fafc;
        transition: all 0.3s ease;
    }

    .form-group input[type="number"]:focus {
        border-color: #3b82f6;
        outline: none;
        box-shadow: 0 0 0 4px rgba(59,130,246,0.3);
        background: rgba(15,23,42,1);
    }

    .form-group input[type="submit"] {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        color: white;
        padding: 1rem 2.5rem;
        border: none;
        border-radius: 50px;
        font-size: 1em;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 0 8px 25px rgba(245,158,11,0.4);
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .form-group input[type="submit"]:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 35px rgba(245,158,11,0.5);
    }

    /* MESSAGGI */
    .success-msg {
        background: rgba(16,185,129,0.2);
        color: #dcfce7;
        padding: 1.5rem;
        border-radius: 12px;
        border-left: 5px solid #10b981;
        margin-bottom: 2rem;
        font-weight: 500;
        border: 1px solid rgba(16,185,129,0.4);
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

    /* UTILITY */
    .text-center { text-align: center; }
    .mb-4 { margin-bottom: 2rem; }
    .flex-center {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 1rem;
    }

    /* BOTTONI DARK MODE */
    .btn-back {
        color: #fecaca;
        background: linear-gradient(135deg, rgba(239,68,68,0.2), rgba(248,113,113,0.2));
        border: 1px solid rgba(239,68,68,0.5);
        padding: 0.75rem 1.75rem;
        border-radius: 12px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
    }

    .btn-back:hover {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(239,68,68,0.4);
    }

    /* RESPONSIVE */
    @media (max-width: 768px) {
        .container {
            margin: 1rem;
            border-radius: 15px;
            min-height: calc(100vh - 2rem);
        }
        .content { padding: 2rem 1.5rem; }
        .header h1 { font-size: 2.2em; }
        .nav-actions {
            flex-direction: column;
            padding: 1.5rem;
            gap: 0.75rem;
        }
        .nav a, .nav button {
            width: 100%;
            text-align: center;
        }
        table { font-size: 0.85em; }
        .prenota-btn {
            padding: 0.75rem 1.25rem;
            font-size: 0.85em;
        }
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
<p style="display:none;">Benvenuto: ${tipo_utente}</p>
<p style="display:none;">Username: ${username}</p>
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
        <h1 class="saluto">Dashboard Professore</h1>
        <h1>Bentornato Prof.<%=nome%> <%=cognome%></h1>
    </div>

    <div class="nav">
        <div class="nav-actions">
            <a href="gestioneAppelli.jsp" class="btn-primary">Gestisci Appelli</a>
            <form method="POST" action="Logout" style="display: inline; margin-left: auto;">
                <button type="submit">Logout</button>
            </form>
        </div>
    </div>

    <div class="content">
        <% if(appelli != null) { %>
        <div class="section">
            <div class="materia-info">
                <h2>I TUOI APPELLI!</h2>
                <p>Appelli disponibili</p>

                <div class="form-group text-center">
                    <% if(appelli != null && appelli.first()) {
                        appelli.beforeFirst(); // Riporta il cursore PRIMA della prima riga
                    %>
                        <% while(appelli.next()) { %>
                        <form action="StampaStudenti" method="post" style="display:inline-block; margin: 0.5rem;">
                            <input type="hidden" name="ID_appello" value="<%=appelli.getInt(1)%>">
                            <input type="submit" value="<%=appelli.getString("Materia")%> del <%=appelli.getDate("data")%>" class="prenota-btn">
                        </form>
                        <% } %>
                    <% } else { %>
                        <p><strong>Nessun appello disponibile</strong></p>
                    <% } %>
                </div>
            </div>
        <% } %>

        <% if(elenco != null) { %>
        <div class="flex-center mb-4">
            <button type="button" onclick="window.history.go(-1)" class="btn-back">INDIETRO</button>
        </div>

        <div class="section studenti-section">
            <h2 class="section-title">Studenti Prenotati</h2>
            <p>Per esame <strong><%=materia != null ? materia : "N/D"%></strong> in data <strong><%=Data != null ? Data : "N/D"%></strong></p>

            <table>
                <tr>
                    <th>Nome</th>
                    <th>Cognome</th>
                    <th>Matricola</th>
                </tr>
                <%
                elenco.beforeFirst(); // Reset cursor
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
