function ajaxSearch(tipo) {
    const queryEl = document.getElementById(tipo + "Search");
    const minEl = document.getElementById(tipo + "Min");
    const maxEl = document.getElementById(tipo + "Max");
    const sortEl = document.getElementById(tipo + "Sort");

    const query = queryEl ? queryEl.value : "";
    const min = minEl ? minEl.value : "";
    const max = maxEl ? maxEl.value : "";
    const sort = sortEl ? sortEl.value : "";

    const url = "CercaProdottiServlet?tipo=" + tipo +
        "&query=" + encodeURIComponent(query) +
        "&min=" + min +
        "&max=" + max +
        "&sort=" + sort;

    console.log("🔎 Richiesta AJAX:", tipo, url);

    const xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onload = function() {
        if (xhr.status === 200) {
            const resultEl = document.getElementById(tipo + "Results");
            if (resultEl) resultEl.innerHTML = xhr.responseText;
            console.log("✅ Risposta ricevuta per", tipo);
        } else {
            console.warn("❌ Errore nella risposta AJAX:", xhr.status);
        }
    };
    xhr.onerror = function() {
        console.error("🚨 Errore di rete nella richiesta AJAX:", tipo);
    };
    xhr.send();
}

["Search", "Min", "Max", "Sort"].forEach(field => {
    const mangaEl = document.getElementById("manga" + field);
    if (mangaEl) {
        mangaEl.addEventListener("input", () => {
            console.log("✏️ Manga - campo cambiato:", field);
            ajaxSearch("manga");
        });
    }

    const funkoEl = document.getElementById("funko" + field);
    if (funkoEl) {
        funkoEl.addEventListener("input", () => {
            console.log("✏️ Funko - campo cambiato:", field);
            ajaxSearch("funko");
        });
    }
});

window.addEventListener("load", function() {
    console.log("📦 Caricamento iniziale prodotti...");
    ajaxSearch("manga");
    ajaxSearch("funko");
});
