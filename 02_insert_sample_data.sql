USE EasyBuy;
GO

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber)
VALUES
('Ahmed','Ali','ahmed.ali@email.com','01010000001'),
('Mohamed','Hassan','mohamed.hassan@email.com','01010000002'),
('Sara','Ibrahim','sara.ibrahim@email.com','01010000003'),
('Mona','Khaled','mona.khaled@email.com','01010000004'),
('Omar','Mahmoud','omar.mahmoud@email.com','01010000005'),
('Nour','Adel','nour.adel@email.com','01010000006'),
('Youssef','Mostafa','youssef.mostafa@email.com','01010000007'),
('Laila','Samir','laila.samir@email.com','01010000008'),
('Hany','Said','hany.said@email.com','01010000009'),
('Fatma','Nasser','fatma.nasser@email.com','01010000010');
GO

INSERT INTO Addresses
(CustomerID, Street, City, State, ZipCode, AddressType)
VALUES
(1,'12 Nile St','Cairo','Cairo','11511','Home'),
(2,'18 Tahrir St','Giza','Giza','12511','Home'),
(3,'25 Corniche','Alexandria','Alexandria','21511','Home'),
(4,'10 El-Horreya','Mansoura','Dakahlia','35511','Home'),
(5,'5 Salah Salem','Cairo','Cairo','11512','Home'),
(6,'33 University St','Assiut','Assiut','71511','Home'),
(7,'8 El-Gomhoria','Tanta','Gharbia','31511','Home'),
(8,'17 Sea Road','Hurghada','Red Sea','84511','Home'),
(9,'45 Ramses','Cairo','Cairo','11513','Home'),
(10,'90 Canal St','Ismailia','Ismailia','41511','Home');
GO

INSERT INTO Categories (CategoryName, Description)
VALUES
('Laptops','Laptop Computers'),
('Smartphones','Mobile Phones'),
('Accessories','Computer Accessories'),
('Monitors','Computer Monitors'),
('Storage','Storage Devices'),
('Networking','Networking Devices');
GO

INSERT INTO Products (ProductName, Description, Price, CategoryID)
VALUES
('Dell XPS 13','13-inch Ultrabook',45999.99,1),
('HP Victus 15','Gaming Laptop',38999.99,1),
('Lenovo Legion 5','Gaming Laptop',52999.99,1),
('MacBook Air M4','Apple Laptop',64999.99,1),
('Samsung Galaxy S25','Android Smartphone',39999.99,2),
('iPhone 17','Apple Smartphone',58999.99,2),
('Xiaomi 15','Android Smartphone',26999.99,2),
('Google Pixel 10','Google Smartphone',41999.99,2),
('Logitech MX Master 3S','Wireless Mouse',4999.99,3),
('Logitech G Pro Keyboard','Mechanical Keyboard',6499.99,3),
('Razer Headset','Gaming Headset',5499.99,3),
('HP Backpack','Laptop Bag',1299.99,3),
('Samsung Odyssey G5','32-inch Gaming Monitor',14999.99,4),
('LG UltraFine','27-inch Monitor',12999.99,4),
('Dell UltraSharp','Professional Monitor',15999.99,4),
('Samsung 990 Pro 1TB','NVMe SSD',6999.99,5),
('Kingston NV3 1TB','NVMe SSD',3499.99,5),
('WD Blue 2TB HDD','Hard Disk',2699.99,5),
('TP-Link Archer AX55','WiFi Router',3999.99,6),
('TP-Link Switch 8 Port','Network Switch',2299.99,6);
GO

INSERT INTO Inventory (ProductID, Quantity)
VALUES
(1,15),(2,20),(3,10),(4,8),(5,30),
(6,18),(7,25),(8,12),(9,40),(10,35),
(11,22),(12,50),(13,9),(14,14),(15,11),
(16,27),(17,31),(18,18),(19,16),(20,13);
GO

