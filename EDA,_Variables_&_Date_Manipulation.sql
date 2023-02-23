USE BikeShare;
GO
/*
TEMPORAL EDA, VARIABLES AND DATE MANIPULATION
Learn how to do effective exploratory data analysis on temporal data, 
create scalar and table variables to store data, 
and how to execute date manipulation. uSING THE FOLLOWING SQL functions: 
DATEDIFF( ), DATENAME( ), DATEPART( ), CAST( ), CONVERT( ), GETDATE( ), and DATEADD( ).
*/



/* TRANSACTIONS PER DAY
Write a query to determine how many transactions exist per day.

Use CONVERT() to SELECT and GROUP BY the date portion of the StartDate.
Use COUNT() to measure how many records exist for each StartDate.
Sort the results by the date portion of StartDate.
*/

SELECT
  -- Select the date portion of StartDate
  CONVERT(DATE, StartDate) as StartDate,
  -- Measure how many records exist for each StartDate
  COUNT(*) as CountOfRows 
FROM CapitalBikeShare 
-- Group by the date portion of StartDate
GROUP BY CONVERT(DATE, StartDate)
-- Sort the results by the date portion of StartDate
ORDER BY CONVERT(DATE, StartDate);


/* Seconds or no seconds?
Complete the first CASE statement, using DATEPART() to evaluate the SECOND date part of StartDate.
Complete the second CASE statement in the GROUP BY the same way.
*/

SELECT
	-- Count the number of IDs
	COUNT(*) AS Count,
    -- Use DATEPART() to evaluate the SECOND part of StartDate
    "StartDate" = CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
					   WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END
FROM CapitalBikeShare
GROUP BY
    -- Use DATEPART() to Group By the CASE statement
	CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
		 WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END

SELECT * FROM CapitalBikeShare;


/* Which day of week is busiest?
There are seconds consistently in our 
dataset we can calculate the Total Trip Time for each day of the week.
----

Use DATENAME() to SELECT the weekday value for the StartDate.
Use SUM() and DATEDIFF() to calculate TotalTripHours. (beginning with seconds).
Group by the DATENAME() result and summarize TotalTripHours.
Order TotalTripHours in descending order.

*/

SELECT
    -- Select the day of week value for StartDate
	DATENAME(WEEKDAY, StartDate) as DayOfWeek,
    -- Calculate TotalTripHours
	SUM(DATEDIFF(SECOND, StartDate, EndDate))/ 3600 as TotalTripHours 
FROM CapitalBikeShare 
-- Group by the day of week
GROUP BY DATENAME(WEEKDAY, StartDate)
-- Order TotalTripHours in descending order
ORDER BY TotalTripHours DESC


/*Find the outliers
The previous exercise showed us that Saturday was the busiest day of the month for BikeShare rides. 
Could there have been an individual saturday with outliers?
---

Use SUM() and DATEDIFF() to find the Total Ride Hours per day starting from seconds.
Use CONVERT() to SELECT the date portion of StartDate.
Use DATENAME() and CONVERT() to select the WEEKDAY.
Use WHERE to only include Saturdays.

*/

SELECT
	-- Calculate TotalRideHours using SUM() and DATEDIFF()
  	SUM(DATEDIFF(SECOND, StartDate, EndDate))/ 3600 AS TotalRideHours,
    -- Select the DATE portion of StartDate
  	CONVERT(DATE, StartDate) AS DateOnly,
    -- Select the WEEKDAY
  	DATENAME(WEEKDAY, CONVERT(DATE, StartDate)) AS DayOfWeek 
FROM CapitalBikeShare
-- Only include Saturday
WHERE DATENAME(WEEKDAY, StartDate) = 'Saturday' 
GROUP BY CONVERT(DATE, StartDate);



-------------------------------
-- VARIABLES FOR DATETIME DATA
-------------------------------

/* DECLARE & CAST

Create a time variable named @ShiftStartTime and set initial value to '08:00 AM'.
Create a date variable named @StartDate and set it to the first StartDate from the BikeShare table.
Create a datetime variable named `@ShiftStartDateTime.
Change @StartDate and @ShiftStartTime to datetime data types and assign to @ShiftStartDateTime.

*/

