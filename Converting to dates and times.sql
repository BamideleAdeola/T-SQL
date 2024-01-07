							----------------------------------
							--CONVERTING TO DATES AND TIMES
							----------------------------------
/*
Create dates from component parts in the calendar table: calendar year, calendar month, and the day of the month.
*/

-- Create dates from component parts on the calendar table
SELECT TOP(10)
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.Day) AS CalendarDate
FROM dbo.Calendar c
WHERE
	c.CalendarYear = 2017
ORDER BY
	c.FiscalDayOfYear ASC;


/*
Create dates from the component parts of the calendar table. Use the calendar year, calendar month, and day of month.
*/
SELECT TOP(10)
	c.CalendarQuarterName,
	c.MonthName,
	c.CalendarDayOfYear
FROM dbo.Calendar c
WHERE
	-- Create dates from component parts
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.Day) >= '2018-06-01'
	AND c.DayName = 'Tuesday'
ORDER BY
	c.FiscalYear,
	c.FiscalDayOfYear ASC;

/*

1. Build the date and time (using DATETIME2FROMPARTS()) 
that Neil and Buzz became the first people to land on the 
moon. Note the "2" in DATETIME2FROMPARTS(), meaning 
we want to build a DATETIME2 rather than a DATETIME.


2. Build the date and time (using DATETIMEFROMPARTS()) 
that Neil and Buzz took off from the moon. Note that this is 
for a DATETIME, not a DATETIME2.
*/

SELECT
	-- Mark the date and time the lunar module touched down
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIME2FROMPARTS(1969, 07, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
	-- Mark the date and time the lunar module took back off
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIMEFROMPARTS(1969, 07, 21, 18, 54, 00, 000) AS MoonDeparture;


							----------------------------------
							--Build dates and times with offsets from parts
							----------------------------------
/* USE Case
On January 19th, 2038 at 03:14:08 UTC (that is, 3:14:08 AM), 
we will experience the Year 2038 (or Y2.038K) problem. 
This is the moment that 32-bit devices will reset back to the date 1900-01-01. 
This runs the risk of breaking every 32-bit device using POSIX time, 
which is the number of seconds elapsed since January 1, 1970 at midnight UTC.
*/

--
/*
Build a DATETIMEOFFSET which represents the last millisecond before the Y2.038K problem hits. 
The offset should be UTC.

Build a DATETIMEOFFSET which represents the moment devices hit the Y2.038K issue in UTC time. 
Then use the AT TIME ZONE operator to convert this to Eastern Standard Time.
*/
SELECT
	-- Fill in the millisecond PRIOR TO chaos
	DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 07, 999, 0, 0, 3) AS LastMoment,
    -- Fill in the date and time when we will experience the Y2.038K problem
    -- Then convert to the Eastern Standard Time time zone
	DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 08, 0, 0, 0, 3) AT TIME ZONE 'EASTERN STANDARD TIME' AS TimeForChaos;
