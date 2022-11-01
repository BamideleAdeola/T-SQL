							----------------------------------
							--TRANSLATING DATE STRINGS
							----------------------------------
/*
CASTING
CONVERT - Allows a string to be converted into a date format. Not a standard format
PARSING Strings - Uses the .NET framework

 The CAST() function doesn't give us much flexibility in how we can ingest dates but it is the ANSI standard. 
 However CONVERT() FUNCTION IS SPECIFIC TO T-SQL 

*/

SELECT 
	PARSE('25 December 2014' AS DATE
			USING 'de-de') AS Weihnachten;

-- SET LANGUAGE SYNTAX: This helps to change the language to be used

SET LANGUAGE 'FRENCH'
DECLARE
	@FrenchDate NVARCHAR(30) = N'18 avril 2019',
	@FrenchNumberDate NVARCHAR(30) = N'18/4/2019';

SELECT
	CAST(@FrenchDate AS DATETIME),
	CAST(@FrenchNumberDate AS DATETIME);



/*
Cast the input string DateText in the dbo.Dates temp table to the DATE data type.
Cast the input string DateText in the dbo.Dates temp table to the DATETIME2(7) data type.
*/

SELECT
	d.DateText AS String,
	-- Cast as DATE
	CAST(d.DateText AS DATE) AS StringAsDate,
	-- Cast as DATETIME2(7)
	CAST(d.DateText AS DATETIME2) AS StringAsDateTime2
FROM dbo.Dates d;



/* CONVERT() FUNCTION 
Use the CONVERT() function to translate DateText into a date data type.
Then use the CONVERT() function to translate DateText into a DATETIME2(7) data type.
*/

SET LANGUAGE 'GERMAN'

SELECT
	d.DateText AS String,
	-- Convert to DATE
	CONVERT(DATE, d.DateText) AS StringAsDate,
	-- Convert to DATETIME2(7)
	CONVERT(DATETIME2(7), d.DateText) AS StringAsDateTime2
FROM dbo.Dates d;



/* PARSING STRINGS TO DATE
Parse DateText as dates using the German locale (de-de).
Then, parse DateText as the data type DATETIME2(7), still using the German locale.
*/ --  It turns out that the PARSE() function has some difficulty with strings in YYYYMMDD format and will not consistently parse them correctly.
SELECT
	d.DateText AS String,
	-- Parse as DATE using German
	PARSE(d.DateText AS DATE USING 'de-de') AS StringAsDate,
	-- Parse as DATETIME2(7) using German
	PARSE(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
FROM dbo.Dates d;
