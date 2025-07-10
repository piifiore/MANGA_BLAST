document.addEventListener("DOMContentLoaded", () => {
    const logoutForms = document.querySelectorAll("form.logout");

    logoutForms.forEach(form => {
        form.addEventListener("submit", (e) => {
            const confirmed = confirm("Sei sicuro di voler effettuare il logout?");
            if (!confirmed) {
                e.preventDefault();
            }
        });
    });
});
