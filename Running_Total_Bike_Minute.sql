USE TestDb;
GO

/*
Retrieve a running total of minutes spent on capital bike trips per day. 
*/

--SELECT * FROM CapitalTrips;

SELECT
 start_station,
 Start_date,
 Duration,
 SUM(Duration) OVER (ORDER BY Start_date
   ROWS BETWEEN UNBOUNDED PRECEDING 
      AND CURRENT ROW) AS running_total
FROM CapitalTrips;