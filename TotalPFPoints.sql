USE TestDb;
GO


SET STATISTICS TIME ON
/*
Write a query that returns the total points contribution of a teams 
Power Forwards (PF) where their total points contribution is greater than 2000.
*/

SELECT Team, 
	SUM(TotalPoints) AS TotalPFPoints
FROM NbaPlayerStats
-- Filter for only rows with power forwards
WHERE Position = 'PF'
GROUP BY Team
-- Filter for total points greater than 2000
HAVING sum(TotalPoints) > 2000
ORDER BY TotalPFPoints DESC;