document.getElementById("SignUpForm").addEventListener("submit", function(event) {
    let email = document.getElementById("email").value.trim();
    let password = document.getElementById("password").value.trim();
    let msg = document.getElementById("signupMessage");

    if (password.length < 5) {
        event.preventDefault();
        msg.textContent = " La password deve contenere almeno 5 caratteri!";
    } else if (!email.match(/^\S+@\S+\.\S+$/)) {
        event.preventDefault();
        msg.textContent = "Inserisci un'email valida!";
    } else {
        msg.textContent = "";
    }

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
                e.preventDefault();
                alert("La password non soddisfa tutti i requisiti. Per favore, controlla il feedback.");
            }
        });
    });
});
