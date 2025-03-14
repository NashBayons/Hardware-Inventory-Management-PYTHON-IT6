-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3307
-- Generation Time: Mar 14, 2025 at 12:40 AM
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
-- Database: `hardhardware`
--

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
(45, 'LOGIN', 'employee', 6, NULL, '2025-03-14 07:39:05', NULL, NULL, 'User logged in successfully');

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL,
  `Payment_Status` varchar(50) DEFAULT NULL,
  `Order_status` varchar(50) DEFAULT NULL,
  `OrderTimestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_order`
--

INSERT INTO `customer_order` (`OrderID`, `CustomerName`, `OrderDate`, `ItemID`, `Quantity`, `TotalAmount`, `Payment_Status`, `Order_status`, `OrderTimestamp`) VALUES
(12, 'Raven', '2025-03-12 08:47:31', NULL, NULL, 7000.00, 'Paid', 'Cancelled', '2025-03-12 08:50:48'),
(13, 'Ravens', '2025-03-12 08:50:39', NULL, NULL, 33000.00, 'Pending', 'Processing', '2025-03-12 08:50:48'),
(22, 'ravens', '2025-03-12 16:56:18', NULL, NULL, 3500.00, 'Paid', 'Completed', '2025-03-12 08:56:18'),
(23, 'trish', '2025-03-12 17:18:59', NULL, NULL, 200.00, 'Paid', 'Processing', '2025-03-12 09:18:59'),
(24, 'Rizinni', '2025-03-12 20:40:54', NULL, NULL, 3500.00, 'Pending', 'Processing', '2025-03-12 12:40:54'),
(25, 'rai', '2025-03-13 07:21:05', NULL, NULL, 200.00, 'Paid', 'Completed', '2025-03-12 23:21:05'),
(26, 'Ravenj', '2025-03-13 10:18:40', NULL, NULL, 200.00, 'Paid', 'Processing', '2025-03-13 02:18:40'),
(27, 'kim', '2025-03-13 20:28:49', NULL, NULL, 600.00, 'Pending', 'Processing', '2025-03-13 12:28:49');

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
(29, 27, 9, 2, 300.00, 600.00);

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
  `Status` enum('Active','Inactive') DEFAULT 'Inactive'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmpID`, `Emp_Name`, `Position`, `username`, `password`, `CreatedByID`, `CreatedDate`, `UpdatedByID`, `UpdatedDate`, `Status`) VALUES
(4, 'Nashen', 'Cashier', 'Nash', '$2b$12$qynb7plurMkGKUxn3KhBGuuhzqr3VEVBOkLY0ACwY1DAoZzI0Ayqi', 1, '2025-03-07 19:42:19', 1, '2025-03-07 19:42:19', 'Active'),
(5, 'Nash1', 'okay', 'Nashh', '$2b$12$lPOrY6R4s6tPRgqxliTLoeQOMBmk5X94gZF.ccBqXGbDb6D86YoTu', 1, '2025-03-07 19:46:26', 1, '2025-03-07 19:46:26', 'Inactive'),
(6, 'Raven', 'Raven@gmail.com', 'Rav', '$2b$12$SsfKD9T/H/1aAj/jwtauue3yKXCTVR.C8zZwY1h.QXLp6floK3..a', 1, '2025-03-10 10:08:20', 1, '2025-03-10 10:08:20', 'Active'),
(9, 'Raven John M. Canedo', 'leader', 'Rav', '$2b$12$F5ZzmIgqSa94J96blvciUe6/9BBLVcLSgNivMnYx6x94ZcJzS1K8y', 1, NULL, 1, NULL, 'Inactive');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `ItemID` int(11) NOT NULL,
  `ItemName` varchar(255) DEFAULT NULL,
  `Is_Serialized` int(11) DEFAULT NULL,
  `Quantity_in_Stock` int(11) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT 0.00,
  `Category` varchar(50) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`ItemID`, `ItemName`, `Is_Serialized`, `Quantity_in_Stock`, `UnitPrice`, `Category`, `Description`) VALUES
(2, 'Screwdriver Set', 0, 30, 250.00, NULL, NULL),
(3, 'Electric Drill', 0, 6, 3500.00, NULL, NULL),
(4, 'Adjustable Wrench', 0, 37, 200.00, NULL, NULL),
(7, 'Cordless Grinder', 0, 8, 4200.00, NULL, NULL),
(8, 'Circular Saw', 0, -1, 5500.00, NULL, NULL),
(9, 'Chisel Set', 0, 18, 300.00, NULL, NULL),
(13, 'VALVES', 0, 100, NULL, NULL, NULL),
(14, 'soap', 0, 20, NULL, NULL, NULL),
(15, 'Raven', 0, 1000, 12.00, 'human', 'ravens'),
(16, 'gilgre', 0, 3, 1.00, 'human', 'smart'),
(17, 'raven', 0, 5, 3.00, 'human', 'ye');

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
(33, 60, 17, 5, 3.00);

-- --------------------------------------------------------

--
-- Table structure for table `order_table`
--

CREATE TABLE `order_table` (
  `OrderID` int(11) NOT NULL,
  `SuppID` int(11) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `ReceiveDate` datetime DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `EmpID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_table`
--

INSERT INTO `order_table` (`OrderID`, `SuppID`, `OrderDate`, `ReceiveDate`, `Status`, `EmpID`) VALUES
(46, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 6),
(47, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 5),
(48, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 6),
(49, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 5),
(50, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 5),
(51, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 6),
(53, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 5),
(54, 2, '2025-03-12 00:00:00', '2025-03-19 00:00:00', 'Pending', 5),
(55, 2, '2025-03-13 00:00:00', '2025-03-20 00:00:00', 'Pending', 6),
(56, 2, '2025-03-13 00:00:00', '2025-03-20 00:00:00', 'Pending', 6),
(57, 2, '2025-03-13 00:00:00', '2025-03-20 00:00:00', 'Pending', 6),
(58, 2, '2025-03-13 00:00:00', '2025-03-20 00:00:00', 'Pending', 6),
(59, 2, '2025-03-13 00:00:00', '2025-03-20 00:00:00', 'Pending', 6),
(60, 2, '2025-03-13 00:00:00', '2025-03-20 00:00:00', 'Pending', 4);

-- --------------------------------------------------------

--
-- Table structure for table `sales_table`
--

CREATE TABLE `sales_table` (
  `SaleID` int(11) NOT NULL,
  `SaleDate` datetime DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `OrderTimestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `SuppID` int(11) NOT NULL,
  `Supplier_Name` varchar(255) DEFAULT NULL,
  `Contact` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`SuppID`, `Supplier_Name`, `Contact`) VALUES
