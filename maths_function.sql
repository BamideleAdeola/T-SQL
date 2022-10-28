
------------------------------
-- SUM AND COUNT FUNCTIONS FOR TOTALS
------------------------------

-- SUM AND COUNT FUNCTIONS FOR TOTALS
-- To know the no of unique count in a columnn, add distinct inside a count

/* Q1
Write a T-SQL query which will return the sum of the Quantity column as Total for each type of MixDesc.
*/

-- Write a query that returns an aggregation 
SELECT MixDesc, SUM(Quantity) AS Total
FROM Shipments
-- Group by the relevant column
GROUP BY MixDesc;


/* Q2
Create a query that returns the number of rows for each type of MixDesc.
*/
-- Count the number of rows by MixDesc
SELECT MixDesc, COUNT(*)
FROM Shipments
GROUP BY MixDesc;



/* Q3
Replace missing values in Country with the first non-missing value from IncidentState or City, 
in that order. Name the new column Location.
*/