-- Create @ShiftStartTime
DECLARE @ShiftStartTime AS time = '08:00 AM'

-- Create @StartDate
DECLARE @StartDate AS date

-- Set StartDate to the first StartDate from CapitalBikeShare
SET 
	@StartDate = (
    	SELECT TOP 1 StartDate 
    	FROM CapitalBikeShare 
    	ORDER BY StartDate ASC
		)

-- Create ShiftStartDateTime
DECLARE @ShiftStartDateTime AS datetime

-- Cast StartDate and ShiftStartTime to datetime data types
SET @ShiftStartDateTime = CAST(@StartDate AS datetime) + CAST(@ShiftStartTime AS datetime) 

SELECT @ShiftStartDateTime


/* DECLARE a TABLE

Use DECLARE to create a TABLE variable named @Shifts
The @Shifts table variable should have the following columns - StartDateTime and EndDateTime - both of datetime data type.
Populate the table variable with the values '3/1/2018 8:00 AM' and '3/1/2018 4:00 PM'.


*/

-- Declare @Shifts as a TABLE
DECLARE @Shifts TABLE (
    -- Create StartDateTime column
	StartDateTime DATETIME,
    -- Create EndDateTime column
	EndDateTime DATETIME)
-- Populate @Shifts
INSERT INTO @Shifts (StartDateTime, EndDateTime)
	SELECT '3/1/2018 8:00 AM', '3/1/2018 4:00 PM'
SELECT * 
FROM @Shifts;


/*
Declare a TABLE variable named @RideDates with the following columns RideStart and RideEnd.
Both table variable columns should be date data type.
SELECT the unique values of StartDate and EndDate from the CapitalBikeShare table. CAST them from datetime to date data types.
Store the query results in @RideDates.
*/

-- Declare @RideDates
DECLARE @RideDates TABLE(
    -- Define RideStart column
	RideStart DATE, 
    -- Define RideEnd column
    RideEnd DATE)
-- Populate @RideDates
INSERT INTO @RideDates(RideStart, RideEnd)
-- Select the unique date values of StartDate and EndDate
SELECT DISTINCT
    -- Cast StartDate as date
	CAST(StartDate as date),
    -- Cast EndDate as date
	CAST(EndDate as date) 
FROM CapitalBikeShare 
SELECT * 
FROM @RideDates


-----------------------
--DATE MANIPULATION
------------------------
/*
GETDAT()
DATEADD

YESTERDA'S TAXI PASSENGER COUNT

SELECT SUM(PassengerCOunt)
FROM YellowTripData
WHERE CAST(PickUpDate AS DATE) = DATEADD(d, -1, GETDATE())


-- FIRST DAY OF CURRENT WEEK
SELECT DATEADD(week, DATEDIFF(week, 0, GETDATE()), 0)
-- For the above nested function, start from the innermost query

*/


/* First day of month
Find the current date value.
Calculate the difference in months between today and 0 (1/1/1900 in SQL).
Add 0 months to that difference to get the first day of the month.
*/

-- Find the first day of the current month
SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)


------------------------
--USER DEFINED FUNCTION (UDFs)
-----------------------
/*
WHAT
ROutines that
1. can accept input parameters
2. perform an action 
3. Return result ( Single scalar value or table)

WHY
1. Can reduce execution time 
2. Can reduce network traffic
3. Allows for modular programming
*/



-- Scalar function with no input parameters
CREATE FUNCTION GetTomorrow()
	RETURNS date AS BEGIN
RETURN (SELECT DATEADD(day, 1, GETDATE()))
END

-- Scaar Function with One Parameter
CREATE FUNCTION GetRidersOneDay (@DateParm date)
	RETURNS numeric AS BEGIN
RETURN (
  SELECT 
    SUM(
	  DATEDIFF(second, PickupDate, DropoffDate)
	  ) / 3600
	FROM YellowTripData
	WHERE 
	  CONVERT ( date. PickUpDate) = @DateParm
) END;

/* What was yesterday?
Create a function that returns yesterday's date.
-------

Create a function named GetYesterday() with no input parameters that RETURNS a date data type.
Use GETDATE() and DATEADD() to calculate yesterday's date value.
*/

