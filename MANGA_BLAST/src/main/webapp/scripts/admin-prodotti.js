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

    function validateMangaForm(e) {
        let valid = true;
        const isbn = document.getElementById('isbn');
        const nome = document.getElementById('nomeManga');
        const descr = document.getElementById('descrizioneManga');
        const prezzo = document.getElementById('prezzoManga');
        clearError(isbn); clearError(nome); clearError(descr); clearError(prezzo);
        if (!/^\d{10,13}$/.test(isbn.value.trim())) {
            showError(isbn, 'ISBN deve essere 10-13 cifre'); valid = false;
        }
        if (nome.value.trim().length < 2) {
            showError(nome, 'Nome troppo corto'); valid = false;
        }
        if (descr.value.trim().length < 5) {
            showError(descr, 'Descrizione troppo corta'); valid = false;
        }
        if (!/^\d+(\.\d{1,2})?$/.test(prezzo.value) || parseFloat(prezzo.value) <= 0) {
            showError(prezzo, 'Prezzo non valido'); valid = false;
        }
        if (!valid && e) e.preventDefault();
        return valid;
    }
    function validateFunkoForm(e) {
        let valid = true;
        const num = document.getElementById('numeroSerie');
        const nome = document.getElementById('nomeFunko');
        const descr = document.getElementById('descrizioneFunko');
        const prezzo = document.getElementById('prezzoFunko');
        clearError(num); clearError(nome); clearError(descr); clearError(prezzo);
        if (!/^\w{2,}$/.test(num.value.trim())) {
            showError(num, 'Numero serie obbligatorio'); valid = false;
        }
        if (nome.value.trim().length < 2) {
            showError(nome, 'Nome troppo corto'); valid = false;
        }
        if (descr.value.trim().length < 5) {
            showError(descr, 'Descrizione troppo corta'); valid = false;
        }
        if (!/^\d+(\.\d{1,2})?$/.test(prezzo.value) || parseFloat(prezzo.value) <= 0) {
            showError(prezzo, 'Prezzo non valido'); valid = false;
        }
        if (!valid && e) e.preventDefault();
        return valid;
    }

    const mangaForm = document.querySelector('form[action="AggiungiMangaServlet"]');
    if (mangaForm) {
        mangaForm.addEventListener('submit', validateMangaForm);
        ['isbn','nomeManga','descrizioneManga','prezzoManga'].forEach(id => {
            document.getElementById(id).addEventListener('change', validateMangaForm);
        });
    }
    const funkoForm = document.querySelector('form[action="AggiungiFunkoServlet"]');
    if (funkoForm) {
        funkoForm.addEventListener('submit', validateFunkoForm);
        ['numeroSerie','nomeFunko','descrizioneFunko','prezzoFunko'].forEach(id => {
            document.getElementById(id).addEventListener('change', validateFunkoForm);
        });
    }
});
