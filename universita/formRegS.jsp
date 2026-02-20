<!DOCTYPE html>
<html>
<head>
<title>Registrazione Studente</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700;800&display=swap" rel="stylesheet">
<style>
body {
    background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
    padding: 2rem;
    font-family: 'Roboto', sans-serif;
}

h1 {
    text-align: center;
    color: #60a5fa;
    margin-bottom: 2rem;
}

/* ✅ 2. Table + LABEL VISIBILI */
table {
    max-width: 450px;
    margin: 0 auto;
    background: rgba(15,23,42,0.95);
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 25px 50px rgba(0,0,0,0.5);
    border: 1px solid rgba(148,163,184,0.3);
}

td {
    color: #e2e8f0;        /* ✅ LABEL BIANCHE VISIBILI */
    padding: 0.5rem 0;
    font-weight: 500;
}

td:first-child {
    width: 30%;
    padding-right: 1rem;
}

/* 3. Inputs glass */
input {
    border: 2px solid rgba(59,130,246,0.3);
    border-radius: 12px;
    background: rgba(15,23,42,0.8);
    color: white;
    padding: 0.8rem;
    width: 100%;
}

input[type="submit"] {
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
    border: none;
    border-radius: 12px;
    padding: 1rem;
    font-weight: bold;
    color: white;
    font-size: 1.1rem;
}

/* ✅ 4. Link stilizzato */
a {
    display: block;
    text-align: center;
    color: #60a5fa;
    margin-top: 1rem;
    padding: 0.8rem;
    text-decoration: none;
    border-radius: 8px;
    transition: background 0.3s;
}

a:hover {
    background: rgba(96,165,250,0.1);
}
</style>
</head>
<body>
<h1>Registrazione Studente</h1>


<div style="background:#e8f5e8; border:2px solid #4caf50; padding:15px; margin-bottom:20px;">
<h3> REGOLE REGISTRAZIONE</h3>
<ul style="color:#2e7d32; font-weight:bold;">
<li>Matricola: <span style="color:#d32f2f;">100000-999999 (6 numeri UNICO)</span></li>
<li>Username: <span style="color:#d32f2f;">max 10 caratteri (UNICO)</span></li>
<li>Password: <span style="color:#d32f2f;">max 20 caratteri</span></li>
<li>Nome/Cognome: <span style="color:#d32f2f;">max 45 caratteri</span></li>
</ul>
 <b>Duplicati BLOCK automaticamente dal DB!</b>
</div>



<form action="RegistrazioneS" method="POST">
<table>
<tr>
    <td>Matricola:</td>
    <td>
    <input type="number" name="Matricola" min="100000" max="999999" maxlength="6" required>
    </td>
</tr>

<tr>
    <td>Nome:</td>
    <td><input type="text" name="nome" required></td>
</tr>

<tr>
    <td>Cognome:</td>
    <td><input type="text" name="cognome" required></td>
</tr>

<tr>
    <td>Username:</td>
    <td><input type="text" name="username" required></td>
</tr>

<tr>
    <td>Password:</td>
    <td><input type="password" name="password" required></td>
</tr>


<tr><td colspan="2"><input type="submit" value="REGISTRATI"></td></tr>
</table>
</form>

<a href="login.jsp"> Gia registrato? Login</a>
</body>
</html>
