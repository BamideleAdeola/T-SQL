-- DATEDIFF() FUNCTION - Returns difference between two dates.

DECLARE @yearend DATETIME = '2022-12-31 23:59:59';
-- How many months,days...seconds to the end of the year?
SELECT 
	DATEDIFF(MONTH,GETDATE(),@yearend) AS Monthsleft,
	DATEDIFF(DAY,GETDATE(),@yearend) AS Daysleft,
	DATEDIFF(HOUR,GETDATE(),@yearend) AS Hoursleft,
	DATEDIFF(MINUTE,GETDATE(),@yearend) AS Minutessleft,
	DATEDIFF(SECOND,GETDATE(),@yearend) AS Secondsleft;