USE Northwind;
GO
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [CustomerID]
      ,[CompanyName]
      ,[ContactName]
      ,[ContactTitle]
      ,[Address]
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]
      ,[Phone]
      ,[Fax]
  FROM [Northwind].[dbo].[Customers]


  /*
  Write an SQL query to fetch the contactName that begins with any two characters, 
  followed by a text “ab” and ends with any sequence of characters.
  */
SELECT ContactName
FROM dbo.Customers
WHERE ContactName LIKE '__ab%';

--OR

SELECT ContactName
FROM dbo.Customers
WHERE SUBSTRING(ContactName,3,2) = 'ab';