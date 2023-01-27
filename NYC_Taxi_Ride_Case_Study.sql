USE BikeShare;
GO
/*
NYC Taxi Ride Case Study

Apply your new skills in temporal EDA, user-defined functions, and stored procedures 
to solve a business case problem. Analyze the New York City taxi ride dataset to identify 
average fare per distance, ride count, and total ride time for each borough on each day of 
the week. And which pickup locations within the borough should be scheduled for each driver shift?

----------
Use EDA to find impossible scenarios
Calculate how many YellowTripData records have each type of error discovered during EDA.

Use CASE and COUNT to understand how many records contain the following errors:
DropOffDate before PickupDate, DropOffDate before today, PickupDate before today, TripDistance is zero.
*/

SELECT
	-- PickupDate is after today
	COUNT (CASE WHEN PickupDate > GetDate() THEN 1 END) AS 'FuturePickup',
    -- DropOffDate is after today
	COUNT (CASE WHEN DropOffDate > GetDate() THEN 1 END) AS 'FutureDropOff',
    -- PickupDate is after DropOffDate
	COUNT (CASE WHEN PickupDate > DropOffDate THEN 1 END) AS 'PickupBeforeDropoff',
    -- TripDistance is 0
	COUNT (CASE WHEN TripDistance = 0 THEN 1 END) AS 'ZeroTripDistance'  
FROM YellowTripData;


/*
Mean imputation
Create a stored procedure that will apply mean imputation to the YellowTripData records 
with an incorrect TripDistance of zero. The average trip distance variable should have 
a precision of 18 and 4 decimal places.
-------

Create a stored procedure named cuspImputeTripDistanceMean
Create a numeric variable: @AvgTripDistance.
Compute the average TripDistance for all records where TripDistance is greater than 0.
Update the records in YellowTripData where TripDistance is 0 and set to @AvgTripDistance.

*/

-- Create the stored procedure
CREATE PROCEDURE dbo.cuspImputeTripDistanceMean
AS
BEGIN
-- Specify @AvgTripDistance variable
DECLARE @AvgTripDistance AS numeric (18,4)

-- Calculate the average trip distance
SELECT @AvgTripDistance = AVG(TripDistance) 
FROM YellowTripData
-- Only include trip distances greater than 0
WHERE TripDistance > 0

-- Update the records where trip distance is 0
UPDATE YellowTripData
SET TripDistance =  @AvgTripDistance
WHERE TripDistance = 0
END;


/*Hot Deck imputation
Create a function named dbo.GetTripDistanceHotDeck that returns a TripDistance value 
via Hot Deck methodology. TripDistance should have a precision of 18 and 4 decimal places.
--------

Create a function named dbo.GetTripDistanceHotDeck() that returns a numeric data type.
Select the first TripDistance value from YellowTripData sample of 1000 records.
The sample of 1000 records should only include those where TripDistance is more than zero.
*/

-- Create the function
CREATE FUNCTION dbo.GetTripDistanceHotDeck()
-- Specify return data type
RETURNS numeric(18,4)
AS 
BEGIN
RETURN
	-- Select the first TripDistance value
	(SELECT TOP 1 TripDistance
	FROM YellowTripData
    -- Sample 1000 records
	TABLESAMPLE(1000 rows)
    -- Only include records where TripDistance is > 0
	WHERE TripDistance > 0)
END;


/*

CREATE FUNCTIONs
Create three functions to help solve the business case:

Convert distance from miles to kilometers.
Convert currency based on exchange rate parameter.
(These two functions should return a numeric value with precision of 18 and 2 decimal places.)
Identify the driver shift based on the hour parameter value passed.

*/
-- Create the function
CREATE FUNCTION dbo.ConvertMileToKm (@Miles numeric(18,2))
-- Specify return data type
RETURNS numeric(18,2)
AS
BEGIN
RETURN
	-- Convert Miles to Kilometers
	(SELECT @Miles * 1.609)
END;

/*
Create a function which accepts @DollarAmt and @ExchangeRate input parameters, 
multiplies them, and returns the result.
*/

