<!DOCTYPE html>
<html>
<head><title>Registrazione Studente</title></head>
<body>
<h1>Registrazione Studente</h1>

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
