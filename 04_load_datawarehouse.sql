USE EasyBuy_DW;
GO

INSERT INTO DimCustomer
(CustomerID, FirstName, LastName, Email, Phone)
SELECT
    CustomerID, FirstName, LastName, Email, PhoneNumber
FROM EasyBuy.dbo.Customers;
GO

INSERT INTO DimCategory
(CategoryID, CategoryName)
SELECT
    CategoryID, CategoryName
FROM EasyBuy.dbo.Categories;
GO

INSERT INTO DimProduct
(ProductID, ProductName, CategoryID, Price)
SELECT
    ProductID, ProductName, CategoryID, Price
FROM EasyBuy.dbo.Products;
GO

INSERT INTO DimDate
(DateKey, FullDate, DayNumber, MonthNumber, MonthName,
 QuarterNumber, YearNumber, DayName)
SELECT DISTINCT
    YEAR(OrderDate) * 10000 + MONTH(OrderDate) * 100 + DAY(OrderDate),
    CAST(OrderDate AS DATE),
    DAY(OrderDate),
    MONTH(OrderDate),
    DATENAME(MONTH, OrderDate),
    DATEPART(QUARTER, OrderDate),
    YEAR(OrderDate),
    DATENAME(WEEKDAY, OrderDate)
FROM EasyBuy.dbo.Orders;
GO

INSERT INTO FactSales
(DateKey, CustomerKey, ProductKey, CategoryKey,
 OrderID, Quantity, UnitPrice, SalesAmount)
SELECT
    YEAR(O.OrderDate) * 10000 + MONTH(O.OrderDate) * 100 + DAY(O.OrderDate),
    DC.CustomerKey,
    DP.ProductKey,
    DCat.CategoryKey,
    O.OrderID,
    OI.Quantity,
    OI.UnitPrice,
    OI.Quantity * OI.UnitPrice
FROM EasyBuy.dbo.Orders AS O
INNER JOIN EasyBuy.dbo.OrderItems AS OI
    ON O.OrderID = OI.OrderID
INNER JOIN DimCustomer AS DC
    ON O.CustomerID = DC.CustomerID
INNER JOIN DimProduct AS DP
    ON OI.ProductID = DP.ProductID
INNER JOIN DimCategory AS DCat
    ON DP.CategoryID = DCat.CategoryID;
GO