(1, 'wahaha', 'nooo'),
(2, 'Holcim', 'hahaha'),
(3, 'wow', '1239'),
(4, 'Eavn2', 'www'),
(5, 'shell', 'oil'),
(6, 'Raven', '095138'),
(7, 'OK', '222222');

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

-- --------------------------------------------------------

--
-- Table structure for table `supplier_return_details`
--

CREATE TABLE `supplier_return_details` (
  `SuppReturnDetails_ID` int(11) NOT NULL,
  `Supp_Return_ID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Refund_amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  ADD PRIMARY KEY (`OrderID`);

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
-- Indexes for table `sales_table`
--
ALTER TABLE `sales_table`
  ADD PRIMARY KEY (`SaleID`),
  ADD KEY `fk_order` (`OrderID`);

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
  ADD KEY `Supp_Return_ID` (`Supp_Return_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `customer_return`
--
ALTER TABLE `customer_return`
  MODIFY `Cust_Return_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_return_details`
--
ALTER TABLE `customer_return_details`
  MODIFY `CustReturnDetails_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `custorder_details`
--
ALTER TABLE `custorder_details`
  MODIFY `CODetails_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `EmpID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `ItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `OrDetail_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `order_table`
--
ALTER TABLE `order_table`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `sales_table`
--
ALTER TABLE `sales_table`
  MODIFY `SaleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stock_adjustment`
--
ALTER TABLE `stock_adjustment`
  MODIFY `Adjustment_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_adjustment_detail`
--
ALTER TABLE `stock_adjustment_detail`
  MODIFY `AdjustmentDetail_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `SuppID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `supplier_return`
--
ALTER TABLE `supplier_return`
  MODIFY `Supp_Return_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier_return_details`
--
ALTER TABLE `supplier_return_details`
  MODIFY `SuppReturnDetails_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`Employee_ID`) REFERENCES `employee` (`EmpID`);

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
-- Constraints for table `sales_table`
--
ALTER TABLE `sales_table`
  ADD CONSTRAINT `fk_order` FOREIGN KEY (`OrderID`) REFERENCES `customer_order` (`OrderID`);

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
  ADD CONSTRAINT `supplier_return_details_ibfk_1` FOREIGN KEY (`Supp_Return_ID`) REFERENCES `supplier_return` (`Supp_Return_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
