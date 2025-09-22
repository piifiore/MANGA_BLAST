-- =============================================
-- MANGA BLAST - Reset Database Script
-- Svuota tutte le tabelle per ricominciare da zero
-- =============================================

-- Disabilita controlli foreign key temporaneamente
SET FOREIGN_KEY_CHECKS = 0;

-- Svuota tutte le tabelle in ordine corretto
-- (dalle tabelle dipendenti a quelle indipendenti)

-- 1. Tabelle di relazione e dipendenze
TRUNCATE TABLE `recensioni_like`;
TRUNCATE TABLE `recensioni`;
TRUNCATE TABLE `carrello_contiene_funko`;
TRUNCATE TABLE `carrello_contiene_manga`;
TRUNCATE TABLE `ordine_include_funko`;
TRUNCATE TABLE `ordine_include_manga`;
TRUNCATE TABLE `ordine_dettagli`;
TRUNCATE TABLE `preferiti`;

-- 2. Tabelle principali
TRUNCATE TABLE `ordini`;
TRUNCATE TABLE `carrelli`;
TRUNCATE TABLE `carte_pagamento`;
TRUNCATE TABLE `utenti`;
TRUNCATE TABLE `admin`;

-- 3. Tabelle prodotti
TRUNCATE TABLE `funko`;
TRUNCATE TABLE `manga`;

-- 4. Tabelle categorie (nuove)
TRUNCATE TABLE `sottocategorie`;
TRUNCATE TABLE `categorie`;

-- Riabilita controlli foreign key
SET FOREIGN_KEY_CHECKS = 1;

-- Reset degli auto-increment
ALTER TABLE `ordini` AUTO_INCREMENT = 1;
ALTER TABLE `categorie` AUTO_INCREMENT = 1;
ALTER TABLE `sottocategorie` AUTO_INCREMENT = 1;
ALTER TABLE `recensioni` AUTO_INCREMENT = 1;
ALTER TABLE `recensioni_like` AUTO_INCREMENT = 1;

-- =============================================
-- INSERIMENTO DATI INIZIALI
-- =============================================

-- Admin di default
INSERT INTO `admin` (`email`, `password`) VALUES
('admin@mangablast.it', 'admin123'),
('admin2@mangablast.it', 'admin456');

-- Gli utenti esistenti vengono mantenuti (non vengono toccati)

-- Database pulito - nessun dato iniziale per categorie e prodotti
-- Le categorie e i prodotti verranno aggiunti tramite l'interfaccia admin

-- =============================================
-- FINE RESET DATABASE
-- =============================================

-- Mostra statistiche finali
SELECT 'Database resettato con successo!' as Status;
SELECT COUNT(*) as 'Categorie create' FROM categorie;
SELECT COUNT(*) as 'Sottocategorie create' FROM sottocategorie;
SELECT COUNT(*) as 'Manga inseriti' FROM manga;
SELECT COUNT(*) as 'Funko inseriti' FROM funko;
SELECT COUNT(*) as 'Utenti creati' FROM utenti;
SELECT COUNT(*) as 'Admin creati' FROM admin;
