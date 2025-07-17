<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🔐 Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/loginStyle.css?v=<%= System.currentTimeMillis() %>">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <script src="scripts/login.js"></script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="login-container">
    <h2>🔐 Accedi al tuo account</h2>

    <% String success = request.getParameter("signupSuccess");
        if ("true".equals(success)) { %>
    <div class="success-msg">✅ Registrazione effettuata con successo!</div>
    <% } %>

    <form method="post" id="loginForm" action="${pageContext.request.contextPath}/login">
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" placeholder="Inserisci la tua email" required>

        <label for="password">Password:</label>
        <div class="password-wrapper">
            <input type="password" name="password" id="password" placeholder="••••••" required>
            <span class="password-toggle-icon" onclick="togglePassword('password', this)">
          <i class="fas fa-eye"></i>
        </span>
        </div>

        <button type="submit">Accedi</button>

        <% String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { %>
        <p class="error-msg"><%= errorMessage %></p>
        <% } %>

        <p class="register-link">Non hai un account? <a href="signup.jsp">Registrati qui</a></p>
    </form>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
