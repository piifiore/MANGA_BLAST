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
});
