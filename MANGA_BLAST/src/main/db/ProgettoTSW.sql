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
INSERT INTO `admin` VALUES ('admin1@example.com','adminpass'),('admin2@example.com','supersecure');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
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
INSERT INTO `carrelli` VALUES ('fiorello@example.com');
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
INSERT INTO `carrello_contiene_funko` VALUES ('fiorello@example.com','FNK002',1);
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
INSERT INTO `carrello_contiene_manga` VALUES ('fiorello@example.com',9781234567890,2);
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
INSERT INTO `funko` VALUES ('FNK001',14.99,'funko1.jpg','Funko Pop Spider-Man','Edizione limitata di Spider-Man'),('FNK002',19.99,'funko2.jpg','Funko Pop Iron Man','Versione speciale con armatura dorata');
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
INSERT INTO `manga` VALUES (9780987654321,12.50,'manga2.jpg','Attack on Titan Vol. 5','Battaglia epica tra umani e giganti'),(9781234567890,9.99,'manga1.jpg','One Piece Vol. 1','Primo volume della saga di One Piece');
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
INSERT INTO `ordine_include_funko` VALUES (1,'FNK001'),(1,'FNK002');
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
INSERT INTO `ordine_include_manga` VALUES (2,9780987654321),(2,9781234567890);
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
  `email` varchar(255) DEFAULT NULL,
  `totale` decimal(10,2) DEFAULT '0.00',
  `data` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_ordine`),
  KEY `email` (`email`),
  CONSTRAINT `ordini_ibfk_1` FOREIGN KEY (`email`) REFERENCES `utenti` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordini`
--

LOCK TABLES `ordini` WRITE;
/*!40000 ALTER TABLE `ordini` DISABLE KEYS */;
INSERT INTO `ordini` VALUES (1,'luigi@example.com',34.98,'2025-06-17 18:30:00'),(2,'ciccio@example.com',22.49,'2025-06-17 19:00:00');
/*!40000 ALTER TABLE `ordini` ENABLE KEYS */;
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
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES ('ciccio@example.com','securepass'),('fiorello@example.com','mypassword'),('luigi@example.com','password123');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-17 18:56:51