-- Create GetYesterday()
CREATE FUNCTION GetYesterday()
-- Specify return data type
RETURNS date
AS
BEGIN
-- Calculate yesterday's date value
RETURN(SELECT DATEADD(day, -1, GETDATE()))
END 


/* ONE IN ONE OUT
Define input parameter of type date - @DateParm and a return data type of numeric.
Use BEGIN/END keywords.
In your SELECT statement, SUM the difference between the StartDate and EndDate of the transactions that have the same StartDate value as the parameter passed.
Use CAST to compare the date portion of StartDate to the @DateParm.
*/

-- Create SumRideHrsSingleDay
CREATE FUNCTION SumRideHrsSingleDay (@DateParm date)
-- Specify return data type
RETURNS NUMERIC
AS
-- Begin
BEGIN
RETURN
-- Add the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
 -- Only include transactions where StartDate = @DateParm
WHERE CAST(StartDate AS date) = @DateParm)
-- End
END


/* Multiple inputs one output
Create a function named SumRideHrsDateRange with @StartDateParm and @EndDateParm as the input parameters of datetime data type.
Specify the return data type to be numeric.
Use a select statement to sum the difference between the StartDate and EndDate of the transactions.
Only include transactions that have a StartDate greater than @StartDateParm and less than @EndDateParm.
*/
-- Create the function
CREATE FUNCTION SumRideHrsDateRange (@StartDateParm DATETIME, @EndDateParm DATETIME)
-- Specify return data type
RETURNS NUMERIC
AS
BEGIN
RETURN
-- Sum the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
-- Include only the relevant transactions
WHERE StartDate > @StartDateParm and StartDate < @EndDateParm)
END


--------------------------
-- TABLE VALUE FUNCTION
--------------------------

/* INLINE TVF -
Create an inline table value function that returns the number of rides and total ride duration 
for each StartStation where the StartDate of the ride is equal to the input parameter.
----------
Create a function named SumStationStats that has one input parameter of type datetime - @StartDate - and returns a TABLE data type.
Calculate the total RideCount using COUNT() and ID.
Calculate the TotalDuration using SUM() and DURATION.
Group by StartStation.
*/

-- Create the function
CREATE FUNCTION SumStationStats(@StartDate AS DATETIME)
-- Specify return data type
RETURNS TABLE
AS
RETURN
SELECT
	StartStation,
    -- Use COUNT() to select RideCount
	COUNT(*) AS RideCount,
    -- Use SUM() to calculate TotalDuration
    SUM(Duration) AS TotalDuration
FROM CapitalBikeShare
WHERE CAST(StartDate as Date) = @StartDate
-- Group by StartStation
GROUP BY StartStation;


/* Multi statement TVF
Create a multi statement table value function that returns the trip count and 
average ride duration for each day for the month & year parameter values passed.
-------
Create a function CountTripAvgDuration() that returns a table variable named @DailyTripStats.
Declare input parameters @Month and @Year.
Insert the query results into the @DailyTripStats table variable.
Use CAST to select and group by StartDate as a date data type.
*/

-- Create the function
CREATE FUNCTION CountTripAvgDuration (@Month CHAR(2), @Year CHAR(4))
-- Specify return variable
RETURNS @DailyTripStats TABLE(
	TripDate	date,
	TripCount	int,
	AvgDuration	numeric)
AS
BEGIN
-- Insert query results into @DailyTripStats
INSERT INTO @DailyTripStats
SELECT
    -- Cast StartDate as a date
	CAST(StartDate AS DATE),
    COUNT(*),
    AVG(Duration)
FROM CapitalBikeShare
WHERE
	DATEPART(month, StartDate) = @Month AND
    DATEPART(year, StartDate) = @Year
-- Group by StartDate as a date
GROUP BY CAST(StartDate AS DATE)
-- Return
RETURN
END

SELECT dbo.GetYesterday();

/*
Execute that function for the '3/1/2018' through '3/10/2018' date range by passing local date variables.
----
Create @BeginDate and @EndDate variables of type date with values '3/1/2018' and '3/10/2018'.
Execute the SumRideHrsDateRange() function by passing @BeginDate and @EndDate variables.
Include @BeginDate and @EndDate variables in your SELECT statement with the function result.
*/

