-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 14, 2025 at 04:23 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hardware_5`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertOrder` (IN `supplier_id` INT, IN `employee_id` INT)   BEGIN
	INSERT INTO order_table 
    (SuppID, EmpID, ReceiveDate, Status)
    VALUES (supplier_id, employee_id, CURRENT_DATE, 'Received');
    
    SELECT LAST_INSERT_ID() AS order_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Employe` (IN `p_Emp_Name` VARCHAR(100), IN `p_Position` VARCHAR(100), IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_CreatedByID` INT, IN `p_UpdatedByID` INT, IN `p_Status` VARCHAR(50))   BEGIN
	INSERT INTO employee (Emp_Name, Position, username, password, CreatedByID, UpdatedByID, Status)
    VALUES (p_Emp_Name, p_Position, p_username, p_password, p_CreatedByID, p_UpdatedByID, p_Status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Employee` (IN `p_Emp_Name` VARCHAR(100), IN `p_Position` VARCHAR(100), IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_CreatedByID` INT, IN `p_UpdatedByID` INT)   BEGIN
	INSERT INTO employee (Emp_Name, Position, username, password, CreatedByID, CreatedDate, UpdatedByID)
    VALUES (p_Emp_Name, p_Position, p_username, p_password, p_CreatedByID, now(), p_UpdatedByID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateEmployee` (IN `emp_id` INT, IN `new_name` VARCHAR(255), IN `new_position` VARCHAR(255), IN `new_status` INT, IN `updated_by` INT)   BEGIN
	UPDATE employee
    SET Emp_Name = new_name,
        Position = new_position,
        Status = new_status,
        UpdatedByID = updated_by,
        UpdatedDate = now()
    WHERE EmpID = emp_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSuppliers` (IN `p_SupplierID` INT, IN `p_SupplierName` VARCHAR(255), IN `p_Contact` VARCHAR(255), IN `p_isActive` INT)   BEGIN
    UPDATE supplier
    SET Supplier_Name = p_SupplierName,
        Contact = p_Contact,
        is_active = p_isActive
    WHERE SuppID = p_SupplierID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `Log_ID` int(11) NOT NULL,
  `Action_Type` varchar(255) DEFAULT NULL,
  `Table_Name` varchar(255) DEFAULT NULL,
  `Record_ID` int(11) DEFAULT NULL,
  `Employee_ID` int(11) DEFAULT NULL,
  `Timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `Old_value` text DEFAULT NULL,
  `New_value` text DEFAULT NULL,
  `Reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`Log_ID`, `Action_Type`, `Table_Name`, `Record_ID`, `Employee_ID`, `Timestamp`, `Old_value`, `New_value`, `Reason`) VALUES
