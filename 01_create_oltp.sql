CREATE DATABASE EasyBuy;
GO

USE EasyBuy;
GO

CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,

    CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);
GO

CREATE TABLE Addresses
(
    AddressID INT IDENTITY(1,1) NOT NULL,
    CustomerID INT NOT NULL,
    Street NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    State NVARCHAR(50) NOT NULL,
    ZipCode NVARCHAR(20) NOT NULL,
    AddressType NVARCHAR(20) NOT NULL,

    CONSTRAINT PK_Addresses PRIMARY KEY (AddressID),
    CONSTRAINT FK_Addresses_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CHK_Addresses_AddressType
        CHECK (AddressType IN ('Home', 'Work'))
);
GO

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NOT NULL,

    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
    CONSTRAINT UQ_Categories_CategoryName UNIQUE (CategoryName)
);
GO

CREATE TABLE Products
(
    ProductID INT IDENTITY(1,1) NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,

    CONSTRAINT PK_Products PRIMARY KEY (ProductID),
    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT CHK_Products_Price CHECK (Price >= 0)
);
GO

CREATE TABLE Inventory
(
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    LastUpdated DATETIME NOT NULL
        CONSTRAINT DF_Inventory_LastUpdated DEFAULT GETDATE(),

    CONSTRAINT PK_Inventory PRIMARY KEY (ProductID),
    CONSTRAINT FK_Inventory_Products
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT CHK_Inventory_Quantity CHECK (Quantity >= 0)
);
GO

CREATE TABLE Orders
(
    OrderID INT IDENTITY(1,1) NOT NULL,
    OrderDate DATETIME NOT NULL
        CONSTRAINT DF_Orders_OrderDate DEFAULT GETDATE(),
    OrderStatus NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Orders_OrderStatus DEFAULT 'Pending',
    TotalAmount DECIMAL(10,2) NOT NULL,
    CustomerID INT NOT NULL,
    AddressID INT NOT NULL,

    CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_Address
        FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID),
    CONSTRAINT FK_Orders_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CHK_Orders_Status
        CHECK (OrderStatus IN
            ('Pending', 'Confirmed', 'Processing',
             'Shipped', 'Delivered', 'Cancelled'))
);
GO

CREATE TABLE OrderItems
(
    OrderItemID INT IDENTITY(1,1) NOT NULL,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderItemID),
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT CHK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CHK_OrderItems_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT UQ_OrderItems_Order_Product UNIQUE (OrderID, ProductID)
);
GO

CREATE TABLE Payments
(
    PaymentID INT IDENTITY(1,1) NOT NULL,
    OrderID INT NOT NULL,
    PaymentMethod NVARCHAR(20) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Payments_Status DEFAULT 'Pending',
    PaymentDate DATETIME NOT NULL
        CONSTRAINT DF_Payments_Date DEFAULT GETDATE(),
    Amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Payments PRIMARY KEY (PaymentID),
    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT UQ_Payments_OrderID UNIQUE (OrderID),
    CONSTRAINT CHK_Payments_Method
        CHECK (PaymentMethod IN
            ('Cash', 'Credit Card', 'Debit Card', 'PayPal')),
    CONSTRAINT CHK_Payments_Status
        CHECK (PaymentStatus IN
            ('Pending', 'Paid', 'Failed', 'Refunded')),
    CONSTRAINT CHK_Payments_Amount CHECK (Amount >= 0)
);
GO

CREATE TABLE Shipping
(
    ShippingID INT IDENTITY(1,1) NOT NULL,
    OrderID INT NOT NULL,
    ShippingMethod NVARCHAR(20) NOT NULL,
    ShippingStatus NVARCHAR(20) NOT NULL,
    ShippingDate DATETIME NOT NULL,
    DeliveryDate DATETIME NULL,

    CONSTRAINT PK_Shipping PRIMARY KEY (ShippingID),
    CONSTRAINT FK_Shipping_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT UQ_Shipping_OrderID UNIQUE (OrderID),
    CONSTRAINT CHK_Shipping_Method
        CHECK (ShippingMethod IN ('Standard', 'Express', 'Same Day')),
    CONSTRAINT CHK_Shipping_Status
        CHECK (ShippingStatus IN
            ('Pending', 'Shipped', 'In Transit', 'Delivered', 'Returned'))
);
GO