-- Create @BeginDate
DECLARE @BeginDate AS date = '3/1/2018'
-- Create @EndDate
DECLARE @EndDate AS date = '3/10/2018' 
SELECT
  -- Select @BeginDate
  @BeginDate AS BeginDate,
  -- Select @EndDate
  @EndDate AS EndDate,
  -- Execute SumRideHrsDateRange()
  dbo.SumRideHrsDateRange(@BeginDate, @EndDate) AS TotalRideHrs


  /*
  Execute that function using the EXEC keyword and store the result in a local variable.

  Create a local numeric variable named @RideHrs.
Use EXEC to execute the SumRideHrsSingleDay function and pass '3/5/2018' as the input parameter.
Store the result of the function in @RideHrs variable.

  */

  -- Create @RideHrs
DECLARE @RideHrs AS NUMERIC
-- Execute SumRideHrsSingleDay function and store the result in @RideHrs
EXEC @RideHrs = dbo.SumRideHrsSingleDay @DateParm = '3/5/2018' 
SELECT 
  'Total Ride Hours for 3/5/2018:', 
  @RideHrs


  /*
  Create a table variable named @StationStats with columns StartStation, RideCount, and TotalDuration.
Execute the SumStationStats function and pass '3/15/2018' as the input parameter.
Use INSERT INTO to populate the @StationStats table variable with the results of the function.
Select all the records from the table variable.
  */
  -- Create @StationStats
DECLARE @StationStats TABLE(
	StartStation nvarchar(100), 
	RideCount int, 
	TotalDuration numeric)
-- Populate @StationStats with the results of the function
INSERT INTO @StationStats
SELECT TOP 10 *
-- Execute SumStationStats with 3/15/2018
FROM dbo.SumStationStats ('3/15/2018') 
ORDER BY RideCount DESC
-- Select all the records from @StationStats
SELECT * 
FROM @StationStats

  ------------

/*  CREATE OR ALTER
Change the SumStationStats function to enable SCHEMABINDING. Also change the parameter 
name to @EndDate and compare to EndDate of CapitalBikeShare table.
-----
Use CREATE OR ALTER keywords to update the SumStationStats function.
Change the parameter name to @EndDate and data type to date.
Compare the @EndDate to EndDate of the CapitalBikeShare table.
Enable SCHEMABINDING.
*/

-- Update SumStationStats
CREATE OR ALTER FUNCTION dbo.SumStationStats(@EndDate AS DATE)
-- Enable SCHEMABINDING
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN
SELECT
	StartStation,
    COUNT(ID) AS RideCount,
    SUM(DURATION) AS TotalDuration
FROM dbo.CapitalBikeShare
-- Cast EndDate as date and compare to @EndDate
WHERE CAST(EndDate AS Date) = @EndDate
GROUP BY StartStation;



										----------------------
										  --STORED PROCEDURE
										----------------------
/*
WHY
1. Can reduce execution time
2. Can reduce network teaffic
3. Allow for modular Programming
4. Improve Security

*/

/*
CREATE PROCEDURE with OUTPUT
Create a Stored Procedure named cuspSumRideHrsSingleDay in the dbo schema that accepts 
a date and returns the total ride hours for the date passed.

------
Create a stored procedure called cuspSumRideHrsSingleDay in the dbo schema.
Declare @DateParm as the input parameter and @RideHrsOut as the output parameter.
Don't send the row count to the caller.
Assign the query result to @RideHrsOut and include the RETURN keyword.
*/

-- Create the stored procedure
CREATE PROCEDURE dbo.cuspSumRideHrsSingleDay
    -- Declare the input parameter
	@DateParm date,
    -- Declare the output parameter
	@RideHrsOut numeric OUTPUT
AS
-- Don't send the row count 
SET NOCOUNT ON
BEGIN
-- Assign the query result to @RideHrsOut
SELECT
	@RideHrsOut = SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
-- Cast StartDate as date and compare with @DateParm
WHERE CAST(StartDate AS date) = @DateParm
RETURN
END


