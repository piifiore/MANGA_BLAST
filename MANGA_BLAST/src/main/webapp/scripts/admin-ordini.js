function caricaOrdini() {
    const email = document.getElementById("searchEmail").value;
    const stato = document.getElementById("filterStato").value;
    const sort = document.getElementById("ordina").value;
    const dataDa = document.getElementById("dataDa").value;
    const dataA = document.getElementById("dataA").value;

    const xhr = new XMLHttpRequest();
    xhr.open("GET", "OrderManagementServlet?email=" + encodeURIComponent(email) + "&stato=" + stato + "&sort=" + sort + "&dataDa=" + dataDa + "&dataA=" + dataA, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onload = function() {
        document.getElementById("ordiniContainer").innerHTML = xhr.responseText;
        
        // Mostra/nascondi sezione ordini archiviati
        const archiviatiSection = document.getElementById("ordiniArchiviatiSection");
        if (archiviatiSection) {
            if (stato === "Archiviato") {
                archiviatiSection.style.display = "none";
            } else {
                archiviatiSection.style.display = "block";
            }
        }
    };
    xhr.send();
}

function caricaOrdiniArchiviati() {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", "OrderManagementServlet?stato=Archiviato", true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onload = function() {
        document.getElementById("ordiniArchiviatiContainer").innerHTML = xhr.responseText;
    };
    xhr.send();
}

["searchEmail", "filterStato", "ordina", "dataDa", "dataA"].forEach(id => {
    document.getElementById(id).addEventListener("input", caricaOrdini);
});

window.addEventListener("load", function() {
    caricaOrdini();
    caricaOrdiniArchiviati();
});