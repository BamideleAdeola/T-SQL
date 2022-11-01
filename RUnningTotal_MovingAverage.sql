							----------------------------------
					--CALCULATING RUNNING TOTAL AND MOVING AVERAGE
							----------------------------------


/*Fill in the correct window function.
Fill in the PARTITION BY clause in the window function, partitioning by incident type ID.
Fill in the ORDER BY clause in the window function, ordering by incident date (in its default, ascending order).
*/

SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
	ir.NumberOfIncidents,
    -- Get the total number of incidents
	SUM(ir.NumberOfIncidents) OVER (
      	-- Do this for each incident type ID
		PARTITION BY ir.IncidentTypeID
      	-- Sort by the incident date
		ORDER BY ir.IncidentDate
	) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarYear = 2019
	AND c.CalendarMonth = 7
	AND ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;




/*
Fill in the correct window function to perform a moving average starting from 
6 days ago through today (the current row).

Fill in the window frame, including the ROWS clause, 
window frame preceding, and window frame following.
*/

SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
	ir.NumberOfIncidents,
    -- Fill in the correct window function
	AVG(ir.NumberOfIncidents) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
      	-- Fill in the three parts of the window frame
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	) AS MeanNumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarYear = 2019
	AND c.CalendarMonth IN (7, 8)
	AND ir.IncidentTypeID = 1
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;