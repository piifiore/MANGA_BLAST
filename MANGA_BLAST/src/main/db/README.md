# 🗄️ Database Scripts - MangaBlast

## 📋 Script Disponibili

### 1. `reset_database.sql` - Reset Completo
**Cosa fa:**
- Svuota tutte le tabelle del database
- Inserisce dati iniziali (admin, categorie, sottocategorie, prodotti di esempio)
- Reset degli auto-increment

**Quando usarlo:**
- Quando vuoi ricominciare da zero
- Per testare il sistema con dati puliti
- Dopo aver fatto modifiche strutturali al database

**Come usarlo:**
```sql
-- Esegui questo script in MySQL Workbench o phpMyAdmin
SOURCE reset_database.sql;
```

### 2. `clear_database.sql` - Solo Svuotamento
**Cosa fa:**
- Svuota tutte le tabelle del database
- NON inserisce dati iniziali
- Reset degli auto-increment

**Quando usarlo:**
- Quando vuoi solo svuotare il database
- Per testare con dati personalizzati
- Per pulire il database senza dati di esempio

**Come usarlo:**
```sql
-- Esegui questo script in MySQL Workbench o phpMyAdmin
SOURCE clear_database.sql;
```

### 3. `updates_safe.sql` - Aggiornamenti Schema
**Cosa fa:**
- Crea tabelle categorie e sottocategorie
- Crea tabelle recensioni
- Aggiunge colonne ai prodotti esistenti
- Inserisce dati iniziali per categorie

**Quando usarlo:**
- Per aggiornare un database esistente
- Per aggiungere le nuove funzionalità a un database già popolato

## 🚀 Procedura Consigliata

### Per Ricominciare da Zero:
1. **Esegui `reset_database.sql`** - Ti darà un database pulito con dati di esempio
2. **Testa le funzionalità** - Verifica che tutto funzioni
3. **Aggiungi i tuoi prodotti** - Usa l'interfaccia admin per aggiungere i tuoi prodotti

### Per Aggiornare Database Esistente:
1. **Fai backup** del database esistente
2. **Esegui `updates_safe.sql`** - Aggiunge le nuove funzionalità
3. **Testa le funzionalità** - Verifica che tutto funzioni

## 📊 Dati Iniziali Inclusi

### Admin:
- `admin@mangablast.it` / `admin123`
- `admin2@mangablast.it` / `admin456`

### Utenti di Esempio:
- `mario.rossi@email.com` / `password123`
- `giulia.bianchi@email.com` / `password456`
- `luca.verdi@email.com` / `password789`
- `anna.neri@email.com` / `password321`
- `marco.ferrari@email.com` / `password654`

### Categorie (3 totali):
- **Horror**: Manga e Funko horror e thriller
- **Fantasy**: Manga e Funko fantasy e magia  
- **Romance**: Manga e Funko romantici

### Sottocategorie (12 totali):
- **Horror (4)**: Supernatural Horror, Psychological Horror, Gore, Classic Horror
- **Fantasy (4)**: High Fantasy, Urban Fantasy, Dark Fantasy, Magical Fantasy
- **Romance (4)**: School Romance, Adult Romance, Fantasy Romance, Historical Romance

### Prodotti di Esempio:
- **Nessun prodotto iniziale** - Aggiungi tramite l'interfaccia admin

## ⚠️ Avvertenze

- **Fai sempre backup** prima di eseguire gli script
- **Testa in ambiente di sviluppo** prima di usare in produzione
- **Verifica le connessioni** al database prima di eseguire
- **Controlla i permessi** del database

## 🔧 Risoluzione Problemi

### Errore "Table doesn't exist":
- Esegui prima `updates_safe.sql` per creare le tabelle

### Errore "Foreign key constraint":
- Gli script disabilitano temporaneamente i controlli foreign key

### Errore "Access denied":
- Verifica le credenziali del database
- Controlla i permessi dell'utente MySQL

## 📞 Supporto

Se hai problemi con gli script, controlla:
1. **Log del database** per errori specifici
2. **Connessione** al database
3. **Permessi** dell'utente MySQL
4. **Versione** di MySQL (richiede 8.0+)