INSERT INTO Orders
(OrderDate, OrderStatus, TotalAmount, CustomerID, AddressID)
VALUES
('2026-07-01','Delivered',85999.98,1,1),
('2026-07-02','Delivered',39999.99,2,2),
('2026-07-03','Shipped',64999.99,3,3),
('2026-07-04','Processing',11499.98,4,4),
('2026-07-05','Delivered',6999.99,5,5),
('2026-07-06','Cancelled',14999.99,6,6),
('2026-07-07','Delivered',54299.98,7,7),
('2026-07-08','Pending',2299.99,8,8),
('2026-07-09','Shipped',43798.97,9,9),
('2026-07-10','Delivered',3499.99,10,10),
('2026-07-11','Processing',4999.99,1,1),
('2026-07-12','Delivered',60298.99,2,2),
('2026-07-13','Pending',2699.99,3,3),
('2026-07-14','Delivered',12999.99,4,4),
('2026-07-15','Shipped',41999.99,5,5);
GO

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1,1,1,45999.99),(1,5,1,39999.99),
(2,5,1,39999.99),
(3,4,1,64999.99),
(4,9,1,4999.99),(4,10,1,6499.99),
(5,16,1,6999.99),
(6,13,1,14999.99),
(7,3,1,52999.99),(7,12,1,1299.99),
(8,20,1,2299.99),
(9,2,1,38999.99),(9,17,1,3499.99),(9,12,1,1299.99),
(10,17,1,3499.99),
(11,9,1,4999.99),
(12,6,1,58999.99),(12,12,1,1299.99),
(13,18,1,2699.99),
(14,14,1,12999.99),
(15,8,1,41999.99);
GO

-- Recalculate order totals from order-item detail.
UPDATE O
SET TotalAmount = X.Total
FROM Orders AS O
INNER JOIN
(
    SELECT OrderID, SUM(Quantity * UnitPrice) AS Total
    FROM OrderItems
    GROUP BY OrderID
) AS X
    ON O.OrderID = X.OrderID;
GO

INSERT INTO Payments
(OrderID, PaymentMethod, PaymentStatus, Amount)
VALUES
(1,'Credit Card','Paid',85999.98),
(2,'Cash','Paid',39999.99),
(3,'Credit Card','Paid',64999.99),
(4,'Debit Card','Paid',11499.98),
(5,'PayPal','Paid',6999.99),
(6,'Credit Card','Refunded',14999.99),
(7,'Cash','Paid',54299.98),
(8,'Cash','Pending',2299.99),
(9,'Credit Card','Paid',43798.97),
(10,'Debit Card','Paid',3499.99),
(11,'PayPal','Paid',4999.99),
(12,'Credit Card','Paid',60298.99),
(13,'Cash','Pending',2699.99),
(14,'Debit Card','Paid',12999.99),
(15,'Credit Card','Paid',41999.99);
GO

INSERT INTO Shipping
(OrderID, ShippingMethod, ShippingStatus, ShippingDate, DeliveryDate)
VALUES
(1,'Express','Delivered','2026-07-02','2026-07-04'),
(2,'Standard','Delivered','2026-07-03','2026-07-06'),
(3,'Express','Shipped','2026-07-04',NULL),
(4,'Standard','Pending','2026-07-05',NULL),
(5,'Express','Delivered','2026-07-06','2026-07-07'),
(6,'Standard','Returned','2026-07-07','2026-07-10'),
(7,'Express','Delivered','2026-07-08','2026-07-09'),
(8,'Standard','Pending','2026-07-09',NULL),
(9,'Express','In Transit','2026-07-10',NULL),
(10,'Standard','Delivered','2026-07-11','2026-07-13'),
(11,'Express','Shipped','2026-07-12',NULL),
(12,'Express','Delivered','2026-07-13','2026-07-15'),
(13,'Standard','Pending','2026-07-14',NULL),
(14,'Express','Delivered','2026-07-15','2026-07-17'),
(15,'Express','In Transit','2026-07-16',NULL);
GO
