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
INSERT INTO `funko` VALUES ('11',20.00,'images/2727d988-152a-4724-853b-a6197df8dcc5_618U9RkyMiL.jpg','Piccolo','Verde'),('1104',34.90,'images/b0fffce9-bc46-42aa-b4c9-7d0e12f7b306_71QXEVEZn0L.jpg','Vasto Lorde Ichigo','Top 10 design manga'),('1141',15.20,'images/048ca346-5446-4e5f-b96e-0f3f270261e9_FUNKO-POP-My-Hero-Academia-Hawks.jpg','Hawks','Il numero 2'),('1738',12.90,'images/6e9c999b-4c85-4402-928c-6332cd0a9695_E1083161_1.jpg','Drago Arcobaleno','Un drago');
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
INSERT INTO `manga` VALUES (54646252,52.90,'images/6400f53b-5658-413f-93b1-83c1ba19d63f_91eRoWSACCL._UF1000,1000_QL80_.jpg','Berserk Ominbus','Il secondo miglior manga della storia'),(5346568645,7.00,'images/434985e9-9a68-4779-ac53-725652d118fc_81VkApOiIdL._UF1000,1000_QL80_.jpg','Homunculus','Un senzatetto dopo aver accettato una operazione di trapanazione del cranio, inizia a vedere gli homunculus.'),(43654786545,4.20,'images/c3d5c0d1-e309-4e89-b510-41c5340e933a_A1jabEOoe6L.jpg','hajime no ippo manga','Ippo aspira a diventare un grande pugile'),(534655364536,12.90,'images/a02efed9-ea1e-453a-acb6-9ff253dee379_images.jpeg','SandLand','Un capolavoro di Toriyama'),(565475464363,5.20,'images/c2602e35-86c7-4708-9cef-fc248e061a5f_One_Piece_vol_1.jpg','One Piece: Volume 1','Non il miglior manga della storia (Dragon ball meglio)'),(4723574589536,27.90,'images/0395d7cc-e8cb-4b2a-b2bc-1555b219afab_81s+7U+z6oL._UF1000,1000_QL80_.jpg','La Divina Commedia','la divina commedia di Go Nagai'),(4923874789534,5.90,'images/9cf12c94-68f5-461a-b1a8-8b360ef048ad_81KjLQJ7xsL.jpg','Dragon Ball Evergreen: Volume 1','Il miglior manga della storia'),(45096754743596,15.00,'images/583acf3b-7ece-4717-b939-78945dd3a69e_71KYuGRVRML.jpg','Brivido e altre storie','Paura');
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
INSERT INTO `ordine_include_manga` VALUES (9,54646252,1),(9,5346568645,1),(9,534655364536,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordini`
--

LOCK TABLES `ordini` WRITE;
/*!40000 ALTER TABLE `ordini` DISABLE KEYS */;
INSERT INTO `ordini` VALUES (9,'romanofiorello@gmail.com',72.80,'2025-07-20 17:59:25','Consegnato');
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
INSERT INTO `preferiti` VALUES ('rotondoluigi0@gmail.com','funko','47'),('rotondoluigi0@gmail.com','funko','69'),('cassieLaNocerese@gattino.it','manga','1234567890'),('cassieLaNocerese@gattino.it','manga','4923874789534'),('romanofiorello@gmail.com','manga','6666666'),('rotondoluigi0@gmail.com','manga','456'),('rotondoluigi0@gmail.com','manga','53625643'),('rotondoluigi0@gmail.com','manga','6666666'),('rotondoluigi0@gmail.com','manga','9788864201795'),('vincenzogay@lasburra.la','manga','53625643');
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
INSERT INTO `utenti` VALUES ('cassieLaNocerese@gattino.it','Ilygirl2/',NULL),('izzof@gmail.com','Password1@',NULL),('romanofiorello@gmail.com','Fiorello27/','Via delle Rose, SNC'),('rotondoluigi0@gmail.com','Password1@','Via P. A. Mastrilli 41\r\n'),('vincenzogay@lasburra.la','Sonogay27/',NULL);
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

-- Dump completed on 2025-07-20 18:11:29
