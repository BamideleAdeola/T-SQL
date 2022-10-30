							----------------------------------
							--TIME SERIES ANALYSIS IN SQL

							-- WORKING WITH DATES AND PARTS
							----------------------------------
-- 1. PARSING DATES WITH DATEPART() AND DATENAME()
/*
You can extract Year, Month, Day etc from a Date or datetime column with the Datepart function
However, it returns numbers
*/

DECLARE @mydate DATETIME = GETDATE();
SELECT YEAR(@mydate) CurrentYear, MONTH(@mydate) CurrentMonth , DAY(@mydate) CurrentDay;

-- DATEPART - Returns digit 
-- DATENAME - Returns Strings

SELECT DATEPART(YEAR, @mydate) AS ThisYear;
SELECT DATENAME(MONTH, @mydate) AS ThisMonth;

-- ADDING AND SUBTRACTING DATES WITH DATEADD FUNCTION
DECLARE @mydate DATETIME = GETDATE();
SELECT 
	DATEADD(DAY, 1, @mydate) AS Nextday,
	DATEADD(DAY, -1, @mydate) AS PreviousDay;

SELECT DATEADD(HOUR, -5, DATEADD(DAY, -6, @mydate)) AS Minus6Days5Hours;

-- DATEDIFF - Does the opposite of DATEADD. It subtracts 2 different dates to return an int not a date.

DECLARE 
	@StartTime DATETIME2(7) = '2022-10-29 16:57:42',
	@EndtTime DATETIME2(7) = '2022-10-29 20:00:00';

SELECT 
	DATEDIFF(SECOND, @StartTime, @EndtTime) AS SecondsElapsed,
	DATEDIFF(MINUTE, @StartTime, @EndtTime) AS MinutesElapsed,
	DATEDIFF(HOUR, @StartTime, @EndtTime) AS HoursElapsed;


	/* Q. 1
	Use the YEAR(), MONTH(), and DAY() functions to determine the year, month, and day for the current date and time.
	*/
DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();

-- Retrieve the year, month, and day
SELECT
	DATEPART(YEAR, @SomeTime) AS TheYear,
	DATEPART(MONTH, @SomeTime) AS TheMonth,
	DATEPART(DAY, @SomeTime) AS TheDay;


	/* Q. 2
	Using the DATEPART() function, fill in the appropriate 
	date parts. For a list of parts, review https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql
	*/
DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in each date part
SELECT
	DATEPART(YEAR, @BerlinWallFalls) AS TheYear,
	DATEPART(MONTH, @BerlinWallFalls) AS TheMonth,
	DATEPART(DAY, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(WEEK, @BerlinWallFalls) AS TheWeek,
	DATEPART(SECOND, @BerlinWallFalls) AS TheSecond,
	DATEPART(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;

	/*Q. 3
	Using the DATENAME() function, fill in the appropriate function calls.
	*/
	DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in the function to show the name of each date part
SELECT
	DATENAME(YEAR, @BerlinWallFalls) AS TheYear,
	DATENAME(MONTH, @BerlinWallFalls) AS TheMonth,
	DATENAME(DAY, @BerlinWallFalls) AS TheDay,
	DATENAME(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATENAME(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATENAME(WEEK, @BerlinWallFalls) AS TheWeek,
	DATENAME(SECOND, @BerlinWallFalls) AS TheSecond,
	DATENAME(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;

	
	/*Q. 4
	Fill in the date parts and intervals needed to determine how SQL Server works on February 29th of a leap year.
	2012 was a leap year. The leap year before it was 4 years earlier, and the leap year after it was 4 years later.
	*/
DECLARE
	@LeapDay DATETIME2(7) = '2012-02-29 18:00:00';

-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @LeapDay) AS PriorDay,
	DATEADD(DAY, 1, @LeapDay) AS NextDay,
    -- For leap years, we need to move 4 years, not just 1
	DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @LeapDay) AS PriorYear;


	/*Q. 4
		Fill in the date parts and intervals needed to determine how SQL Server works on days next to a leap year.
	*/

DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00';

-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @PostLeapDay) AS PriorDay,
	DATEADD(DAY, 1, @PostLeapDay) AS NextDay,
	DATEADD(YEAR, -4, @PostLeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @PostLeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @PostLeapDay) AS PriorYear,
    -- Move 4 years forward and one day back
	DATEADD(DAY, -1, DATEADD(YEAR, 4, @PostLeapDay)) AS NextLeapDay,
    DATEADD(DAY, -2, @PostLeapDay) AS TwoDaysAgo;


	/* Q. 5
	Taking TwoDaysAgo from the prior step, use the DATEDIFF() function to test how it handles leap years.
	*/
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
    @TwoDaysAgo DATETIME2(7);

SELECT
	@TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);

SELECT
	@TwoDaysAgo AS TwoDaysAgo,
	@PostLeapDay AS SomeTime,
    -- Fill in the appropriate function and date types
	DATEDIFF(DAY, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
	DATEDIFF(HOUR, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
	DATEDIFF(MINUTE, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference;

-- ROUNDING DATES - No intuitive way to rund dates in SQL Srver but we can combine DATEASD and DATEDIFF

	/*
	Use DATEADD() and DATEDIFF() in conjunction with date parts to round down our time to the day, hour, and minute.

	*/
DECLARE
	@SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248991';

-- Fill in the appropriate functions and date parts
SELECT
	DATEADD(DAY, DATEDIFF(DAY, 0, @SomeTime), 0) AS RoundedToDay,
	DATEADD(HOUR, DATEDIFF(HOUR, 0, @SomeTime), 0) AS RoundedToHour,
	DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @SomeTime), 0) AS RoundedToMinute;

							----------------------------------
							--FORMATING DATE FOR REPORTING
							----------------------------------
/*
SQL SERVER has 3 formating tyoes of dates available for use: 
1. CAST();		2. CONVERT();		3. FORMAT()

1. CAST();	This has been in SQL Server for over 2 decades (2000). 
It is useful for converting from one data type to another such as Integer to a Decimal
- No control over formating from date to strings
- ANSI SQL standard, meaning any relational and most non-relational databases would have this function.

2. CONVERT(); Also goes back to atleast SQL Server 2000
It is useful for converting from one data type to another such as Integer to a Decimal just like CAST()
unlike CAST, we can have some control over formating from dates to strings using the style parameter
- It is specific to T-SQL

3. FORMAT(); Arrived in SQL Server 2012
- Useful for formatting a date or number in a particular way for reporting
- More more flexible over formating from dates to strings than either CAST() or CONVERT()
- Specific to T_SQL
- Uses the .NET framework for conversion
- Hence, it can be	slower as more rows are processed.

*/


					-- CAST--

DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245',
	@OlderDateType DATETIME = '2016-11-03 00:30:29.245';

SELECT
	-- Fill in the missing function calls
	CAST(@CubsWinWorldSeries AS DATE) AS CubsWinDateForm,
	CAST(@CubsWinWorldSeries AS NVARCHAR(30)) AS CubsWinStringForm,
	CAST(@OlderDateType AS DATE) AS OlderDateForm,
	CAST(@OlderDateType AS NVARCHAR(30)) AS OlderStringForm;


/* Q.
	For the inner function, turn the date the Cubs won the World Series into a DATE data type using the CAST() function.
	For the outer function, reshape this date as an NVARCHAR(30) using the CAST() function.
*/

DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CAST(CAST(@CubsWinWorldSeries AS DATE) AS NVARCHAR(30)) AS DateStringForm;

						
						-- CONVERT--
/*
Use the CONVERT() function to translate the date the Cubs won the world series into the DATE and NVARCHAR(30) data types.
The functional form for CONVERT() is CONVERT(DataType, SomeValue).*/

DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(DATE, @CubsWinWorldSeries) AS CubsWinDateForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries) AS CubsWinStringForm;

					
						--CAST() AND CONVERT()--

/*
Fill in the correct function call for conversion.
The UK date formats are 3 and 103, representing two-digit year (dmy) and four-digit year (dmyyyy), respectively.
The corresponding US date formats are 1 and 101.
*/

DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 0) AS DefaultForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 3) AS UK_dmy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 1) AS US_mdy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 103) AS UK_dmyyyy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 101) AS US_mdyyyy;


