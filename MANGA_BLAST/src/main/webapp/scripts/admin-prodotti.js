document.addEventListener("DOMContentLoaded", () => {
    const wrapper = document.querySelector(".admin-prodotti-wrapper");

    if (wrapper) {
        wrapper.style.opacity = "0";
        wrapper.style.transform = "translateY(20px)";
        wrapper.style.transition = "opacity 0.5s ease, transform 0.5s ease";

        setTimeout(() => {
            wrapper.style.opacity = "1";
            wrapper.style.transform = "translateY(0)";
        }, 100);
    }

    const formGroups = document.querySelectorAll(".form-group input, .form-group textarea");
    formGroups.forEach(input => {
        input.addEventListener("focus", () => {
            input.style.boxShadow = "0 0 8px #EF5350";
        });
        input.addEventListener("blur", () => {
            input.style.boxShadow = "none";
        });
    });

    // VALIDAZIONE FORM AGGIUNTA MANGA E FUNKO
    function showError(input, message) {
        let err = input.parentElement.querySelector('.error-msg');
        if (!err) {
            err = document.createElement('div');
            err.className = 'error-msg';
            err.style.color = '#c62828';
            err.style.fontSize = '0.95em';
            err.style.marginTop = '0.2em';
            input.parentElement.appendChild(err);
        }
        err.textContent = message;
        input.classList.add('input-error');
    }
    function clearError(input) {
        let err = input.parentElement.querySelector('.error-msg');
        if (err) err.remove();
        input.classList.remove('input-error');
    }

    // Validazione rimossa - ora gestita nella pagina di verifica
    // Validazione rimossa - ora gestita nella pagina di verifica

    // Event listeners per validazione rimossi - ora gestiti nella pagina di verifica

    // AJAX per filtri Manga
    const mangaSearchForm = document.querySelector('form input[name="tipo"][value="manga"]').closest('form');
    if (mangaSearchForm) {
        mangaSearchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const params = new URLSearchParams();
            for (let [key, value] of formData.entries()) {
                params.append(key, value);
            }
            fetch('CercaProdottiServlet?' + params.toString(), {
                method: 'GET',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(res => res.text())
            .then(html => {
                const grid = document.getElementById('ajax-manga-grid');
                if (grid) grid.innerHTML = html;
            });
        });
    }

    // AJAX per filtri Funko
    const funkoSearchForm = document.querySelector('form input[name="tipo"][value="funko"]').closest('form');
    if (funkoSearchForm) {
        funkoSearchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const params = new URLSearchParams();
            for (let [key, value] of formData.entries()) {
                params.append(key, value);
            }
            fetch('CercaProdottiServlet?' + params.toString(), {
                method: 'GET',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(res => res.text())
            .then(html => {
                const grid = document.getElementById('ajax-funko-grid');
                if (grid) grid.innerHTML = html;
            });
        });
    }
    
    // GESTIONE CATEGORIE E SOTTOCATEGORIE
    // Sottocategorie rimosse - sistema semplificato
});
