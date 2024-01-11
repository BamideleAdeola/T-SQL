DECLARE
	@mycurrentdate1 DATETIME2(7) = GETDATE();  -- MY CURRENT DATE AT THE TIME OF THIS QUERY for datepart

SELECT
	DATEPART(YEAR, @mycurrentdate1) AS TheYear,
	DATEPART(MONTH, @mycurrentdate1) AS TheMonth,
	DATEPART(DAY, @mycurrentdate1) AS TheDay,
	DATEPART(DAYOFYEAR, @mycurrentdate1) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @mycurrentdate1) AS TheDayOfWeek,
	DATEPART(WEEK, @mycurrentdate1) AS TheWeek,
	DATEPART(SECOND, @mycurrentdate1) AS TheSecond,
	DATEPART(NANOSECOND, @mycurrentdate1) AS TheNanosecond;
GO
------------------------------------------------------------------------
DECLARE
	@mycurrentdate2 DATETIME2(7) = GETDATE();    --MY CURRENT DATE AT THE TIME OF THIS QUERY for datename
SELECT
	DATENAME(YEAR, @mycurrentdate2) AS TheYear,
	DATENAME(MONTH, @mycurrentdate2) AS TheMonth,
	DATENAME(DAY, @mycurrentdate2) AS TheDay,
	DATEPART(DAYOFYEAR, @mycurrentdate2) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATENAME(WEEKDAY, @mycurrentdate2) AS TheDayOfWeek,
	DATENAME(WEEK, @mycurrentdate2) AS TheWeek,
	DATENAME(SECOND, @mycurrentdate2) AS TheSecond,
	DATENAME(NANOSECOND, @mycurrentdate2) AS TheNanosecond;
GO
--
