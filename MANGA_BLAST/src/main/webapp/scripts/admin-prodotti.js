function ajaxSearch(tipo) {
    const query = document.getElementById(tipo + "Search").value;
    const min = document.getElementById(tipo + "Min").value;
    const max = document.getElementById(tipo + "Max").value;
    const sort = document.getElementById(tipo + "Sort").value;

    const xhr = new XMLHttpRequest();
    xhr.open("GET", "CercaProdottiServlet?tipo=" + tipo +
        "&query=" + encodeURIComponent(query) +
        "&min=" + min +
        "&max=" + max +
        "&sort=" + sort, true);
    xhr.onload = function() {
        if (xhr.status === 200) {
            document.getElementById(tipo + "Results").innerHTML = xhr.responseText;
        }
    };
    xhr.send();
}

// Event listeners
["Search", "Min", "Max", "Sort"].forEach(field => {
    document.getElementById("manga" + field).addEventListener("input", () => ajaxSearch("manga"));
    document.getElementById("funko" + field).addEventListener("input", () => ajaxSearch("funko"));
});

// Load all on start
window.addEventListener("load", function() {
    ajaxSearch("manga");
    ajaxSearch("funko");
});