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
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }
    .container {
        background: rgba(255,255,255,0.95);
        padding: 40px;
        border-radius: 20px;
        box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        text-align: center;
        max-width: 500px;
        width: 100%;
        backdrop-filter: blur(10px);
    }
    h1 {
        color: #2c3e50;
        margin-bottom: 10px;
        font-size: 2.2em;
    }
    .subtitle {
        color: #34495e;
        margin-bottom: 30px;
        font-size: 1.1em;
    }
    .error {
        background: rgba(231, 76, 60, 0.2);
        color: #c0392b;
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 25px;
        font-weight: 500;
        border-left: 4px solid #e74c3c;
        backdrop-filter: blur(5px);
    }
    .form-group {
        margin-bottom: 25px;
        text-align: left;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #2c3e50;
        font-weight: 600;
        font-size: 1.1em;
    }
    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 15px 20px;
        border: 2px solid rgba(243,156,18,0.3);
        border-radius: 10px;
        font-size: 16px;
        transition: all 0.3s ease;
        background: rgba(255,255,255,0.9);
        backdrop-filter: blur(5px);
    }
    input[type="text"]:focus, input[type="password"]:focus {
        outline: none;
        border-color: #f39c12;
        box-shadow: 0 0 0 3px rgba(243,156,18,0.1);
    }
    input[type="submit"] {
        width: 100%;
        background: linear-gradient(45deg, #f39c12, #e67e22);
        color: white;
        padding: 18px;
        border: none;
        border-radius: 50px;
        font-size: 1.3em;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 10px 20px rgba(243,156,18,0.3);
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    input[type="submit"]:hover {
        transform: translateY(-2px);
        box-shadow: 0 15px 30px rgba(243,156,18,0.4);
    }
</style>
</head>
<body>
<%
String messaggio = (String)request.getAttribute("messaggio");
%>
<div class="container">
    <h1>Portale Universita</h1>
    <% if(messaggio != null) { %>
    <div class="error">
        <%=messaggio%>
    </div>
    <% } %>

    <form action="login" method="post">


    <div class="scelta-ruolo">

        <input type="radio" id="stud" name="ruolo" value="STUDENTE" checked>
        <label for="stud">Studente</label>

        <input type="radio" id="prof" name="ruolo" value="PROFESSORE">
        <label for="prof">Professore</label>
    </div>


        <div class="form-group">
            <label>Nome Utente</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>
        <input type="submit" value="Accedi">
    </form>
</div>
</body>
</html>