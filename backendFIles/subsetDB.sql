-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 07, 2020 at 06:24 PM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.2.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `subsetDB`
--

-- --------------------------------------------------------

--
-- Table structure for table `answer_image_table`
--

CREATE TABLE `answer_image_table` (
  `answer_image_id` int(11) NOT NULL,
  `answer_id` varchar(50) NOT NULL,
  `url` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `answer_image_table`
--

INSERT INTO `answer_image_table` (`answer_image_id`, `answer_id`, `url`) VALUES
(1, '15', 'QIMG20200203070245647.png'),
(2, '15', 'QIMG2020020307024589.png'),
(3, '1', 'QIMG20200203070237932.png'),
(4, '1', 'QIMG20200203070237131.png'),
(5, '2', 'QIMG20200203070207884.png'),
(6, '2', 'QIMG20200203070207723.png'),
(7, '3', 'QIMG20200203070207587.png'),
(8, '3', 'QIMG20200203070207637.png'),
(9, '4', 'QIMG20200203070226841.png'),
(10, '4', 'QIMG20200203070226286.png'),
(11, '5', 'QIMG20200203070228525.png'),
(12, '5', 'QIMG20200203070228720.png'),
(13, '6', 'QIMG202002030702358.png'),
(14, '6', 'QIMG20200203070235506.png'),
(15, '7', 'QIMG20200203070250878.png'),
(16, '7', 'QIMG20200203070250893.png'),
(17, '8', 'QIMG20200203070213270.png'),
(18, '8', 'QIMG20200203070213224.png'),
(19, '9', 'QIMG20200203070211608.png'),
(20, '9', 'QIMG20200203070211514.png'),
(21, '10', 'QIMG20200203070223826.png'),
(22, '10', 'QIMG20200203070223549.png'),
(23, '11', 'QIMG20200203070244460.png'),
(24, '11', 'QIMG20200203070244399.png'),
(25, '12', 'QIMG2020020307024416.png'),
(26, '12', 'QIMG20200203070244947.png'),
(27, '13', 'QIMG20200203070254270.png'),
(28, '13', 'QIMG20200203070254104.png'),
(29, '14', 'QIMG20200203070203938.png'),
(30, '14', 'QIMG20200203070203632.png'),
(31, '16', 'QIMG20200203070234368.png'),
(32, '16', 'QIMG2020020307023589.png'),
(33, '17', 'QIMG20200203070255925.png'),
(34, '17', 'QIMG20200203070256232.png'),
(35, '18', 'QIMG20200203080220358.png'),
(36, '18', 'QIMG20200203080220658.png'),
(37, '19', 'QIMG20200203080203709.png'),
(38, '19', 'QIMG20200203080203640.png'),
(39, '20', 'QIMG20200203080221260.png'),
(40, '20', 'QIMG20200203080221380.png'),
(41, '21', 'QIMG20200203080257806.png'),
(42, '21', 'QIMG20200203080257136.png'),
(43, '22', 'QIMG20200203080252523.png'),
(44, '22', 'QIMG20200203080252552.png'),
(45, '23', 'QIMG20200203080221655.png'),
(46, '23', 'QIMG20200203080221174.png'),
(47, '24', 'QIMG20200203080250790.png'),
(48, '24', 'QIMG20200203080250506.png'),
(49, '2', 'QIMG2020020308025463.png'),
(50, '2', 'QIMG20200203080254398.png'),
(51, '3', 'QIMG20200203080232385.png'),
(52, '3', 'QIMG20200203080232218.png'),
(53, '4', 'QIMG20200203080213802.png'),
(54, '4', 'QIMG2020020308021396.png'),
(55, '5', 'QIMG20200203080208116.png'),
(56, '5', 'QIMG20200203080208854.png'),
(57, '6', 'QIMG20200203080201761.png'),
(58, '6', 'QIMG20200203080201624.png'),
(59, '7', 'QIMG20200203080254463.png'),
(60, '7', 'QIMG20200203080255107.png'),
(61, '8', 'QIMG20200203080232894.png'),
(62, '8', 'QIMG20200203080232679.png'),
(63, '9', 'QIMG20200203080200379.png'),
(64, '9', 'QIMG20200203080200565.png'),
(65, '10', 'QIMG20200203080235549.png'),
(66, '10', 'QIMG20200203080235204.png'),
(67, '11', 'QIMG20200203080212986.png'),
(68, '11', 'QIMG20200203080212313.png'),
(69, '12', 'QIMG20200203080247379.png'),
(70, '12', 'QIMG20200203080247489.png'),
(71, '13', 'QIMG20200203080212611.png'),
(72, '13', 'QIMG20200203080212533.png'),
(73, '14', 'QIMG20200203080200764.png'),
(74, '14', 'QIMG20200203080200640.png'),
(75, '15', 'QIMG20200203080253185.png'),
(76, '15', 'QIMG20200203080253486.png'),
(77, '16', 'QIMG20200203080219515.png'),
(78, '16', 'QIMG20200203080219523.png'),
(79, '17', 'QIMG20200203080204454.png'),
(80, '17', 'QIMG20200203080204782.png'),
(81, '18', 'QIMG20200203080223940.png'),
(82, '18', 'QIMG2020020308022328.png'),
(83, '19', 'QIMG20200203080237180.png'),
(84, '19', 'QIMG20200203080237643.png'),
(85, '20', 'QIMG20200203080210543.png'),
(86, '20', 'QIMG20200203080210197.png'),
(87, '21', 'QIMG2020020308024287.png'),
(88, '21', 'QIMG20200203080243359.png'),
(89, '22', 'QIMG20200203080220871.png'),
(90, '22', 'QIMG20200203080220682.png'),
(91, '23', 'QIMG20200203080246563.png'),
(92, '23', 'QIMG20200203080246261.png'),
(93, '24', 'QIMG20200203080234524.png'),
(94, '24', 'QIMG20200203080234136.png'),
(95, '25', 'QIMG20200203080246930.png'),
(96, '26', 'QIMG20200203080227432.png'),
(97, '27', 'QIMG20200203080213168.png'),
(98, '28', 'QIMG20200203080250711.png'),
(99, '29', 'QIMG20200203080234732.png'),
(100, '30', 'QIMG20200203080256883.png'),
(101, '31', 'QIMG20200203080217869.png'),
(102, '32', 'QIMG20200203080236832.png'),
(103, '33', 'QIMG20200203080209707.png'),
(104, '1', 'QIMG20200203090216772.png'),
(105, '2', 'QIMG20200203090244222.png'),
(106, '3', 'QIMG20200203090200774.png'),
(107, '4', 'QIMG20200203090224148.png'),
(108, '5', 'QIMG20200203090225331.png'),
(109, '6', 'QIMG20200203090222295.png'),
(110, '7', 'QIMG20200203090223192.png'),
(111, '8', 'QIMG20200203090257491.png'),
(112, '9', 'QIMG20200203090216989.png'),
(113, '10', 'QIMG20200203090204604.png'),
(114, '11', 'QIMG20200203090241438.png'),
(115, '12', 'QIMG2020020309022686.png'),
(116, '13', 'QIMG20200203090218628.png'),
(117, '14', 'QIMG20200203090206375.png'),
(118, '15', 'QIMG20200203090254389.png'),
(119, '16', 'QIMG20200203090234152.png'),
(120, '17', 'QIMG20200203090222492.png'),
(121, '18', 'QIMG20200203090256250.png'),
(122, '22', 'answer20200203100234227.png'),
(123, '23', 'answer20200203100230370.png'),
(124, '24', '20200203100208755.png'),
(125, '25', 'user20200203110226879.png'),
(126, '26', 'user20200203110222289.png'),
(127, '27', 'user20200203110248134.png'),
(128, '28', 'user20200203110259911.png'),
(129, '29', 'user2020020311023391.png'),
(130, '30', 'user20200203110245339.png'),
(131, '31', 'user20200203110225121.png'),
(132, '32', 'user20200203110257580.png'),
(133, '33', 'user20200203110222438.png'),
(134, '34', 'user20200203110253153.png'),
(135, '35', 'user20200203110249721.png'),
(136, '36', 'user20200203110238493.png'),
(137, '37', 'user20200203110250392.png'),
(138, '38', 'user20200203110227193.png'),
(139, '38', 'user20200203110227822.png'),
(140, '39', 'user5e37f9882f3bb.png'),
(141, '39', 'user5e37f98854262.png'),
(142, '40', 'user5e37f9a0bcc98.png'),
(143, '40', 'user5e37f9a0ccfac.png'),
(144, '41', 'user5e37fa81cefcf.png'),
(145, '41', 'user5e37fa81e4ed6.png'),
(146, '42', 'user5e37fab47d80e.png'),
(147, '42', 'user5e37fab497eb8.png'),
(148, '4245', 'user5e37fc5ac8a27.png'),
(149, '4245', 'user5e37fc5ada042.png'),
(150, '424', 'user20200203110222328.png'),
(151, '424', 'user20200203110222528.png'),
(152, '152', 'user2020020312025135.png'),
(153, '152', 'user20200203120251646.png'),
(154, '153', 'user20200203030231480.png'),
(155, '153', 'user20200203030231541.png'),
(156, '154', 'user20200203030245294.png'),
(157, '154', 'user20200203030245928.png'),
(158, '155', 'user2020020303023432.png'),
(159, '155', 'user2020020303023435.png'),
(160, '156', 'user20200203030233133.png'),
(161, '156', 'user20200203030233902.png'),
(162, '157', 'user20200203030240153.png'),
(163, '157', 'user2020020303024016.png'),
(164, '158', 'user20200203030222654.png'),
(165, '158', 'user20200203030222690.png'),
(166, '159', 'user20200203030230282.png'),
(167, '159', 'user20200203030230863.png'),
(168, '160', 'user20200204060229691.png'),
(169, '160', 'user20200204060229638.png'),
(170, '161', 'user20200204060227195.png'),
(171, 'b6801120-4c37-11ea-a9ab-cde99c5a236e', 'user20200210080216887.png'),
(172, 'b6801120-4c37-11ea-a9ab-cde99c5a236e', 'user20200210080216822.png'),
(173, 'b6801120-4c37-11ea-a9ab-cde99c5a236e', 'user20200210080216589.png'),
(174, 'b6801120-4c37-11ea-a9ab-cde99c5a236e', 'user2020021008021793.png'),
(175, '30330130-4c38-11ea-fd0c-7ff4a9eec0b6', 'user2020021008024110.png'),
(176, '30330130-4c38-11ea-fd0c-7ff4a9eec0b6', 'user20200210080241236.png'),
(177, '30330130-4c38-11ea-fd0c-7ff4a9eec0b6', 'user20200210080241764.png'),
(178, '30330130-4c38-11ea-fd0c-7ff4a9eec0b6', 'user20200210080241822.png'),
(179, '30330130-4c38-11ea-fd0c-7ff4a9eec0b6', 'user2020021008024166.png'),
(180, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222770.png'),
(181, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222927.png'),
(182, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222919.png'),
(183, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222111.png'),
(184, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222408.png'),
(185, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222888.png'),
(186, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222555.png'),
(187, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222864.png'),
(188, '3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'user20200211100222812.png'),
(189, '5bd27110-4dbc-11ea-ab5f-af79f1b527b1', 'user20200212060220402.png'),
(190, '5bd27110-4dbc-11ea-ab5f-af79f1b527b1', 'user20200212060220166.png'),
(191, '5bd27110-4dbc-11ea-ab5f-af79f1b527b1', 'user202002120602203.png'),
(192, '5bd27110-4dbc-11ea-ab5f-af79f1b527b1', 'user20200212060220967.png'),
(193, '5ec67810-4f4e-11ea-8bf0-cd987a38fb2e', 'QIMG20200214100201715.png'),
(194, '5ec67810-4f4e-11ea-8bf0-cd987a38fb2e', 'QIMG20200214100201236.png'),
(195, 'a55e8560-4f4e-11ea-ffe5-89ad1c484ea6', 'QIMG20200214100200507.png'),
(196, 'cedfac20-5593-11ea-b75f-d7f59f389239', 'QIMG20200222100219366.png'),
(197, '9ceae1e0-605f-11ea-8d9e-15313c2f50c2', 'QIMG20200307040318664.png');

-- --------------------------------------------------------

--
-- Table structure for table `answer_table`
--

CREATE TABLE `answer_table` (
  `answer_id` varchar(50) NOT NULL,
  `answer` varchar(2000) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `created_at` varchar(30) NOT NULL,
  `question_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `answer_table`
--

INSERT INTO `answer_table` (`answer_id`, `answer`, `user_id`, `created_at`, `question_id`) VALUES
('00f698c0-5a3c-11ea-c06e-55a620e760d2', 'vubuh', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:37:15', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('03bf0790-5a3c-11ea-c06e-55a620e760d2', 'vyvyb', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:37:20', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('1', 'answer', 'user_id', '2020/02/03 09:01:15', 'question_id'),
('10', 'answer', 'user_id', '2020/02/03 09:16:04', 'question_id'),
('11', 'answer', 'user_id', '2020/02/03 09:16:41', 'question_id'),
('12', 'answer', 'user_id', '2020/02/03 09:20:26', 'question_id'),
('13', 'answer', 'user_id', '2020/02/03 09:21:18', 'question_id'),
('14', 'answer', 'user_id', '2020/02/03 09:24:06', 'question_id'),
('15', 'answer', 'user_id', '2020/02/03 09:24:54', 'question_id'),
('152', 'answer', 'user_id', '2020/02/03 12:11:51', 'question_id'),
('153', 'answer', 'user_id', '2020/02/03 15:38:31', 'question_id'),
('154', 'answer', 'user_id', '2020/02/03 15:41:45', 'question_id'),
('155', 'answer', 'user_id', '2020/02/03 15:42:34', 'question_id'),
('156', 'answer', 'user_id', '2020/02/03 15:44:33', 'question_id'),
('157', 'answer', 'user_id', '2020/02/03 15:45:40', 'question_id'),
('158', 'answer', 'user_id', '2020/02/03 15:50:22', 'question_id'),
('159', 'answer', 'user_id', '2020/02/03 15:51:30', 'question_id'),
('16', 'answer', 'user_id', '2020/02/03 09:26:34', 'question_id'),
('160', 'answer', 'user_id', '2020/02/04 18:01:29', 'question_id'),
('161', 'answer', 'user_id', '2020/02/04 18:02:27', 'question_id'),
('17', 'answer', 'user_id', '2020/02/03 09:27:22', 'question_id'),
('18', 'answer', 'user_id', '2020/02/03 09:29:56', 'question_id'),
('1d025ef0-4db7-11ea-ea07-190be32b011d', 'bJ', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('2', 'answer', 'user_id', '2020/02/03 09:01:44', 'question_id'),
('22', 'answer', 'user_id', '2020/02/03 10:22:34', 'question_id'),
('23', 'answer', 'user_id', '2020/02/03 10:23:30', 'question_id'),
('24', 'answer', 'user_id', '2020/02/03 10:28:08', 'question_id'),
('25', 'answer', 'user_id', '2020/02/03 11:11:26', 'question_id'),
('26', 'answer', 'user_id', '2020/02/03 11:14:21', 'question_id'),
('27', 'answer', 'user_id', '2020/02/03 11:15:48', 'question_id'),
('28', 'answer', 'user_id', '2020/02/03 11:16:59', 'question_id'),
('29', 'answer', 'user_id', '2020/02/03 11:17:33', 'question_id'),
('3', 'answer', 'user_id', '2020/02/03 09:06:00', 'question_id'),
('30', 'answer', 'user_id', '2020/02/03 11:18:45', 'question_id'),
('30330130-4c38-11ea-fd0c-7ff4a9eec0b6', 'Thank you Kerry We are so grateful for your kind words. Thanks for sharing your review with us. Team Subset', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', '543f8010-4915-11ea-8565-5958c6dc27a7'),
('31', 'answer', 'user_id', '2020/02/03 11:20:25', 'question_id'),
('32', 'answer', 'user_id', '2020/02/03 11:29:57', 'question_id'),
('33', 'answer', 'user_id', '2020/02/03 11:30:22', 'question_id'),
('34', 'answer', 'user_id', '2020/02/03 11:31:53', 'question_id'),
('35', 'answer', 'user_id', '2020/02/03 11:32:49', 'question_id'),
('36', 'answer', 'user_id', '2020/02/03 11:33:38', 'question_id'),
('37', 'answer', 'user_id', '2020/02/03 11:37:50', 'question_id'),
('38', 'answer', 'user_id', '2020/02/03 11:38:27', 'question_id'),
('39', 'answer', 'user_id', '2020/02/03 11:44:24', 'question_id'),
('3ba15680-4d90-11ea-8810-2d5f4f80ecb2', 'bNnk yxcuvuvi jcc', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('3d9d7fa0-4d17-11ea-efa9-87d7a1e5442b', 'awhxxhcjvjv', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('4', 'answer', 'user_id', '2020/02/03 09:09:24', 'question_id'),
('40', 'answer', 'user_id', '2020/02/03 11:44:48', 'question_id'),
('41', 'answer', 'user_id', '2020/02/03 11:48:33', 'question_id'),
('42', 'answer', 'user_id', '2020/02/03 11:49:24', 'question_id'),
('424', 'answer', 'user_id', '2020/02/03 11:57:22', 'question_id'),
('4245', 'answer', 'user_id', '2020/02/03 11:56:26', 'question_id'),
('43327fb0-4d8a-11ea-fbe2-751ee5092466', 'hchchc hajajjvvjvuvu', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('5', 'answer', 'user_id', '2020/02/03 09:10:25', 'question_id'),
('5bd27110-4dbc-11ea-ab5f-af79f1b527b1', 'hdkdo', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/12 18:23:20', '543f8010-4915-11ea-8565-5958c6dc27a7'),
('5ec67810-4f4e-11ea-8bf0-cd987a38fb2e', 'bajao', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/14 22:51:01', '4274b690-4f4e-11ea-d89c-79caeb2ba288'),
('6', 'answer', 'user_id', '2020/02/03 09:11:22', 'question_id'),
('7', 'answer', 'user_id', '2020/02/03 09:12:23', 'question_id'),
('8', 'answer', 'user_id', '2020/02/03 09:12:57', 'question_id'),
('9', 'answer', 'user_id', '2020/02/03 09:15:16', 'question_id'),
('9ceae1e0-605f-11ea-8d9e-15313c2f50c2', 'Hewguc I will be there at once and for all the help you', '06965f90-4669-11ea-a224-b7c48b686887', '2020/03/07 16:07:18', 'e214cb20-605d-11ea-e8d9-c18ae4a60317'),
('a55e8560-4f4e-11ea-ffe5-89ad1c484ea6', 'bak', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/14 22:53:00', '4274b690-4f4e-11ea-d89c-79caeb2ba288'),
('b02d7c50-5a3c-11ea-9535-a1b979f8e610', 'bubub', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:42:09', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('b54f9290-5a3c-11ea-9535-a1b979f8e610', 'ubuhh', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:42:18', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('b6801120-4c37-11ea-a9ab-cde99c5a236e', 'hvvh ', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', 'a29fdf00-4c37-11ea-cdab-733936802645'),
('bfb4dba0-5a3c-11ea-d268-1991f6170798', 'ubub', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:42:35', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('c8d8b430-4d7c-11ea-e43a-e5ecc5eed197', 'bchcj', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/12 10:48:14', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('cedfac20-5593-11ea-b75f-d7f59f389239', 'Well I will be there at once and for all the help you have given me the details of the image of the image of', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/22 22:23:19', '4274b690-4f4e-11ea-d89c-79caeb2ba288'),
('d1fce190-5a3c-11ea-cdb4-2122957cc328', 'vyvyvy', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:43:06', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147'),
('fa528fb0-491f-11ea-906e-8f876e85b937', 'Thank you Kerry We are so grateful for your kind words. Thanks for sharing your review with us. Team Subset', '06965f90-4669-11ea-a224-b7c48b686887', '2020-02-12 17:45:46', '543f8010-4915-11ea-8565-5958c6dc27a7'),
('fe90bc50-5a3b-11ea-c06e-55a620e760d2', 'vhhvyby', 'fbeab580-4917-11ea-ab59-975ee2726871', '2020/02/28 20:37:11', '1b15edf0-4d17-11ea-a0d3-bbd5b2658147');

-- --------------------------------------------------------

--
-- Table structure for table `areas`
--

CREATE TABLE `areas` (
  `area_id` int(11) NOT NULL,
  `area_name` varchar(100) NOT NULL,
  `dist_id` mediumint(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `areas`
--

INSERT INTO `areas` (`area_id`, `area_name`, `dist_id`) VALUES
(1, 'Gokalpur', 24),
(2, 'Azad Chowk', 1);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_table`
--

CREATE TABLE `attendance_table` (
  `attendance_id` int(11) NOT NULL,
  `user_uid` varchar(50) NOT NULL,
  `date` varchar(15) NOT NULL,
  `value` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attendance_table`
--

INSERT INTO `attendance_table` (`attendance_id`, `user_uid`, `date`, `value`) VALUES
(1, '734f5420-48e9-11ea-e2fe-1b7777785978', '07-02-2020', 'P'),
(2, 'f8cf4190-484f-11ea-c2c1-99836777e478', '07-02-2020', 'P'),
(3, '734f5420-48e9-11ea-e2fe-1b7777785978', '10-02-2020', 'P'),
(4, 'f8cf4190-484f-11ea-c2c1-99836777e478', '10-02-2020', 'P'),
(5, 'f8cf4190-484f-11ea-c2c1-99836777e478', '12-02-2020', 'P'),
(6, 'cb6249d0-4dbf-11ea-8a40-b9e1748013c4', '25-02-2020', 'P');

-- --------------------------------------------------------

--
-- Table structure for table `batch_table`
--

CREATE TABLE `batch_table` (
  `batch_id` int(11) NOT NULL,
  `batch_name` varchar(50) NOT NULL,
  `coaching_id` varchar(50) NOT NULL,
  `class_id` int(11) NOT NULL,
  `created_at` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `batch_table`
--

INSERT INTO `batch_table` (`batch_id`, `batch_name`, `coaching_id`, `class_id`, `created_at`) VALUES
(1, 'AIR4', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 4, '14 Feb 2020'),
(3, 'AIR 3', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 1, '12 Feb 2020'),
(4, 'AIR 1', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 1, '12 Feb 2020'),
(5, 'Batch 1', '436f4a60-5197-11ea-ee18-bf6801d418e5', 1, '19 Feb 2020'),
(6, 'Batch 2', '436f4a60-5197-11ea-ee18-bf6801d418e5', 1, '19 Feb 2020');

-- --------------------------------------------------------

--
-- Table structure for table `classes_table`
--

CREATE TABLE `classes_table` (
  `class_id` int(11) NOT NULL,
  `class_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `classes_table`
--

INSERT INTO `classes_table` (`class_id`, `class_name`) VALUES
(1, 'Class II'),
(2, 'Class I'),
(4, 'Class III');

-- --------------------------------------------------------

--
-- Table structure for table `coaching_comments`
--

CREATE TABLE `coaching_comments` (
  `coaching_comments_id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `coaching_id` varchar(50) NOT NULL,
  `comment` varchar(2000) NOT NULL,
  `created_at` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `coaching_comments`
--

INSERT INTO `coaching_comments` (`coaching_comments_id`, `user_id`, `coaching_id`, `comment`, `created_at`) VALUES
(1, 'fbeab580-4917-11ea-ab59-975ee2726871', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'vuvuvuv', 'Feb 06 2020 20:40'),
(2, 'fbeab580-4917-11ea-ab59-975ee2726871', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'b hv', 'Feb 06 2020 20:41'),
(3, '06965f90-4669-11ea-a224-b7c48b686887', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'guvihihhib', 'Feb 11 2020 23:01'),
(4, '06965f90-4669-11ea-a224-b7c48b686887', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'ycyvyvvufuf', 'Feb 12 2020 15:19'),
(5, '06965f90-4669-11ea-a224-b7c48b686887', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'bajakla', 'Feb 12 2020 17:45'),
(6, 'fbeab580-4917-11ea-ab59-975ee2726871', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'hai', 'Feb 12 2020 18:22'),
(7, '06965f90-4669-11ea-a224-b7c48b686887', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'Well I will be there at once and for all the help and support you in whatever way you can get a good night\'s', 'Feb 14 2020 16:57'),
(8, 'user_id', 'coaching_id', 'comment', 'Feb 14 2020 16:59'),
(9, 'fbeab580-4917-11ea-ab59-975ee2726871', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', 'j jvjv', 'Feb 14 2020 23:15');

-- --------------------------------------------------------

--
-- Table structure for table `coaching_images`
--

CREATE TABLE `coaching_images` (
  `coaching_image_id` varchar(50) NOT NULL,
  `url` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `coaching_table`
--

CREATE TABLE `coaching_table` (
  `coaching_id` varchar(50) NOT NULL,
  `coaching_name` varchar(200) NOT NULL,
  `tagline` varchar(200) DEFAULT NULL,
  `address` varchar(200) NOT NULL,
  `email` varchar(50) NOT NULL,
  `contact` varchar(15) NOT NULL,
  `coaching_description` varchar(2000) NOT NULL,
  `registration_no` varchar(45) DEFAULT NULL,
  `achievements` varchar(5000) DEFAULT NULL,
  `establishmentat` varchar(100) NOT NULL,
  `created_at` varchar(100) NOT NULL,
  `expired_at` varchar(100) DEFAULT NULL,
  `is_active` int(1) NOT NULL DEFAULT 0,
  `location_id` varchar(11) DEFAULT NULL,
  `logo` varchar(100) DEFAULT 'default.png',
  `image` varchar(100) DEFAULT 'default.png',
  `year_id` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `coaching_table`
--

INSERT INTO `coaching_table` (`coaching_id`, `coaching_name`, `tagline`, `address`, `email`, `contact`, `coaching_description`, `registration_no`, `achievements`, `establishmentat`, `created_at`, `expired_at`, `is_active`, `location_id`, `logo`, `image`, `year_id`) VALUES
('436f4a60-5197-11ea-ee18-bf6801d418e5', 'Engineering Circle', 'We build your dreams', 'Address is not an option for me to get a chance to look at the house and I will', 'email@email.com', '+9199261311123', 'Description of the image of the image of experience and a little late to be there by the image', '40', NULL, '07-10-2019', '2020/02/17 20:37:57', NULL, 1, 'MP12', 'default.png', 'default.png', '2020'),
('48010790-55b5-11ea-bcfa-2bfd7df289ec', 'Indian Institute of technology', 'we are here to build your dreams', 'Shajapur Madhya Pradesh', 'email', '+919926131113', 'Description of the image of the image of the image of the image', '50', NULL, '03-02-2020', '2020/02/23 02:22:48', NULL, 1, 'MP12', 'default.png', 'default.png', '2020'),
('aaaada50-1f06-11ea-9289-1f3d8e220c20', 'Vedanta Coaching Institute', 'tagline', 'address', 'email', '+919926131112', 'Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes (also known as modes of discourse), along with exposition, argumentation, and narration.', '50', 'Dance washes away from the soul the dust of everyday life and makes the spirits high! \nThere\'s nothing in sitting back and watching things go. Aureole brings to you, the enthusiastic, exuberant people who are gonna make you groove in FlashMob! Be it classic Bollywood, Punjabi or any trending beats we have it all covered. Get ready to witness the heart-throbing, jaunty, emulsifying dance moves. This is the event you won\'t wish missing.', '12/12/2011', '12/12/12', '02 Feb 2021', 1, 'MP12', 'IMG20200217020221840.png', 'IMG20200210080228888.png', '2020'),
('c33c2c40-48e6-11ea-968e-97f9c7c685ef', 'Azad Coaching Institute', 'tag', 'addre', 'email', '+919977969296', 'Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes (also known as modes of discourse), along with exposition, argumentation, and narration.', '2', NULL, '06-02-2020', '2020/02/06 19:14:16', NULL, 1, 'MP12', 'default.png', 'default.png', '2020');

-- --------------------------------------------------------

--
-- Table structure for table `coaching_user_connection_table`
--

CREATE TABLE `coaching_user_connection_table` (
  `user_uid` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `admission_date` varchar(15) NOT NULL,
  `year_id` int(11) NOT NULL,
  `user_type` varchar(1) NOT NULL,
  `coaching_id` varchar(50) NOT NULL,
  `status` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `coaching_user_connection_table`
--

INSERT INTO `coaching_user_connection_table` (`user_uid`, `user_id`, `batch_id`, `admission_date`, `year_id`, `user_type`, `coaching_id`, `status`) VALUES
('08d8f360-4918-11ea-c8a7-f98d5aed1411', 'fbeab580-4917-11ea-ab59-975ee2726871', 1, '07-02-2020', 2020, 'T', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '1'),
('3884fe40-57f7-11ea-a7ba-f35ca81467b6', 'fbeab580-4917-11ea-ab59-975ee2726871', 1, '03-02-2020', 2020, 'T', '436f4a60-5197-11ea-ee18-bf6801d418e5', '0'),
('cb6249d0-4dbf-11ea-8a40-b9e1748013c4', '06965f90-4669-11ea-a224-b7c48b686887', 1, '12-02-2020', 2020, 'S', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '1');

-- --------------------------------------------------------

--
-- Table structure for table `comments_table`
--

CREATE TABLE `comments_table` (
  `comment_id` int(11) NOT NULL,
  `comment` varchar(2000) NOT NULL,
  `notice_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `created_at` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `comments_table`
--

INSERT INTO `comments_table` (`comment_id`, `comment`, `notice_id`, `user_id`, `created_at`) VALUES
(3, 'Hello', 'b5b86c20-4d7b-11ea-8bc6-bf330de1d053', 'fbeab580-4917-11ea-ab59-975ee2726871', 'Feb 12 10:40'),
(5, 'bsjjsxbdj', 'b5b86c20-4d7b-11ea-8bc6-bf330de1d053', '06965f90-4669-11ea-a224-b7c48b686887', 'Feb 12 13:07'),
(7, 'zgdhx', 'b5b86c20-4d7b-11ea-8bc6-bf330de1d053', '06965f90-4669-11ea-a224-b7c48b686887', 'Feb 12 18:08'),
(8, 'We are going to be in the same room as well as the other one', 'e6523050-4e8e-11ea-eba0-a70bc90707a3', '06965f90-4669-11ea-a224-b7c48b686887', 'Feb 14 14:53'),
(10, 'vgvybub', 'e6523050-4e8e-11ea-eba0-a70bc90707a3', 'fbeab580-4917-11ea-ab59-975ee2726871', 'Feb 28 20:35'),
(11, 'Hello sir I am not able to make it to the meeting tonight but I will', 'e6523050-4e8e-11ea-eba0-a70bc90707a3', 'fbeab580-4917-11ea-ab59-975ee2726871', 'Feb 28 20:35'),
(12, 'ubb', 'e6523050-4e8e-11ea-eba0-a70bc90707a3', 'fbeab580-4917-11ea-ab59-975ee2726871', 'Feb 28 20:35'),
(13, 'vyvu', 'e6523050-4e8e-11ea-eba0-a70bc90707a3', 'fbeab580-4917-11ea-ab59-975ee2726871', 'Feb 28 21:01');

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `dist_id` mediumint(9) NOT NULL,
  `dist_name` varchar(30) NOT NULL,
  `state_id` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`dist_id`, `dist_name`, `state_id`) VALUES
(1, 'Shajapur', 'MP');

-- --------------------------------------------------------

--
-- Table structure for table `notes_table`
--

CREATE TABLE `notes_table` (
  `notes_id` int(11) NOT NULL,
  `coaching_id` varchar(45) NOT NULL,
  `class_id` varchar(5) NOT NULL,
  `subject_id` varchar(5) NOT NULL,
  `title` varchar(200) NOT NULL,
  `pdf_url` varchar(45) NOT NULL,
  `created_at` varchar(45) NOT NULL,
  `hide` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_table`
--

INSERT INTO `notes_table` (`notes_id`, `coaching_id`, `class_id`, `subject_id`, `title`, `pdf_url`, `created_at`, `hide`) VALUES
(9, 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '4', '4', 'Title', 'files20200227060208302.pdf', '2020/02/27 18:46:08', '0'),
(10, 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '4', '4', 'à¤•à¤¹à¥€à¤‚ à¤¨à¤¹à¥€à¤‚ à¤•à¥‹à¤ˆ à¤¸à¥‚à¤°à¤œ, à¤§à¥à¤†à¤ à¤§à¥à¤†à¤ à¤¹à¥ˆ à¤«à¤¼à¤¿à¤œà¤¼à¤¾\nà¤–à¤¼à¥à¤¦ à¤…à¤ªà¤¨à¥‡ à¤†à¤ª à¤¸à¥‡ à¤¬à¤¾à¤¹à¤° à¤¨à¤¿à¤•à¤² à¤¸à¤•à¥‹ à¤¤à¥‹ à¤šà¤²à¥‹', 'files20200227060202826.pdf', '2020/02/27 18:50:02', '0'),
(11, 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '4', '4', 'hvyyv', 'files20200227060215849.pdf', '2020/02/27 18:51:15', '0'),
(12, 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '4', '4', 'His name is on the list for the next few days', 'files20200229120247847.pdf', '2020/02/29 00:58:47', '0');

-- --------------------------------------------------------

--
-- Table structure for table `notice_files`
--

CREATE TABLE `notice_files` (
  `id` int(11) NOT NULL,
  `notice_id` varchar(50) NOT NULL,
  `url` varchar(100) NOT NULL,
  `type` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `notice_likes`
--

CREATE TABLE `notice_likes` (
  `notice_like_id` int(11) NOT NULL,
  `notice_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `notice_table`
--

CREATE TABLE `notice_table` (
  `notice_id` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `created_at` varchar(35) NOT NULL,
  `user_uid` varchar(50) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `type` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notice_table`
--

INSERT INTO `notice_table` (`notice_id`, `title`, `description`, `created_at`, `user_uid`, `batch_id`, `type`) VALUES
('1f0154e0-5a3c-11ea-e462-a91bc1cfdc05', 'vhbhb', 'vyvyv', '2020/02/28 20:38:06', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 3, 'N'),
('2651bcd0-5a3c-11ea-ae06-a3da0819f32f', 'hbub', 'yvvhvy', '2020/02/28 20:38:18', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 4, 'N'),
('2c4e2d80-5a3c-11ea-88b2-7f44ad6908f1', 'ubb', 'vhvyv', '2020/02/28 20:38:28', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 4, 'N'),
('374cf770-5a3c-11ea-d79f-b380e1f8659c', 'buby', 'hvyvy', '2020/02/28 20:38:46', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 3, 'N'),
('401a3b60-5a3c-11ea-c10b-bb6a06cdf0fb', ' hbuv', 'ububb', '2020/02/28 20:39:01', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 3, 'N'),
('44c9e0c0-5a3c-11ea-d6e4-35b3f301ca94', 'h by', 'uvyvy', '2020/02/28 20:39:09', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 3, 'N'),
('493a3330-5a3c-11ea-b67b-593f6dbc4c47', 'ubyb', 'uvbby', '2020/02/28 20:39:16', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 1, 'N'),
('54d69cb0-5a3c-11ea-a6a6-677a734af722', 'uvyv', 'uvby', '2020/02/28 20:39:35', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 3, 'N'),
('7416adb0-4dc9-11ea-c1dc-9d76a6853b45', 'gxcyf', 'ufyf', '2020/02/12 19:57:04', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 1, 'N'),
('b5b86c20-4d7b-11ea-8bc6-bf330de1d053', 'chch', 'gug', '2020/02/12 10:40:32', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 1, 'A'),
('e6523050-4e8e-11ea-eba0-a70bc90707a3', 'Be prepared with the first 2 units of all subjects.Final timetable will be forwarded later.', 'Pls forward the msg.\n\nMidSem 1 starting from tomorrow!\nBe prepared with the first 2 units of all subjects.\n\nFinal timetable will be forwarded later.', '2020/02/13 19:30:26', '08d8f360-4918-11ea-c8a7-f98d5aed1411', 3, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `notification_table`
--

CREATE TABLE `notification_table` (
  `notification_id` int(11) NOT NULL,
  `title` varchar(1000) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `coaching_id` varchar(50) NOT NULL,
  `year_id` varchar(4) NOT NULL,
  `created_at` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notification_table`
--

INSERT INTO `notification_table` (`notification_id`, `title`, `description`, `coaching_id`, `year_id`, `created_at`) VALUES
(3, 'No ma\'am I will be there at once and for all the help you', 'Hello sir I am not able to make it to the meeting tonight but', 'aaaada50-1f06-11ea-9289-1f3d8e220c20', '2020', '2020/02/14 23:17:04');

-- --------------------------------------------------------

--
-- Table structure for table `question_image`
--

CREATE TABLE `question_image` (
  `question_image_id` int(11) NOT NULL,
  `question_id` varchar(50) NOT NULL,
  `url` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `question_image`
--

INSERT INTO `question_image` (`question_image_id`, `question_id`, `url`) VALUES
(1, '543f8010-4915-11ea-8565-5958c6dc27a7', 'QIMG20200206080235291.png'),
(2, 'a29fdf00-4c37-11ea-cdab-733936802645', 'QIMG20200210080244630.png'),
(3, 'a29fdf00-4c37-11ea-cdab-733936802645', 'QIMG20200210080244359.png'),
(4, 'a29fdf00-4c37-11ea-cdab-733936802645', 'QIMG20200210080244257.png'),
(5, 'a29fdf00-4c37-11ea-cdab-733936802645', 'QIMG2020021008024420.png'),
(6, '1b15edf0-4d17-11ea-a0d3-bbd5b2658147', 'QIMG20200211100223302.png'),
(7, '1b15edf0-4d17-11ea-a0d3-bbd5b2658147', 'QIMG20200211100223518.png'),
(8, '4274b690-4f4e-11ea-d89c-79caeb2ba288', 'QIMG20200214100214500.png'),
(9, '4274b690-4f4e-11ea-d89c-79caeb2ba288', 'QIMG20200214100214839.png'),
(10, 'c9a06050-605c-11ea-eb2d-c35b3e08ca88', 'QIMG20200307030310303.png'),
(11, 'cd55c730-605c-11ea-eb2d-c35b3e08ca88', 'QIMG20200307030312711.png'),
(12, 'cd55c730-605c-11ea-eb2d-c35b3e08ca88', 'QIMG20200307030313988.png'),
(13, 'e214cb20-605d-11ea-e8d9-c18ae4a60317', 'QIMG20200307030356465.png'),
(14, 'ebd22980-605f-11ea-a42f-390442ea65ea', 'QIMG20200307040342908.png');

-- --------------------------------------------------------

--
-- Table structure for table `question_like`
--

CREATE TABLE `question_like` (
  `question_like_id` int(11) NOT NULL,
  `question_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `value` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `question_like`
--

INSERT INTO `question_like` (`question_like_id`, `question_id`, `user_id`, `value`) VALUES
(1, '543f8010-4915-11ea-8565-5958c6dc27a7', '06965f90-4669-11ea-a224-b7c48b686887', 0),
(2, '543f8010-4915-11ea-8565-5958c6dc27a7', 'fbeab580-4917-11ea-ab59-975ee2726871', 0),
(3, '1b15edf0-4d17-11ea-a0d3-bbd5b2658147', '06965f90-4669-11ea-a224-b7c48b686887', 0),
(4, '1b15edf0-4d17-11ea-a0d3-bbd5b2658147', 'fbeab580-4917-11ea-ab59-975ee2726871', 0),
(5, '1acbd530-4e8e-11ea-a812-0910e924652d', '06965f90-4669-11ea-a224-b7c48b686887', 1);

-- --------------------------------------------------------

--
-- Table structure for table `question_table`
--

CREATE TABLE `question_table` (
  `question_id` varchar(50) NOT NULL,
  `question` varchar(500) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `created_at` varchar(20) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `question_table`
--

INSERT INTO `question_table` (`question_id`, `question`, `user_id`, `created_at`, `subject_id`, `class_id`) VALUES
('1acbd530-4e8e-11ea-a812-0910e924652d', 'Pls forward the msg.\n\nMidSem 1 starting from tomorrow!\nBe prepared with the first 2 units of all subjects.\n\nFinal timetable will be forwarded later.', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/13 19:24:44', 2, 1),
('1b15edf0-4d17-11ea-a0d3-bbd5b2658147', 'What is the name of the image of the image of the', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/11 22:40:23', 4, 4),
('291238b0-5694-11ea-91bc-b9777ba9b35d', 'Thank you Kerry We are so grateful for your kind words. Thanks for sharing your review with us. Team Subset', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/24 04:58:13', 2, 1),
('4274b690-4f4e-11ea-d89c-79caeb2ba288', 'Well I will be there at once and for all the help you have?', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/14 22:50:14', 2, 1),
('543f8010-4915-11ea-8565-5958c6dc27a7', 'do you have a pic of the image of the image of the image', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/06 20:17:35', 2, 1),
('a29fdf00-4c37-11ea-cdab-733936802645', 'vyvyvy', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/10 20:00:44', 2, 1),
('c9a06050-605c-11ea-eb2d-c35b3e08ca88', 'Hello', '06965f90-4669-11ea-a224-b7c48b686887', '2020/03/07 15:47:09', 4, 4),
('cd55c730-605c-11ea-eb2d-c35b3e08ca88', 'Hello', '06965f90-4669-11ea-a224-b7c48b686887', '2020/03/07 15:47:12', 4, 4),
('e214cb20-605d-11ea-e8d9-c18ae4a60317', 'New Questions', '06965f90-4669-11ea-a224-b7c48b686887', '2020/03/07 15:54:55', 4, 4),
('ebd22980-605f-11ea-a42f-390442ea65ea', 'yes sir I am not able to make it to the', '06965f90-4669-11ea-a224-b7c48b686887', '2020/03/07 16:09:38', 4, 4),
('ed2ce290-555e-11ea-b7cd-1fc4518c13f3', 'bxhchvjvi', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/22 16:04:44', 2, 1),
('fd06d4a0-4e8d-11ea-a812-0910e924652d', 'MidSem 1 starting from tomorrow!\nBe prepared with the first 2 units of all subjects.', '06965f90-4669-11ea-a224-b7c48b686887', '2020/02/13 19:23:54', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `result_table`
--

CREATE TABLE `result_table` (
  `result_id` int(11) NOT NULL,
  `user_uid` varchar(50) NOT NULL,
  `test_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `marks` varchar(3) NOT NULL,
  `total` varchar(5) NOT NULL DEFAULT '20'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `result_table`
--

INSERT INTO `result_table` (`result_id`, `user_uid`, `test_id`, `subject_id`, `batch_id`, `marks`, `total`) VALUES
(1, '734f5420-48e9-11ea-e2fe-1b7777785978', 1, 1, 1, '53', '20'),
(2, 'f8cf4190-484f-11ea-c2c1-99836777e478', 1, 1, 1, '60', '20'),
(3, '734f5420-48e9-11ea-e2fe-1b7777785978', 1, 1, 1, '50', '20'),
(4, 'cb6249d0-4dbf-11ea-8a40-b9e1748013c4', 1, 5, 1, '60', '20'),
(5, 'f8cf4190-484f-11ea-c2c1-99836777e478', 1, 4, 1, '80', '20'),
(6, 'cb6249d0-4dbf-11ea-8a40-b9e1748013c4', 1, 4, 1, '50', '20');

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `state_id` varchar(2) NOT NULL,
  `state_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`state_id`, `state_name`) VALUES
('AN', 'Andaman and Nicobar Islands'),
('AP', 'Andhra Pradesh'),
('AR', 'Arunachal Pradesh'),
('AS', 'Assam'),
('BR', 'Bihar'),
('CH', 'Chandigarh'),
('CT', 'Chhattisgarh'),
('DD', 'Daman and Diu'),
('DL', 'Delhi'),
('DN', 'Dadra and Nagar Haveli'),
('GA', 'Goa'),
('GJ', 'Gujarat'),
('HP', 'Himachal Pradesh'),
('HR', 'Haryana'),
('JH', 'Jharkhand'),
('JK', 'Jammu and Kashmir'),
('KA', 'Karnataka'),
('KL', 'Kerala'),
('LD', 'Lakshadweep'),
('MH', 'Maharashtra'),
('ML', 'Meghalaya'),
('MN', 'Manipur'),
('MP', 'Madhya Pradesh'),
('MZ', 'Mizoram'),
('NL', 'Nagaland'),
('OR', 'Odisha, Orissa'),
('PB', 'Punjab'),
('PY', 'Puducherry'),
('RJ', 'Rajasthan'),
('SK', 'Sikkim'),
('TG', 'Telangana'),
('TN', 'Tamil Nadu'),
('TR', 'Tripura'),
('UP', 'Uttar Pradesh'),
('UT', 'Uttarakhand,Uttaranchal'),
('WB', 'West Bengal');

-- --------------------------------------------------------

--
-- Table structure for table `student_table`
--

CREATE TABLE `student_table` (
  `user_id` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `mobile` varchar(13) NOT NULL,
  `address` varchar(200) NOT NULL,
  `birth` varchar(15) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `father_name` varchar(50) NOT NULL,
  `image` varchar(50) NOT NULL,
  `school_name` varchar(100) NOT NULL,
  `parents_mobile` varchar(15) NOT NULL,
  `token` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_table`
--

INSERT INTO `student_table` (`user_id`, `username`, `mobile`, `address`, `birth`, `gender`, `father_name`, `image`, `school_name`, `parents_mobile`, `token`) VALUES
('06965f90-4669-11ea-a224-b7c48b686887', 'Deepak Patidar', '+919926131113', 'hf', '03-02-2020', 'M', 'fuf', 'user2020021105023874.png', 'uf', '+919926131113', 'fcKTh2cSt9Y:APA91bET1mnAL4l-gWzPMabmhoAnZHsmq-Ut0ckoM2nTyMNlUrBUhA9egHBvdEUlpOtsMvLBKrX0tmNbbmXKk35gq3oWhIdp9RrKa5ZS23KAkn5a1GmcFXZ4elFKEKD5ArWBT6oYnYf5');

-- --------------------------------------------------------

--
-- Table structure for table `subject_table`
--

CREATE TABLE `subject_table` (
  `subject_id` int(11) NOT NULL,
  `subject_name` varchar(50) NOT NULL,
  `class_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subject_table`
--

INSERT INTO `subject_table` (`subject_id`, `subject_name`, `class_id`) VALUES
(1, 'Hindi', 1),
(3, 'Mathematics', 2),
(4, 'Hindi', 4),
(5, 'English', 1);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_table`
--

CREATE TABLE `teacher_table` (
  `user_id` varchar(50) NOT NULL,
  `username` varchar(100) NOT NULL,
  `mobile` varchar(13) NOT NULL,
  `address` varchar(200) NOT NULL,
  `birth` varchar(15) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `father_husband` varchar(100) NOT NULL,
  `image` varchar(50) NOT NULL,
  `subjects` varchar(100) NOT NULL,
  `experience` varchar(200) NOT NULL,
  `token` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `teacher_table`
--

INSERT INTO `teacher_table` (`user_id`, `username`, `mobile`, `address`, `birth`, `gender`, `father_husband`, `image`, `subjects`, `experience`, `token`) VALUES
('fbeab580-4917-11ea-ab59-975ee2726871', 'Deoraj Poudyal', '+919926131113', 'addresd', '07-02-2020', 'F', 'husband nane', 'user2020021105023874.png', 'maths science', 'work experience', 'fcKTh2cSt9Y:APA91bET1mnAL4l-gWzPMabmhoAnZHsmq-Ut0ckoM2nTyMNlUrBUhA9egHBvdEUlpOtsMvLBKrX0tmNbbmXKk35gq3oWhIdp9RrKa5ZS23KAkn5a1GmcFXZ4elFKEKD5ArWBT6oYnYf5');

-- --------------------------------------------------------

--
-- Table structure for table `test_list_table`
--

CREATE TABLE `test_list_table` (
  `test_id` int(11) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `created_at` varchar(30) NOT NULL,
  `year_id` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `test_list_table`
--

INSERT INTO `test_list_table` (`test_id`, `test_name`, `batch_id`, `created_at`, `year_id`) VALUES
(1, 'Test One', 1, '2020/02/04 11:11:03', '2020'),
(2, 'Test RWO', 1, '2020/02/04 13:13:24', '2020'),
(3, 'Test 5WO', 1, '2020/02/04 13:13:57', '2020');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `answer_image_table`
--
ALTER TABLE `answer_image_table`
  ADD PRIMARY KEY (`answer_image_id`);

--
-- Indexes for table `answer_table`
--
ALTER TABLE `answer_table`
  ADD PRIMARY KEY (`answer_id`);

--
-- Indexes for table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`area_id`);

--
-- Indexes for table `attendance_table`
--
ALTER TABLE `attendance_table`
  ADD PRIMARY KEY (`attendance_id`);

--
-- Indexes for table `batch_table`
--
ALTER TABLE `batch_table`
  ADD PRIMARY KEY (`batch_id`);

--
-- Indexes for table `classes_table`
--
ALTER TABLE `classes_table`
  ADD PRIMARY KEY (`class_id`);

--
-- Indexes for table `coaching_comments`
--
ALTER TABLE `coaching_comments`
  ADD PRIMARY KEY (`coaching_comments_id`);

--
-- Indexes for table `coaching_table`
--
ALTER TABLE `coaching_table`
  ADD PRIMARY KEY (`coaching_id`);

--
-- Indexes for table `coaching_user_connection_table`
--
ALTER TABLE `coaching_user_connection_table`
  ADD PRIMARY KEY (`user_uid`);

--
-- Indexes for table `comments_table`
--
ALTER TABLE `comments_table`
  ADD PRIMARY KEY (`comment_id`);

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`dist_id`);

--
-- Indexes for table `notes_table`
--
ALTER TABLE `notes_table`
  ADD PRIMARY KEY (`notes_id`);

--
-- Indexes for table `notice_files`
--
ALTER TABLE `notice_files`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notice_likes`
--
ALTER TABLE `notice_likes`
  ADD PRIMARY KEY (`notice_like_id`);

--
-- Indexes for table `notice_table`
--
ALTER TABLE `notice_table`
  ADD PRIMARY KEY (`notice_id`);

--
-- Indexes for table `notification_table`
--
ALTER TABLE `notification_table`
  ADD PRIMARY KEY (`notification_id`);

--
-- Indexes for table `question_image`
--
ALTER TABLE `question_image`
  ADD PRIMARY KEY (`question_image_id`);

--
-- Indexes for table `question_like`
--
ALTER TABLE `question_like`
  ADD PRIMARY KEY (`question_like_id`);

--
-- Indexes for table `question_table`
--
ALTER TABLE `question_table`
  ADD PRIMARY KEY (`question_id`);

--
-- Indexes for table `result_table`
--
ALTER TABLE `result_table`
  ADD PRIMARY KEY (`result_id`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`state_id`);

--
-- Indexes for table `student_table`
--
ALTER TABLE `student_table`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `subject_table`
--
ALTER TABLE `subject_table`
  ADD PRIMARY KEY (`subject_id`);

--
-- Indexes for table `teacher_table`
--
ALTER TABLE `teacher_table`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `test_list_table`
--
ALTER TABLE `test_list_table`
  ADD PRIMARY KEY (`test_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `answer_image_table`
--
ALTER TABLE `answer_image_table`
  MODIFY `answer_image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT for table `areas`
--
ALTER TABLE `areas`
  MODIFY `area_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `attendance_table`
--
ALTER TABLE `attendance_table`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `batch_table`
--
ALTER TABLE `batch_table`
  MODIFY `batch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `classes_table`
--
ALTER TABLE `classes_table`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `coaching_comments`
--
ALTER TABLE `coaching_comments`
  MODIFY `coaching_comments_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `comments_table`
--
ALTER TABLE `comments_table`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `dist_id` mediumint(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notes_table`
--
ALTER TABLE `notes_table`
  MODIFY `notes_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `notice_files`
--
ALTER TABLE `notice_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notice_likes`
--
ALTER TABLE `notice_likes`
  MODIFY `notice_like_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notification_table`
--
ALTER TABLE `notification_table`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `question_image`
--
ALTER TABLE `question_image`
  MODIFY `question_image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `question_like`
--
ALTER TABLE `question_like`
  MODIFY `question_like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `result_table`
--
ALTER TABLE `result_table`
  MODIFY `result_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `subject_table`
--
ALTER TABLE `subject_table`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `test_list_table`
--
ALTER TABLE `test_list_table`
  MODIFY `test_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
