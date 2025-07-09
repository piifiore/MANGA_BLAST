<%--
  Created by IntelliJ IDEA.
  User: roman
  Date: 17/06/2025
  Time: 21:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="style/signup.css">
<script src="scripts/signup.js"></script>
<html>
<head>
    <title>Sign-up</title>
</head>
<body>

<form method="post" action="SignUpServlet">
    <label for="email">Email:</label>
    <input type="email" name="email" id="email" required>

    <label for="password">Password:</label>
    <input type="password" name="password" id="password" required>

    <button type="submit">Registrati</button>

    <p id="signupMessage">
        <c:if test="${not empty signupMessage}">${signupMessage}</c:if>
    </p>

</form>
</body>
</html>
