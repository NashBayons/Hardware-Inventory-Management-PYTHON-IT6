-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2025 at 02:49 PM
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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdjustStock` (IN `p_ItemID` INT, IN `p_EmpID` INT, IN `p_AdjustmentType` VARCHAR(50), IN `p_QuantityAdjusted` INT)   BEGIN
	DECLARE v_PreviousQuantity INT;
    DECLARE v_NewQuantity INT;
    
    SELECT Quantity_in_Stock INTO v_PreviousQuantity FROM Items WHERE ItemID = p_ItemID;
    
    IF p_AdjustmentType = 'Increase' THEN
        SET v_NewQuantity = v_PreviousQuantity + p_QuantityAdjusted;
    ELSE
        SET v_NewQuantity = v_PreviousQuantity - p_QuantityAdjusted;
    END IF;
    
    UPDATE Items SET Quantity_in_Stock = v_NewQuantity WHERE ItemID = p_ItemID;
    
    INSERT INTO Stock_adjustment (EmpID, ReportedDate, Adjustment_Type, Status)
    VALUES (p_EmpID, NOW(), p_AdjustmentType, 'Completed');
    
    INSERT INTO Stock_Adjustment_Detail (Adjustment_ID, ItemID, Quantity_Adjusted, Previous_Quantity, New_Quantity)
    VALUES (LAST_INSERT_ID(), p_ItemID, p_QuantityAdjusted, v_PreviousQuantity, v_NewQuantity);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertAuditLog` (IN `p_ActionType` VARCHAR(50), IN `p_TableName` VARCHAR(50), IN `p_RecordID` INT, IN `p_EmployeeID` INT, IN `p_OldValue` TEXT, IN `p_NewValue` TEXT, IN `p_Reason` TEXT)   BEGIN
	INSERT INTO Audit_Log (Action_Type, Table_Name, Record_ID, Employee_ID, Timestamp, Old_value, New_value, Reason)
    VALUES (p_ActionType, p_TableName, p_RecordID, p_EmployeeID, NOW(), p_OldValue, p_NewValue, p_Reason);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertCustomerOrder` (IN `p_Date` DATE, IN `p_TotalAmount` DECIMAL(10,2), IN `p_PaymentStatus` VARCHAR(50), IN `p_OrderStatus` VARCHAR(50), IN `p_ItemID` INT, IN `p_Quantity` INT, IN `p_UnitPrice` DECIMAL(10,2), IN `p_TotalPrice` DECIMAL(10,2))   BEGIN
    DECLARE v_CustOrderID INT;

    -- Insert into customer_order and retrieve the generated ID
    INSERT INTO customer_order (Date, Total_Amount, Payment_Status, Order_status)
    VALUES (p_Date, p_TotalAmount, p_PaymentStatus, p_OrderStatus);

    -- Get the last inserted order ID
    SET v_CustOrderID = LAST_INSERT_ID();

    -- Insert into custorder_details using the retrieved CustOrder_ID
    INSERT INTO custorder_details (CustOrder_ID, ItemID, Quantity, Unit_Price, Total_Price)
    VALUES (v_CustOrderID, p_ItemID, p_Quantity, p_UnitPrice, p_TotalPrice);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertItem` (IN `item_name` VARCHAR(255), IN `is_serialized` INT(11), IN `quantity_in_stock` INT)   BEGIN
	INSERT INTO items (ItemName, Is_Serialized, Quantity_in_Stock)
    VALUES (item_name, is_serialized, quantity_in_stock);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSupplierOrder` (IN `p_SuppID` INT, IN `p_EmpID` INT, IN `p_OrderDate` DATE, IN `p_ReceiveDate` DATE, IN `p_Status` VARCHAR(50), IN `p_ItemID` INT, IN `p_Quantity` INT, IN `p_UnitPrice` DECIMAL(10,2))   BEGIN
    DECLARE v_OrderID INT;

    -- Insert into order_table and retrieve the generated OrderID
    INSERT INTO order_table (SuppID, EmpID, OrderDate, ReceiveDate, Status)
    VALUES (p_SuppID, p_EmpID, p_OrderDate, p_ReceiveDate, p_Status);

    -- Get the last inserted order ID
    SET v_OrderID = LAST_INSERT_ID();

    -- Insert into order_details using the retrieved OrderID
    INSERT INTO order_details (OrderID, ItemID, Quantity, UnitPrice)
    VALUES (v_OrderID, p_ItemID, p_Quantity, p_UnitPrice);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSuppliers` (IN `p_SupplierName` VARCHAR(255), IN `p_Contact` VARCHAR(255))   BEGIN
	Insert into supplier (Supplier_Name, Contact)
    Values (p_SupplierName, p_Contact);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Employee` (IN `p_EmpName` VARCHAR(255), IN `p_Position` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_CreatedByID` INT(11), IN `p_UpdatedByID` INT(11))   BEGIN
	insert into employee (Emp_Name, Position, username, password, CreatedbyID, CreatedDate, UpdatedbyID,
    UpdatedDate)
    Values (p_EmpName, p_Position, p_username, p_password, p_CreatedByID, CURRENT_TIMESTAMP, 
    p_UpdatedByID, CURRENT_TIMESTAMP);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessCustomerReturn` (IN `p_CustOrderID` INT, IN `p_ReturnDate` DATE, IN `p_ReturnReason` VARCHAR(255), IN `p_ReturnStatus` VARCHAR(50), IN `p_ProcessedBy` INT, IN `p_CODetailsID` INT, IN `p_QuantityReturned` INT, IN `p_RefundAmount` DECIMAL(10,2))   BEGIN
    DECLARE v_CustReturnID INT;

    -- Insert into customer_return and get the generated Cust_Return_ID
    INSERT INTO customer_return 
    (CustOrder_ID, Return_Date, Return_reason, Return_status, Processed_by_Employee)
    VALUES 
    (p_CustOrderID, p_ReturnDate, p_ReturnReason, p_ReturnStatus, p_ProcessedBy);

    -- Get the last inserted ID
    SET v_CustReturnID = LAST_INSERT_ID();

    -- Insert into customer_return_details using the retrieved Cust_Return_ID
    INSERT INTO customer_return_details 
    (Cust_Return_ID, CODetails_ID, Quantity_Returned, Refund_Amount)
    VALUES 
    (v_CustReturnID, p_CODetailsID, p_QuantityReturned, p_RefundAmount);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessSupplierReturn` (IN `p_OrderID` INT, IN `p_SuppID` INT, IN `p_ReturnDate` DATE, IN `p_ReturnReason` VARCHAR(255), IN `p_ReturnStatus` VARCHAR(50), IN `p_ProcessedBy` INT, IN `p_Quantity` INT, IN `p_RefundAmount` DECIMAL(10,2))   BEGIN
    DECLARE v_SuppReturnID INT;

    -- Insert into supplier_return and retrieve the generated Supp_Return_ID
    INSERT INTO supplier_return (OrderID, SuppID, Return_date, Return_reason, Return_status, Processed_by_Employee)
    VALUES (p_OrderID, p_SuppID, p_ReturnDate, p_ReturnReason, p_ReturnStatus, p_ProcessedBy);

    -- Get the last inserted return ID
    SET v_SuppReturnID = LAST_INSERT_ID();

    -- Insert into supplier_return_details using the retrieved Supp_Return_ID
    INSERT INTO supplier_return_details (Supp_Return_ID, Quantity, Refund_amount)
    VALUES (v_SuppReturnID, p_Quantity, p_RefundAmount);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSuppliers` (IN `p_supplier_id` INT, IN `p_name` VARCHAR(255), IN `p_contact` VARCHAR(255))   BEGIN
	UPDATE supplier
    SET supplier_name = p_name, contact = p_contact
    WHERE SuppID = p_supplier_id;
    
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
  `Timestamp` datetime DEFAULT NULL,
  `Old_value` text DEFAULT NULL,
  `New_value` text DEFAULT NULL,
  `Reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `CustOrder_ID` int(11) NOT NULL,
  `Date` datetime DEFAULT NULL,
  `Total_Amount` decimal(10,2) DEFAULT NULL,
  `Payment_Status` varchar(50) DEFAULT NULL,
  `Order_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `CustOrder_ID` int(11) DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Unit_Price` decimal(10,2) DEFAULT NULL,
  `Total_Price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `UpdatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmpID`, `Emp_Name`, `Position`, `username`, `password`, `CreatedByID`, `CreatedDate`, `UpdatedByID`, `UpdatedDate`) VALUES
(4, 'Nashen', 'Cashier', 'Nash', '$2b$12$qynb7plurMkGKUxn3KhBGuuhzqr3VEVBOkLY0ACwY1DAoZzI0Ayqi', 1, '2025-03-07 19:42:19', 1, '2025-03-07 19:42:19'),
(5, 'Nash1', 'okay', 'Nashh', '$2b$12$lPOrY6R4s6tPRgqxliTLoeQOMBmk5X94gZF.ccBqXGbDb6D86YoTu', 1, '2025-03-07 19:46:26', 1, '2025-03-07 19:46:26'),
(6, 'Raven', 'Raven@gmail.com', 'Rav', '$2b$12$SsfKD9T/H/1aAj/jwtauue3yKXCTVR.C8zZwY1h.QXLp6floK3..a', 1, '2025-03-10 10:08:20', 1, '2025-03-10 10:08:20');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `ItemID` int(11) NOT NULL,
  `ItemName` varchar(255) DEFAULT NULL,
  `Is_Serialized` int(11) DEFAULT NULL,
  `Quantity_in_Stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`ItemID`, `ItemName`, `Is_Serialized`, `Quantity_in_Stock`) VALUES
