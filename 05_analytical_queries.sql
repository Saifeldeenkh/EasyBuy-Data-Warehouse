USE EasyBuy_DW;
GO

-- 1. Total Revenue
SELECT
    SUM(SalesAmount) AS TotalRevenue
FROM FactSales;
GO

-- 2. Revenue by Category
SELECT
    C.CategoryName,
    SUM(F.SalesAmount) AS TotalRevenue
FROM FactSales AS F
INNER JOIN DimCategory AS C
    ON F.CategoryKey = C.CategoryKey
GROUP BY C.CategoryName
ORDER BY TotalRevenue DESC;
GO

-- 3. Top 5 Customers by Revenue
SELECT TOP 5
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    SUM(F.SalesAmount) AS TotalRevenue
FROM FactSales AS F
INNER JOIN DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
GROUP BY C.CustomerKey, C.FirstName, C.LastName
ORDER BY TotalRevenue DESC;
GO

-- 4. Top Selling Products
SELECT
    P.ProductName,
    SUM(F.Quantity) AS UnitsSold,
    SUM(F.SalesAmount) AS Revenue
FROM FactSales AS F
INNER JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
GROUP BY P.ProductKey, P.ProductName
ORDER BY UnitsSold DESC, Revenue DESC;
GO

-- 5. Revenue by Month
SELECT
    D.YearNumber,
    D.MonthNumber,
    D.MonthName,
    SUM(F.SalesAmount) AS Revenue
FROM FactSales AS F
INNER JOIN DimDate AS D
    ON F.DateKey = D.DateKey
GROUP BY D.YearNumber, D.MonthNumber, D.MonthName
ORDER BY D.YearNumber, D.MonthNumber;
GO

-- 6. Revenue by Year
SELECT
    D.YearNumber,
    SUM(F.SalesAmount) AS Revenue
FROM FactSales AS F
INNER JOIN DimDate AS D
    ON F.DateKey = D.DateKey
GROUP BY D.YearNumber
ORDER BY D.YearNumber;
GO

-- 7. Average Order Value
SELECT
    AVG(OrderTotal) AS AverageOrderValue
FROM
(
    SELECT
        OrderID,
        SUM(SalesAmount) AS OrderTotal
    FROM FactSales
    GROUP BY OrderID
) AS X;
GO

-- 8. Daily Revenue and Running Total
SELECT
    D.FullDate,
    SUM(F.SalesAmount) AS DailyRevenue,
    SUM(SUM(F.SalesAmount)) OVER
    (
        ORDER BY D.FullDate
    ) AS RunningTotal
FROM FactSales AS F
INNER JOIN DimDate AS D
    ON F.DateKey = D.DateKey
GROUP BY D.FullDate
ORDER BY D.FullDate;
GO

-- 9. Product Revenue Ranking
SELECT
    P.ProductName,
    SUM(F.SalesAmount) AS Revenue,
    RANK() OVER
    (
        ORDER BY SUM(F.SalesAmount) DESC
    ) AS ProductRank
FROM FactSales AS F
INNER JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
GROUP BY P.ProductKey, P.ProductName;
GO

-- 10. Revenue by Customer and Category
SELECT
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    Cat.CategoryName,
    SUM(F.SalesAmount) AS Revenue
FROM FactSales AS F
INNER JOIN DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
INNER JOIN DimCategory AS Cat
    ON F.CategoryKey = Cat.CategoryKey
GROUP BY C.CustomerKey, C.FirstName, C.LastName, Cat.CategoryName
ORDER BY Revenue DESC;
GO

-- 11. Monthly Revenue with Month-over-Month Change
WITH MonthlyRevenue AS
(
    SELECT
        D.YearNumber,
        D.MonthNumber,
        D.MonthName,
        SUM(F.SalesAmount) AS Revenue
    FROM FactSales AS F
    INNER JOIN DimDate AS D
        ON F.DateKey = D.DateKey
    GROUP BY D.YearNumber, D.MonthNumber, D.MonthName
)
SELECT
    YearNumber,
    MonthNumber,
    MonthName,
    Revenue,
    LAG(Revenue) OVER
    (
        ORDER BY YearNumber, MonthNumber
    ) AS PreviousMonthRevenue,
    Revenue - LAG(Revenue) OVER
    (
        ORDER BY YearNumber, MonthNumber
    ) AS RevenueChange
FROM MonthlyRevenue
ORDER BY YearNumber, MonthNumber;
GO
