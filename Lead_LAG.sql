							----------------------------------
									--LEAD AND LAG
							----------------------------------


/*
LAG() and LEAD() gives opportunity to link together past, present and future.

1. LAG() - PRIOR RECORD
2. LEAD() - FUTURE RECORD

They take optional parameter of how far backwards or forwards, you intend to go.
The LAG() and LEAD() window functions give us the ability to look 
backward or forward in time, respectively. This gives us the ability 
to compare period-over-period data in a single, easy query.
*/

/*
Fill in the window function to return the prior day's number of incidents, 
partitioned by incident type ID and ordered by the incident date.

Fill in the window function to return the next day's number of 
incidents, partitioned by incident type ID and ordered by the incident date.
*/

SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
    -- Get the prior day's number of incidents
	LAG(ir.NumberOfIncidents, 1) OVER (
      	-- Partition by incident type ID
		PARTITION BY ir.IncidentTypeID
      	-- Order by incident date
		ORDER BY ir.IncidentDate
	) AS PriorDayIncidents,
	ir.NumberOfIncidents AS CurrentDayIncidents,
    -- Get the next day's number of incidents
	LEAD(ir.NumberOfIncidents, 1) OVER (
      	-- Partition by incident type ID
		PARTITION BY ir.IncidentTypeID
      	-- Order by incident date
		ORDER BY ir.IncidentDate
	) AS NextDayIncidents
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentDate >= '2019-07-02'
	AND ir.IncidentDate <= '2019-07-31'
	AND ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;



/*
Fill in the SQL to return the number of incidents from two periods ago.
Fill in the SQL to return the number of incidents from the prior period.
Fill in the SQL to return the number of incidents from the next period.
*/
SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
    -- Fill in two periods ago
	LAG(ir.NumberOfIncidents, 2) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	) AS Trailing2Day,
    -- Fill in one period ago
	LAG(ir.NumberOfIncidents, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	) AS Trailing1Day,
	ir.NumberOfIncidents AS CurrentDayIncidents,
    -- Fill in next period
	LEAD(ir.NumberOfIncidents, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	) AS NextDay
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentDate >= '2019-07-01'
	AND ir.IncidentDate <= '2019-07-31'
	AND ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;



/*
Calculate the days since the last incident using a combination of DATEDIFF() and LAG() or LEAD().
Calculate the days until the next incident using a combination of DATEDIFF() and LAG() or LEAD().
NOTE: you will not need to use the NumberOfIncidents column in this exercise.
*/

SELECT
	ir.IncidentDate,
	ir.IncidentTypeID,
    -- Fill in the days since last incident
	DATEDIFF(DAY, LAG(ir.IncidentDate, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	), ir.IncidentDate) AS DaysSinceLastIncident,
    -- Fill in the days until next incident
	DATEDIFF(DAY, ir.IncidentDate, LEAD(ir.IncidentDate, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.IncidentDate
	)) AS DaysUntilNextIncident
FROM dbo.IncidentRollup ir
WHERE
	ir.IncidentDate >= '2019-07-02'
	AND ir.IncidentDate <= '2019-07-31'
	AND ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate;



/*
Split out start events and end events.
Fill in the customer's visit start date (dsv.CustomerVisitStart) as TimeUTC in the "entrances" part of the query.
Fill in the window function that we alias as StartStopPoints to give us the stream of check-ins for each customer, ordered by their visit start date.
Fill in the customer's visit end date (dsv.CustomerVisitEnd) as TimeUTC in the "departures" part of the query.
*/

-- This section focuses on entrances:  CustomerVisitStart
SELECT
	dsv.CustomerID,
	dsv.CustomerVisitStart AS TimeUTC,
	1 AS EntryCount,
    -- We want to know each customer's entrance stream
    -- Get a unique, ascending row number
	ROW_NUMBER() OVER (
      -- Break this out by customer ID
      PARTITION BY dsv.CustomerID
      -- Ordered by the customer visit start date
      ORDER BY dsv.CustomerVisitStart
    ) AS StartOrdinal
FROM dbo.DaySpaVisit dsv
UNION ALL
-- This section focuses on departures:  CustomerVisitEnd
SELECT
	dsv.CustomerID,
	dsv.CustomerVisitEnd AS TimeUTC,
	-1 AS EntryCount,
	NULL AS StartOrdinal
FROM dbo.DaySpaVisit dsv;

/*
Fill out the appropriate window function (ROW_NUMBER()) to create a stream of check-ins and check-outs in chronological order.
Partition by the customer ID to calculate a result per user.
Order by the event time and solve ties by using the start ordinal value.
*/

SELECT s.*,
    -- Build a stream of all check-in and check-out events
	ROW_NUMBER() OVER (
      -- Break this out by customer ID
      PARTITION BY s.CustomerID
      -- Order by event time and then the start ordinal
      -- value (in case of exact time matches)
      ORDER BY s.TimeUTC, s.StartOrdinal
    ) AS StartOrEndOrdinal
FROM #StartStopPoints s;



/*
Fill out the HAVING clause to determine cases with more 
than 2 concurrent visitors.

Fill out the ORDER BY clause to show management the 
worst offenders: those with the highest values for 
MaxConcurrentCustomerVisits.
*/

SELECT
	s.CustomerID,
	MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal) AS MaxConcurrentCustomerVisits
FROM #StartStopOrder s
WHERE s.EntryCount = 1
GROUP BY s.CustomerID
-- The difference between 2 * start ordinal and the start/end
-- ordinal represents the number of concurrent visits
HAVING MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal) > 2
-- Sort by the largest number of max concurrent customer visits
ORDER BY MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal);