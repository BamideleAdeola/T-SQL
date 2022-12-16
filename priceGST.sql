USE AdventureWorks2012;
GO
/*
Write SQL Query to get the actual price of product (ListPrice + 20% GST) with Product_name and ProductNumber 
for all products who have product name not starting with A AND product_id must be greater than or equal to 316
And Listprice is not 0. Sort your result with Product_name
*/
-- Query 1
SELECT  
	ProductID, 
	Name As ProductName,
	ListPrice,
	CAST(((0.20 * listPrice) + listPrice) AS DECIMAL(6,2))  AS Actual_price
FROM Production.Product
WHERE Name not Like 'A%'
 AND ProductID >= '316'
 AND listPrice != 0
ORDER BY ProductID ASC;

-- Query 2 (multiply price by 1.20) which is 120%
SELECT  
	ProductID, 
	Name As ProductName,
	ListPrice,
	CAST((1.2 * listPrice) AS DECIMAL(6,2)) AS Actual_price
FROM Production.Product
WHERE Name not Like 'A%'
 AND ProductID >= '316'
 AND listPrice > 0
ORDER BY ProductID ASC;