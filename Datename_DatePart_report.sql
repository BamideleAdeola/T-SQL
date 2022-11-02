
DECLARE
	@mycurrentdate1 DATETIME2(7) = GETDATE();  -- MY CURRENT DATE AT THE TIME OF THIS QUERY for dateoart

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

------------------------------------------------------------------------

SELECT
	DATENAME(YEAR, @mycurrentdate1) AS TheYear,
	DATENAME(MONTH, @mycurrentdate1) AS TheMonth,
	DATENAME(DAY, @mycurrentdate1) AS TheDay,
	DATEPART(DAYOFYEAR, @mycurrentdate1) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATENAME(WEEKDAY, @mycurrentdate1) AS TheDayOfWeek,
	DATENAME(WEEK, @mycurrentdate1) AS TheWeek,
	DATENAME(SECOND, @mycurrentdate1) AS TheSecond,
	DATENAME(NANOSECOND, @mycurrentdate1) AS TheNanosecond;
GO