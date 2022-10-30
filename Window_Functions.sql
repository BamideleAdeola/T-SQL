						------------------------------
							-- WINDOWS FUNCTION
						------------------------------

/*
- It is created with an OVER() clause
- PARTITION BY to create the frame
- Without the PARTITION BY CLAUSE, the frame would be the entire table
- ORDER BY helps to arrange the result
- It allows aggregations to be created as well as the window

*/
-------------------------------------------------------------------------------------------------------------
/* Q1
Write a T-SQL query that returns the sum of OrderPrice by creating partitions for each TerritoryName.
*/

SELECT OrderID, TerritoryName, 
       -- Total price for each partition
       SUM(OrderPrice) 
       -- Create the window and partitions
       OVER(PARTITION BY TerritoryName) AS TotalPrice
FROM Orders;


/* Q2
Count the number of rows in each partition.
Partition the table by TerritoryName.
*/

SELECT OrderID, TerritoryName, 
       -- Number of rows per partition
       COUNT(*) 
       -- Create the window and partitions
       OVER(PARTITION BY TerritoryName) AS TotalOrders
FROM Orders;


						-----------------------------------------
							-- COMMONLY USED WINDOW FUNCTION
						-----------------------------------------

/*
-Commonly used window functions are
1. First_value () -  returns the first value in the window
2. Last_value () - Returns the last value in the window
3. Lead () - Provides the ability to query the value from the next row. Also requires Order by to order the rows.
	Also retuns null at the last value since there wont be any lead value for the current row of the last value.
4. Lag () - Provides the ability to query the value from the previous row. Also requires Order by to order the rows
*/
-------------------------------------------------------------------------------------------------------------------

/* Q1 - FIRST_VALUE
Write a T-SQL query that returns the first OrderDate by creating partitions for each TerritoryName.
*/

SELECT TerritoryName, OrderDate, 
       -- Select the first value in each partition
       FIRST_VALUE(OrderDate) 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS FirstOrder
FROM Orders;

/* Q2 - PREVIOUS AND NEXT
Write a T-SQL query that for each territory:
Shifts the values in OrderDate one row down. Call this column PreviousOrder.
Shifts the values in OrderDate one row up. Call this column NextOrder. You will need to PARTITION BY the territory
*/

SELECT TerritoryName, OrderDate, 
       -- Specify the previous OrderDate in the window
       LAG(OrderDate) 
       -- Over the window, partition by territory & order by order date
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS PreviousOrder,
       -- Specify the next OrderDate in the window
       LEAD(OrderDate) 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS NextOrder
FROM Orders;


						-----------------------------------------
							-- ROW_NUMBERS
						-----------------------------------------
-- Row_number() - sequentially numbers the rows in the window. Order by is required when using this function

/*Q1 RUNNING TOTAL WITHOUT ROW_NUMBER()
Create the window, partition by TerritoryName and order by OrderDate to calculate a running total of OrderPrice.
*/
SELECT TerritoryName, OrderDate, 
       -- Create a running total
       SUM(OrderPrice) 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS TerritoryTotal	  
FROM Orders;

/* RUNNING TOTAL WITH ROW_NUMBER()
Write a T-SQL query that assigns row numbers to all records partitioned by TerritoryName and ordered by OrderDate.
*/

SELECT TerritoryName, OrderDate, 
       -- Assign a row number
       ROW_NUMBER() 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS OrderCount
FROM Orders;



						-----------------------------------------
						-- USING WINDOWS TO CALCULATE STATISTICS
						-----------------------------------------
/*
Calculating standard deviation STDEV(). This can be calculated for the entire table or the window or groups.

-- MODE - This is a value that appears the most in a dataset
Unlike Standard deviation (STDEV), there is no function to calculate mode in SQL Server
To calculate mode, 
1. create a CTE containing ordered count of values using ROW_NUMBER()
2. Write a query Using the CTE to pick the value with the highest ROW_NUMBER

*/

WITH QuotaCount AS (
SELECT salesperson, salesYear, CurrentQuota,
	ROW_NUMBER() OVER(PARTITION BY CurrentQuota ORDER BY CurrentQuota) AS QuotaList
FROM SalesGoal
)

SELECT CurrentQuota, QuotaList AS mode
FROM QuotaCount
WHERE QuotaList IN (SELECT MAX(QuotaList) FROM QuotaCount)
--------

/* Q1 STANDARD DEVIATION
Create the window, partition by TerritoryName and order by OrderDate to calculate a running standard deviation of OrderPrice.
*/

SELECT OrderDate, TerritoryName, 
       -- Calculate the standard deviation
	   STDEV(OrderPrice) 
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS StdDevPrice	  
FROM Orders;

/* Q2 MODE
Create a CTE ModePrice that returns two columns (OrderPrice and UnitPriceFrequency).
Write a query that returns all rows in this CTE.
*/
-- Create a CTE Called ModePrice which contains two columns
WITH ModePrice (OrderPrice, UnitPriceFrequency)
AS
(
	SELECT OrderPrice, 
	ROW_NUMBER() 
	OVER(PARTITION BY OrderPrice ORDER BY OrderPrice) AS UnitPriceFrequency
	FROM Orders 
)

-- Select everything from the CTE
SELECT * FROM ModePrice


/* Q3 MODE
Create a CTE ModePrice that returns two columns (OrderPrice and UnitPriceFrequency).
Use the CTE ModePrice to return the value of OrderPrice with the highest row number.
*/

-- CTE from the previous exercise
WITH ModePrice (OrderPrice, UnitPriceFrequency)
AS
(
	SELECT OrderPrice,
	ROW_NUMBER() 
    OVER (PARTITION BY OrderPrice ORDER BY OrderPrice) AS UnitPriceFrequency
	FROM Orders
)

-- Select the order price from the CTE
SELECT OrderPrice AS ModeOrderPrice
FROM ModePrice
-- Select the maximum UnitPriceFrequency from the CTE
WHERE UnitPriceFrequency IN (SELECT MAX(UnitPriceFrequency) FROM ModePrice);