/*
Fill in the function and use the 'd' format parameter 
(note that this is case sensitive!) to format as short dates. 
Also, fill in the culture for Japan, which in the .NET framework is jp-JP (this is not case sensitive).
*/


DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
	-- Fill in the function call and format parameter
	FORMAT(@Python3ReleaseDate, 'd', 'en-US') AS US_d,
	FORMAT(@Python3ReleaseDate, 'd', 'de-DE') AS DE_d,
	-- Fill in the locale for Japan
	FORMAT(@Python3ReleaseDate, 'd', 'jp-JP') AS JP_d,
	FORMAT(@Python3ReleaseDate, 'd', 'zh-cn') AS CN_d;


/*
Use the 'D' format parameter (this is case sensitive!) 
to build long dates. Also, fill in the culture for Indonesia, which in the .NET framework is id-ID.
*/

DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
	-- Fill in the format parameter
	FORMAT(@Python3ReleaseDate, 'D', 'en-US') AS US_D,
	FORMAT(@Python3ReleaseDate, 'D', 'de-DE') AS DE_D,
	-- Fill in the locale for Indonesia
	FORMAT(@Python3ReleaseDate, 'D', 'id-ID') AS ID_D,
	FORMAT(@Python3ReleaseDate, 'D', 'zh-cn') AS CN_D;


/*
Fill in the custom format strings needed to generate the 
results in preceding comments. Use date parts such as 
yyyy, MM, MMM, and dd. Capitalization is important 
for the FORMAT() function! See the full list at https://bit.ly/30SGA5a. 
*/

DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';
    
SELECT
	-- 20081203
	FORMAT(@Python3ReleaseDate, 'yyyyMMdd') AS F1,
	-- 2008-12-03
	FORMAT(@Python3ReleaseDate, 'yyyy-MM-dd') AS F2,
	-- Dec 03+2008 (the + is just a "+" character)
	FORMAT(@Python3ReleaseDate, 'MMM dd+yyyy') AS F3,
	-- 12 08 03 (month, two-digit year, day)
	FORMAT(@Python3ReleaseDate, 'MM yy dd') AS F4,
	-- 03 07:45 2008.00
    -- (day hour:minute year.second)
	FORMAT(@Python3ReleaseDate, 'dd hh:mm yyyy.ss') AS F5;




							----------------------------------
								--APPLY OPERATORS
							----------------------------------

-- APPLY() Function is used to simplify queries

/*
Find the dates of all Tuesdays in December covering the calendar years 2008 through 2010.
*/

-- Find Tuesdays in December for calendar years 2008-2010
SELECT
	c.Date
FROM dbo.calendar c
WHERE
	c.MonthName = 'December'
	AND c.DayName = 'Tuesday'
	AND c.CalendarYear BETWEEN 2008 AND 2010
ORDER BY
	c.Date;


/*
Find the dates for fiscal week 29 of fiscal year 2019.
*/
-- Find fiscal week 29 of fiscal year 2019
SELECT
	c.Date
FROM dbo.Calendar c
WHERE
    -- Instead of month, use the fiscal week
	c.FiscalWeekOfYear = 29
    -- Instead of calendar year, use fiscal year
	AND c.FiscalYear = 2019
ORDER BY
	c.Date ASC;


/* Q
 determine which dates had type 3 incidents during the third fiscal quarter of FY2019.
*/

SELECT
	ir.IncidentDate,
	c.FiscalDayOfYear,
	c.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 3
	ir.IncidentTypeID = 3
    -- Fiscal year 2019
	AND c.FiscalYear = '2019'
    -- Fiscal quarter 3
	AND c.FiscalQuarter = 3;


/*
determine type 4 incidents which happened on weekends in FY2019 after fiscal week 30.
*/
SELECT
	ir.IncidentDate,
	c.FiscalDayOfYear,
	c.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 4
	ir.IncidentTypeID = 4
    -- Fiscal year 2019
	AND c.FiscalYear = 2019
    -- Beyond fiscal week of year 30
	AND c.FiscalWeekOfYear > 30
    -- Only return weekends
	AND c.IsWeekend = 1;