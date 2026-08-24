CREATE DATABASE EasyBuy_DW;
GO

USE EasyBuy_DW;
GO

CREATE TABLE DimDate
(
    DateKey INT NOT NULL PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayNumber INT NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    QuarterNumber INT NOT NULL,
    YearNumber INT NOT NULL,
    DayName NVARCHAR(20) NOT NULL
);
GO

CREATE TABLE DimCustomer
(
    CustomerKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NULL
);
GO

CREATE TABLE DimCategory
(
    CategoryKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryID INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE DimProduct
(
    ProductKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);
GO

-- Grain: one row per product line within an order.
CREATE TABLE FactSales
(
    SalesKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    CategoryKey INT NOT NULL,
    OrderID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    SalesAmount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_FactSales_Date
        FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_Product
        FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey),
    CONSTRAINT FK_FactSales_Category
        FOREIGN KEY (CategoryKey) REFERENCES DimCategory(CategoryKey)
);
GO
