USE AdventureWorks2019;

-- 
GO
-- Confirming if today is a weekend or weekday
SELECT GETDATE() AS Today,
DATENAME(dw, GETDATE()) AS dayofweek,
CHOOSE(DATEPART(dw, GETDATE()), 'WEEKEND', 'Weekday',
 'Weekday', 'Weekday', 'Weekday', 'Weekday', 'WEEKEND') AS Workday;

 SELECT s.ModifiedDate AS OrderDate,
DATENAME(dw, s.ModifiedDate) AS DayofWeek,
CHOOSE(DATEPART(dw, s.ModifiedDate), 'WEEKEND','Weekday',
'Weekday','Weekday','Weekday','Weekday','WEEKEND') AS WorkDay
FROM Sales.SalesOrderDetail AS s
GO

--SELECT * FROM Person.Address;