/*Use SP to INSERT
Create a stored procedure named cusp_RideSummaryCreate in the dbo schema 
that will insert a record into the RideSummary table.

----
Define two input parameters named @DateParm and @RideHrsParm.
Insert @DateParm and @RideHrsParm into the Date and RideHours columns of the RideSummary table.
Select the record that was just inserted where the Date is equal to @DateParm.
*/
-- Create the stored procedure
CREATE PROCEDURE dbo.cusp_RideSummaryCreate 
    (@DateParm date, @RideHrsParm numeric)
AS
BEGIN
SET NOCOUNT ON
-- Insert into the Date and RideHours columns
INSERT INTO dbo.RideSummary(Date, RideHours)
-- Use values of @DateParm and @RideHrsParm
VALUES(@DateParm, @RideHrsParm) 

-- Select the record that was just inserted
SELECT
    -- Select Date column
	Date,
    -- Select RideHours column
    RideHours
FROM dbo.RideSummary
-- Check whether Date equals @DateParm
WHERE Date = @DateParm
END;


/* Use SP to UPDATE
Create a stored procedure named cuspRideSummaryUpdate in the dbo schema that 
will update an existing record in the RideSummary table.
-----
The SP should accept input parameters for each RideSummary column and be named @Date and @RideHrs.
Make @Date parameter a date data type and @RideHrs a numeric data type.
Use UPDATE and SET keywords to assign the parameter values to the RideSummary 
record where the @Date matches the Date value.

*/

-- Create the stored procedure
CREATE PROCEDURE dbo.cuspRideSummaryUpdate
	-- Specify @Date input parameter
	(@Date date,
     -- Specify @RideHrs input parameter
     @RideHrs numeric(18,0))
AS
BEGIN
SET NOCOUNT ON
-- Update RideSummary
UPDATE RideSummary
-- Set
SET
	Date = @Date,
    RideHours = @RideHrs
-- Include records where Date equals @Date
WHERE Date = @Date
END;

/*
Use SP to DELETE
Create a stored procedure named cuspRideSummaryDelete in the dbo schema that 
will delete an existing record 
in the RideSummary table and RETURN the number of rows affected via output parameter.
-----

Create a stored procedure called cuspRideSummaryDelete that accepts @DateParm as an input parameter and has an integer output parameter named @RowCountOut.
Delete the record(s) in the RideSummary table that have the same Date value as @DateParm.
Set @RowCountOut to @@ROWCOUNT to return the number of rows affected by the statement.

*/

-- Create the stored procedure
CREATE PROCEDURE dbo.cuspRideSummaryDelete
	-- Specify @DateParm input parameter
	(@DateParm date,
     -- Specify @RowCountOut output parameter
     @RowCountOut int OUTPUT)
AS
BEGIN
-- Delete record(s) where Date equals @DateParm
DELETE FROM dbo.RideSummary
WHERE Date = @DateParm
-- Set @RowCountOut to @@ROWCOUNT
SET @RowCountOut = @@ROWCOUNT
END;


/*

EXEC

EXECUTE with OUTPUT parameter
Execute the dbo.cuspSumRideHrsSingleDay stored procedure and capture the output parameter.
--------

Declare @RideHrs as a numeric output parameter.
Execute dbo.cuspSumRideHrsSingleDay and pass '3/1/2018' as the @DateParm input parameter.
Store the output parameter value in @RideHrs.
Select @RideHrs to show the output parameter value of the SP.
*/

-- Create @RideHrs
DECLARE @RideHrs AS numeric(18,0)
-- Execute the stored procedure
EXEC dbo.cuspSumRideHrsSingleDay
    -- Pass the input parameter
	@DateParm = '3/1/2018',
    -- Store the output in @RideHrs
	@RideHrsOut = @RideHrs OUTPUT
-- Select @RideHrs
SELECT @RideHrs AS RideHours

/*
EXECUTE with return value
Execute dbo.cuspRideSummaryUpdate to change the RideHours to 300 for '3/1/2018'. 
Store the return code from the stored procedure.
-------
Declare @ReturnStatus as an integer and assign its value to the result of dbo.cuspRideSummaryUpdate.
Execute the stored procedure, setting @DateParm to '3/1/2018' and @RideHrs to 300.
Select the @ReturnStatus to see its value as well as the '3/1/2018' record from RideSummary to see the impact of the SP update.
*/

