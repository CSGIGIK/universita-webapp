<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portale Università</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Roboto', 'Open Sans', sans-serif;
            background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e2e8f0;
        }

        .container {
            background: linear-gradient(145deg, rgba(15,23,42,0.9), rgba(30,41,59,0.9));
            padding: 3rem 2.5rem;
            border-radius: 24px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.6);
            text-align: center;
            max-width: 550px;
            border: 1px solid rgba(148,163,184,0.3);
            backdrop-filter: blur(20px);
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3b82f6, #10b981, #f59e0b);
        }

        h1 {
            font-size: 3em;
            font-weight: 800;
            margin-bottom: 1rem;
            letter-spacing: 1px;
            background: linear-gradient(90deg, #3b82f6, #10b981, #f59e0b);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .subtitle {
            color: #cbd5e1;
            margin-bottom: 2rem;
            font-size: 1.3em;
            opacity: 0.9;
        }

        .login-btn {
            display: inline-block;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 1.2rem 3rem;
            border-radius: 50px;
            text-decoration: none;
            font-size: 1.2em;
            font-weight: 700;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 12px 30px rgba(59,130,246,0.4);
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
            border: 2px solid rgba(59,130,246,0.3);
            backdrop-filter: blur(10px);
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(59,130,246,0.6);
            background: linear-gradient(135deg, #2563eb, #1e40af);
        }

        .features {
            margin-top: 3rem;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .feature {
            background: rgba(30,41,59,0.6);
            padding: 1.5rem 1rem;
            border-radius: 16px;
            flex: 1;
            min-width: 140px;
            border: 1px solid rgba(148,163,184,0.2);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            cursor: default;
        }

        .feature:hover {
            background: rgba(59,130,246,0.2);
            border-color: #3b82f6;
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(59,130,246,0.2);
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .container {
                margin: 1rem;
                padding: 2rem 1.5rem;
            }
            h1 { font-size: 2.2em; }
            .features {
                flex-direction: column;
                align-items: center;
            }
            .feature {
                width: 100%;
                max-width: 300px;
            }
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
