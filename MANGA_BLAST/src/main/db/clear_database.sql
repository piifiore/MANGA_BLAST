-- =============================================
-- MANGA BLAST - Clear Database Script
-- Svuota solo le tabelle senza inserire dati
-- =============================================

-- Disabilita controlli foreign key temporaneamente
SET FOREIGN_KEY_CHECKS = 0;

-- Svuota tutte le tabelle in ordine corretto
TRUNCATE TABLE `recensioni_like`;
TRUNCATE TABLE `recensioni`;
TRUNCATE TABLE `carrello_contiene_funko`;
TRUNCATE TABLE `carrello_contiene_manga`;
TRUNCATE TABLE `ordine_include_funko`;
TRUNCATE TABLE `ordine_include_manga`;
TRUNCATE TABLE `ordine_dettagli`;
TRUNCATE TABLE `preferiti`;
TRUNCATE TABLE `ordini`;
TRUNCATE TABLE `carrelli`;
TRUNCATE TABLE `carte_pagamento`;
TRUNCATE TABLE `utenti`;
TRUNCATE TABLE `admin`;
TRUNCATE TABLE `funko`;
TRUNCATE TABLE `manga`;
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

SELECT 'Database svuotato con successo!' as Status;
