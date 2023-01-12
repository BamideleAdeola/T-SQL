USE AdventureWorks2019;
GO

-- Display weekend orders

SELECT 
  SalesOrderID,
  OrderQty,
  DATENAME(dw, ModifiedDate) AS WeekendOrder
FROM Sales.SalesOrderDetail
WHERE DATENAME(dw, ModifiedDate) IN ('Saturday', 'Sunday');
go

SELECT 
  SalesOrderID,
  OrderQty,
  DATENAME(dw, ModifiedDate) AS WeekdayOrder
FROM Sales.SalesOrderDetail
WHERE DATENAME(dw, ModifiedDate) NOT IN ('Saturday', 'Sunday');
go

