<%--
  Created by IntelliJ IDEA.
  User: Pino
  Date: 16/06/2025
  Time: 16:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel ="stylesheet" href="${pageContext.request.contextPath}/style/loginStyle.css">
<script src="../scripts/login.js"></script>
<html>
<head>
    <title>Login</title>

</head>


<body>
<div id="Log-in">

    <h2>Aceedi al tuo account</h2>

    <form method="post" id="LoginForm" action="${pageContext.request.contextPath}/login">

            <label for="email">Email:</label>
            <input type="email" name="email" id="email" required>


            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required>

            <button type="submit">Accedi</button>

        <p>Non hai un account? <a href="signup.jsp">Registrati qui</a></p>

        <p id="errorMessage">
            <c:if test="${not empty errorMessage}">
                ${errorMessage}
            </c:if>
        </p>
    </form>

</div>



</body>
</html>
