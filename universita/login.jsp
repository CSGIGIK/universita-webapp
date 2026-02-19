<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - Portale Università</title>
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: 'Roboto', 'Open Sans', sans-serif;
        background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
        position: relative;
        overflow: hidden;
    }

    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at 20% 80%, rgba(59,130,246,0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(16,185,129,0.1) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(245,158,11,0.1) 0%, transparent 50%);
        animation: float 20s ease-in-out infinite;
        z-index: -1;
    }

    @keyframes float {
        0%, 100% { transform: scale(1) rotate(0deg); opacity: 0.6; }
        50% { transform: scale(1.1) rotate(180deg); opacity: 0.3; }
    }

    .container {
        background: linear-gradient(145deg, rgba(15,23,42,0.95), rgba(30,41,59,0.95));
        padding: 3.5rem 3rem;
        border-radius: 28px;
        box-shadow: 0 35px 70px rgba(0,0,0,0.6);
        text-align: center;
        max-width: 520px;
        width: 100%;
        border: 1px solid rgba(148,163,184,0.3);
        backdrop-filter: blur(25px);
        position: relative;
        overflow: hidden;
    }

    .container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #3b82f6 0%, #10b981 50%, #f59e0b 100%);
        border-radius: 28px 28px 0 0;
    }

    .container::after {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: conic-gradient(from 0deg, transparent, rgba(59,130,246,0.05), transparent);
        animation: rotate 4s linear infinite;
        z-index: -1;
    }

    @keyframes rotate {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    h1 {
        font-size: 2.8em;
        font-weight: 800;
        margin-bottom: 1rem;
        letter-spacing: 2px;
        background: linear-gradient(90deg, #3b82f6, #10b981, #f59e0b);
        background-clip: text;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        text-shadow: 0 4px 20px rgba(0,0,0,0.4);
    }

    .subtitle {
        color: #cbd5e1;
        margin-bottom: 2.5rem;
        font-size: 1.2em;
        opacity: 0.9;
        letter-spacing: 0.5px;
    }

    .error {
        background: rgba(239,68,68,0.2);
        color: #fecaca;
        padding: 1.25rem;
        border-radius: 16px;
        margin-bottom: 2rem;
        font-weight: 500;
        border-left: 5px solid #ef4444;
        border: 1px solid rgba(239,68,68,0.3);
        backdrop-filter: blur(10px);
        animation: shake 0.5s ease-in-out;
    }

    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }

    .scelta-ruolo {
        background: rgba(30,41,59,0.6);
        padding: 1.75rem;
        border-radius: 20px;
        margin-bottom: 2rem;
        border: 1px solid rgba(148,163,184,0.2);
        backdrop-filter: blur(15px);
        display: flex;
        justify-content: center;
        gap: 2rem;
        align-items: center;
    }

    .scelta-ruolo label {
        color: #e2e8f0;
        font-weight: 600;
        font-size: 1.1em;
        margin: 0 2rem;
        cursor: pointer;
        transition: all 0.3s ease;
        padding: 0.75rem 1.5rem;
        border-radius: 12px;
        display: inline-flex;
        align-items: center;
        gap: 0.75rem;
    }

    .scelta-ruolo input[type="radio"] {
        display: none !important;
    }

    .scelta-ruolo label:hover {
        background: rgba(16,185,129,0.2);
        color: #dcfce7;
    }

    .scelta-ruolo input[type="radio"]:checked + label {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        box-shadow: 0 8px 20px rgba(16,185,129,0.3);
        transform: translateY(-2px);
    }

    .form-group {
        margin-bottom: 2rem;
        text-align: left;
        position: relative;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.75rem;
        color: #f8fafc;
        font-weight: 600;
        font-size: 1.1em;
        letter-spacing: 0.5px;
    }

    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 1.25rem 1.5rem;
        border: 2px solid rgba(59,130,246,0.3);
        border-radius: 16px;
        font-size: 16px;
        transition: all 0.4s ease;
        background: rgba(15,23,42,0.8);
        color: #f8fafc;
        backdrop-filter: blur(15px);
        font-family: inherit;
    }

    input[type="text"]:focus, input[type="password"]:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 4px rgba(59,130,246,0.2);
        background: rgba(15,23,42,0.95);
        transform: translateY(-1px);
    }

    input[type="text"]::placeholder, input[type="password"]::placeholder {
        color: #94a3b8;
        opacity: 0.7;
    }

    input[type="submit"] {
        width: 100%;
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
        padding: 1.5rem;
        border: none;
        border-radius: 50px;
        font-size: 1.2em;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 15px 35px rgba(59,130,246,0.4);
        text-transform: uppercase;
        letter-spacing: 1.5px;
        position: relative;
        overflow: hidden;
        backdrop-filter: blur(10px);
        font-family: inherit;
    }

    input[type="submit"]::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
        transition: left 0.6s;
    }

    input[type="submit"]:hover::before {
        left: 100%;
    }

    input[type="submit"]:hover {
        transform: translateY(-4px);
        box-shadow: 0 25px 50px rgba(59,130,246,0.6);
        background: linear-gradient(135deg, #2563eb, #1e40af);
    }

    input[type="submit"]:active {
        transform: translateY(-2px);
    }

    /* RESPONSIVE */
    @media (max-width: 768px) {
        .container {
            margin: 1rem;
            padding: 2.5rem 2rem;
        }
        h1 { font-size: 2.2em; }
        .scelta-ruolo {
            padding: 1.5rem;
        }
        .scelta-ruolo label {
            display: block;
            margin: 0.75rem 0;
            width: 100%;
            justify-content: center;
        }
    }
</style>
</head>
<body>
<%
String messaggio = (String)request.getAttribute("messaggio");
%>
<div class="container">
    <h1>🔐 Accedi al Portale</h1>
    <p class="subtitle">Scegli il tuo ruolo e inserisci le credenziali</p>

    <% if(messaggio != null) { %>
    <div class="error">
        <%=messaggio%>
    </div>
    <% } %>

    <form action="login" method="post">
        <div class="scelta-ruolo">
            <input type="radio" id="stud" name="ruolo" value="STUDENTE" checked>
            <label for="stud">🎓 Studente</label>

            <input type="radio" id="prof" name="ruolo" value="PROFESSORE">
            <label for="prof">👨‍🏫 Professore</label>
        </div>

        <div class="form-group">
            <label>👤 Nome Utente</label>
            <input type="text" name="username" placeholder="Inserisci username" required>
        </div>

        <div class="form-group">
            <label>🔒 Password</label>
            <input type="password" name="password" placeholder="Inserisci password" required>
        </div>

        <input type="submit" value="🚀 Entra nel Portale">
    </form>
    <a href="formRegS.jsp" style="color: red; font-size: 1.2em; font-weight: bold;">
        Non sei registrato? Registrati
    </a>
</div>
</body>
</html>
