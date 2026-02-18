<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>

<title>Gestione Appelli</title>

</head>
<body>

<%
if (session.getAttribute("tipo_utente") == null || !"p".equals(session.getAttribute("tipo_utente"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<div class="container">
    <h1>Gestione Appelli <%=(String)session.getAttribute("materia")%> - Prof. <%=session.getAttribute("nome")%> <%=session.getAttribute("cognome")%></h1>

    <button type="button" onclick="window.history.go(-1)" class="logout">INDIETRO</button>

    <h2>I Miei Appelli</h2>
    <table class="appelli">
        <tr><th>Data</th><th>Materia</th><th>Azioni</th></tr>
        <tr><td colspan="3">Caricamento dinamico... (ListaAppelli.java)</td></tr>
    </table>
</div>
</body>
</html>