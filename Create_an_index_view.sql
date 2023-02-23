
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





