							----------------------------------
							    --BASIC AGGREGATE FUNCTION 
							----------------------------------
/*
There are two(2) counting finction...

COUNT() - Returns an integer
COUNT_BIG() - Returns a 64-bit integer or BIGINT
COUNT(DISTINCT)

*/

/*
Fill in the appropriate aggregate function based on the column name. Choose from COUNT(), SUM(), MIN(), and MAX() for each.
*/

-- Fill in the appropriate aggregate functions
SELECT
	it.IncidentType,
	COUNT(1) AS NumberOfRows,
	SUM(ir.NumberOfIncidents) AS TotalNumberOfIncidents,
	MIN(ir.NumberOfIncidents) AS MinNumberOfIncidents,
	MAX(ir.NumberOfIncidents) AS MaxNumberOfIncidents,
	MIN(ir.IncidentDate) As MinIncidentDate,
	MAX(ir.IncidentDate) AS MaxIncidentDate
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
	ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
	it.IncidentType;
	

	/*
Return the count of distinct incident type IDs as NumberOfIncidentTypes
Return the count of distinct incident dates as NumberOfDaysWithIncidents
Fill in the appropriate function call and input column to determine number of unique incident types and number of days with incidents in our rollup table.
*/
-- Fill in the functions and columns
SELECT
	Count(distinct ir.IncidentTypeID) AS NumberOfIncidentTypes,
	count(distinct ir.IncidentDate) AS NumberOfDaysWithIncidents
FROM dbo.IncidentRollup ir
WHERE
ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31';


/*
Fill in a CASE expression which lets us use the SUM() function to calculate the number of big-incident and small-incident days.
In the CASE expression, you should return 1 if the appropriate filter criterion is met and 0 otherwise.
Be sure to specify the alias when referencing a column, like ir.IncidentDate or it.IncidentType!
*/

SELECT
	it.IncidentType,
    -- Fill in the appropriate expression
	SUM(CASE WHEN ir.NumberOfIncidents > 5 THEN 1 ELSE 0 END) AS NumberOfBigIncidentDays,
    -- Number of incidents will always be at least 1, so
    -- no need to check the minimum value, just that it's
    -- less than or equal to 5
    SUM(CASE WHEN ir.NumberOfIncidents <= 5 THEN 1 ELSE 0 END) AS NumberOfSmallIncidentDays
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
	ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
it.IncidentType;