-- Create the function
CREATE FUNCTION dbo.ConvertDollar
	-- Specify @DollarAmt parameter
	(@DollarAmt numeric(18,2),
     -- Specify ExchangeRate parameter
     @ExchangeRate numeric(18,2))
-- Specify return data type
RETURNS numeric(18,2)
AS
BEGIN
RETURN
	-- Multiply @ExchangeRate and @DollarAmt
	(SELECT @ExchangeRate * @DollarAmt)
END;

/*
Create a function that returns the shift as an integer: 
1st shift is 12am to 9am, 2nd is 9am to 5pm, 3rd is 5pm to 12am.

*/
-- Create the function
CREATE FUNCTION dbo.GetShiftNumber (@Hour integer)
-- Specify return data type
RETURNS int
AS
BEGIN
RETURN
	-- 12am (0) to 9am (9) shift
	(CASE WHEN @Hour >= 0 AND @Hour < 9 THEN 1
     	  -- 9am (9) to 5pm (17) shift
		  WHEN @Hour >= 9 AND @Hour < 17 THEN 2
          -- 5pm (17) to 12am (24) shift
	      WHEN @Hour >= 17 AND @Hour < 24 THEN 3 END)
END;


/*
Test FUNCTIONs
Now it's time to test the three functions you wrote in the previous exercise.
----------
Display the first 100 records of PickupDate, TripDistance and FareAmount from YellowTripData.
Determine the shift value of PickupDate by passing the hour value to dbo.GetShiftNumber function; display the shift and include it in the WHERE clause for shifts = 2 only.
Convert TripDistance to kilometers with dbo.ConvertMiletoKm function.
Convert FareAmount to Euro (with exchange rate of 0.87) with the dbo.ConvertDollar function.
*/
SELECT
	-- Select the first 100 records of PickupDate
	TOP 100 PickupDate,
    -- Determine the shift value of PickupDate
	dbo.GetShiftNumber(DATEPART(hour, PickupDate)) AS 'Shift',
    -- Select FareAmount
	FareAmount,
    -- Convert FareAmount to Euro
	dbo.ConvertDollar(FareAmount, 0.87) AS 'FareinEuro',
    -- Select TripDistance
	TripDistance,
    -- Convert TripDistance to kilometers
	dbo.ConvertMileToKm(TripDistance) AS 'TripDistanceinKM'
FROM YellowTripData
-- Only include records for the 2nd shift
WHERE dbo.GetShiftNumber(DATEPART(hour, PickupDate)) = 2;


/* Logical weekdays with Hot Deck
Calculate Total Fare Amount per Total Distance for each day of week. If the TripDistance 
is zero use the Hot Deck imputation function you created earlier in the chapter.
------

Use DATENAME() and PickupDate to select the day of week.
Use AVG() to calculate TotalAmount per TripDistance, and a CASE statement to select TripDistance if it's more than 0. If not, use dbo.GetTripDistanceHotDeck().
Order by the PickupDate day of week, with 'Monday' appearing first.
*/

SELECT
    -- Select the pickup day of week
	DATENAME(weekday, PickupDate) as DayofWeek,
    -- Calculate TotalAmount per TripDistance
	CAST(AVG(TotalAmount/
            -- Select TripDistance if it's more than 0
			CASE WHEN TripDistance > 0 THEN TripDistance
                 -- Use GetTripDistanceHotDeck()
     			 ELSE dbo.GetTripDistanceHotDeck() END) as decimal(10,2)) as 'AvgFare'
FROM YellowTripData
GROUP BY DATENAME(weekday, PickupDate)
-- Order by the PickupDate day of week
ORDER BY
     CASE WHEN DATENAME(weekday, PickupDate) = 'Monday' THEN 1
          WHEN DATENAME(weekday, PickupDate) = 'Tuesday' THEN 2
          WHEN DATENAME(weekday, PickupDate) = 'Wednesday' THEN 3
          WHEN DATENAME(weekday, PickupDate) = 'Thursday' THEN 4
          WHEN DATENAME(weekday, PickupDate) = 'Friday' THEN 5
          WHEN DATENAME(weekday, PickupDate) = 'Saturday' THEN 6
          WHEN DATENAME(weekday, PickupDate) = 'Sunday' THEN 7
