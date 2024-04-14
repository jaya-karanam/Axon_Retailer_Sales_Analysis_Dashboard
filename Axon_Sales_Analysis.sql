# AXON CLASSIC CARS RETAILER - SALES ANALYSIS

# Using classicmodels database
USE classicmodels;

############################################################################################################################################
# Task 1 : Finding the top 10 customers in terms of total purchase

SELECT c.customerNumber, c.customerName,  SUM(od.quantityOrdered * od.priceEach) AS totalPurchase FROM customers AS c
INNER JOIN orders AS o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails AS od ON  o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY totalPurchase DESC
LIMIT 10;

############################################################################################################################################
# Task 2 : Finding top 10 sales rep in terms of total sales

SELECT c. salesRepEmployeeNumber, e.firstName, e. lastName, e.jobTitle, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM customers AS c
INNER JOIN employees AS e ON c. salesRepEmployeeNumber = e.employeeNumber
INNER JOIN orders AS o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails AS od ON  o.orderNumber = od.orderNumber
GROUP BY c. salesRepEmployeeNumber
ORDER BY totalSales DESC
LIMIT 10;
###########################################################################################################################################
# Task 3 : Creating View to find the top sold product along with year sold

CREATE VIEW SalesByProductYear AS
SELECT p.productCode, p.productName, YEAR(o.orderDate) AS orderYear, SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM orders AS o
INNER JOIN orderDetails AS od ON o.orderNumber = od.orderNumber
INNER JOIN products AS p ON od.productCode = p.productCode
GROUP BY p.productCode, p.productName, orderYear
ORDER BY totalSales DESC;

# For dropping view
DROP VIEW IF EXISTS SalesByProductYear;

# For selecting view
SELECT * FROM SalesByProductYear;

##########################################################################################################################################
# Task 4 : Finding which ventor's product sold more than 500000

SELECT t1.productVendor, t1.totalSales AS vendorTotalSales FROM (
SELECT p.productVendor, SUM(od.priceEach * od.quantityOrdered) AS totalSales FROM orders AS o
INNER JOIN orderDetails AS od ON o.orderNumber = od.orderNumber
INNER JOIN products AS p ON od.productCode = p.productCode
GROUP BY p.productVendor) AS t1
GROUP BY t1.productVendor
HAVING SUM(TotalSales) > 500000
ORDER BY vendorTotalSales DESC;

###########################################################################################################################################
# Task 5 : Finding how many order where placed year wise

SELECT YEAR(o.orderDate) AS orderedYear, COUNT(o.orderNumber) AS totalNumberOfOrders FROM orders AS o
GROUP BY orderedYear;

##########################################################################################################################################
# Task 6 : Finding top 5 productLine which has highest number of quantity sold along with sales amount

SELECT p.productLine, COUNT(od.orderNumber) AS quantityOrdered, SUM(od.priceEach * od.quantityOrdered) AS totalSales FROM orderdetails AS od
INNER JOIN products AS p ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY quantityOrdered DESC
LIMIT 5;

#########################################################################################################################################
# Task 7 : Finding the average profit for each product the company sold

SELECT t1.productCode, t1.productName, t1.productLine, t1.buyPrice, t1.averageSellPrice, 
t1.averageSellPrice - t1.buyPrice AS averageProfit FROM
(SELECT p.productCode, p.productName, p.productLine, p.buyPrice, AVG(od.priceEach) AS averageSellPrice FROM products AS p
INNER JOIN orderdetails AS od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.productLine, p.buyPrice) AS t1;

#########################################################################################################################################