
------------------------------
-- MATHS FUNCTIONS
------------------------------

-- SUM AND COUNT FUNCTIONS FOR TOTALS
-- To know the no of unique count in a columnn, add distinct inside a count

/* Q1
Write a T-SQL query which will return the sum of the Quantity column as Total for each type of MixDesc.
*/

-- Write a query that returns an aggregation 
SELECT MixDesc, SUM(Quantity) AS Total
FROM shipments
-- Group by the relevant column
GROUP BY MixDesc;


/* Q2
Create a query that returns the number of rows for each type of MixDesc.
*/
-- Count the number of rows by MixDesc
SELECT MixDesc, COUNT(*)
FROM Shipments
GROUP BY MixDesc;


----------------------
-- MATHS WITH DATES
----------------------
/*
-- DATEPART: Used to determine what part of the date you wish to calculate or retrieve
DD for Day
MM for Month
YY for Year
HH for Hour

DATEADD() - Add or subtract datetime values  e.g Always returns a date
DATEDIFF() - Obtain the difference between two datetike values e.g Always returns number 

*/


/* Q3
Add 30 days to the current time
or what is 30 days from now or What is 30 days from October 28, 2022
*/
SELECT DATEADD(DD, 30, GETDATE());

/* Q3
What what is 30 days from October 5, 2022
*/
SELECT DATEADD(DD, 30, '2022-10-05'); -- IN THE FUTURE

/* Q3
What what is 30 days BEFORE October 5, 2022
*/
SELECT DATEADD(DD, -30, '2022-10-05'); -- IN THE PAST

/* Q3 DATEDIFF

*/
SELECT DATEDIFF(DD, '2022-05-22', '2022-06-21') AS difference1,
	   DATEDIFF(DD, '2022-07-21', '2022-06-21') AS difference2;
	   

/* Q4
Write a query that returns the number of days between OrderDate and ShipDate.
*/

-- Return the difference in OrderDate and ShipDate
SELECT OrderDate, ShipDate, 
       DATEDIFF(DD, OrderDate, ShipDate) AS Duration
FROM Shipments

/* Q6
Write a query that returns the approximate delivery date as five days after the ShipDate.
*/

-- Return the DeliveryDate as 5 days after the ShipDate
SELECT OrderDate, 
       DATEADD(DD, 5, ShipDate) AS DeliveryDate
FROM Shipments;


-- ROUNDING AND TRUNCATING NUMBERS
SELECT durationseconds,
ROUND(durationseconds, 0) AS RoundToZero,
ROUND(durationseconds, 1) AS RoundToOne
FROM Incidents;


/* Q6
Write a SQL query to round the values in the Cost column to the nearest whole number.
*/

-- Round Cost to the nearest dollar
SELECT Cost, 
       ROUND(Cost, 0) AS RoundedCost
FROM Shipments;


/* Q6
Write a SQL query to truncate the values in the Cost column to the nearest whole number.
*/
-- Truncate cost to whole number
SELECT Cost, 
       ROUND(Cost, 0, 1) AS TruncateCost
FROM Shipments;


-------------------
/*
 ABS - ABSOLUTE VALUE
 -Use ABS() function to return non-negative values 

*/
-------------------

SELECT ABS(-2.78), ABS(3), ABS(-2);

-------------------
/*
 SQUARES AND SQUARE ROOT
*/
-------------------
SELECT SQRT (81) AS squareroot,
	   SQUARE(8) AS squares;

-------------------
/*
 LOGS() - to retrieve natural logs of value
*/
-------------------

SELECT DurationSeconds, LOG(DurationSeconds, 10) AS logofseconds
FROM incidents;


/* Q7
Write a query that converts all the negative values in the DeliveryWeight column to positive values.
*/

-- Return the absolute value of DeliveryWeight
SELECT DeliveryWeight,
       ABS(DeliveryWeight) AS AbsoluteValue
FROM Shipments;

/* Q8
Write a query that calculates the square and square root of the WeightValue column.
*/

-- Return the square and square root of WeightValue
SELECT WeightValue, 
       SQUARE(WeightValue) AS WeightSquare, 
       SQRT(WeightValue) AS WeightSqrt
FROM Shipments;


/* Q9
Write a query that calculates the square and square root of the WeightValue column.
*/