END ASC;

/*Format for Germany
Write a query to display the TotalDistance, TotalRideTime and TotalFare for each 
day and NYC Borough. Display the date, distance, ride time, and fare totals 
for German culture.
-----

Cast PickupDate as a date and display it as a German date.
Display TotalDistance and TotalRideTime in the German format ('n' format type parameter).
Display Total Fare as German currency ('c' format type parameter).
*/
SELECT
    -- Cast PickupDate as a date and display as a German date
	FORMAT(CAST(PickupDate AS Date), 'd', 'de-de') AS 'PickupDate',
	Zone.Borough,
    -- Display TotalDistance in the German format
	FORMAT(SUM(TripDistance), 'n', 'de-de') AS 'TotalDistance',
    -- Display TotalRideTime in the German format
	FORMAT(SUM(DATEDIFF(minute, PickupDate, DropoffDate)), 'n', 'de-de') AS 'TotalRideTime',
    -- Display TotalFare in German currency
	FORMAT(SUM(TotalAmount), 'c', 'de-de') AS 'TotalFare'
FROM YellowTripData
INNER JOIN TaxiZoneLookup AS Zone 
ON PULocationID = Zone.LocationID 
GROUP BY
	CAST(PickupDate as date),
    Zone.Borough 
ORDER BY
	CAST(PickupDate as date),
    Zone.Borough;

--------------------
/* CASE STUDY: STORED PROCEDURES*/
--------------------

/*
NYC Borough statistics SP
It's time to apply what that you have learned in this course and write a stored 
procedure to solve the first objective of the Taxi Ride business case. 
Calculate AvgFarePerKM, RideCount and TotalRideMin for each NYC borough 
and weekday. After discussion with stakeholders, you should omit records 
where the TripDistance is zero.

--------

Select and group by pickup weekday and Borough.
Calculate AvgFarePerKM with dbo.ConvertDollar() and dbo.ConvertMiletoKM() utilizing .88 exchange rate to the Euro.
Display AvgFarePerKM as German currency, RideCount and TotalRideMin as German numbers.
Omit records where TripDistance is 0.

*/

CREATE OR ALTER PROCEDURE dbo.cuspBoroughRideStats
AS
BEGIN
SELECT
    -- Calculate the pickup weekday
	DATENAME(weekday, PickupDate) AS 'Weekday',
    -- Select the Borough
	Zone.Borough AS 'PickupBorough',
    -- Display AvgFarePerKM as German currency
	FORMAT(AVG(dbo.ConvertDollar(TotalAmount, .88)/dbo.ConvertMiletoKM(TripDistance)), 'c', 'de-de') AS 'AvgFarePerKM',
    -- Display RideCount in the German format
	FORMAT(COUNT (ID), 'n', 'de-de') AS 'RideCount',
    -- Display TotalRideMin in the German format
	FORMAT(SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60, 'n', 'de-de') AS 'TotalRideMin'
FROM YellowTripData
INNER JOIN TaxiZoneLookup AS Zone 
ON PULocationID = Zone.LocationID
-- Only include records where TripDistance is greater than 0
WHERE TripDistance > 0
-- Group by pickup weekday and Borough
GROUP BY DATENAME(WEEKDAY, PickupDate), Zone.Borough
ORDER BY CASE WHEN DATENAME(WEEKDAY, PickupDate) = 'Monday' THEN 1
	     	  WHEN DATENAME(WEEKDAY, PickupDate) = 'Tuesday' THEN 2
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Wednesday' THEN 3
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Thursday' THEN 4
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Friday' THEN 5
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Saturday' THEN 6
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Sunday' THEN 7 END,  
		 SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60
DESC
END;


