function caricaOrdini() {
    const email = document.getElementById("searchEmail").value;
    const stato = document.getElementById("filterStato").value;
    const sort = document.getElementById("ordina").value;

    const xhr = new XMLHttpRequest();
    xhr.open("GET", "OrderManagementServlet?email=" + encodeURIComponent(email) + "&stato=" + stato + "&sort=" + sort, true);
    xhr.onload = function() {
        document.getElementById("ordiniContainer").innerHTML = xhr.responseText;
    };
    xhr.send();
}

["searchEmail", "filterStato", "ordina"].forEach(id => {
    document.getElementById(id).addEventListener("input", caricaOrdini);
});
window.addEventListener("load", caricaOrdini);