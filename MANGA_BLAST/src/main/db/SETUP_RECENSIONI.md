# 🗄️ Setup Sistema Recensioni

## 📋 Panoramica

Il sistema di recensioni richiede due nuove tabelle nel database:

1. **`recensioni`** - Memorizza le recensioni degli utenti
2. **`recensioni_like`** - Per future funzionalità di like/dislike

## 🚀 Installazione

### Opzione 1: Script Automatico (Raccomandato)

Esegui il file SQL fornito:

```sql
-- Esegui questo file nel tuo database MySQL
source src/main/db/setup_recensioni.sql;
```

### Opzione 2: Comandi Manuali

Se preferisci eseguire i comandi manualmente:

```sql
-- 1. Crea la tabella recensioni
CREATE TABLE IF NOT EXISTS `recensioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` varchar(255) NOT NULL,
  `tipo_prodotto` enum('manga','funko') NOT NULL,
  `email_utente` varchar(255) NOT NULL,
  `rating` int NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
  `titolo` varchar(255),
  `commento` text,
  `data_recensione` timestamp DEFAULT CURRENT_TIMESTAMP,
  `moderata` boolean DEFAULT FALSE,
  `attiva` boolean DEFAULT TRUE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`email_utente`) REFERENCES `utenti`(`email`) ON DELETE CASCADE,
  UNIQUE KEY `recensione_unica` (`email_utente`, `id_prodotto`, `tipo_prodotto`),
  INDEX `idx_prodotto` (`id_prodotto`, `tipo_prodotto`),
  INDEX `idx_utente` (`email_utente`),
  INDEX `idx_data` (`data_recensione`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. Crea la tabella recensioni_like (opzionale)
CREATE TABLE IF NOT EXISTS `recensioni_like` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_recensione` int NOT NULL,
  `email_utente` varchar(255) NOT NULL,
  `tipo` enum('like','dislike') NOT NULL,
  `data_like` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_recensione`) REFERENCES `recensioni`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`email_utente`) REFERENCES `utenti`(`email`) ON DELETE CASCADE,
  UNIQUE KEY `like_unico` (`id_recensione`, `email_utente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## ✅ Verifica Installazione

Dopo l'esecuzione, verifica che le tabelle siano state create:

```sql
-- Mostra le tabelle
SHOW TABLES LIKE 'recensioni%';

-- Verifica la struttura
DESCRIBE recensioni;
DESCRIBE recensioni_like;
```

## 🔧 Struttura Tabelle

### Tabella `recensioni`

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | int | Chiave primaria auto-incrementale |
| `id_prodotto` | varchar(255) | ID del prodotto (ISBN per manga, numeroSerie per funko) |
| `tipo_prodotto` | enum | 'manga' o 'funko' |
| `email_utente` | varchar(255) | Email dell'utente che ha scritto la recensione |
| `rating` | int | Voto da 1 a 5 stelle |
| `titolo` | varchar(255) | Titolo della recensione (opzionale) |
| `commento` | text | Testo della recensione |
| `data_recensione` | timestamp | Data e ora di creazione |
| `moderata` | boolean | Se la recensione è stata moderata |
| `attiva` | boolean | Se la recensione è attiva (soft delete) |

### Tabella `recensioni_like`

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | int | Chiave primaria auto-incrementale |
| `id_recensione` | int | ID della recensione |
| `email_utente` | varchar(255) | Email dell'utente che ha messo like/dislike |
| `tipo` | enum | 'like' o 'dislike' |
| `data_like` | timestamp | Data e ora del like/dislike |

## 🔒 Vincoli e Sicurezza

- **Vincolo unico**: Un utente può recensire un prodotto solo una volta
- **Foreign Key**: Le recensioni sono collegate agli utenti esistenti
- **Soft Delete**: Le recensioni vengono disattivate invece di essere eliminate
- **Validazione**: Il rating deve essere tra 1 e 5
- **Indici**: Ottimizzazione per query frequenti

## 🚨 Note Importanti

1. **Backup**: Fai sempre un backup del database prima di eseguire script
2. **Permessi**: Assicurati di avere i permessi per creare tabelle
3. **Charset**: Le tabelle usano utf8mb4 per supportare emoji
4. **Engine**: InnoDB per supportare transazioni e foreign key

## 🎯 Funzionalità Supportate

Dopo l'installazione, il sistema supporta:

- ✅ Recensioni con stelle (1-5)
- ✅ Commenti testuali
- ✅ Una recensione per utente per prodotto
- ✅ Visualizzazione recensioni per prodotto
- ✅ Gestione recensioni nel profilo utente
- ✅ Statistiche (media voti, numero recensioni)
- ✅ Modifica/eliminazione recensioni proprie

## 🆘 Risoluzione Problemi

### Errore: "Table already exists"
```sql
-- Se le tabelle esistono già, puoi saltare la creazione
-- oppure usare DROP TABLE se vuoi ricrearle
DROP TABLE IF EXISTS recensioni_like;
DROP TABLE IF EXISTS recensioni;
```

### Errore: "Foreign key constraint fails"
```sql
-- Verifica che la tabella utenti esista
SHOW TABLES LIKE 'utenti';
DESCRIBE utenti;
```

### Errore: "Access denied"
```sql
-- Verifica i permessi del tuo utente MySQL
SHOW GRANTS FOR CURRENT_USER();
```
