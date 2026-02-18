<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portale Università </title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: rgba(255,255,255,0.95);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            backdrop-filter: blur(10px);
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 2.5em;
        }
        .subtitle {
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 1.2em;
        }
        .login-btn {
            display: inline-block;
            background: linear-gradient(45deg, #f39c12, #e67e22);
            color: white;
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-size: 1.3em;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(243,156,18,0.3);
        }
        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(243,156,18,0.4);
        }
        .features {
            margin-top: 30px;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
        }
        .feature {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin: 5px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎓 Portale Università</h1>
        <p class="subtitle">Sistema di Gestione Esami e Prenotazioni</p>
        <a href="login" class="login-btn">🚀 ACCEDI AL PORTALE</a>

        <div class="features">
            <div class="feature">👨‍🏫 Area Professori</div>
            <div class="feature">🎓 Area Studenti</div>
            <div class="feature">📅 Gestione Appelli</div>
        </div>
    </div>
</body>
</html>