-- Create @ReturnStatus
DECLARE @ReturnStatus AS int
-- Execute the SP
EXEC @ReturnStatus = dbo.cuspRideSummaryUpdate
    -- Specify @DateParm
	@DateParm = '3/1/2018',
    -- Specify @RideHrs
	@RideHrs = 300

-- Select the columns of interest
SELECT
	@ReturnStatus AS ReturnStatus,
    Date,
    RideHours
FROM dbo.RideSummary 
WHERE Date = '3/1/2018';

/*
EXECUTE with OUTPUT & return value
Store and display both the output parameter and return code when executing dbo.cuspRideSummaryDelete SP.
-------

Create integer variables named @ReturnStatus and @RowCount.
Pass '3/1/2018' as the @DateParm value and execute dbo.cuspRideSummaryDelete SP.
Select @ReturnStatus and @RowCount to understand the impact of the SP.
*/

-- Create @ReturnStatus
DECLARE @ReturnStatus AS INT
-- Create @RowCount
DECLARE @RowCount AS INT

-- Execute the SP, storing the result in @ReturnStatus
EXEC @ReturnStatus = dbo.cuspRideSummaryDelete 
    -- Specify @DateParm
	@DateParm = '3/1/2018',
    -- Specify RowCountOut
	@RowCountOut = @RowCount OUTPUT

-- Select the columns of interest
SELECT
	@ReturnStatus AS ReturnStatus,
    @RowCount AS 'RowCount';


/*
Your very own TRY..CATCH
Alter dbo.cuspRideSummaryDelete to include an intentional error so we can see how the TRY CATCH block works.
------
Incorrectly assign @DateParm a nvarchar(30) data type instead of a date.
Include @Error as an optional OUTPUT parameter.
Include the DELETE statement within the BEGIN TRY...END TRY block.
Concatenate the ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_MESSAGE(), ERROR_LINE() within the 
BEGIN CATCH...END CATCH block and SET to @Error
*/

-- Alter the stored procedure
CREATE OR ALTER PROCEDURE dbo.cuspRideSummaryDelete
	-- Specify @DateParm
	@DateParm nvarchar(30),
    -- Specify @Error
	@Error nvarchar(max) = NULL OUTPUT
AS
SET NOCOUNT ON
BEGIN
  -- Start of the TRY block
  BEGIN TRY
  	  -- Delete
      DELETE FROM RideSummary
      WHERE Date = @DateParm
  -- End of the TRY block
  END TRY
  -- Start of the CATCH block
  BEGIN CATCH
		SET @Error = 
		'Error_Number: '+ CAST(ERROR_NUMBER() AS VARCHAR) +
		'Error_Severity: '+ CAST(ERROR_SEVERITY() AS VARCHAR) +
		'Error_State: ' + CAST(ERROR_STATE() AS VARCHAR) + 
		'Error_Message: ' + ERROR_MESSAGE() + 
		'Error_Line: ' + CAST(ERROR_LINE() AS VARCHAR)
  -- End of the CATCH block
  END CATCH
END;


/*
CATCH an error
Execute dbo.cuspRideSummaryDelete and pass an invalid @DateParm value of '1/32/2018' to see how 
the error is handled. The invalid date will be accepted by the nvarchar data type of @DateParm, 
but the error will occur when SQL attempts to convert it to a valid date when executing the stored procedure.
------

DECLARE variable @ReturnCode as an integer and @ErrorOut as a nvarchar(max).
Execute dbo.cuspRideSummaryDelete and pass '1/32/2018' as the @DateParm value.
Assign @ErrorOut to the @Error parameter.
Select both @ReturnCode and @ErrorOut to see their values.
*/

-- Create @ReturnCode
DECLARE @ReturnCode int
-- Create @ErrorOut
DECLARE @ErrorOut nvarchar(max)
-- Execute the SP, storing the result in @ReturnCode
EXECUTE @ReturnCode = dbo.cuspRideSummaryDelete
    -- Specify @DateParm
	@DateParm = '1/32/2018',
    -- Assign @ErrorOut to @Error
	@Error = @ErrorOut OUTPUT
-- Select @ReturnCode and @ErrorOut
SELECT
	@ReturnCode AS ReturnCode,
    @ErrorOut AS ErrorMessage;

--------------------------------------------------------------


