
DECLARE
	@mycurrentdate DATETIME2(7) = GETDATE();  -- MY CURRENT DATE AT THE TIME OF THIS QUERY

-- Fill in each date part
SELECT
	DATEPART(YEAR, @mycurrentdate) AS TheYear,
	DATEPART(MONTH, @mycurrentdate) AS TheMonth,
	DATEPART(DAY, @mycurrentdate) AS TheDay,
	DATEPART(DAYOFYEAR, @mycurrentdate) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @mycurrentdate) AS TheDayOfWeek,
	DATEPART(WEEK, @mycurrentdate) AS TheWeek,
	DATEPART(SECOND, @mycurrentdate) AS TheSecond,
	DATEPART(NANOSECOND, @mycurrentdate) AS TheNanosecond;