(1, 'asd', 0, 0),
(2, 'yes', 0, 12),
(3, 'yeahyeah', 0, 2),
(4, 'Nails', 0, 12),
(5, 'dsfdsfds', 0, 233);

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
(5, 11, 1, 12, 12.00),
(6, 12, 2, 12, 12.00),
(7, 13, 2, 12, 12.00),
(8, 14, 3, 2, 1.99),
(9, 15, 3, 12, 5.00),
(10, 16, 4, 12, 3.99),
(11, 17, 5, 233, 2.00);

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
(5, 2, '2025-03-08 00:00:00', '2025-03-08 00:00:00', 'Pending', 5),
(9, 2, '2025-03-08 00:00:00', '2025-03-15 00:00:00', 'Pending', 5),
(10, 2, '2025-03-08 00:00:00', '2025-03-15 00:00:00', 'Pending', 5),
(11, 2, '2025-03-08 00:00:00', '2025-03-22 00:00:00', 'Pending', 5),
(12, 2, '2025-03-08 00:00:00', '2025-03-22 00:00:00', 'Pending', 5),
(13, 2, '2025-03-09 00:00:00', '2025-03-16 00:00:00', 'Pending', 4),
(14, 2, '2025-03-10 00:00:00', '2025-03-18 00:00:00', 'Pending', 5),
(15, 1, '2025-03-10 00:00:00', '2025-03-17 00:00:00', 'Pending', 6),
(16, 2, '2025-03-10 00:00:00', '2025-03-17 00:00:00', 'Pending', 4),
(17, 4, '2025-03-10 00:00:00', '2025-03-17 00:00:00', 'Pending', 6);

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
(5, 'shell', 'oil');

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
  ADD PRIMARY KEY (`CustOrder_ID`);

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
  ADD KEY `CustOrder_ID` (`CustOrder_ID`),
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
  ADD KEY `Supp_Return_ID` (`Supp_Return_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `CustOrder_ID` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `CODetails_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `EmpID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `ItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `OrDetail_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `order_table`
--
ALTER TABLE `order_table`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

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
  MODIFY `SuppID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  ADD CONSTRAINT `customer_return_ibfk_1` FOREIGN KEY (`CustOrder_ID`) REFERENCES `customer_order` (`CustOrder_ID`),
  ADD CONSTRAINT `customer_return_ibfk_2` FOREIGN KEY (`Processed_by_Employee`) REFERENCES `employee` (`EmpID`);

--
-- Constraints for table `customer_return_details`
--
ALTER TABLE `customer_return_details`
  ADD CONSTRAINT `customer_return_details_ibfk_1` FOREIGN KEY (`Cust_Return_ID`) REFERENCES `customer_return` (`Cust_Return_ID`),
  ADD CONSTRAINT `customer_return_details_ibfk_2` FOREIGN KEY (`CODetails_ID`) REFERENCES `custorder_details` (`CODetails_ID`);

--
-- Constraints for table `custorder_details`
--
ALTER TABLE `custorder_details`
  ADD CONSTRAINT `custorder_details_ibfk_1` FOREIGN KEY (`CustOrder_ID`) REFERENCES `customer_order` (`CustOrder_ID`),
  ADD CONSTRAINT `custorder_details_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`);

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
  ADD CONSTRAINT `supplier_return_details_ibfk_1` FOREIGN KEY (`Supp_Return_ID`) REFERENCES `supplier_return` (`Supp_Return_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
