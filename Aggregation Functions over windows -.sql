							----------------------------------
					--AGGREGATION FUNCTIONS OVER WINDOWS
							----------------------------------
/*
4 window ranking functions

1. ROW_NUMBER() - Unique ascending integer starting from 1


2. RANK() - Ascending integer value from 1. Can have ties and can skip numbers.

3. DENSE_RANK() -Ascending integer value from 1. Can have ties and will not skip numbers.

4. NTILE() - 

Among the ranking window functions, ROW_NUMBER() is the most common, 
followed by RANK() and DENSE_RANK(). Each of these ranking functions 
(as well as NTILE()) provides us with a different way to rank records 
in SQL Server.
*/


/* Contrasting ROW_NUMBER(), RANK(), and DENSE_RANK()
Fill in each window function based on the column alias. You should include ROW_NUMBER(), RANK(), and DENSE_RANK() exactly once.
Fill in the OVER clause ordering by ir.NumberOfIncidents in descending order.
*/
SELECT
	ir.IncidentDate,
	ir.NumberOfIncidents,
    -- Fill in each window function and ordering
    -- Note that all of these are in descending order!
	ROW_NUMBER() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rownum,
	RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rk,
	DENSE_RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS dr
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentTypeID = 3
	AND ir.NumberOfIncidents >= 8
ORDER BY
	ir.NumberOfIncidents DESC;


-- Running a BLANK OVER CLAUSE
SELECT
	ir.IncidentDate,
	ir.NumberOfIncidents,
    -- You do not need to fill in the OVER clause
	SUM(ir.NumberOfIncidents) OVER () AS SumOfIncidents,
	MIN(ir.NumberOfIncidents) OVER () AS LowestNumberOfIncidents,
	MAX(ir.NumberOfIncidents) OVER () AS HighestNumberOfIncidents,
	COUNT(ir.NumberOfIncidents) OVER () AS CountOfIncidents
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentDate BETWEEN '2019-07-01' AND '2019-07-31'
AND ir.IncidentTypeID = 3;

