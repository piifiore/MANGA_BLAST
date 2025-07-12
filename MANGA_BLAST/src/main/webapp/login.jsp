<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/loginStyle.css">
    <script src="../scripts/login.js"></script>
    <style>
        #successMessage {
            color: green;
            font-weight: bold;
            margin-bottom: 1rem;
            text-align: center;
            font-size: 0.95rem;
        }
        #errorMessage {
            color: red;
            font-size: 0.9rem;
            text-align: center;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
<header style="display:flex; align-items:center; padding:10px;">
    <a href="index.jsp">
        <img src="img/logo.png" alt="Logo del sito" style="height:50px;">
    </a>
</header>
<div id="Log-in">

    <h2>Accedi al tuo account</h2>

    <% String success = request.getParameter("signupSuccess");
        if ("true".equals(success)) { %>
    <div id="successMessage">Registrazione effettuata con successo!</div>
    <% } %>

    <form method="post" id="LoginForm" action="${pageContext.request.contextPath}/login">

        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>

        <button type="submit">Accedi</button>

        <p>Non hai un account? <a href="signup.jsp">Registrati qui</a></p>

        <% String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { %>
        <p id="errorMessage"><%= errorMessage %></p>
        <% } %>
    </form>

</div>
</body>
</html>