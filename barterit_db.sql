-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 20, 2023 at 03:08 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_phone` varchar(15) NOT NULL,
  `user_address` varchar(250) NOT NULL,
  `otp` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_password`, `user_phone`, `user_address`, `otp`) VALUES
(2, 'engjoann@gmail.com', 'Eng Jo Ann', '412e360b01dc3fc44c2af3d268cf104d4266cd6d', '019-6325514', '', 16871),
(4, 'leexunan@gmail.com', 'Lee Xun An', '3c776dacfd82b327a679bdf2339cc9477299ebb6', '019-6355217', '', 83425),
(5, 'lucassong@gmail.com', 'Lucas Song', '7ce0359f12857f2a90c7de465f40a95f01cb5da9', '018-3622414', '', 80595),
(6, 'chiaweijie@gmail.com', 'Chia Wei Jie', '36ec17838bbfc77b597ca16318ab0db88156cbae', '017-6634411', '', 80988),
(7, 'kaifeng@gmail.com', 'Kong Kai Feng', '8a95c5c4adf2116e4a3524d92ed68029d1e535b3', '019-3622547', '', 32931),
(8, 'ennenn@gmail.com', 'Lee Enn Enn', 'cd911b04ad51c24842ef7d108ec804a299049d66', '012-3456789', '', 91974),
(9, 'lohyanfei@gmail.com', 'Loh Yan Fei', '93a70e141946898d2aa1a94c8c357bf31e42f46e', '012-98765422', '', 52908),
(10, 'tongen@gmail.com', 'Lim Tong En', '5aef4726f908230a4f5fa3cd2bb7a9054477eaab', '014-631212123', '', 95173),
(14, 'jiayi@gmail.com', 'Chong Jia Yi', 'bd3e8d9d8ed80a5c2c3c632d52de325789f50e9c', '012-12121234', '', 52348);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
