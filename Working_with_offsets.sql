							----------------------------------
							    --WORKING WITH OFFSETS
							----------------------------------
/*
DATETIMEOFFSET - This caters for a datetime with the intention of workung with Time zone


--SWITCHOFFSET() FUNCTION
*/
DECLARE @somedate DATETIMEOFFSET = 
	'2019-04-10 12:59:02.3908505 -04:00';
SELECT
	SWITCHOFFSET(@somedate, '-07:00') AS LATime;

--TODATETIMEOFFSET() FUNCTION

DECLARE @somedate2 DATETIMEOFFSET = 
	'2019-04-10 12:59:02.390';
SELECT
	TODATETIMEOFFSET(@somedate2, '-04:00') AS EDT;


/*
Fill in the appropriate function call for Brasilia, Brazil.
Fill in the appropriate function call and time zone for Chicago, Illinois. In August, Chicago is 2 hours behind Brasilia Standard Time.
Fill in the appropriate function call and time zone for New Delhi, India. India does not observe Daylight Savings Time, so in August, New Delhi is 8 1/2 hours ahead of Brasilia Standard Time. Note when calculating time zones that Brasilia and New Delhi are on opposite sides of UTC.


*/

DECLARE
	@OlympicsUTC NVARCHAR(50) = N'2016-08-08 23:00:00';

SELECT
	-- Fill in the time zone for Brasilia, Brazil
	SWITCHOFFSET(@OlympicsUTC, '-03:00') AS BrasiliaTime,
	-- Fill in the time zone for Chicago, Illinois
	SWITCHOFFSET(@OlympicsUTC, '-05:00') AS ChicagoTime,
	-- Fill in the time zone for New Delhi, India
	SWITCHOFFSET(@OlympicsUTC, '+05:30') AS NewDelhiTime;



/* TODATETIMEOFFSET() FUNCTION
Fill in the time in Phoenix, Arizona, which, being Mountain Standard Time, was UTC -07:00.
Fill in the time for Tuvalu, which is 12 hours ahead of UTC.
*/

DECLARE
	@OlympicsClosingUTC DATETIME2(0) = '2016-08-21 23:00:00';

SELECT
	-- Fill in 7 hours back and a '-07:00' offset
	TODATETIMEOFFSET(DATEADD(HOUR, -7, @OlympicsClosingUTC), '-07:00') AS PhoenixTime,
	-- Fill in 12 hours forward and a '+12:00' offset.
	TODATETIMEOFFSET(DATEADD(HOUR, 12, @OlympicsClosingUTC), '+12:00') AS TuvaluTime;