/*NYC Borough statistics results
Let's see the results of the dbo.cuspBoroughRideStats stored procedure 
you just created.

----
Declare @SPResults as a TABLE with the following columns of nvarchar (30) 
data types; Weekday, Borough, AvgFarePerKM, RideCount and TotalRideMin.
Execute dbo.cuspBoroughRideStats and insert the results into @SPResults.
Select all the records from @SPresults.
*/

-- Create SPResults
DECLARE @SPResults TABLE(
  	-- Create Weekday
	Weekday 		nvarchar(30),
    -- Create Borough
	Borough 		nvarchar(30),
    -- Create AvgFarePerKM
	AvgFarePerKM 	nvarchar(30),
    -- Create RideCount
	RideCount		nvarchar(30),
    -- Create TotalRideMin
	TotalRideMin	nvarchar(30))

-- Insert the results into @SPResults
INSERT INTO @SPResults
-- Execute the SP
EXEC dbo.cuspBoroughRideStats

-- Select all the records from @SPresults 
SELECT * 
FROM @SPResults;

/* Pickup locations by shift
It's time to solve the second objective of the business case. 
What are the AvgFarePerKM, RideCount and TotalRideMin for each 
pickup location and shift within a NYC Borough?
------
Create a stored procedure named cuspPickupZoneShiftStats that accepts @Borough nvarchar(30) as an input parameter and limits records with the matching Borough value.
Calculate the 'Shift' by passing the hour of the PickupDate to the dbo.GetShiftNumber() function. Use the DATEPART function to select only the hour portion of the PickupDate.
Group by PickupDate weekday, shift, and Zone.
Sort by PickupDate weekday (with Monday first), shift, and TotalRideMin.
*/

-- Create the stored procedure
CREATE PROCEDURE dbo.cuspPickupZoneShiftStats
	-- Specify @Borough parameter
	@Borough nvarchar(30)
AS
BEGIN
SELECT
	DATENAME(WEEKDAY, PickupDate) as 'Weekday',
    -- Calculate the shift number
	dbo.GetShiftNumber(DATEPART(hour, PickupDate)) as 'Shift',
	Zone.Zone as 'Zone',
	FORMAT(AVG(dbo.ConvertDollar(TotalAmount, .77)/dbo.ConvertMiletoKM(TripDistance)), 'c', 'de-de') AS 'AvgFarePerKM',
	FORMAT(COUNT (ID),'n', 'de-de') as 'RideCount',
	FORMAT(SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60, 'n', 'de-de') as 'TotalRideMin'
FROM YellowTripData
INNER JOIN TaxiZoneLookup as Zone on PULocationID = Zone.LocationID 
WHERE
	dbo.ConvertMiletoKM(TripDistance) > 0 AND
	Zone.Borough = @Borough
GROUP BY
	DATENAME(WEEKDAY, PickupDate),
    -- Group by shift
	dbo.GetShiftNumber(DATEPART(hour, PickupDate)),  
	Zone.Zone
ORDER BY CASE WHEN DATENAME(WEEKDAY, PickupDate) = 'Monday' THEN 1
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Tuesday' THEN 2
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Wednesday' THEN 3
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Thursday' THEN 4
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Friday' THEN 5
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Saturday' THEN 6
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Sunday' THEN 7 END,
         -- Order by shift
         dbo.GetShiftNumber(DATEPART(hour, PickupDate)),
         SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60 DESC
END;

/* Pickup locations by shift results
Let's see the AvgFarePerKM,RideCount and TotalRideMin for the pickup 
locations within Manhattan during the different driver shifts of each weekday.
-------

Declare @Borough as a nvarchar(30) variable and set it to 'Manhattan'.
Pass @Borough to execute the dbo.cuspPickupZoneShiftStats stored procedure.
Admire your work. :)
*/

-- Create @Borough
DECLARE @Borough as nvarchar(30) = 'Manhattan'
-- Execute the SP
EXEC dbo.cuspPickupZoneShiftStats
    -- Pass @Borough
	@Borough = @Borough;