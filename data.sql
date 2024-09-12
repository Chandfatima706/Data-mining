-- create schema retailshop; 

use retailshop;

select * from online_retail;

CREATE TABLE metadata (
    ColumnName VARCHAR(50),
    DataType VARCHAR(50),
    Description TEXT
);

INSERT INTO metadata (ColumnName, DataType, Description) VALUES
('invoice_no', 'VARCHAR', 'The invoice number for each transaction'),
('customer_id', 'VARCHAR', 'The unique identifier for each customer'),
('gender', 'VARCHAR', 'The gender of the customer'),
('age', 'INT', 'The age of the customer'),
('category', 'VARCHAR', 'The product category'),
('quantity', 'INT', 'The quantity of each product sold in each transaction'),
('price', 'DECIMAL', 'The price of each product sold'),
('payment_method', 'VARCHAR', 'The payment method used by the customer'),
('invoice_date', 'DATETIME', 'The date and time of each transaction'),
('shopping_mall', 'VARCHAR', 'The shopping mall where the transaction occurred');

-- Distribution of Order Values Across All Customers
SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY CustomerID
ORDER BY TotalOrderValue DESC;

-- How many unique products has each customer purchased? 
SELECT 
    CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

-- Customers Who Have Only Made a Single Purchase 

SELECT 
    CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

-- Most Commonly Purchased Products Together

SELECT 
    a.StockCode AS ProductA,
    b.StockCode AS ProductB,
    COUNT(*) AS TimesPurchasedTogether
FROM online_retail a
JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
	GROUP BY a.StockCode, b.StockCode
ORDER BY TimesPurchasedTogether DESC
LIMIT 10;

-- Advanced Queries

-- Customer Segmentation by Purchase Frequency

SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency,
    CASE 
        WHEN COUNT(DISTINCT InvoiceNo) > 20 THEN 'High'
        WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 5 AND 20 THEN 'Medium'
        ELSE 'Low'
    END AS FrequencySegment
FROM online_retail
GROUP BY CustomerID;

-- Average Order Value by Country

SELECT 
    Country,
    AVG(Quantity * UnitPrice) AS AvgOrderValue
FROM online_retail
GROUP BY Country
ORDER BY AvgOrderValue DESC;

-- Customer Churn Analysis (Identify Customers Who Haven't Made a Purchase in the Last 6 Months)

SELECT 
    CustomerID
FROM online_retail
WHERE InvoiceDate < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY CustomerID
HAVING COUNT(InvoiceNo) > 0;

-- Product Affinity Analysis

SELECT 
    StockCode,
    COUNT(*) AS PurchaseCount
FROM online_retail
GROUP BY StockCode
ORDER BY PurchaseCount DESC
LIMIT 10;

-- Time-based Analysis (Monthly Sales Patterns)

SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM online_retail
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY Month;
