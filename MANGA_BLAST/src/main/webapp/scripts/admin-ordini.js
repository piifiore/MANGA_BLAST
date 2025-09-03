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
        
        // Aggiungi event listener per i pulsanti di archiviazione
        aggiungiEventListenersArchiviazione();
    };
    xhr.send();
}

function caricaOrdiniArchiviati() {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", "OrderManagementServlet?stato=Archiviato", true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onload = function() {
        document.getElementById("ordiniArchiviatiContainer").innerHTML = xhr.responseText;
        
        // Aggiungi event listener per i pulsanti di rimozione
        aggiungiEventListenersRimozione();
    };
    xhr.send();
}

function aggiungiEventListenersArchiviazione() {
    // Trova tutti i pulsanti di archiviazione
    const archiviaButtons = document.querySelectorAll('.archivia-btn');
    
    archiviaButtons.forEach(button => {
        // Rimuovi event listener esistenti per evitare duplicati
        button.removeEventListener('click', handleArchiviazione);
        // Aggiungi nuovo event listener
        button.addEventListener('click', handleArchiviazione);
    });
}

function aggiungiEventListenersRimozione() {
    // Trova tutti i pulsanti di rimozione
    const rimuoviButtons = document.querySelectorAll('.rimuovi-btn');
    
    rimuoviButtons.forEach(button => {
        // Rimuovi event listener esistenti per evitare duplicati
        button.removeEventListener('click', handleRimozione);
        // Aggiungi nuovo event listener
        button.addEventListener('click', handleRimozione);
    });
}

function handleArchiviazione(event) {
    event.preventDefault();
    
    const form = event.target.closest('form');
    const idOrdine = form.querySelector('input[name="id"]').value;
    
    // Invia richiesta di archiviazione
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "ArchiviaOrdineServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                // Prova a parsare la risposta JSON
                const response = JSON.parse(xhr.responseText);
                
                if (response.success) {
                    // Archiviazione riuscita
                    // Trova la riga dell'ordine nella tabella principale
                    const ordineRow = form.closest('tr');
                    const ordineCard = form.closest('.ordine-card');
                    
                    if (ordineRow) {
                        // Rimuovi dalla tabella principale
                        ordineRow.remove();
                    }
                    
                    if (ordineCard) {
                        // Rimuovi dalla card mobile
                        ordineCard.remove();
                    }
                    
                    // Ricarica gli ordini archiviati
                    caricaOrdiniArchiviati();
                    
                    // Mostra messaggio di successo
                    mostraMessaggioSuccesso(response.message || "Ordine archiviato con successo!");
                } else {
                    // Errore nell'archiviazione
                    mostraMessaggioErrore(response.message || "Errore durante l'archiviazione dell'ordine");
                }
            } catch (e) {
                // Se non è JSON valido, considera come successo (compatibilità)
                const ordineRow = form.closest('tr');
                const ordineCard = form.closest('.ordine-card');
                
                if (ordineRow) {
                    ordineRow.remove();
                }
                
                if (ordineCard) {
                    ordineCard.remove();
                }
                
                caricaOrdiniArchiviati();
                mostraMessaggioSuccesso("Ordine archiviato con successo!");
            }
        } else {
            // Errore HTTP
            mostraMessaggioErrore("Errore durante l'archiviazione dell'ordine");
        }
    };
    
    xhr.onerror = function() {
        mostraMessaggioErrore("Errore di connessione durante l'archiviazione");
    };
    
    xhr.send("id=" + encodeURIComponent(idOrdine));
}

function handleRimozione(event) {
    event.preventDefault();
    
    if (!confirm('Sei sicuro di voler rimuovere definitivamente questo ordine? Questa azione non può essere annullata.')) {
        return;
    }
    
    const form = event.target.closest('form');
    const idOrdine = form.querySelector('input[name="id"]').value;
    
    // Invia richiesta di rimozione
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "RimuoviOrdineServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                // Prova a parsare la risposta JSON
                const response = JSON.parse(xhr.responseText);
                
                if (response.success) {
                    // Rimozione riuscita
                    // Trova la riga dell'ordine nella tabella degli archiviati
                    const ordineRow = form.closest('tr');
                    const ordineCard = form.closest('.ordine-card');
                    
                    if (ordineRow) {
                        // Rimuovi dalla tabella degli archiviati
                        ordineRow.remove();
                    }
                    
                    if (ordineCard) {
                        // Rimuovi dalla card mobile
                        ordineCard.remove();
                    }
                    
                    // Mostra messaggio di successo
                    mostraMessaggioSuccesso(response.message || "Ordine rimosso con successo!");
                    
                    // Se non ci sono più ordini archiviati, mostra il messaggio vuoto
                    const tbody = document.querySelector('#ordiniArchiviatiContainer tbody');
                    const cards = document.querySelectorAll('#ordiniArchiviatiContainer .ordine-card');
                    
                    if (tbody && tbody.children.length === 0) {
                        document.getElementById('ordiniArchiviatiContainer').innerHTML = '<p class="empty-message">Nessun ordine archiviato trovato.</p>';
                    } else if (cards.length === 0) {
                        document.getElementById('ordiniArchiviatiContainer').innerHTML = '<p class="empty-message">Nessun ordine archiviato trovato.</p>';
                    }
                } else {
                    // Errore nella rimozione
                    mostraMessaggioErrore(response.message || "Errore durante la rimozione dell'ordine");
                }
            } catch (e) {
                // Se non è JSON valido, considera come successo (compatibilità)
                const ordineRow = form.closest('tr');
                const ordineCard = form.closest('.ordine-card');
                
                if (ordineRow) {
                    ordineRow.remove();
                }
                
                if (ordineCard) {
                    ordineCard.remove();
                }
                
                mostraMessaggioSuccesso("Ordine rimosso con successo!");
            }
        } else {
            // Errore HTTP
            mostraMessaggioErrore("Errore durante la rimozione dell'ordine");
        }
    };
    
    xhr.onerror = function() {
        mostraMessaggioErrore("Errore di connessione durante la rimozione");
    };
    
    xhr.send("id=" + encodeURIComponent(idOrdine));
}

function mostraMessaggioSuccesso(messaggio) {
    const messaggioDiv = document.createElement('div');
    messaggioDiv.className = 'messaggio-successo';
    messaggioDiv.textContent = messaggio;
    document.body.appendChild(messaggioDiv);
    
    // Rimuovi il messaggio dopo 3 secondi
    setTimeout(() => {
        messaggioDiv.remove();
    }, 3000);
}

function mostraMessaggioErrore(messaggio) {
    const messaggioDiv = document.createElement('div');
    messaggioDiv.className = 'messaggio-errore';
    messaggioDiv.textContent = messaggio;
    document.body.appendChild(messaggioDiv);
    
    // Rimuovi il messaggio dopo 3 secondi
    setTimeout(() => {
        messaggioDiv.remove();
    }, 3000);
}

["searchEmail", "filterStato", "ordina", "dataDa", "dataA"].forEach(id => {
    document.getElementById(id).addEventListener("input", caricaOrdini);
});

window.addEventListener("load", function() {
    caricaOrdini();
    caricaOrdiniArchiviati();
});