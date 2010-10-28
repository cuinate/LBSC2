# Sequel Pro dump
# Version 2492
# http://code.google.com/p/sequel-pro
#
# Host: 127.0.0.1 (MySQL 5.1.50-log)
# Database: lbsc2_development
# Generation Time: 2010-10-27 22:08:55 +0800
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table activities
# ------------------------------------------------------------

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` (`id`,`user_id`,`place_id`,`question_id`,`answer_id`,`action_id`,`created_at`,`updated_at`)
VALUES
	(3,3,3,9,0,5,'2010-10-27 08:24:09','2010-10-27 08:24:09'),
	(4,3,3,9,0,6,'2010-10-27 08:26:38','2010-10-27 08:26:38'),
	(5,3,4,9,0,5,'2010-10-27 08:29:51','2010-10-27 08:29:51'),
	(6,3,0,9,0,2,'2010-10-27 08:59:08','2010-10-27 08:59:08'),
	(7,3,0,6,0,6,'2010-10-27 09:20:11','2010-10-27 09:20:11'),
	(8,3,0,6,11,2,'2010-10-27 09:22:20','2010-10-27 09:22:20'),
	(9,3,0,9,0,3,'2010-10-27 09:52:44','2010-10-27 09:52:44'),
	(10,3,0,9,0,3,'2010-10-27 09:52:52','2010-10-27 09:52:52'),
	(11,3,0,9,0,4,'2010-10-27 09:53:13','2010-10-27 09:53:13'),
	(12,3,4,9,0,5,'2010-10-27 10:08:39','2010-10-27 10:08:39'),
	(13,3,4,9,0,5,'2010-10-27 10:08:53','2010-10-27 10:08:53'),
	(14,3,4,6,0,5,'2010-10-27 10:08:58','2010-10-27 10:08:58'),
	(15,3,1,0,0,5,'2010-10-27 10:09:12','2010-10-27 10:09:12'),
	(16,3,4,9,0,1,'2010-10-27 10:12:24','2010-10-27 10:12:24');

/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table answers
# ------------------------------------------------------------

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
INSERT INTO `answers` (`id`,`user_id`,`question_id`,`description`,`up_counts`,`down_counts`,`is_choosen`,`created_at`,`updated_at`)
VALUES
	(1,4,6,'answer for Q4',NULL,NULL,0,NULL,NULL),
	(2,6,6,'answer1 for Q4',NULL,NULL,0,NULL,NULL),
	(3,6,6,'answer2 for Q4',NULL,NULL,0,NULL,NULL),
	(4,4,6,'answer for Q4',NULL,NULL,0,NULL,NULL),
	(10,4,6,'测试activity_controller',0,0,0,'2010-10-27 09:20:11','2010-10-27 09:20:11'),
	(11,4,6,'测试activity_controller',2,1,0,'2010-10-27 09:22:20','2010-10-27 09:53:13');

/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table places
# ------------------------------------------------------------

LOCK TABLES `places` WRITE;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
INSERT INTO `places` (`id`,`name`,`address`,`latitude`,`longtitude`,`postalcode`,`city`,`pic_url`,`user_id`,`created_at`,`updated_at`,`questions_count`,`activities_count`)
VALUES
	(1,'中关村',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1),
	(3,'北京理工大学设计艺术学院传统工艺美术系','中国北京市海淀区西三环北路辅路北京理工大学设计艺术学院传统工艺美术系',39.961190,116.309173,NULL,'北京',NULL,NULL,'2010-10-19 08:55:34','2010-10-19 08:55:34',0,2),
	(4,'中关村医院','中国北京市海淀区中关村南路4号中关村医院',39.980543,116.321000,NULL,'北京',NULL,3,'2010-10-19 08:58:01','2010-10-19 08:58:01',9,5),
	(7,'北京市妇联','中国北京市海淀区善缘街鼎好电子大厦A座',39.984929,116.313985,NULL,'北京',NULL,NULL,'2010-10-19 13:22:48','2010-10-19 13:22:48',0,0),
	(8,'新世界百货（东煌凯丽酒店南）','中国北京市朝阳区广顺南大街21号新世界百货（东煌凯丽酒店南）',39.986690,116.480303,NULL,'北京',NULL,NULL,'2010-10-19 13:35:05','2010-10-19 13:35:05',0,0),
	(9,'星巴克咖啡店','中国上海市浦东新区东方路969号星巴克咖啡店',31.222253,121.528815,NULL,'上海',NULL,NULL,'2010-10-20 03:37:21','2010-10-20 03:37:21',1,0),
	(10,NULL,'中国北京市东城区天安门',39.908715,116.397389,NULL,'北京',NULL,NULL,'2010-10-24 10:06:58','2010-10-24 10:06:58',0,0);

/*!40000 ALTER TABLE `places` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table questions
# ------------------------------------------------------------

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` (`id`,`place_id`,`description`,`points`,`user_id`,`created_at`,`updated_at`,`answers_count`)
VALUES
	(1,4,' 测试一下看看？',0,3,'2010-10-20 07:36:06','2010-10-20 07:36:06',4),
	(2,4,'',0,3,'2010-10-20 07:38:29','2010-10-20 07:38:29',6),
	(3,4,' 测试一下4',0,3,'2010-10-20 07:40:30','2010-10-20 07:40:30',0),
	(4,4,' 测试5',0,3,'2010-10-20 07:43:16','2010-10-20 07:43:16',10),
	(5,4,' 测试6',15,3,'2010-10-20 07:52:06','2010-10-20 07:52:06',0),
	(6,9,' 测试星巴克',15,3,'2010-10-20 07:54:55','2010-10-20 07:54:55',2),
	(7,4,' f阿迪事发时东方',15,4,'2010-10-24 10:08:12','2010-10-24 10:08:12',0),
	(8,4,' ',5,4,'2010-10-24 13:06:35','2010-10-24 13:06:35',0),
	(9,4,'哪里有快递',5,4,'2010-10-27 10:12:24','2010-10-27 10:12:24',0);

