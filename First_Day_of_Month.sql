USE BikeShare;
GO

/* 
Retrieve the First day of month of the StartDate Column in CapitalBikeShare Table
*/
SELECT 
	StartDate, 
	DATEADD(month, DATEDIFF(month, 0, StartDate), 0) AS first_Day_of_the_month
FROM dbo.CapitalBikeShare;

SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0);