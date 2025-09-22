-- =============================================
-- MANGA BLAST - Setup Sistema Recensioni
-- =============================================

-- Tabella recensioni
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

-- Tabella recensioni_like (opzionale per future funzionalità)
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

-- =============================================
-- VERIFICA SETUP
-- =============================================

-- Mostra le tabelle create
SHOW TABLES LIKE 'recensioni%';

-- Mostra la struttura della tabella recensioni
DESCRIBE recensioni;

-- Mostra la struttura della tabella recensioni_like
DESCRIBE recensioni_like;