/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sessions
# ------------------------------------------------------------

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` (`id`,`session_id`,`data`,`created_at`,`updated_at`)
VALUES
	(1,'5d3ef7e8b1488ab9291cf0e1a7e16822','BAh7ByIQX2NzcmZfdG9rZW4iMXJUdFdsdHBHeVplU1F1UjBjUS9BUmZhcksx\neHFWTWlnWi9Ha2tPT2s1b0E9Igx1c2VyX2lkaQg=\n','2010-10-27 08:24:09','2010-10-27 13:59:42');

/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`,`name`,`hashed_password`,`salt`,`e_mail`,`scores`,`profile_img`,`created_at`,`updated_at`,`remember_token`,`remember_token_expires_at`,`m_token`,`m_token_expires_at`)
VALUES
	(1,'cys','4d2a53ef8ff6686f989938be6282498912f8a1ba','4107f2dcaaae7311abbfbf55e709650de374c9ad','cuiyingsan@gmail.com',NULL,NULL,'2010-10-15 06:20:42','2010-10-15 14:28:30','674ab6a7613bcdbf1cfa8ce106744a493e69c36e','14:28:30',NULL,NULL),
	(2,'nate','639e7a251ed90fe8fb18047bbc177298687a4140','50ff101eb38697673e82484dd1d07ee3205a13e4','cys333@msn.com',NULL,NULL,'2010-10-15 08:11:37','2010-10-15 08:11:37',NULL,NULL,NULL,NULL),
	(3,'natecui','d0cff8ed3351d01b610fa5ae593d64ff6f82dc67','042f94b0ce3dcd64ac6e3c738f9763d0c16112b6','nate@sina.com',NULL,NULL,'2010-10-17 14:27:31','2010-10-19 14:45:58',NULL,NULL,'2b5a9e518027a23f8c365517c73f513eb7c6c586','14:40:03'),
	(4,'cysnew','9fa92643dc32e762dd03e4648aaf5dc0d379b4b2','bcd729e15a9acb3e0ab61340132decda1e8db66b','cysnew@sina.com',NULL,NULL,'2010-10-19 00:44:28','2010-10-19 00:44:28',NULL,NULL,NULL,NULL),
	(5,'dada','4ad583f4a1ccee11968d61d80ff0130dd11ed7ce','5e4d0e548d8b3fc765760b46cc03b0f88795ebad','dada@sina.com',NULL,NULL,'2010-10-25 07:55:11','2010-10-25 07:55:11',NULL,NULL,NULL,NULL);

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;





/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
