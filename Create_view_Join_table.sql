 /* Create a view with a simple JOIN clause*/

USE AdventureWorks2012;   
GO  

CREATE VIEW HumanResources.vvEmployeeHireDate  
AS  
SELECT p.FirstName, p.LastName, e.HireDate  
FROM HumanResources.Employee AS e 
JOIN Person.Person AS  p  
ON e.BusinessEntityID = p.BusinessEntityID ;   
GO  

-- Querying the created view  
SELECT FirstName, LastName, HireDate  
FROM HumanResources.vvEmployeeHireDate  
ORDER BY LastName; -- order by clause
