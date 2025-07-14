<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/loginStyle.css">
    <script src="../scripts/login.js"></script>

</head>
<body>
<header style="display:flex; align-items:center; padding:10px;">
 <jsp:include page="header.jsp"></jsp:include>
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

    <jsp:include page="footer.jsp"></jsp:include>

</div>
</body>
</html>