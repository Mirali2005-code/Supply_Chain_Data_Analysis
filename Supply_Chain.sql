CREATE DATABASE supply_chain_analytics;
USE supply_chain_analytics;

SHOW TABLES;


SELECT * 
FROM supply_chain_data
LIMIT 10;

-- =====================================
-- TOTAL SALES KPI
-- =====================================

SELECT 
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM supply_chain_data;

SELECT COUNT(*) AS Total_Rows
FROM supply_chain_data;

-- =====================================
-- TOTAL PROFIT
-- =====================================

SELECT 
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit
FROM supply_chain_data;

-- =====================================
-- TOTAL ORDERS
-- =====================================

SELECT 
    COUNT(`Order Id`) AS Total_Orders
FROM supply_chain_data;

-- =====================================
-- TOP 10 PRODUCTS BY SALES
-- =====================================

SELECT 
    `Product Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM supply_chain_data
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- =====================================
-- TOP CATEGORIES BY PROFIT
-- =====================================

SELECT 
    `Category Name`,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit
FROM supply_chain_data
GROUP BY `Category Name`
ORDER BY Total_Profit DESC;

-- =====================================
-- TOP CUSTOMER SEGMENTS
-- =====================================

SELECT 
    `Customer Segment`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM supply_chain_data
GROUP BY `Customer Segment`
ORDER BY Total_Sales DESC;

-- =====================================
-- SHIPPING MODE PERFORMANCE
-- =====================================

SELECT 
    `Shipping Mode`,
    COUNT(*) AS Total_Orders,
    ROUND(AVG(`Days for shipping (real)`),2) AS Avg_Shipping_Days
FROM supply_chain_data
GROUP BY `Shipping Mode`
ORDER BY Avg_Shipping_Days;

-- =====================================
-- LATE DELIVERY ANALYSIS
-- =====================================

SELECT 
    `Delivery Status`,
    COUNT(*) AS Total_Orders
FROM supply_chain_data
GROUP BY `Delivery Status`
ORDER BY Total_Orders DESC;

-- =====================================
-- TOP COUNTRIES BY SALES
-- =====================================

SELECT 
    `Order Country`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM supply_chain_data
GROUP BY `Order Country`
ORDER BY Total_Sales DESC
LIMIT 10;

-- =====================================
-- HIGH LOSS PRODUCTS
-- =====================================

SELECT 
    `Product Name`,
    ROUND(SUM(`Order Profit Per Order`),2) AS Total_Loss
FROM supply_chain_data
GROUP BY `Product Name`
HAVING Total_Loss < 0
ORDER BY Total_Loss;

-- =====================================
-- REGION-WISE SALES
-- =====================================

SELECT 
    `Order Region`,
    ROUND(SUM(Sales),2) AS Regional_Sales
FROM supply_chain_data
GROUP BY `Order Region`
ORDER BY Regional_Sales DESC;

-- =====================================
-- MOST DELAYED SHIPPING MODES
-- =====================================

SELECT 
    `Shipping Mode`,
    ROUND(AVG(`Days for shipping (real)` - `Days for shipment (scheduled)`),2) AS Avg_Delay
FROM supply_chain_data
GROUP BY `Shipping Mode`
ORDER BY Avg_Delay DESC;

-- =====================================
-- ADVANCED SQL
-- =====================================
-- =====================================
-- CUSTOMER SALES RANKING
-- =====================================

SELECT 
    `Customer Id`,
    CONCAT(`Customer Fname`, ' ', `Customer Lname`) AS Customer_Name,
    ROUND(SUM(Sales),2) AS Total_Sales,
    
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Customer_Rank

FROM supply_chain_data

GROUP BY 
    `Customer Id`,
    Customer_Name

LIMIT 20;

-- =====================================
-- MONTHLY SALES TREND
-- =====================================

SELECT 
    YEAR(`order date (DateOrders)`) AS Year,
    MONTH(`order date (DateOrders)`) AS Month,
    
    ROUND(SUM(Sales),2) AS Monthly_Sales

FROM supply_chain_data

GROUP BY 
    Year,
    Month

ORDER BY 
    Year,
    Month;

-- =====================================
-- RUNNING TOTAL SALES
-- =====================================

SELECT 
    YEAR(`order date (DateOrders)`) AS Year,
    MONTH(`order date (DateOrders)`) AS Month,
    
    ROUND(SUM(Sales),2) AS Monthly_Sales,

    ROUND(
        SUM(SUM(Sales)) OVER (
            ORDER BY YEAR(`order date (DateOrders)`),
                     MONTH(`order date (DateOrders)`)
        ),
    2) AS Running_Total

FROM supply_chain_data

GROUP BY Year, Month

ORDER BY Year, Month;

-- =====================================
-- PROFIT CONTRIBUTION PERCENTAGE
-- =====================================

SELECT 
    `Category Name`,
    
    ROUND(SUM(`Order Profit Per Order`),2) AS Total_Profit,

    ROUND(
        (
            SUM(`Order Profit Per Order`)
            /
            (SELECT SUM(`Order Profit Per Order`)
             FROM supply_chain_data)
        ) * 100,
    2) AS Profit_Contribution_Percent

FROM supply_chain_data

GROUP BY `Category Name`

ORDER BY Profit_Contribution_Percent DESC;

-- =====================================
-- DELIVERY DELAY RISK ANALYSIS
-- =====================================

SELECT 
    `Shipping Mode`,
    
    COUNT(*) AS Total_Orders,

    ROUND(
        AVG(
            `Days for shipping (real)` -
            `Days for shipment (scheduled)`
        ),
    2) AS Avg_Delay

FROM supply_chain_data

GROUP BY `Shipping Mode`

ORDER BY Avg_Delay DESC;

-- =====================================
-- TOP LOSS MAKING PRODUCTS
-- =====================================

SELECT 
    `Product Name`,
    
    ROUND(
        SUM(`Order Profit Per Order`),
    2) AS Total_Loss

FROM supply_chain_data

GROUP BY `Product Name`

HAVING Total_Loss < 0

ORDER BY Total_Loss ASC

LIMIT 20;

-- =====================================
-- TOP REGIONS BY REVENUE
-- =====================================

SELECT 
    `Order Region`,
    
    ROUND(SUM(Sales),2) AS Regional_Revenue,

    DENSE_RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Region_Rank

FROM supply_chain_data

GROUP BY `Order Region`;

-- =====================================
-- CUSTOMER LIFETIME VALUE
-- =====================================

SELECT 
    `Customer Id`,
    
    CONCAT(`Customer Fname`, ' ', `Customer Lname`) 
    AS Customer_Name,

    COUNT(`Order Id`) AS Total_Orders,

    ROUND(SUM(Sales),2) AS Lifetime_Value

FROM supply_chain_data

GROUP BY 
    `Customer Id`,
    Customer_Name

ORDER BY Lifetime_Value DESC

LIMIT 20;

-- =====================================
-- CATEGORY PERFORMANCE ANALYSIS
-- =====================================

SELECT 
    `Category Name`,

    COUNT(*) AS Total_Orders,

    ROUND(AVG(Sales),2) AS Avg_Sales,

    ROUND(AVG(`Order Profit Per Order`),2) 
    AS Avg_Profit

FROM supply_chain_data

GROUP BY `Category Name`

ORDER BY Avg_Profit DESC;

-- =====================================
-- EXECUTIVE BUSINESS KPI SUMMARY
-- =====================================

SELECT 
    ROUND(SUM(Sales),2) AS Total_Revenue,

    ROUND(SUM(`Order Profit Per Order`),2) 
    AS Total_Profit,

    COUNT(DISTINCT `Order Id`) AS Total_Orders,

    COUNT(DISTINCT `Customer Id`) AS Total_Customers,

    ROUND(AVG(Sales),2) AS Avg_Order_Value

FROM supply_chain_data;

-- =====================================
-- VIEW
-- =====================================

CREATE VIEW vw_sales_summary AS
SELECT
    `Category Name`,
    SUM(Sales) AS Total_Sales,
    SUM(`Order Profit Per Order`) AS Total_Profit
FROM supply_chain_data
GROUP BY `Category Name`;

SELECT * FROM vw_sales_summary;

CREATE VIEW vw_customer_lifetime_value AS
SELECT
    `Customer Id`,
    CONCAT(`Customer Fname`, ' ', `Customer Lname`) AS Customer_Name,
    COUNT(`Order Id`) AS Total_Orders,
    SUM(Sales) AS Lifetime_Value
FROM supply_chain_data
GROUP BY
    `Customer Id`,
    Customer_Name;

SELECT * FROM vw_customer_lifetime_value;

