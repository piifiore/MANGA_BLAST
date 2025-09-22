// JavaScript per la pagina di verifica prodotto
document.addEventListener('DOMContentLoaded', function() {
    // I dati vengono letti dalla pagina JSP, non dall'URL
    const tipo = document.querySelector('input[name="tipo"]')?.value || 
                 document.querySelector('.dato-item:nth-child(1) .dato-value')?.textContent?.includes('ISBN') ? 'manga' : 'funko';
    
    if (!tipo) {
        window.location.href = 'admin-prodotti.jsp';
        return;
    }
    
    // Esegui validazione automatica al caricamento
    eseguiValidazione(tipo);
});

function eseguiValidazione(tipo) {
    const risultatiContainer = document.getElementById('validazione-risultati');
    risultatiContainer.innerHTML = '';
    
    const dati = ottieniDatiProdotto(tipo);
    const validazioni = [];
    
    if (tipo === 'manga') {
        validazioni.push(
            validaISBN(dati.isbn),
            validaNome(dati.nome),
            validaDescrizione(dati.descrizione),
            validaPrezzo(dati.prezzo),
            validaCategoria(dati.categoria),
            validaSottocategoria(dati.sottocategoria)
        );
    } else if (tipo === 'funko') {
        validazioni.push(
            validaNumeroSerie(dati.numeroSerie),
            validaNome(dati.nome),
            validaDescrizione(dati.descrizione),
            validaPrezzo(dati.prezzo),
            validaCategoria(dati.categoria),
            validaSottocategoria(dati.sottocategoria)
        );
    }
    
    // Mostra risultati
    validazioni.forEach(validazione => {
        const item = document.createElement('div');
        item.className = `validazione-item ${validazione.tipo}`;
        
        const icon = document.createElement('span');
        icon.className = 'validazione-icon';
        icon.textContent = validazione.tipo === 'success' ? '✅' : 
                          validazione.tipo === 'error' ? '❌' : '⚠️';
        
        const message = document.createElement('span');
        message.className = 'validazione-message';
        message.textContent = validazione.messaggio;
        
        item.appendChild(icon);
        item.appendChild(message);
        risultatiContainer.appendChild(item);
    });
    
    // Abilita/disabilita pulsante conferma
    const btnConfirm = document.querySelector('.btn-confirm');
    const hasErrors = validazioni.some(v => v.tipo === 'error');
    btnConfirm.disabled = hasErrors;
    
    if (hasErrors) {
        btnConfirm.style.opacity = '0.5';
        btnConfirm.style.cursor = 'not-allowed';
    } else {
        btnConfirm.style.opacity = '1';
        btnConfirm.style.cursor = 'pointer';
    }
}

function ottieniDatiProdotto(tipo) {
    const dati = {};
    
    if (tipo === 'manga') {
        dati.isbn = document.querySelector('.dato-item:nth-child(1) .dato-value').textContent;
        dati.nome = document.querySelector('.dato-item:nth-child(2) .dato-value').textContent;
        dati.descrizione = document.querySelector('.dato-item:nth-child(3) .dato-value').textContent;
        dati.prezzo = document.querySelector('.dato-item:nth-child(4) .dato-value').textContent.replace('€', '');
        dati.categoria = document.querySelector('.dato-item:nth-child(5) .dato-value').textContent;
        dati.sottocategoria = document.querySelector('.dato-item:nth-child(6) .dato-value').textContent;
    } else if (tipo === 'funko') {
        dati.numeroSerie = document.querySelector('.dato-item:nth-child(1) .dato-value').textContent;
        dati.nome = document.querySelector('.dato-item:nth-child(2) .dato-value').textContent;
        dati.descrizione = document.querySelector('.dato-item:nth-child(3) .dato-value').textContent;
        dati.prezzo = document.querySelector('.dato-item:nth-child(4) .dato-value').textContent.replace('€', '');
        dati.categoria = document.querySelector('.dato-item:nth-child(5) .dato-value').textContent;
        dati.sottocategoria = document.querySelector('.dato-item:nth-child(6) .dato-value').textContent;
    }
    
    return dati;
}

// Funzioni di validazione
function validaISBN(isbn) {
    if (!isbn || isbn.trim() === '') {
        return { tipo: 'error', messaggio: 'ISBN è obbligatorio' };
    }
    if (!/^\d{10,13}$/.test(isbn.trim())) {
        return { tipo: 'error', messaggio: 'ISBN deve essere 10-13 cifre' };
    }
    return { tipo: 'success', messaggio: 'ISBN valido' };
}

