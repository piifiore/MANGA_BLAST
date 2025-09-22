# 🚨 PROBLEMA IDENTIFICATO: Tabella Recensioni Mancante

## ❌ **Errore Attuale**
Il sistema di recensioni non funziona perché:
1. **La tabella `recensioni` non esiste** nel database attuale
2. **NullPointerException** nel servlet quando `action` è null

## ✅ **Soluzione**

### 1. **Esegui lo Script SQL**
Devi eseguire il file `setup_recensioni.sql` nel tuo database MySQL:

```sql
-- Apri MySQL Workbench o phpMyAdmin
-- Esegui il contenuto del file: src/main/db/setup_recensioni.sql
```

### 2. **Contenuto dello Script**
Lo script creerà:
- Tabella `recensioni` con tutti i campi necessari
- Tabella `recensioni_like` (opzionale per future funzionalità)
- Indici per ottimizzare le query
- Vincoli di integrità referenziale

### 3. **Verifica**
Dopo aver eseguito lo script, verifica che la tabella sia stata creata:
```sql
SHOW TABLES LIKE 'recensioni%';
DESCRIBE recensioni;
```

## 🔧 **Correzioni Applicate**

### ✅ **Servlet Corretto**
- Aggiunto controllo per `action` null
- Aggiunto logging dettagliato per debug
- Corretto attributo sessione da `"email"` a `"user"`

### ✅ **Frontend Corretto**
- Aggiunti campi nascosti per `id` e `tipo` prodotto
- Aggiunto logging JavaScript dettagliato
- Corretto inizializzazione recensioni

## 🚀 **Prossimi Passi**

1. **Esegui lo script SQL** `setup_recensioni.sql`
2. **Riavvia il server** per caricare le modifiche
3. **Testa il sistema di recensioni**

## 📋 **File da Eseguire**
- `src/main/db/setup_recensioni.sql` - Script per creare le tabelle

## 🧪 **Test da Eseguire**
- `http://localhost:8080/MANGA_BLAST/test-db-connection.jsp` - Verifica database
- Aggiungi una recensione su una scheda prodotto
- Controlla i log del server per debug
