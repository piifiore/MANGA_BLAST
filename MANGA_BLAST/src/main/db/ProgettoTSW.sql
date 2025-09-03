-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: progettotsw_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('admin1@mangablast.it','admin'),('admin2@mangablast.it','admin');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carte_pagamento`
--

DROP TABLE IF EXISTS `carte_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carte_pagamento` (
  `email` varchar(255) NOT NULL,
  `intestatario` varchar(60) NOT NULL,
  `numero_maschera` varchar(25) NOT NULL, -- es: **** **** **** 1234
  `last4` char(4) NOT NULL,
  `brand` varchar(20) DEFAULT NULL, -- Visa/Mastercard/Amex...
  `scadenza_mese` tinyint unsigned NOT NULL, -- 1-12
  `scadenza_anno` smallint unsigned NOT NULL, -- es: 2027
  PRIMARY KEY (`email`),
  CONSTRAINT `carte_pagamento_ibfk_1` FOREIGN KEY (`email`) REFERENCES `utenti` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carte_pagamento`
--

LOCK TABLES `carte_pagamento` WRITE;
/*!40000 ALTER TABLE `carte_pagamento` DISABLE KEYS */;
-- Esempi (facoltativi):
-- INSERT INTO `carte_pagamento` (`email`,`intestatario`,`numero_maschera`,`last4`,`brand`,`scadenza_mese`,`scadenza_anno`) VALUES
-- ('romanofiorello@gmail.com','ROMANO FIORELLO','**** **** **** 1234','1234','Visa',7,2027);
/*!40000 ALTER TABLE `carte_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrelli`
--

DROP TABLE IF EXISTS `carrelli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrelli` (
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `carrelli_ibfk_1` FOREIGN KEY (`email`) REFERENCES `utenti` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrelli`
--

LOCK TABLES `carrelli` WRITE;
/*!40000 ALTER TABLE `carrelli` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrelli` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrello_contiene_funko`
--

DROP TABLE IF EXISTS `carrello_contiene_funko`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrello_contiene_funko` (
  `email` varchar(255) NOT NULL,
  `NumeroSerie` varchar(50) NOT NULL,
  `quantita` int DEFAULT '1',
  PRIMARY KEY (`email`,`NumeroSerie`),
  KEY `NumeroSerie` (`NumeroSerie`),
  CONSTRAINT `carrello_contiene_funko_ibfk_1` FOREIGN KEY (`email`) REFERENCES `carrelli` (`email`) ON DELETE CASCADE,
  CONSTRAINT `carrello_contiene_funko_ibfk_2` FOREIGN KEY (`NumeroSerie`) REFERENCES `funko` (`NumeroSerie`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrello_contiene_funko`
--

LOCK TABLES `carrello_contiene_funko` WRITE;
/*!40000 ALTER TABLE `carrello_contiene_funko` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrello_contiene_funko` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrello_contiene_manga`
--

DROP TABLE IF EXISTS `carrello_contiene_manga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrello_contiene_manga` (
  `email` varchar(255) NOT NULL,
  `ISBN` bigint NOT NULL,
  `quantita` int DEFAULT '1',
  PRIMARY KEY (`email`,`ISBN`),
  KEY `ISBN` (`ISBN`),
  CONSTRAINT `carrello_contiene_manga_ibfk_1` FOREIGN KEY (`email`) REFERENCES `carrelli` (`email`) ON DELETE CASCADE,
  CONSTRAINT `carrello_contiene_manga_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `manga` (`ISBN`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrello_contiene_manga`
--

LOCK TABLES `carrello_contiene_manga` WRITE;
/*!40000 ALTER TABLE `carrello_contiene_manga` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrello_contiene_manga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funko`
--

DROP TABLE IF EXISTS `funko`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funko` (
  `NumeroSerie` varchar(50) NOT NULL,
  `prezzo` decimal(10,2) DEFAULT NULL,
  `immagine` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `descrizione` text,
  PRIMARY KEY (`NumeroSerie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funko`
--

LOCK TABLES `funko` WRITE;
/*!40000 ALTER TABLE `funko` DISABLE KEYS */;
INSERT INTO `funko` VALUES ('11',12.90,'images/12cea184-19c2-427b-add5-fb6ea739b343_piccolo.jpg','Piccolo','Piccolo'),('1621',35.84,'images/956f7f39-30ca-447d-95c9-ef138cb3bfb9_gear 5.jpg','Luffy Gear 5','Gear 5'),('1694',25.90,'images/89e72dce-3349-415c-b7a9-ea5dba00b743_goku ui.jpg','Goku UI','troppo forte');
/*!40000 ALTER TABLE `funko` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manga`
--

DROP TABLE IF EXISTS `manga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manga` (
  `ISBN` bigint NOT NULL,
  `prezzo` decimal(10,2) DEFAULT NULL,
  `immagine` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `descrizione` text,
  PRIMARY KEY (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manga`
--

LOCK TABLES `manga` WRITE;
/*!40000 ALTER TABLE `manga` DISABLE KEYS */;
INSERT INTO `manga` VALUES (5346568645,4.20,'images/3e3c6717-253b-44e4-9048-3409704db661_One_Piece_vol_1.jpg','One Piece: Volume 1','non il miglior manga'),(53895739085,5.90,'images/3d36d218-e8a1-43fb-894d-2a60bb6d97b1_DB.jpg','Dragon Ball Evergreen: Volume 1','Il miglior manga'),(4923874789534,52.90,'images/7c7596f3-71ae-4a1d-a2b6-80f21ae63462_bre.jpg','Berserk Ominbus','Berserk');
/*!40000 ALTER TABLE `manga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine_include_funko`
--

DROP TABLE IF EXISTS `ordine_include_funko`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine_include_funko` (
  `id_ordine` int NOT NULL,
  `NumeroSerie` varchar(50) NOT NULL,
  `quantita` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_ordine`,`NumeroSerie`),
  KEY `NumeroSerie` (`NumeroSerie`),
  CONSTRAINT `ordine_include_funko_ibfk_1` FOREIGN KEY (`id_ordine`) REFERENCES `ordini` (`id_ordine`) ON DELETE CASCADE,
  CONSTRAINT `ordine_include_funko_ibfk_2` FOREIGN KEY (`NumeroSerie`) REFERENCES `funko` (`NumeroSerie`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine_include_funko`
--

LOCK TABLES `ordine_include_funko` WRITE;
/*!40000 ALTER TABLE `ordine_include_funko` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordine_include_funko` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine_include_manga`
--

DROP TABLE IF EXISTS `ordine_include_manga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine_include_manga` (
  `id_ordine` int NOT NULL,
  `ISBN` bigint NOT NULL,
  `quantita` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_ordine`,`ISBN`),
  KEY `ISBN` (`ISBN`),
  CONSTRAINT `ordine_include_manga_ibfk_1` FOREIGN KEY (`id_ordine`) REFERENCES `ordini` (`id_ordine`) ON DELETE CASCADE,
  CONSTRAINT `ordine_include_manga_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `manga` (`ISBN`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine_include_manga`
--

LOCK TABLES `ordine_include_manga` WRITE;
/*!40000 ALTER TABLE `ordine_include_manga` DISABLE KEYS */;
INSERT INTO `ordine_include_manga` VALUES (10,53895739085,1);
/*!40000 ALTER TABLE `ordine_include_manga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordini`
--

DROP TABLE IF EXISTS `ordini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordini` (
  `id_ordine` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `totale` decimal(10,2) NOT NULL DEFAULT '0.00',
  `data` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stato` varchar(45) NOT NULL,
  PRIMARY KEY (`id_ordine`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordini`
--

LOCK TABLES `ordini` WRITE;
/*!40000 ALTER TABLE `ordini` DISABLE KEYS */;
INSERT INTO `ordini` VALUES (9,'romanofiorello@gmail.com',72.80,'2025-07-20 17:59:25','Consegnato'),(10,'romanofiorello@gmail.com',5.90,'2025-07-20 22:13:31','In attesa');
/*!40000 ALTER TABLE `ordini` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferiti`
--

DROP TABLE IF EXISTS `preferiti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preferiti` (
  `email_utente` varchar(255) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `id_prodotto` varchar(100) NOT NULL,
  PRIMARY KEY (`email_utente`,`tipo`,`id_prodotto`),
  KEY `idx_email` (`email_utente`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_id` (`id_prodotto`),
  CONSTRAINT `preferiti_ibfk_1` FOREIGN KEY (`email_utente`) REFERENCES `utenti` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferiti`
--

LOCK TABLES `preferiti` WRITE;
/*!40000 ALTER TABLE `preferiti` DISABLE KEYS */;
INSERT INTO `preferiti` VALUES ('rotondoluigi0@gmail.com','funko','47'),('rotondoluigi0@gmail.com','funko','69'),('romanofiorello@gmail.com','manga','6666666'),('rotondoluigi0@gmail.com','manga','456'),('rotondoluigi0@gmail.com','manga','53625643'),('rotondoluigi0@gmail.com','manga','6666666'),('rotondoluigi0@gmail.com','manga','9788864201795');
/*!40000 ALTER TABLE `preferiti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utenti` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `indirizzo` text,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES ('izzof@gmail.com','Password1@',NULL),('romanofiorello@gmail.com','Fiorello27/','Via delle Rose, SNC'),('rotondoluigi0@gmail.com','Password1@','Via P. A. Mastrilli 41\r\n');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine_dettagli`
--

DROP TABLE IF EXISTS `ordine_dettagli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine_dettagli` (
  `id_ordine` INT NOT NULL,
  `tipo` VARCHAR(20) NOT NULL, -- 'manga' o 'funko'
  `id_prodotto` VARCHAR(50) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `prezzo` DECIMAL(10,2) NOT NULL,
  `quantita` INT NOT NULL,
  PRIMARY KEY (`id_ordine`, `tipo`, `id_prodotto`),
  KEY `idx_ordine` (`id_ordine`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'progettotsw_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-20 22:15:41