function validaNumeroSerie(numeroSerie) {
    if (!numeroSerie || numeroSerie.trim() === '') {
        return { tipo: 'error', messaggio: 'Numero serie è obbligatorio' };
    }
    if (!/^\w{2,}$/.test(numeroSerie.trim())) {
        return { tipo: 'error', messaggio: 'Numero serie deve essere almeno 2 caratteri alfanumerici' };
    }
    return { tipo: 'success', messaggio: 'Numero serie valido' };
}

function validaNome(nome) {
    if (!nome || nome.trim() === '') {
        return { tipo: 'error', messaggio: 'Nome è obbligatorio' };
    }
    if (nome.trim().length < 2) {
        return { tipo: 'error', messaggio: 'Nome deve essere almeno 2 caratteri' };
    }
    return { tipo: 'success', messaggio: 'Nome valido' };
}

function validaDescrizione(descrizione) {
    if (!descrizione || descrizione.trim() === '') {
        return { tipo: 'error', messaggio: 'Descrizione è obbligatoria' };
    }
    if (descrizione.trim().length < 5) {
        return { tipo: 'error', messaggio: 'Descrizione deve essere almeno 5 caratteri' };
    }
    return { tipo: 'success', messaggio: 'Descrizione valida' };
}

function validaPrezzo(prezzo) {
    if (!prezzo || prezzo.trim() === '') {
        return { tipo: 'error', messaggio: 'Prezzo è obbligatorio' };
    }
    const prezzoNum = parseFloat(prezzo);
    if (isNaN(prezzoNum) || prezzoNum <= 0) {
        return { tipo: 'error', messaggio: 'Prezzo deve essere un numero positivo' };
    }
    if (!/^\d+(\.\d{1,2})?$/.test(prezzo)) {
        return { tipo: 'warning', messaggio: 'Prezzo formattato correttamente (max 2 decimali)' };
    }
    return { tipo: 'success', messaggio: 'Prezzo valido' };
}

function validaCategoria(categoria) {
    if (!categoria || categoria.trim() === '' || categoria === 'Seleziona categoria') {
        return { tipo: 'error', messaggio: 'Categoria è obbligatoria' };
    }
    return { tipo: 'success', messaggio: 'Categoria selezionata' };
}

function validaSottocategoria(sottocategoria) {
    if (!sottocategoria || sottocategoria.trim() === '' || sottocategoria === 'Seleziona sottocategoria') {
        return { tipo: 'error', messaggio: 'Sottocategoria è obbligatoria' };
    }
    return { tipo: 'success', messaggio: 'Sottocategoria selezionata' };
}

// Funzioni per i pulsanti
function confermaAggiunta() {
    const tipo = document.querySelector('input[name="tipo"]')?.value || 
                 document.querySelector('.dato-item:nth-child(1) .dato-value')?.textContent?.includes('ISBN') ? 'manga' : 'funko';
    const btnConfirm = document.querySelector('.btn-confirm');
    
    if (btnConfirm.disabled) {
        return;
    }
    
    // Mostra loading
    btnConfirm.innerHTML = '⏳ Aggiungendo...';
    btnConfirm.disabled = true;
    
    // Invia i dati al servlet appropriato
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = tipo === 'manga' ? 'AggiungiMangaServlet' : 'AggiungiFunkoServlet';
    
    const dati = ottieniDatiProdotto(tipo);
    
    // Aggiungi tutti i campi al form
    Object.keys(dati).forEach(key => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = mappaNomeCampo(key, tipo);
        input.value = dati[key];
        form.appendChild(input);
    });
    
    document.body.appendChild(form);
    form.submit();
}

function modificaDati() {
    // Torna alla pagina admin-prodotti
    window.location.href = 'admin-prodotti.jsp';
}

function annullaOperazione() {
    // Conferma prima di annullare
    if (confirm('Sei sicuro di voler annullare? Tutti i dati inseriti andranno persi.')) {
        window.location.href = 'admin-prodotti.jsp';
    }
}

function mappaNomeCampo(key, tipo) {
    const mappature = {
        'manga': {
            'isbn': 'ISBN',
            'nome': 'nome',
            'descrizione': 'descrizione',
            'prezzo': 'prezzo',
            'categoria': 'id_categoria',
            'sottocategoria': 'id_sottocategoria'
        },
        'funko': {
            'numeroSerie': 'numeroSerie',
            'nome': 'nome',
            'descrizione': 'descrizione',
            'prezzo': 'prezzo',
            'categoria': 'id_categoria',
            'sottocategoria': 'id_sottocategoria'
        }
    };
    
    return mappature[tipo][key] || key;
}
