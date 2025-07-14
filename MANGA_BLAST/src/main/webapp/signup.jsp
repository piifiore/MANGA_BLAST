<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/signup.css?v=<%= System.currentTimeMillis() %>">
<script src="../scripts/signup.js"></script>

<html>
<head>
    <title>Sign-up</title>
</head>
<body>
<header style="display:flex; align-items:center; padding:10px;">
    <a href="index.jsp">
        <img src="img/logo.png" alt="Logo del sito" style="height:50px;">
    </a>
</header>

<h2>Registrazione Utente</h2>

<%
    String errore = (String) request.getAttribute("errore");
    String successo = request.getParameter("signupSuccess");

    if (errore != null) {
%>
<div style="color: red; font-weight: bold;">⚠️ <%= errore %></div>
<%
} else if ("true".equals(successo)) {
%>
<div style="color: green; font-weight: bold;">Registrazione completata! Effettua il login.</div>
<%
    }
%>

<form method="post" id="SignUpForm" action="${pageContext.request.contextPath}/signup">
    <label for="email">Email:</label>
    <input type="email" name="email" id="email" required>

    <label for="password">Password:</label>
    <input type="password" name="password" id="password" minlength="8" required>

    <div id="password-feedback">
        <ul>
            <li id="length">Minimo 8 caratteri</li>
            <li id="lowercase">Almeno una minuscola</li>
            <li id="uppercase">Almeno una MAIUSCOLA</li>
            <li id="number">Almeno un numero</li>
            <li id="special">Almeno un carattere speciale</li>
        </ul>
    </div>

    <button type="submit">Registrati</button>
    <p>Hai già un account? <a href="login.jsp">Vai al login</a></p>
</form>



</body>
</html>