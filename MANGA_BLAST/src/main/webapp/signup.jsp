<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎉 Registrazione</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/signup.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/form-messages.css?v=<%= System.currentTimeMillis() %>">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <script src="scripts/signup.js"></script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="signup-container">
    <h2>🎉 Crea il tuo account</h2>

    <%
        String errore = (String) request.getAttribute("errore");
        String successo = request.getParameter("signupSuccess");

        if (errore != null) {
    %>
    <div class="error-msg">⚠️ <%= errore %></div>
    <% } else if ("true".equals(successo)) { %>
    <div class="success-msg">✅ Registrazione completata! Effettua il login.</div>
    <% } %>

    <form method="post" id="SignUpForm" action="${pageContext.request.contextPath}/signup">
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" placeholder="Inserisci email" required>

        <label for="password">Password:</label>
        <div class="password-wrapper">
            <input type="password" name="password" id="password" minlength="8" required>
            <span class="password-toggle-icon" onclick="togglePassword('password', this)">
          <i class="fas fa-eye"></i>
        </span>
        </div>

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
        <p class="login-link">Hai già un account? <a href="login.jsp">Accedi qui</a></p>
    </form>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
