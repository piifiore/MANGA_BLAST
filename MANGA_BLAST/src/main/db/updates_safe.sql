-- =============================================
-- MANGA BLAST - Database Updates (Safe Version)
-- Sistema Categorie, Recensioni e Miglioramenti
-- =============================================

-- 1. SISTEMA CATEGORIE
-- =============================================

-- Tabella categorie principali
CREATE TABLE IF NOT EXISTS `categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descrizione` text,
  `immagine` varchar(255),
  `colore` varchar(7) DEFAULT '#FF6B35',
  `attiva` boolean DEFAULT TRUE,
  `data_creazione` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome_unico` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabella sottocategorie
CREATE TABLE IF NOT EXISTS `sottocategorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_categoria` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descrizione` text,
  `attiva` boolean DEFAULT TRUE,
  `data_creazione` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_categoria`) REFERENCES `categorie`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `nome_categoria_unico` (`nome`, `id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. SISTEMA RECENSIONI
-- =============================================

-- Tabella recensioni
CREATE TABLE IF NOT EXISTS `recensioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` int NOT NULL,
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
  UNIQUE KEY `recensione_unica` (`id_prodotto`, `tipo_prodotto`, `email_utente`),
  INDEX `idx_prodotto_tipo` (`id_prodotto`, `tipo_prodotto`),
  INDEX `idx_rating` (`rating`),
  INDEX `idx_data` (`data_recensione`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabella like/dislike recensioni
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

-- 3. DATI INIZIALI CATEGORIE
-- =============================================

-- Inserire categorie per Manga (solo se non esistono)
INSERT IGNORE INTO `categorie` (`nome`, `descrizione`, `colore`) VALUES
('Shonen', 'Manga per ragazzi con azione e avventura', '#FF6B35'),
('Shojo', 'Manga per ragazze con storie romantiche', '#E91E63'),
('Seinen', 'Manga per adulti con temi maturi', '#3F51B5'),
('Josei', 'Manga per donne adulte', '#9C27B0'),
('Kodomomuke', 'Manga per bambini', '#4CAF50'),
('Isekai', 'Manga di trasferimento in altri mondi', '#FF9800'),
('Slice of Life', 'Manga di vita quotidiana', '#607D8B'),
('Horror', 'Manga horror e thriller', '#795548'),
('Comedy', 'Manga comici e umoristici', '#FFC107'),
('Drama', 'Manga drammatici', '#673AB7');

-- Inserire categorie per Funko (solo se non esistono)
INSERT IGNORE INTO `categorie` (`nome`, `descrizione`, `colore`) VALUES
('Anime', 'Funko Pop di personaggi anime', '#FF6B35'),
('Marvel', 'Funko Pop Marvel e supereroi', '#E53E3E'),
('DC Comics', 'Funko Pop DC Comics', '#3182CE'),
('Star Wars', 'Funko Pop Star Wars', '#2D3748'),
('Disney', 'Funko Pop Disney', '#E53E3E'),
('Movies', 'Funko Pop di film', '#805AD5'),
('TV Shows', 'Funko Pop di serie TV', '#38A169'),
('Games', 'Funko Pop di videogiochi', '#D69E2E'),
('Music', 'Funko Pop di musicisti', '#DD6B20'),
('Sports', 'Funko Pop di sportivi', '#319795');

-- Inserire sottocategorie per Manga (solo se non esistono)
INSERT IGNORE INTO `sottocategorie` (`id_categoria`, `nome`, `descrizione`) VALUES
-- Shonen (id=1)
(1, 'Battle', 'Manga di combattimenti e battaglie'),
(1, 'Adventure', 'Manga di avventura e esplorazione'),
(1, 'Sports', 'Manga sportivi'),
(1, 'Supernatural', 'Manga con elementi soprannaturali'),

-- Shojo (id=2)
(2, 'Romance', 'Manga romantici'),
(2, 'School Life', 'Manga di vita scolastica'),
(2, 'Fantasy', 'Manga fantasy per ragazze'),
(2, 'Historical', 'Manga storici'),

-- Seinen (id=3)
(3, 'Psychological', 'Manga psicologici'),
(3, 'Crime', 'Manga di crimine e thriller'),
(3, 'Sci-Fi', 'Manga di fantascienza'),
(3, 'Philosophical', 'Manga filosofici'),

-- Isekai (id=6)
(6, 'Reincarnation', 'Manga di reincarnazione'),
(6, 'Summoning', 'Manga di evocazione'),
(6, 'Game World', 'Manga in mondi di gioco'),
(6, 'Magic', 'Manga con magia'),

-- Horror (id=8)
(8, 'Supernatural Horror', 'Horror soprannaturale'),
(8, 'Psychological Horror', 'Horror psicologico'),
(8, 'Gore', 'Manga gore e splatter'),
(8, 'Thriller', 'Manga thriller');

-- Inserire sottocategorie per Funko (solo se non esistono)
INSERT IGNORE INTO `sottocategorie` (`id_categoria`, `nome`, `descrizione`) VALUES
-- Anime (id=11)
(11, 'Naruto', 'Funko Pop Naruto'),
(11, 'Dragon Ball', 'Funko Pop Dragon Ball'),
(11, 'One Piece', 'Funko Pop One Piece'),
(11, 'Attack on Titan', 'Funko Pop Attack on Titan'),
(11, 'My Hero Academia', 'Funko Pop My Hero Academia'),

-- Marvel (id=12)
(12, 'Avengers', 'Funko Pop Avengers'),
(12, 'Spider-Man', 'Funko Pop Spider-Man'),
(12, 'X-Men', 'Funko Pop X-Men'),
(12, 'Guardians', 'Funko Pop Guardians of the Galaxy'),

-- DC Comics (id=13)
(13, 'Batman', 'Funko Pop Batman'),
(13, 'Superman', 'Funko Pop Superman'),
(13, 'Wonder Woman', 'Funko Pop Wonder Woman'),
(13, 'Justice League', 'Funko Pop Justice League'),

-- Star Wars (id=14)
(14, 'Original Trilogy', 'Funko Pop trilogia originale'),
(14, 'Prequels', 'Funko Pop prequel'),
(14, 'Sequels', 'Funko Pop sequel'),
(14, 'TV Shows', 'Funko Pop serie TV Star Wars');

-- 4. AGGIORNAMENTI TABELLE PRODOTTI
-- =============================================

-- Aggiungere colonne categoria ai prodotti esistenti
ALTER TABLE `manga` ADD COLUMN `id_categoria` int DEFAULT NULL;
ALTER TABLE `manga` ADD COLUMN `id_sottocategoria` int DEFAULT NULL;
ALTER TABLE `funko` ADD COLUMN `id_categoria` int DEFAULT NULL;
ALTER TABLE `funko` ADD COLUMN `id_sottocategoria` int DEFAULT NULL;

-- Aggiungere foreign keys
ALTER TABLE `manga` ADD FOREIGN KEY (`id_categoria`) REFERENCES `categorie`(`id`) ON DELETE SET NULL;
ALTER TABLE `manga` ADD FOREIGN KEY (`id_sottocategoria`) REFERENCES `sottocategorie`(`id`) ON DELETE SET NULL;
ALTER TABLE `funko` ADD FOREIGN KEY (`id_categoria`) REFERENCES `categorie`(`id`) ON DELETE SET NULL;
ALTER TABLE `funko` ADD FOREIGN KEY (`id_sottocategoria`) REFERENCES `sottocategorie`(`id`) ON DELETE SET NULL;

-- 5. AGGIORNAMENTI PRODOTTI ESISTENTI
-- =============================================

-- Disabilita temporaneamente safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Assegnare categorie ai manga esistenti (esempio)
UPDATE `manga` SET `id_categoria` = 1 WHERE `nome` LIKE '%One Piece%' OR `nome` LIKE '%Dragon Ball%';
UPDATE `manga` SET `id_categoria` = 2 WHERE `nome` LIKE '%Shojo%' OR `nome` LIKE '%Romance%';
UPDATE `manga` SET `id_categoria` = 6 WHERE `nome` LIKE '%Isekai%' OR `nome` LIKE '%Reincarnation%';
UPDATE `manga` SET `id_categoria` = 3 WHERE `nome` LIKE '%Berserk%' OR `nome` LIKE '%Seinen%';

-- Assegnare categorie ai funko esistenti (esempio)
UPDATE `funko` SET `id_categoria` = 11 WHERE `nome` LIKE '%Piccolo%' OR `nome` LIKE '%Goku%' OR `nome` LIKE '%Luffy%';
UPDATE `funko` SET `id_categoria` = 12 WHERE `nome` LIKE '%Marvel%' OR `nome` LIKE '%Avengers%';
UPDATE `funko` SET `id_categoria` = 14 WHERE `nome` LIKE '%Star Wars%';

-- Riabilita safe update mode
SET SQL_SAFE_UPDATES = 1;

-- 6. VISTE PER FACILITARE LE QUERY
-- =============================================

-- Vista prodotti con categorie
CREATE OR REPLACE VIEW `prodotti_con_categorie` AS
SELECT 
    'manga' as tipo,
    m.ISBN as id,
    m.nome as titolo,
    m.prezzo,
    m.immagine,
    c.nome as categoria,
    c.colore as colore_categoria,
    s.nome as sottocategoria
FROM `manga` m
LEFT JOIN `categorie` c ON m.id_categoria = c.id
LEFT JOIN `sottocategorie` s ON m.id_sottocategoria = s.id
WHERE c.attiva = TRUE OR c.attiva IS NULL

UNION ALL

SELECT 
    'funko' as tipo,
    f.NumeroSerie as id,
    f.nome as titolo,
    f.prezzo,
    f.immagine,
    c.nome as categoria,
    c.colore as colore_categoria,
    s.nome as sottocategoria
FROM `funko` f
LEFT JOIN `categorie` c ON f.id_categoria = c.id
LEFT JOIN `sottocategorie` s ON f.id_sottocategoria = s.id
WHERE c.attiva = TRUE OR c.attiva IS NULL;

-- Vista statistiche recensioni
CREATE OR REPLACE VIEW `statistiche_recensioni` AS
SELECT 
    id_prodotto,
    tipo_prodotto,
    COUNT(*) as totale_recensioni,
    AVG(rating) as rating_medio,
    MIN(rating) as rating_minimo,
    MAX(rating) as rating_massimo,
    SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as recensioni_5_stelle,
    SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as recensioni_4_stelle,
    SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as recensioni_3_stelle,
    SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as recensioni_2_stelle,
    SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as recensioni_1_stella
FROM `recensioni`
WHERE `attiva` = TRUE
GROUP BY id_prodotto, tipo_prodotto;

-- =============================================
-- FINE AGGIORNAMENTI DATABASE
-- =============================================
