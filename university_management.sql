-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: university_management
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(10) NOT NULL,
  `course_name` varchar(100) NOT NULL,
  `credit_units` int DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `lecturer_id` int DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_code` (`course_code`),
  KEY `department_id` (`department_id`),
  KEY `lecturer_id` (`lecturer_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `courses_ibfk_2` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`lecturer_id`),
  CONSTRAINT `courses_chk_1` CHECK ((`credit_units` between 1 and 6))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'CSC101','Introduction to Computer Science',3,1,1),(2,'CSC201','Data Structures',3,1,1),(3,'CSC301','Database Systems',3,1,2),(4,'IT101','Introduction to Information Technology',3,2,3),(5,'IT202','Web Development',3,2,3),(6,'IT301','Network Administration',3,2,4),(7,'ACC101','Financial Accounting',3,3,5),(8,'BUS201','Business Management',3,4,5),(9,'ENG101','Engineering Mathematics',3,5,4),(10,'ENG201','Engineering Mechanics',3,5,4);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(50) NOT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_name` (`department_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (3,'Accounting'),(4,'Business Adminidtration'),(1,'Computer Science'),(5,'Engineering'),(2,'Information Technology');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollment_audit`
--

DROP TABLE IF EXISTS `enrollment_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollment_audit` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `log_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollment_audit`
--

LOCK TABLES `enrollment_audit` WRITE;
/*!40000 ALTER TABLE `enrollment_audit` DISABLE KEYS */;
INSERT INTO `enrollment_audit` VALUES (1,9,4,'Enrolled','2026-08-27 15:44:12'),(2,9,6,'Enrolled','2026-08-27 15:44:12'),(3,9,5,'Enrolled','2026-08-27 15:44:12'),(4,10,8,'Enrolled','2026-08-27 15:44:12'),(5,10,10,'Enrolled','2026-08-27 15:44:12'),(6,10,9,'Enrolled','2026-08-27 15:44:12'),(7,9,4,'grade update','2026-08-27 15:46:53'),(8,10,10,'grade update','2026-08-27 15:50:44');
/*!40000 ALTER TABLE `enrollment_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `enrollment_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `enrollment_date` date NOT NULL,
  `grade` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  UNIQUE KEY `student_id` (`student_id`,`course_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (1,1,1,'2026-01-10','A'),(2,1,2,'2026-01-10','B'),(3,1,3,'2026-01-10','A'),(4,2,4,'2026-01-11','A'),(5,2,5,'2026-01-11','B'),(6,2,6,'2026-01-11','A'),(7,3,1,'2026-01-12','B'),(8,3,2,'2026-01-12','A'),(9,4,7,'2026-01-13','A'),(10,5,4,'2026-01-13','B'),(11,5,5,'2026-01-13','A'),(12,5,6,'2026-01-13','A'),(13,6,8,'2026-01-14','B'),(14,7,9,'2026-01-14','A'),(15,7,10,'2026-01-14','B'),(16,8,4,'2026-01-15','A'),(17,8,5,'2026-01-15','A'),(18,8,6,'2026-01-15','B'),(19,9,4,'2026-01-11','A'),(20,9,6,'2026-01-11','A'),(21,9,5,'2026-01-11','B'),(22,10,8,'2026-01-14','B'),(23,10,10,'2026-01-14','C'),(24,10,9,'2026-01-14','B');
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lecturers`
--

DROP TABLE IF EXISTS `lecturers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lecturers` (
  `lecturer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `salary` int DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  PRIMARY KEY (`lecturer_id`),
  UNIQUE KEY `email` (`email`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `lecturers_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `lecturers_chk_1` CHECK ((`salary` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lecturers`
--

LOCK TABLES `lecturers` WRITE;
/*!40000 ALTER TABLE `lecturers` DISABLE KEYS */;
INSERT INTO `lecturers` VALUES (1,'Robert','johnso','robert@gmail.com',850000,1),(2,'Amanda','Williams','amanda@gmail.com',780000,2),(3,'Christopher','Brown','christopher@gmail.com',720000,2),(4,'Jennifer','Davis','jennifer@gmail.com',900000,5),(5,'Daniel','Smith','smith@gmail.com',750000,3);
/*!40000 ALTER TABLE `lecturers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `student_acadmic_view`
--

DROP TABLE IF EXISTS `student_acadmic_view`;
/*!50001 DROP VIEW IF EXISTS `student_acadmic_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `student_acadmic_view` AS SELECT 
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `department_name`,
 1 AS `course_code`,
 1 AS `course_name`,
 1 AS `lecturer_first_name`,
 1 AS `lecturer_last_name`,
 1 AS `credit_units`,
 1 AS `grade`,
 1 AS `enrollment_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `department_id` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `email` (`email`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'Daniel','Johnson','daniel@gmail.com','2004-03-15',1),(2,'Sarah','Williams','sarah@gmail.com','2003-07-22',2),(3,'Michael','Brown','michael@gmail.com','2005-01-10',1),(4,'Emily','Davis','emily@gmail.com','2004-11-05',3),(5,'David','Wilson','david@gmail.com','2003-09-18',2),(6,'Jessica','Taylor','jessica@gmail.com','2005-05-27',4),(7,'James','Anderson','james@gmail.com','2004-12-12',5),(8,'Oliva','Martinez','oliva@gmail.com','2003-06-30',2),(9,'Grace','Adeyemi','grace@gmail.com','2005-02-24',2),(10,'Samuel','Okafor','samuel@gmail.com','2004-08-12',4);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `student_acadmic_view`
--

/*!50001 DROP VIEW IF EXISTS `student_acadmic_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `student_acadmic_view` AS select `students`.`first_name` AS `first_name`,`students`.`last_name` AS `last_name`,`department`.`department_name` AS `department_name`,`courses`.`course_code` AS `course_code`,`courses`.`course_name` AS `course_name`,`lecturers`.`first_name` AS `lecturer_first_name`,`lecturers`.`last_name` AS `lecturer_last_name`,`courses`.`credit_units` AS `credit_units`,`enrollments`.`grade` AS `grade`,`enrollments`.`enrollment_date` AS `enrollment_date` from ((((`students` join `department` on((`students`.`department_id` = `department`.`department_id`))) join `enrollments` on((`students`.`student_id` = `enrollments`.`student_id`))) join `courses` on((`enrollments`.`course_id` = `courses`.`course_id`))) join `lecturers` on((`courses`.`lecturer_id` = `lecturers`.`lecturer_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-27 15:52:04
