<%--
  Created by IntelliJ IDEA.
  User: Pino
  Date: 16/06/2025
  Time: 16:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel ="stylesheet" href="Style/loginStyle.css">
<script src="Scripts/login.js"></script>
<html>
<head>
    <title>Login</title>



</head>
<body>

<div id="Log-in">

    <h2>Aceedi al tuo account</h2>

    <form method="post" id="LoginForm" action="LoginServlet">

            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required>

            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required>

            <button type="submit">Accedi</button>

    </form>

</div>



</body>
</html>