(1, 'LOGIN', 'employee', 4, NULL, '0000-00-00 00:00:00', NULL, NULL, 'User logged in successfully'),
(2, 'LOGIN', 'employee', 4, NULL, '0000-00-00 00:00:00', NULL, NULL, 'User logged in successfully'),
(3, 'LOGIN_FAILED', 'employee', NULL, NULL, '0000-00-00 00:00:00', NULL, NULL, 'Failed login attempt for username: Nash'),
(4, 'LOGIN', 'employee', 4, NULL, '0000-00-00 00:00:00', NULL, NULL, 'User logged in successfully'),
(5, 'LOGIN', 'employee', 4, NULL, '0000-00-00 00:00:00', NULL, NULL, 'User logged in successfully'),
(6, 'LOGIN', 'employee', 4, NULL, '2025-03-13 10:03:09', NULL, NULL, 'User logged in successfully'),
(7, 'DELETE', 'employee', 7, NULL, '2025-03-13 10:03:30', 'Name: Rave1, Position: leader, Status: Inactive', NULL, 'Employee removed'),
(8, 'LOGIN', 'employee', 4, NULL, '2025-03-13 10:18:14', NULL, NULL, 'User logged in successfully'),
(9, 'PURCHASE', 'customer_order', 26, NULL, '2025-03-13 10:18:42', NULL, NULL, 'New order placed by Ravenj'),
(10, 'LOGIN', 'employee', 4, NULL, '2025-03-13 10:23:52', NULL, NULL, 'User logged in successfully'),
(11, 'LOGIN_FAILED', 'employee', NULL, NULL, '2025-03-13 10:25:02', NULL, NULL, 'Failed login attempt for username: Raven'),
(12, 'LOGIN', 'employee', 4, NULL, '2025-03-13 10:25:12', NULL, NULL, 'User logged in successfully'),
(13, 'LOGIN', 'employee', 4, NULL, '2025-03-13 10:26:08', NULL, NULL, 'User logged in successfully'),
(14, 'LOGIN', 'employee', 4, NULL, '2025-03-13 10:27:04', NULL, NULL, 'User logged in successfully'),
(15, 'LOGIN', 'employee', 4, NULL, '2025-03-13 11:06:22', NULL, NULL, 'User logged in successfully'),
(16, 'LOGIN', 'employee', 4, NULL, '2025-03-13 12:37:11', NULL, NULL, 'User logged in successfully'),
(17, 'LOGIN', 'employee', 4, NULL, '2025-03-13 12:41:30', NULL, NULL, 'User logged in successfully'),
(18, 'REGISTER', 'employee', 0, NULL, '2025-03-13 12:50:15', NULL, NULL, 'New user registered'),
(19, 'LOGIN', 'employee', 4, NULL, '2025-03-13 12:52:54', NULL, NULL, 'User logged in successfully'),
(20, 'LOGIN', 'employee', 6, NULL, '2025-03-13 13:04:41', NULL, NULL, 'User logged in successfully'),
(21, 'LOGIN', 'employee', 6, NULL, '2025-03-13 13:08:23', NULL, NULL, 'User logged in successfully'),
(22, 'LOGIN', 'employee', 6, NULL, '2025-03-13 13:15:24', NULL, NULL, 'User logged in successfully'),
(23, 'LOGIN', 'employee', 6, NULL, '2025-03-13 13:17:23', NULL, NULL, 'User logged in successfully'),
(24, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:26:36', NULL, NULL, 'User logged in successfully'),
(25, 'CREATE', 'order_table', 55, NULL, '2025-03-13 20:27:49', NULL, NULL, 'New purchase order created by Raven'),
(26, 'CREATE', 'order_table', 56, NULL, '2025-03-13 20:27:50', NULL, NULL, 'New purchase order created by Raven'),
(27, 'CREATE', 'order_table', 57, NULL, '2025-03-13 20:27:51', NULL, NULL, 'New purchase order created by Raven'),
(28, 'CREATE', 'order_table', 58, NULL, '2025-03-13 20:27:55', NULL, NULL, 'New purchase order created by Raven'),
(29, 'PURCHASE', 'customer_order', 27, NULL, '2025-03-13 20:28:50', NULL, NULL, 'New order placed by kim'),
(30, 'CREATE', 'order_table', 59, NULL, '2025-03-13 20:29:04', NULL, NULL, 'New purchase order created by Raven'),
(31, 'CREATE', 'supplier', 7, NULL, '2025-03-13 20:31:57', NULL, 'Name: OK, Contact: 222222', 'New supplier added'),
(32, 'LOGIN_FAILED', 'employee', NULL, NULL, '2025-03-13 20:40:01', NULL, NULL, 'Failed login attempt for username: Nash'),
(33, 'LOGIN_FAILED', 'employee', NULL, NULL, '2025-03-13 20:40:05', NULL, NULL, 'Failed login attempt for username: Nash'),
(34, 'LOGIN_FAILED', 'employee', NULL, NULL, '2025-03-13 20:40:37', NULL, NULL, 'Failed login attempt for username: Nash'),
(35, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:40:44', NULL, NULL, 'User logged in successfully'),
(36, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:44:47', NULL, NULL, 'User logged in successfully'),
(37, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:47:43', NULL, NULL, 'User logged in successfully'),
(38, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:47:53', NULL, NULL, 'User logged in successfully'),
(39, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:55:03', NULL, NULL, 'User logged in successfully'),
(40, 'LOGIN', 'employee', 4, NULL, '2025-03-13 20:56:38', NULL, NULL, 'User logged in successfully'),
(41, 'LOGIN', 'employee', 4, NULL, '2025-03-13 21:03:40', NULL, NULL, 'User logged in successfully'),
(42, 'LOGIN', 'employee', 4, NULL, '2025-03-13 21:05:55', NULL, NULL, 'User logged in successfully'),
(43, 'LOGIN', 'employee', 4, NULL, '2025-03-13 21:07:18', NULL, NULL, 'User logged in successfully'),
(44, 'CREATE_PURCHASE_ORDER', 'po', 60, NULL, '2025-03-13 21:07:43', NULL, NULL, 'Purchase Order #60 created by Employee ID 4'),
(45, 'LOGIN', 'employee', 6, NULL, '2025-03-14 07:39:05', NULL, NULL, 'User logged in successfully'),
(46, 'LOGIN', 'employee', 4, NULL, '2025-03-14 17:12:23', NULL, NULL, 'User logged in successfully'),
(47, 'LOGIN', 'employee', 4, NULL, '2025-03-14 17:14:31', NULL, NULL, 'User logged in successfully'),
(48, 'LOGIN', 'employee', 4, NULL, '2025-03-14 17:16:07', NULL, NULL, 'User logged in successfully'),
(49, 'LOGIN', 'employee', 4, NULL, '2025-03-14 17:26:17', NULL, NULL, 'User logged in successfully'),
(50, 'LOGIN', 'employee', 4, NULL, '2025-03-14 17:27:51', NULL, NULL, 'User logged in successfully'),
(51, 'CREATE_PURCHASE_ORDER', 'po', 61, NULL, '2025-03-14 17:52:34', NULL, NULL, 'Purchase Order #61 created by Employee ID 4'),
(52, 'LOGIN', 'employee', 4, NULL, '2025-03-14 17:59:12', NULL, NULL, 'User logged in successfully'),
(53, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:03:38', NULL, NULL, 'User logged in successfully'),
(54, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:07:45', NULL, NULL, 'User logged in successfully'),
(55, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:09:25', NULL, NULL, 'User logged in successfully'),
(56, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:25:16', NULL, NULL, 'User logged in successfully'),
(57, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:27:48', NULL, NULL, 'User logged in successfully'),
(58, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:29:10', NULL, NULL, 'User logged in successfully'),
(59, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:29:50', NULL, NULL, 'User logged in successfully'),
(60, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:31:00', NULL, NULL, 'User logged in successfully'),
(61, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:34:22', NULL, NULL, 'User logged in successfully'),
(62, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:38:40', NULL, NULL, 'User logged in successfully'),
(63, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:40:02', NULL, NULL, 'User logged in successfully'),
(64, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:47:01', NULL, NULL, 'User logged in successfully'),
(65, 'CREATE_PURCHASE_ORDER', 'po', 62, NULL, '2025-03-14 18:47:23', NULL, NULL, 'Purchase Order #62 created by Employee ID 4'),
(66, 'LOGIN', 'employee', 4, NULL, '2025-03-14 18:52:16', NULL, NULL, 'User logged in successfully'),
(67, 'CREATE_PURCHASE_ORDER', 'po', 63, NULL, '2025-03-14 18:53:53', NULL, NULL, 'Purchase Order #63 created by Employee ID 4'),
(68, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:00:13', NULL, NULL, 'User logged in successfully'),
(69, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:01:33', NULL, NULL, 'User logged in successfully'),
(70, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:04:28', NULL, NULL, 'User logged in successfully'),
(71, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:12:27', NULL, NULL, 'User logged in successfully'),
(72, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:15:05', NULL, NULL, 'User logged in successfully'),
(73, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:15:34', NULL, NULL, 'User logged in successfully'),
(74, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:17:04', NULL, NULL, 'User logged in successfully'),
(75, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:19:58', NULL, NULL, 'User logged in successfully'),
(76, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:22:40', NULL, NULL, 'User logged in successfully'),
(77, 'CREATE_PURCHASE_ORDER', 'Recieve_Order', 67, NULL, '2025-03-14 19:22:53', NULL, NULL, 'Purchase Order #67 created by Employee ID 4'),
(78, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:32:44', NULL, NULL, 'User logged in successfully'),
(79, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:35:48', NULL, NULL, 'User logged in successfully'),
(80, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:37:18', NULL, NULL, 'User logged in successfully'),
(81, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:40:13', NULL, NULL, 'User logged in successfully'),
(82, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:41:52', NULL, NULL, 'User logged in successfully'),
(83, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:42:49', NULL, NULL, 'User logged in successfully'),
(84, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:47:32', NULL, NULL, 'User logged in successfully'),
(85, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:57:13', NULL, NULL, 'User logged in successfully'),
(86, 'LOGIN', 'employee', 4, NULL, '2025-03-14 19:59:12', NULL, NULL, 'User logged in successfully'),
(87, 'UPDATE', 'supplier', 1, NULL, '2025-03-14 19:59:21', 'Name: wahaha, Contact: nooo', 'Name: wahaha, Contact: nooo', 'Supplier details updated'),
(88, 'UPDATE', 'supplier', 1, NULL, '2025-03-14 19:59:27', 'Name: wahaha, Contact: nooo', 'Name: wahaha, Contact: nooo', 'Supplier details updated'),
(89, 'LOGIN', 'employee', 4, NULL, '2025-03-14 20:00:12', NULL, NULL, 'User logged in successfully'),
(90, 'LOGIN', 'employee', 4, NULL, '2025-03-14 20:12:57', NULL, NULL, 'User logged in successfully'),
(91, 'LOGIN', 'employee', 4, NULL, '2025-03-14 20:15:12', NULL, NULL, 'User logged in successfully'),
(92, 'UPDATE', 'employee', 9, NULL, '2025-03-14 20:16:03', 'Name: Raven John M. Canedo, Position: leader, Status: Rav', 'Name: Raven John M. Canedo, Position: leader, Status: Active', 'Employee details updated'),
(93, 'UPDATE', 'employee', 9, NULL, '2025-03-14 20:17:17', 'Name: Raven John M. Canedo, Position: leader, Status: Rav', 'Name: Raven John M. Canedo, Position: leader, Status: Inactive', 'Employee details updated'),
(94, 'UPDATE', 'employee', 9, NULL, '2025-03-14 20:19:03', 'Name: Raven John M. Canedo, Position: leader, Status: Rav', 'Name: Raven John M. Canedo, Position: leader, Status: Inactive', 'Employee details updated'),
(95, 'UPDATE', 'employee', 9, NULL, '2025-03-14 20:19:09', 'Name: Raven John M. Canedo, Position: leader, Status: Rav', 'Name: Raven John M. Canedo, Position: leader, Status: Active', 'Employee details updated'),
(96, 'LOGIN', 'employee', 4, NULL, '2025-03-14 20:22:51', NULL, NULL, 'User logged in successfully'),
(97, 'UPDATE', 'employee', 4, NULL, '2025-03-14 20:24:30', 'Name: Nashen, Position: Cashier, Status: Nash', 'Name: Nashen, Position: Cashier, Status: Active', 'Employee details updated'),
(98, 'UPDATE', 'employee', 4, NULL, '2025-03-14 20:25:30', 'Name: Nashen, Position: Cashier, Status: Nash', 'Name: Nashen, Position: Cashier, Status: Inactive', 'Employee details updated'),
(99, 'UPDATE', 'employee', 9, NULL, '2025-03-14 20:25:47', 'Name: Raven John M. Canedo, Position: leader, Status: Rav', 'Name: Raven John M. Canedo, Position: leader, Status: Inactive', 'Employee details updated'),
(100, 'REGISTER', 'employee', 0, NULL, '2025-03-14 20:42:41', NULL, NULL, 'New user registered'),
(101, 'REGISTER', 'employee', 0, NULL, '2025-03-14 20:45:13', NULL, NULL, 'New user registered'),
(102, 'REGISTER', 'employee', 0, NULL, '2025-03-14 20:46:51', NULL, NULL, 'New user registered'),
(103, 'LOGIN', 'employee', 12, NULL, '2025-03-14 20:46:56', NULL, NULL, 'User logged in successfully'),
(104, 'UPDATE', 'employee', 9, NULL, '2025-03-14 20:47:16', 'Name: Raven John M. Canedo, Position: leader, Status: Rav', 'Name: Raven John M. Canedo, Position: leader, Status: Active', 'Employee details updated'),
(105, 'UPDATE', 'employee', 4, NULL, '2025-03-14 20:47:23', 'Name: Nashen, Position: Cashier, Status: Nash', 'Name: Nashen, Position: Cashier, Status: Active', 'Employee details updated'),
(106, 'CREATE', 'supplier_return', 1, NULL, '2025-03-14 20:48:56', NULL, NULL, 'Supplier return created for Order ID: 67'),
(107, 'CREATE', 'supplier_return', 2, NULL, '2025-03-14 20:48:58', NULL, NULL, 'Supplier return created for Order ID: 67'),
(108, 'CREATE', 'supplier_return', 3, NULL, '2025-03-14 20:49:39', NULL, NULL, 'Supplier return created for Order ID: 67'),
(109, 'CREATE', 'supplier_return', 4, NULL, '2025-03-14 20:51:53', NULL, NULL, 'Supplier return created for Order ID: 67'),
(110, 'CREATE', 'supplier_return', 5, NULL, '2025-03-14 20:51:56', NULL, NULL, 'Supplier return created for Order ID: 67'),
(111, 'CREATE', 'supplier_return', 6, NULL, '2025-03-14 20:52:00', NULL, NULL, 'Supplier return created for Order ID: 67'),
(112, 'CREATE', 'supplier_return', 7, NULL, '2025-03-14 20:52:22', NULL, NULL, 'Supplier return created for Order ID: 63'),
(113, 'LOGIN', 'employee', 12, NULL, '2025-03-14 20:54:19', NULL, NULL, 'User logged in successfully'),
(114, 'CREATE', 'supplier_return', 8, NULL, '2025-03-14 20:54:29', NULL, NULL, 'Supplier return created for Order ID: 63'),
(115, 'CREATE', 'supplier_return', 9, NULL, '2025-03-14 20:54:31', NULL, NULL, 'Supplier return created for Order ID: 63'),
(116, 'CREATE', 'supplier_return', 10, NULL, '2025-03-14 20:54:38', NULL, NULL, 'Supplier return created for Order ID: 63'),
(117, 'LOGIN', 'employee', 12, NULL, '2025-03-14 20:55:23', NULL, NULL, 'User logged in successfully'),
(118, 'CREATE', 'supplier_return', 11, NULL, '2025-03-14 20:55:32', NULL, NULL, 'Supplier return created for Order ID: 63'),
(119, 'CREATE', 'supplier_return', 12, NULL, '2025-03-14 20:55:34', NULL, NULL, 'Supplier return created for Order ID: 63'),
(120, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:01:49', NULL, NULL, 'User logged in successfully'),
(121, 'CREATE', 'supplier_return', 13, NULL, '2025-03-14 21:01:58', NULL, NULL, 'Supplier return created for Order ID: 63'),
(122, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:02:45', NULL, NULL, 'User logged in successfully'),
(123, 'CREATE', 'supplier_return', 14, NULL, '2025-03-14 21:02:56', NULL, NULL, 'Supplier return created for Order ID: 63'),
(124, 'CREATE', 'supplier_return', 15, NULL, '2025-03-14 21:02:58', NULL, NULL, 'Supplier return created for Order ID: 63'),
(125, 'CREATE', 'supplier_return', 16, NULL, '2025-03-14 21:02:59', NULL, NULL, 'Supplier return created for Order ID: 63'),
(126, 'CREATE', 'supplier_return', 17, NULL, '2025-03-14 21:02:59', NULL, NULL, 'Supplier return created for Order ID: 63'),
(127, 'CREATE', 'supplier_return', 18, NULL, '2025-03-14 21:03:00', NULL, NULL, 'Supplier return created for Order ID: 63'),
(128, 'CREATE', 'supplier_return', 19, NULL, '2025-03-14 21:03:00', NULL, NULL, 'Supplier return created for Order ID: 63'),
(129, 'CREATE', 'supplier_return', 20, NULL, '2025-03-14 21:03:00', NULL, NULL, 'Supplier return created for Order ID: 63'),
(130, 'CREATE', 'supplier_return', 21, NULL, '2025-03-14 21:03:00', NULL, NULL, 'Supplier return created for Order ID: 63'),
(131, 'CREATE', 'supplier_return', 22, NULL, '2025-03-14 21:03:00', NULL, NULL, 'Supplier return created for Order ID: 63'),
(132, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:03:38', NULL, NULL, 'User logged in successfully'),
(133, 'CREATE', 'supplier_return', 23, NULL, '2025-03-14 21:03:48', NULL, NULL, 'Supplier return created for Order ID: 63'),
(134, 'CREATE', 'supplier_return', 24, NULL, '2025-03-14 21:03:50', NULL, NULL, 'Supplier return created for Order ID: 63'),
(135, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:04:39', NULL, NULL, 'User logged in successfully'),
(136, 'CREATE', 'supplier_return', 25, NULL, '2025-03-14 21:04:45', NULL, NULL, 'Supplier return created for Order ID: 63'),
(137, 'CREATE', 'supplier_return', 26, NULL, '2025-03-14 21:04:47', NULL, NULL, 'Supplier return created for Order ID: 63'),
(138, 'CREATE', 'supplier_return', 27, NULL, '2025-03-14 21:25:51', NULL, NULL, 'Supplier return created for Order ID: 63'),
(139, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:27:47', NULL, NULL, 'User logged in successfully'),
(140, 'CREATE', 'supplier_return', 28, NULL, '2025-03-14 21:27:59', NULL, NULL, 'Supplier return created for Order ID: 63'),
(141, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:31:29', NULL, NULL, 'User logged in successfully'),
(142, 'CREATE', 'supplier_return', 29, NULL, '2025-03-14 21:31:41', NULL, NULL, 'Supplier return created for Order ID: 63'),
(143, 'CREATE', 'supplier_return', 30, NULL, '2025-03-14 21:32:15', NULL, NULL, 'Supplier return created for Order ID: 63'),
(144, 'CREATE', 'supplier_return', 31, NULL, '2025-03-14 21:32:25', NULL, NULL, 'Supplier return created for Order ID: 63'),
(145, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:36:04', NULL, NULL, 'User logged in successfully'),
(146, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:37:13', NULL, NULL, 'User logged in successfully'),
(147, 'CREATE', 'supplier_return', 32, NULL, '2025-03-14 21:37:22', NULL, NULL, 'Supplier return created for Order ID: 63'),
(148, 'LOGIN', 'employee', 4, NULL, '2025-03-14 21:37:53', NULL, NULL, 'User logged in successfully'),
(149, 'CREATE', 'supplier_return', 33, NULL, '2025-03-14 21:38:03', NULL, NULL, 'Supplier return created for Order ID: 63'),
(150, 'CREATE', 'supplier_return', 34, NULL, '2025-03-14 21:38:13', NULL, NULL, 'Supplier return created for Order ID: 63'),
(151, 'CREATE', 'supplier_return', 35, NULL, '2025-03-14 21:42:29', NULL, NULL, 'Supplier return created for Order ID: 63'),
(152, 'ADD_ITEM', 'supplier_return_details', 35, NULL, '2025-03-14 21:42:29', NULL, 'Item: 3, Quantity: 4, Refund: 13600.00', 'Item added to supplier return #35'),
(153, 'CREATE', 'supplier_return', 36, NULL, '2025-03-14 21:51:03', NULL, NULL, 'Supplier return created for Order ID: 63'),
(154, 'ADD_ITEM', 'supplier_return_details', 36, NULL, '2025-03-14 21:51:03', NULL, 'Item: 3, Quantity: 4, Refund: 13600.00', 'Item added to supplier return #36'),
(155, 'PURCHASE', 'customer_order', 28, NULL, '2025-03-14 21:55:23', NULL, NULL, 'New order placed by Nash'),
(156, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:09:44', NULL, NULL, 'User logged in successfully'),
(157, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:11:21', NULL, NULL, 'User logged in successfully'),
(158, 'PURCHASE', 'customer_order', 29, NULL, '2025-03-14 22:11:37', NULL, NULL, 'New order placed by hughs'),
(159, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:36:13', NULL, NULL, 'User logged in successfully'),
(160, 'CREATE', 'supplier_return', 37, NULL, '2025-03-14 22:36:45', NULL, NULL, 'Supplier return created for Order ID: 67'),
(161, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:37:27', NULL, NULL, 'User logged in successfully'),
(162, 'CREATE', 'supplier_return', 38, NULL, '2025-03-14 22:37:59', NULL, NULL, 'Supplier return created for Order ID: 67'),
(163, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:39:11', NULL, NULL, 'User logged in successfully'),
(164, 'CREATE', 'supplier_return', 39, NULL, '2025-03-14 22:39:21', NULL, NULL, 'Supplier return created for Order ID: 67'),
(165, 'ADD_ITEM', 'supplier_return_details', 39, NULL, '2025-03-14 22:39:21', NULL, 'Item: 23, Quantity: 4, Refund: 15.96', 'Item added to supplier return #39'),
(166, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:51:18', NULL, NULL, 'User logged in successfully'),
(167, 'CREATE', 'customer_return', 1, NULL, '2025-03-14 22:51:59', NULL, NULL, 'Customer return created for Order ID: 29'),
(168, 'LOGIN', 'employee', 4, NULL, '2025-03-14 22:52:47', NULL, NULL, 'User logged in successfully'),
(169, 'CREATE', 'customer_return', 2, NULL, '2025-03-14 22:54:08', NULL, NULL, 'Customer return created for Order ID: 29'),
(170, 'LOGIN', 'employee', 4, NULL, '2025-03-14 23:03:37', NULL, NULL, 'User logged in successfully'),
(171, 'CREATE', 'customer_return', 3, NULL, '2025-03-14 23:04:04', NULL, NULL, 'Customer return created for Order ID: 29'),
(172, 'LOGIN', 'employee', 4, NULL, '2025-03-14 23:04:52', NULL, NULL, 'User logged in successfully'),
(173, 'CREATE', 'customer_return', 4, NULL, '2025-03-14 23:05:23', NULL, NULL, 'Customer return created for Order ID: 29'),
(174, 'ADD_ITEM', 'customer_return_details', 4, NULL, '2025-03-14 23:05:23', NULL, 'Item: 7, Quantity: 1, Refund: 4200.00', 'Item added to customer return #4'),
(175, 'PURCHASE', 'customer_order', 30, NULL, '2025-03-14 23:06:06', NULL, NULL, 'New order placed by Raven'),
(176, 'CREATE', 'customer_return', 5, NULL, '2025-03-14 23:07:06', NULL, NULL, 'Customer return created for Order ID: 30'),
(177, 'ADD_ITEM', 'customer_return_details', 5, NULL, '2025-03-14 23:07:06', NULL, 'Item: 7, Quantity: 1, Refund: 4200.00', 'Item added to customer return #5'),
(178, 'LOGIN', 'employee', 4, NULL, '2025-03-14 23:11:21', NULL, NULL, 'User logged in successfully'),
(179, 'LOGIN', 'employee', 4, NULL, '2025-03-14 23:12:38', NULL, NULL, 'User logged in successfully'),
(180, 'LOGIN', 'employee', 4, NULL, '2025-03-14 23:16:14', NULL, NULL, 'User logged in successfully'),
(181, 'LOGIN', 'employee', 4, NULL, '2025-03-14 23:21:13', NULL, NULL, 'User logged in successfully');

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL,
  `Payment_Status` varchar(50) DEFAULT NULL,
  `Order_status` varchar(50) DEFAULT NULL,
  `OrderTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `EmpID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_order`
--

INSERT INTO `customer_order` (`OrderID`, `CustomerName`, `OrderDate`, `TotalAmount`, `Payment_Status`, `Order_status`, `OrderTimestamp`, `EmpID`) VALUES
(12, 'Raven', '2025-03-12 08:47:31', 7000.00, 'Paid', 'Cancelled', '2025-03-12 08:50:48', NULL),
(13, 'Ravens', '2025-03-12 08:50:39', 33000.00, 'Pending', 'Processing', '2025-03-12 08:50:48', NULL),
(22, 'ravens', '2025-03-12 16:56:18', 3500.00, 'Paid', 'Completed', '2025-03-12 08:56:18', NULL),
(23, 'trish', '2025-03-12 17:18:59', 200.00, 'Paid', 'Processing', '2025-03-12 09:18:59', NULL),
(24, 'Rizinni', '2025-03-12 20:40:54', 3500.00, 'Pending', 'Processing', '2025-03-12 12:40:54', NULL),
(25, 'rai', '2025-03-13 07:21:05', 200.00, 'Paid', 'Completed', '2025-03-12 23:21:05', NULL),
(26, 'Ravenj', '2025-03-13 10:18:40', 200.00, 'Paid', 'Processing', '2025-03-13 02:18:40', NULL),
(27, 'kim', '2025-03-13 20:28:49', 600.00, 'Pending', 'Processing', '2025-03-13 12:28:49', NULL),
(28, 'Nash', '2025-03-14 21:55:22', 33600.00, 'Paid', 'Completed', '2025-03-14 13:55:22', NULL),
(29, 'hughs', '2025-03-14 22:11:35', 4200.00, 'Paid', 'Completed', '2025-03-14 14:11:35', 4),
(30, 'Raven', '2025-03-14 23:06:04', 4200.00, 'Paid', 'Completed', '2025-03-14 15:06:04', 4);

-- --------------------------------------------------------

--
-- Table structure for table `customer_return`
--

CREATE TABLE `customer_return` (
  `Cust_Return_ID` int(11) NOT NULL,
  `CustOrder_ID` int(11) DEFAULT NULL,
  `Return_Date` datetime DEFAULT NULL,
  `Return_reason` text DEFAULT NULL,
  `Return_status` varchar(50) DEFAULT NULL,
  `Processed_by_Employee` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_return`
--

INSERT INTO `customer_return` (`Cust_Return_ID`, `CustOrder_ID`, `Return_Date`, `Return_reason`, `Return_status`, `Processed_by_Employee`) VALUES
(1, 29, '2025-03-14 22:51:59', 'faulty', 'Pending', 4),
(2, 29, '2025-03-14 22:54:08', 'faukty', 'Pending', 4),
(3, 29, '2025-03-14 23:04:04', 'faulty', 'Pending', 4),
(4, 29, '2025-03-14 23:05:23', 'asd', 'Pending', 4),
(5, 30, '2025-03-14 23:07:06', 'Mahal', 'Pending', 4);

-- --------------------------------------------------------

--
-- Table structure for table `customer_return_details`
--

CREATE TABLE `customer_return_details` (
  `CustReturnDetails_ID` int(11) NOT NULL,
  `Cust_Return_ID` int(11) DEFAULT NULL,
  `CODetails_ID` int(11) DEFAULT NULL,
  `Quantity_Returned` int(11) DEFAULT NULL,
  `Refund_Amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_return_details`
--

INSERT INTO `customer_return_details` (`CustReturnDetails_ID`, `Cust_Return_ID`, `CODetails_ID`, `Quantity_Returned`, `Refund_Amount`) VALUES
(2, 4, 32, 1, 4200.00),
(3, 5, 33, 1, 4200.00);

-- --------------------------------------------------------

--
-- Table structure for table `custorder_details`
--

CREATE TABLE `custorder_details` (
  `CODetails_ID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Unit_Price` decimal(10,2) DEFAULT NULL,
  `Total_Price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `custorder_details`
--

INSERT INTO `custorder_details` (`CODetails_ID`, `OrderID`, `ItemID`, `Quantity`, `Unit_Price`, `Total_Price`) VALUES
(22, 12, 3, 2, 3500.00, 7000.00),
(23, 13, 8, 6, 5500.00, 33000.00),
(24, 22, 3, 1, 3500.00, 3500.00),
(25, 23, 4, 1, 200.00, 200.00),
(26, 24, 3, 1, 3500.00, 3500.00),
(27, 25, 4, 1, 200.00, 200.00),
(28, 26, 4, 1, 200.00, 200.00),
(29, 27, 9, 2, 300.00, 600.00),
(30, 28, 4, 21, 200.00, 4200.00),
(31, 28, 7, 7, 4200.00, 29400.00),
(32, 29, 7, 1, 4200.00, 4200.00),
(33, 30, 7, 1, 4200.00, 4200.00);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmpID` int(11) NOT NULL,
  `Emp_Name` varchar(255) DEFAULT NULL,
  `Position` varchar(255) DEFAULT NULL,
  `username` varchar(25) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `CreatedByID` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `UpdatedByID` int(11) DEFAULT NULL,
  `UpdatedDate` datetime DEFAULT NULL,
  `Status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmpID`, `Emp_Name`, `Position`, `username`, `password`, `CreatedByID`, `CreatedDate`, `UpdatedByID`, `UpdatedDate`, `Status`) VALUES
(4, 'Nashen', 'Cashier', 'Nash', '$2b$12$qynb7plurMkGKUxn3KhBGuuhzqr3VEVBOkLY0ACwY1DAoZzI0Ayqi', 1, '2025-03-07 19:42:19', 12, '2025-03-14 20:47:23', 1),
(5, 'Nash1', 'okay', 'Nashh', '$2b$12$lPOrY6R4s6tPRgqxliTLoeQOMBmk5X94gZF.ccBqXGbDb6D86YoTu', 1, '2025-03-07 19:46:26', 1, '2025-03-07 19:46:26', 1),
(6, 'Raven', 'Raven@gmail.com', 'Rav', '$2b$12$SsfKD9T/H/1aAj/jwtauue3yKXCTVR.C8zZwY1h.QXLp6floK3..a', 1, '2025-03-10 10:08:20', 1, '2025-03-10 10:08:20', 1),
(9, 'Raven John M. Canedo', 'leader', 'Rav', '$2b$12$F5ZzmIgqSa94J96blvciUe6/9BBLVcLSgNivMnYx6x94ZcJzS1K8y', 1, NULL, 12, '2025-03-14 20:47:16', 1),
(12, 'Rav John', 'manager', 'rav123', '$2b$12$qN0LqpJUlfCkVZOGFP2uB.Wlbrb2h08mlgbDuvkPLv60fQ3R.SiKi', 0, '2025-03-14 20:46:51', 0, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `ItemID` int(11) NOT NULL,
  `ItemName` varchar(255) DEFAULT NULL,
  `Is_Serialized` int(11) DEFAULT NULL,
  `Quantity_in_Stock` int(11) DEFAULT NULL,
  `SellingPrice` decimal(10,2) DEFAULT 0.00,
  `Category` varchar(50) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`ItemID`, `ItemName`, `Is_Serialized`, `Quantity_in_Stock`, `SellingPrice`, `Category`, `Description`, `is_active`) VALUES
(2, 'Screwdriver Set', 0, 30, 250.00, NULL, NULL, 1),
(3, 'Electric Drill', 0, 6, 3500.00, NULL, NULL, 1),
(4, 'Adjustable Wrench', 0, 16, 200.00, NULL, NULL, 1),
(7, 'Cordless Grinder', 0, 1, 4200.00, NULL, NULL, 1),
(8, 'Circular Saw', 0, -1, 5500.00, NULL, NULL, 1),
(9, 'Chisel Set', 0, 18, 300.00, NULL, NULL, 1),
(13, 'VALVES', 0, 100, NULL, NULL, NULL, 1),
(14, 'soap', 0, 20, NULL, NULL, NULL, 1),
(15, 'Raven', 0, 1000, 12.00, 'human', 'ravens', 0),
(16, 'gilgre', 0, 3, 1.00, 'human', 'smart', 0),
(17, 'raven', 0, 5, 3.00, 'human', 'ye', 0),
(18, 'Hammerdin', 0, 12, 3.99, 'Tools', 'Steel', 1),
(19, 'qwerty', 0, 12, 9.99, 'Tools', 'asdfg', 1),
(23, 'zxc', 0, 8, 4.39, 'Tools', 'asd', 1);

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `OrDetail_ID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`OrDetail_ID`, `OrderID`, `ItemID`, `Quantity`, `UnitPrice`) VALUES
(25, 46, 4, 3, 3.00),
(26, 47, 13, 100, 50.00),
(27, 48, 13, 200, 60.00),
(28, 49, 13, 1, 200.00),
(29, 50, 7, 1, 20.00),
(30, 51, 14, 20, 1.00),
(31, 53, 15, 1000, 12.00),
(32, 54, 16, 3, 1.00),
(33, 60, 17, 5, 3.00),
(34, 61, 18, 12, 3.99),
(35, 62, 19, 12, 9.99),
(36, 63, 3, 12, 3400.00),
(40, 67, 23, 12, 3.99);

-- --------------------------------------------------------

--
-- Table structure for table `order_table`
--

CREATE TABLE `order_table` (
  `OrderID` int(11) NOT NULL,
  `SuppID` int(11) DEFAULT NULL,
  `ReceiveDate` datetime DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `EmpID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_table`
--

INSERT INTO `order_table` (`OrderID`, `SuppID`, `ReceiveDate`, `Status`, `EmpID`) VALUES
(46, 2, '2025-03-19 00:00:00', 'Pending', 6),
(47, 2, '2025-03-19 00:00:00', 'Pending', 5),
(48, 2, '2025-03-19 00:00:00', 'Pending', 6),
(49, 2, '2025-03-19 00:00:00', 'Pending', 5),
(50, 2, '2025-03-19 00:00:00', 'Pending', 5),
(51, 2, '2025-03-19 00:00:00', 'Pending', 6),
(53, 2, '2025-03-19 00:00:00', 'Pending', 5),
(54, 2, '2025-03-19 00:00:00', 'Pending', 5),
(55, 2, '2025-03-20 00:00:00', 'Pending', 6),
(56, 2, '2025-03-20 00:00:00', 'Pending', 6),
(57, 2, '2025-03-20 00:00:00', 'Pending', 6),
(58, 2, '2025-03-20 00:00:00', 'Pending', 6),
(59, 2, '2025-03-20 00:00:00', 'Pending', 6),
(60, 2, '2025-03-20 00:00:00', 'Pending', 4),
(61, 2, '2025-03-21 00:00:00', 'Pending', 4),
(62, 2, '2025-03-14 00:00:00', 'Received', 4),
(63, 2, '2025-03-14 00:00:00', 'Received', 4),
(67, 5, '2025-03-14 00:00:00', 'Received', 4);

-- --------------------------------------------------------

--
-- Table structure for table `stock_adjustment`
--

CREATE TABLE `stock_adjustment` (
  `Adjustment_ID` int(11) NOT NULL,
  `EmpID` int(11) DEFAULT NULL,
  `ReportedDate` datetime DEFAULT NULL,
  `Adjustment_Type` varchar(50) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_adjustment`
--

INSERT INTO `stock_adjustment` (`Adjustment_ID`, `EmpID`, `ReportedDate`, `Adjustment_Type`, `Status`) VALUES
(1, 4, '2025-03-14 22:36:45', 'Supplier Return', 'Pending'),
(2, 4, '2025-03-14 22:37:59', 'Supplier Return', 'Pending'),
(3, 4, '2025-03-14 22:39:21', 'Supplier Return', 'Pending'),
(4, 4, '2025-03-14 22:51:59', 'Customer Return', 'Pending'),
(5, 4, '2025-03-14 22:54:08', 'Customer Return', 'Pending'),
(6, 4, '2025-03-14 23:04:04', 'Customer Return', 'Pending'),
(7, 4, '2025-03-14 23:05:23', 'Customer Return', 'Pending'),
(8, 4, '2025-03-14 23:07:06', 'Customer Return', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `stock_adjustment_detail`
--

CREATE TABLE `stock_adjustment_detail` (
  `AdjustmentDetail_ID` int(11) NOT NULL,
  `Adjustment_ID` int(11) DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Quantity_Adjusted` int(11) DEFAULT NULL,
  `Previous_Quantity` int(11) DEFAULT NULL,
  `New_Quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_adjustment_detail`
--

INSERT INTO `stock_adjustment_detail` (`AdjustmentDetail_ID`, `Adjustment_ID`, `ItemID`, `Quantity_Adjusted`, `Previous_Quantity`, `New_Quantity`) VALUES
(1, 3, 23, -4, 12, 8),
(2, 7, 7, 1, 0, 1),
(3, 8, 7, 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `SuppID` int(11) NOT NULL,
  `Supplier_Name` varchar(255) DEFAULT NULL,
  `Contact` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`SuppID`, `Supplier_Name`, `Contact`, `is_active`) VALUES
(1, 'wahaha', 'nooo', 0),
(2, 'Holcim', 'hahaha', 1),
(3, 'wow', '1239', 1),
(4, 'Eavn2', 'www', 1),
(5, 'shell', 'oil', 1),
(6, 'Raven', '095138', 1),
(7, 'OK', '222222', 1);

-- --------------------------------------------------------

--
-- Table structure for table `supplier_return`
--

CREATE TABLE `supplier_return` (
  `Supp_Return_ID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `SuppID` int(11) DEFAULT NULL,
  `Return_date` datetime DEFAULT NULL,
  `Return_reason` text DEFAULT NULL,
  `Return_status` varchar(50) DEFAULT NULL,
  `Processed_by_Employee` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier_return`
--

INSERT INTO `supplier_return` (`Supp_Return_ID`, `OrderID`, `SuppID`, `Return_date`, `Return_reason`, `Return_status`, `Processed_by_Employee`) VALUES
(1, 67, 5, '2025-03-14 20:48:56', 'Faulty', 'Pending', 4),
(2, 67, 5, '2025-03-14 20:48:58', 'Faulty', 'Pending', 4),
(3, 67, 5, '2025-03-14 20:49:39', 'Faulty', 'Pending', 4),
(4, 67, 5, '2025-03-14 20:51:53', 'Faulty', 'Pending', 4),
(5, 67, 5, '2025-03-14 20:51:56', 'Faulty', 'Pending', 4),
(6, 67, 5, '2025-03-14 20:52:00', 'Faulty', 'Pending', 4),
(7, 63, 2, '2025-03-14 20:52:22', 'zcx', 'Pending', 4),
(8, 63, 2, '2025-03-14 20:54:29', 'asd', 'Pending', 4),
(9, 63, 2, '2025-03-14 20:54:31', 'asd', 'Pending', 4),
(10, 63, 2, '2025-03-14 20:54:38', 'asd', 'Pending', 4),
(11, 63, 2, '2025-03-14 20:55:32', 'asd', 'Pending', 4),
(12, 63, 2, '2025-03-14 20:55:34', 'asd', 'Pending', 4),
(13, 63, 2, '2025-03-14 21:01:58', 'ghj', 'Pending', 4),
(14, 63, 2, '2025-03-14 21:02:56', 'qwe', 'Pending', 4),
(15, 63, 2, '2025-03-14 21:02:57', 'qwe', 'Pending', 4),
(16, 63, 2, '2025-03-14 21:02:59', 'qwe', 'Pending', 4),
(17, 63, 2, '2025-03-14 21:02:59', 'qwe', 'Pending', 4),
(18, 63, 2, '2025-03-14 21:03:00', 'qwe', 'Pending', 4),
(19, 63, 2, '2025-03-14 21:03:00', 'qwe', 'Pending', 4),
(20, 63, 2, '2025-03-14 21:03:00', 'qwe', 'Pending', 4),
(21, 63, 2, '2025-03-14 21:03:00', 'qwe', 'Pending', 4),
(22, 63, 2, '2025-03-14 21:03:00', 'qwe', 'Pending', 4),
(23, 63, 2, '2025-03-14 21:03:48', 'asd', 'Pending', 4),
(24, 63, 2, '2025-03-14 21:03:50', 'asd', 'Pending', 4),
(25, 63, 2, '2025-03-14 21:04:45', 'asd', 'Pending', 4),
(26, 63, 2, '2025-03-14 21:04:47', 'asd', 'Pending', 4),
(27, 63, 2, '2025-03-14 21:25:51', 'asd', 'Pending', 4),
(28, 63, 2, '2025-03-14 21:27:59', 'zxc', 'Pending', 4),
(29, 63, 2, '2025-03-14 21:31:41', '123', 'Pending', 4),
(30, 63, 2, '2025-03-14 21:32:15', '123', 'Pending', 4),
(31, 63, 2, '2025-03-14 21:32:25', '123', 'Pending', 4),
(32, 63, 2, '2025-03-14 21:37:22', 'asd', 'Pending', 4),
(33, 63, 2, '2025-03-14 21:38:03', 'asd', 'Pending', 4),
(34, 63, 2, '2025-03-14 21:38:13', 'asd', 'Pending', 4),
(35, 63, 2, '2025-03-14 21:42:29', 'asd', 'Pending', 4),
(36, 63, 2, '2025-03-14 21:51:03', 'ads', 'Pending', 4),
(37, 67, 5, '2025-03-14 22:36:45', 'faulty', 'Pending', 4),
(38, 67, 5, '2025-03-14 22:37:59', 'faulty', 'Pending', 4),
(39, 67, 5, '2025-03-14 22:39:21', 'faulty', 'Pending', 4);

-- --------------------------------------------------------

--
-- Table structure for table `supplier_return_details`
--

CREATE TABLE `supplier_return_details` (
  `SuppReturnDetails_ID` int(11) NOT NULL,
  `Supp_Return_ID` int(11) DEFAULT NULL,
  `itemID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Refund_amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier_return_details`
--

INSERT INTO `supplier_return_details` (`SuppReturnDetails_ID`, `Supp_Return_ID`, `itemID`, `Quantity`, `Refund_amount`) VALUES
(1, 35, 3, 4, 13600.00),
(2, 36, 3, 4, 13600.00),
(5, 39, 23, 4, 15.96);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`Log_ID`),
  ADD KEY `Employee_ID` (`Employee_ID`);

--
-- Indexes for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `fk_EmpID` (`EmpID`);

--
-- Indexes for table `customer_return`
--
ALTER TABLE `customer_return`
  ADD PRIMARY KEY (`Cust_Return_ID`),
  ADD KEY `CustOrder_ID` (`CustOrder_ID`),
  ADD KEY `Processed_by_Employee` (`Processed_by_Employee`);

--
-- Indexes for table `customer_return_details`
--
ALTER TABLE `customer_return_details`
  ADD PRIMARY KEY (`CustReturnDetails_ID`),
  ADD KEY `Cust_Return_ID` (`Cust_Return_ID`),
  ADD KEY `CODetails_ID` (`CODetails_ID`);

--
-- Indexes for table `custorder_details`
--
ALTER TABLE `custorder_details`
  ADD PRIMARY KEY (`CODetails_ID`),
  ADD KEY `ItemID` (`ItemID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmpID`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`ItemID`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`OrDetail_ID`),
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `ItemID` (`ItemID`);

--
-- Indexes for table `order_table`
--
ALTER TABLE `order_table`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `SuppID` (`SuppID`),
  ADD KEY `EmpID` (`EmpID`);

--
-- Indexes for table `stock_adjustment`
--
ALTER TABLE `stock_adjustment`
  ADD PRIMARY KEY (`Adjustment_ID`),
  ADD KEY `EmpID` (`EmpID`);

--
-- Indexes for table `stock_adjustment_detail`
--
ALTER TABLE `stock_adjustment_detail`
  ADD PRIMARY KEY (`AdjustmentDetail_ID`),
  ADD KEY `Adjustment_ID` (`Adjustment_ID`),
  ADD KEY `ItemID` (`ItemID`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`SuppID`);

--
-- Indexes for table `supplier_return`
--
ALTER TABLE `supplier_return`
  ADD PRIMARY KEY (`Supp_Return_ID`),
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `SuppID` (`SuppID`),
  ADD KEY `Processed_by_Employee` (`Processed_by_Employee`);

--
-- Indexes for table `supplier_return_details`
--
ALTER TABLE `supplier_return_details`
  ADD PRIMARY KEY (`SuppReturnDetails_ID`),
  ADD KEY `Supp_Return_ID` (`Supp_Return_ID`),
  ADD KEY `fk_itemID` (`itemID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `customer_return`
--
ALTER TABLE `customer_return`
  MODIFY `Cust_Return_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `customer_return_details`
--
ALTER TABLE `customer_return_details`
  MODIFY `CustReturnDetails_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `custorder_details`
--
ALTER TABLE `custorder_details`
  MODIFY `CODetails_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `EmpID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `ItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `OrDetail_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `order_table`
--
ALTER TABLE `order_table`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `stock_adjustment`
--
ALTER TABLE `stock_adjustment`
  MODIFY `Adjustment_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `stock_adjustment_detail`
--
ALTER TABLE `stock_adjustment_detail`
  MODIFY `AdjustmentDetail_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `SuppID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `supplier_return`
--
ALTER TABLE `supplier_return`
  MODIFY `Supp_Return_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `supplier_return_details`
--
ALTER TABLE `supplier_return_details`
  MODIFY `SuppReturnDetails_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`Employee_ID`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD CONSTRAINT `fk_EmpID` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `customer_return`
--
ALTER TABLE `customer_return`
  ADD CONSTRAINT `customer_return_ibfk_1` FOREIGN KEY (`CustOrder_ID`) REFERENCES `customer_order` (`OrderID`),
  ADD CONSTRAINT `customer_return_ibfk_2` FOREIGN KEY (`Processed_by_Employee`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `customer_return_details`
--
ALTER TABLE `customer_return_details`
  ADD CONSTRAINT `customer_return_details_ibfk_1` FOREIGN KEY (`Cust_Return_ID`) REFERENCES `customer_return` (`Cust_Return_ID`),
  ADD CONSTRAINT `customer_return_details_ibfk_2` FOREIGN KEY (`CODetails_ID`) REFERENCES `custorder_details` (`CODetails_ID`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `order_table` (`OrderID`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`);

--
-- Constraints for table `order_table`
--
ALTER TABLE `order_table`
  ADD CONSTRAINT `order_table_ibfk_1` FOREIGN KEY (`SuppID`) REFERENCES `supplier` (`SuppID`),
  ADD CONSTRAINT `order_table_ibfk_2` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `stock_adjustment`
--
ALTER TABLE `stock_adjustment`
  ADD CONSTRAINT `stock_adjustment_ibfk_1` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `stock_adjustment_detail`
--
ALTER TABLE `stock_adjustment_detail`
  ADD CONSTRAINT `stock_adjustment_detail_ibfk_1` FOREIGN KEY (`Adjustment_ID`) REFERENCES `stock_adjustment` (`Adjustment_ID`),
  ADD CONSTRAINT `stock_adjustment_detail_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`);

--
-- Constraints for table `supplier_return`
--
ALTER TABLE `supplier_return`
  ADD CONSTRAINT `supplier_return_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `order_table` (`OrderID`),
  ADD CONSTRAINT `supplier_return_ibfk_2` FOREIGN KEY (`SuppID`) REFERENCES `supplier` (`SuppID`),
  ADD CONSTRAINT `supplier_return_ibfk_3` FOREIGN KEY (`Processed_by_Employee`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `supplier_return_details`
--
ALTER TABLE `supplier_return_details`
  ADD CONSTRAINT `fk_itemID` FOREIGN KEY (`itemID`) REFERENCES `items` (`ItemID`),
  ADD CONSTRAINT `supplier_return_details_ibfk_1` FOREIGN KEY (`Supp_Return_ID`) REFERENCES `supplier_return` (`Supp_Return_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
