CREATE DATABASE TestOrders;
GO

USE TestOrders;
GO

CREATE TABLE products_t
(ProductID INT PRIMARY KEY,
Name NVARCHAR(50),
UnitPrice INT);

DROP TABLE products_t;

CREATE TABLE ProdTransaction
(ProductID INT FOREIGN KEY REFERENCES products_t(ProductID),
QtySold INT);

INSERT INTO products_t 
VALUES 
( 1, 'Biro', 40 ),
( 2, 'Pencil', 14 ),
( 3, 'Books', 25 ),
( 4, 'MathSets', 15),
( 5, 'Eraser', 30 )


INSERT INTO ProdTransaction 
VALUES 
( 1,  12 ),
( 3,  24),
( 5, 31),
( 1, 22),
( 2, 24),
( 3,  12 ),
( 4,  28),
( 5, 20),
( 1, 22),
( 2, 24),
( 5, 31),
( 4, 31),
( 2, 24),
( 1,  12 ),
( 4,  28),
( 5, 20),
( 2, 22),
( 2, 24),
( 5, 31),
( 1, 22),
( 2, 24),
( 1,  12 ),
( 2,  40),
( 5, 20),
( 1, 22),
( 2, 24);

CREATE VIEW vProductTotalSales
WITH SCHEMABINDING
AS
SELECT Name, 
  SUM(ISNULL((QtySold * UnitPrice),0)) AS TotalSales,
  COUNT_BIG(*) AS TotalTransactions
FROM dbo.ProdTransaction
JOIN dbo.products_t
ON dbo.ProdTransaction.ProductID = dbo.products_t.ProductID
GROUP BY Name;

SELECT * FROM vProductTotalSales;

CREATE UNIQUE CLUSTERED INDEX UCI_vProductTotalSales_Name
ON vProductTotalSales (Name);





