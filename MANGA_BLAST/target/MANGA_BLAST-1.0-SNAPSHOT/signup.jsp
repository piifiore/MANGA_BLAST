<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/signup.css?v=<%= System.currentTimeMillis() %>">
<script src="../scripts/signup.js"></script>
<html>
<head>
    <title>Sign-up</title>
</head>
<body>

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

    <p id="signupMessage">
        <c:if test="${not empty signupMessage}">${signupMessage}</c:if>
    </p>

</form>

<script>
    window.addEventListener("load", function () {
        const passwordField = document.getElementById("password");
        const form = document.getElementById("SignUpForm");

        const feedbackItems = {
            length: document.getElementById("length"),
            lowercase: document.getElementById("lowercase"),
            uppercase: document.getElementById("uppercase"),
            number: document.getElementById("number"),
            special: document.getElementById("special")
        };

        const checkPasswordRequirements = () => {
            const password = passwordField.value;

            return {
                length: password.length >= 8,
                lowercase: /[a-z]/.test(password),
                uppercase: /[A-Z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[^A-Za-z0-9]/.test(password)
            };
        };

        passwordField.addEventListener("input", function () {
            const checks = checkPasswordRequirements();
            let allValid = true;

            for (const [key, isValid] of Object.entries(checks)) {
                const item = feedbackItems[key];
                if (isValid) {
                    item.classList.add("valid");
                } else {
                    item.classList.remove("valid");
                    allValid = false;
                }
            }

            passwordField.classList.toggle("valid", allValid);
            passwordField.classList.toggle("invalid", !allValid);
        });

        form.addEventListener("submit", function (e) {
            const checks = checkPasswordRequirements();
            const allValid = Object.values(checks).every(Boolean);

            if (!allValid) {
                e.preventDefault(); // blocca l'invio del form
                alert("La password non soddisfa tutti i requisiti. Per favore, controlla il feedback.");
            }
        });
    });
</script>

</body>
</html>