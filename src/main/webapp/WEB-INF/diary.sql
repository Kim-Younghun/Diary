-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.5.19-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- diary 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `diary` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `diary`;

-- 테이블 diary.notice 구조 내보내기
CREATE TABLE IF NOT EXISTS `notice` (
  `notice_no` int(11) NOT NULL AUTO_INCREMENT,
  `notice_title` varchar(200) NOT NULL,
  `notice_content` text NOT NULL,
  `notice_writer` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`notice_no`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 diary.schedule 구조 내보내기
CREATE TABLE IF NOT EXISTS `schedule` (
  `schedule_no` int(11) NOT NULL AUTO_INCREMENT,
  `schedule_date` date NOT NULL,
  `schedule_time` time NOT NULL,
  `schedule_memo` text NOT NULL,
  `schedule_color` char(7) NOT NULL COMMENT '#000000',
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  `schedule_pw` varchar(50) NOT NULL DEFAULT '1234',
  PRIMARY KEY (`schedule_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1007 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
