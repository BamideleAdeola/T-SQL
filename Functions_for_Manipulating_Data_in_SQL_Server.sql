							----------------------------------
							--FUNCTIONS FOR MANIPULATING SQL
						----------------------------------
USE DataManipulation;
GO

/*Q1
Select information from the ratings table for the Belgian companies 
that received a rating higher than 3.5.
*/
SELECT 
	company, 
	company_location, 
	bean_origin, 
	cocoa_percent, 
	rating
FROM ratings
-- Location should be Belgium and the rating should exceed 3.5
WHERE company_location = 'Belgium'
	AND rating > 3.5;


/*Q2
Query the voters table where birthdate is greater than '1990-01-01' 
and the total_votes is between 100 and 200.
*/

SELECT 
	first_name,
	last_name,
	birthdate,
	gender,
	email,
	country,
	total_votes
FROM voters
-- Birthdate > 1990-01-01, total_votes > 100 but < 200
WHERE Birthdate > '1990-01-01'
  AND (total_votes > 100
  AND total_votes < 200);


  							----------------------------------
							  --STORING DATES IN A DATABASE
							----------------------------------
/*
--Add a new column with the correct data type, for storing 
the last date a person voted ("2018-01-17").
*/
ALTER TABLE voters
ADD last_vote_date date;  --must be lowercased from my test

/*
Add a new column called last_vote_time, to keep track 
of the most recent time when a person voted ("16:55:00").
*/

ALTER TABLE voters
ADD last_vote_time time; --must be lowercased from my test

/*
Add a new column,last_login, storing the most recent 
time a person accessed the application ("2019-02-02 13:44:00").
*/

ALTER TABLE voters
ADD last_login datetime2;


  							----------------------------------
							   --IMPLICIT CONVERSION - done automatically
							----------------------------------

/*
Implicit conversion between data types
This is what you need to remember about implicit conversion:

For comparing two values in SQL Server, they need to have the same data type.
If the data types are different, SQL Server implicitly converts one type to another, 
based on data type precedence.

The data type with the lower precedence is converted to the data type with the higher precedence.
*/

/*
Restrict the query to show only the rows where total_votes 
is higher than the character string '120'.
*/

SELECT 
	first_name,
	last_name,     
	total_votes
FROM voters
WHERE total_votes > '120';  -- '120' IS IMPLICIT SO THE DATA TYPE IS CONVERTED TO NUMERIC


-- Data type precedence

/*Select information about all the ratings that were higher than 3.*/
SELECT 
	bean_type,
	rating
FROM ratings
WHERE rating > 3;  -- The integer 3 is converted to decimal because the data type must be same



  							----------------------------------
							   --EXPLICIT CONVERSION - by an analyst
							----------------------------------
-- This can be done using CAST() which is a general function to most databases OR CONVERT() which is specific to SQL Server


--1. CAST()
/*
Write a query that will show a message like the following, 
for each voter: Carol Rai was born in 1989.
*/

SELECT 
	-- Transform the year part from the birthdate to a string
	first_name + ' ' + last_name + ' was born in ' + CAST(YEAR(birthdate) AS nvarchar) + '.' 
FROM voters;

/*
Divide the total votes by 5.5. Transform the result to an integer.
*/
SELECT 
	-- Transform to int the division of total_votes to 5.5
	CAST(total_votes/5.5 AS int) AS DividedVotes
FROM voters;

/*
Select the voters whose total number of votes starts with 5.
*/

SELECT 
	first_name,
	last_name,
	total_votes
FROM voters
-- Transform the total_votes to char of length 10
WHERE CAST(total_votes AS CHAR(10)) LIKE '5%';

--2. CONVERT()
/*
Retrieve the birth date from voters, in this format: Mon dd,yyyy.
*/
SELECT 
	email,
    -- Convert birthdate to varchar show it like: "Mon dd,yyyy" 
    CONVERT(varchar, birthdate, 107) AS birthdate
FROM voters;

/*
Select the company, bean origin and the rating from the ratings table. 
The rating should be converted to a whole number.
*/
SELECT 
	company,
    bean_origin,
    -- Convert the rating column to an integer
    CONVERT(integer, rating) AS rating
FROM ratings;


/*
Select the company, bean origin and the rating from the ratings 
table where the whole part of the rating equals 3.
*/

SELECT 
	company,
    bean_origin,
    rating
FROM ratings
-- Convert the rating to an integer before comparison
WHERE CONVERT(INTEGER, rating) = 3;


/*
Restrict the query to retrieve only the female 
voters who voted more than 20 times.
*/
SELECT 
	first_name,
	last_name,
	gender,
	country
FROM voters
WHERE country = 'Belgium'
	-- Select only the female voters
	AND (gender = 'f'
    -- Select only people who voted more than 20 times   
    AND total_votes > 20);


/*
Now that we have the data set prepared, let’s make it more user-friendly. 
Perform an explicit conversion from datetime to varchar(10), 
to show the dates as yy/mm/dd.

*/
SELECT 
	first_name,
    last_name,
	-- Convert birthdate to varchar(10) and show it as yy/mm/dd. This format corresponds to value 11 of the "style" parameter.
	CONVERT(VARCHAR(10), birthdate, 11) AS birthdate,
    gender,
    country
FROM voters
WHERE country = 'Belgium' 
    -- Select only the female voters
	AND gender = 'F'
    -- Select only people who voted more than 20 times  
    AND total_votes > 20;

/*
Let’s now create a comments column that will show the 
number of votes performed by each person, in the following form: “Voted "x" times.”
*/
SELECT
	first_name,
    last_name,
	-- Convert birthdate to varchar(10) to show it as yy/mm/dd
	CONVERT(varchar(10), birthdate, 11) AS birthdate,
    gender,
    country,
    -- Convert the total_votes number to nvarchar
    'Voted ' + CAST(total_votes AS NVARCHAR) + ' times.' AS comments
FROM voters
WHERE country = 'Belgium'
    -- Select only the female voters
	AND gender = 'F'
    -- Select only people who voted more than 20 times
    AND total_votes > 20;


--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
							--CHAPTER 2: MANIPULATING TIME
							----------------------------------
-- FUNCTIONS THAT RETURNS SYSTEM DATE AND TIME


/* HIGH PRECISION					LOWER- PRECISION
  ------------------ 		   ------------------
1. SYSDATETIME()					GETDAT()
2. SYSUTCDATETIME()					GETUTCDATE()
3. SYSUTCDATETIMEOFFSET()			CURRENT_TIMESTAMP - Without parenthesis


*/


/* CHALLENGE
Select the current date in UTC time (Universal Time Coordinate) using two different functions.
*/

SELECT 
	SYSUTCDATETIME() AS UTC_HighPrecision,
	GETUTCDATE() AS UTC_LowPrecision;


/* CHALLENGE
Select the local system's date, including the timezone information. */
SELECT 
	SYSDATETIMEOFFSET() AS Timezone;



/* CHALLENGE
Use two functions to query the system's local date, without timezone information. Show the dates in different formats.
*/
SELECT 
	CONVERT(VARCHAR(24), SYSDATETIME(), 107) AS HighPrecision,
	CONVERT(VARCHAR(24), GETDATE(), 102) AS LowPrecision;



/* CHALLENGE
Use two functions to retrieve the current time, in Universal Time Coordinate.
*/
SELECT 
	CAST(SYSUTCDATETIME() AS time) AS HighPrecision,
	CAST(GETUTCDATE() AS time) AS LowPrecision;

/*CHALLENGE
Extract the year, month and day of the first vote.

Restrict the query to show only the voters who started to vote after 2015.

Restrict the query to show only the voters did not vote on the first day of the month.
*/

SELECT 
	first_name,
	last_name,
   	-- Extract the year of the first vote
	YEAR(first_vote_date)  AS first_vote_year,
    -- Extract the month of the first vote
	MONTH(first_vote_date) AS first_vote_month,
    -- Extract the day of the first vote
	DAY(first_vote_date)   AS first_vote_day
FROM voters
-- The year of the first vote should be greater than 2015
WHERE YEAR(first_vote_date) > 2015
-- The day should not be the first day of the month
  AND DAY(first_vote_date) <> 1;


/* CHALLENGE
Select information from the voters table, including the name of the month when they first voted.
*/
SELECT 
	first_name,
	last_name,
	first_vote_date,
    -- Select the name of the month of the first vote
	DATENAME(MONTH, first_vote_date) AS first_vote_month
FROM voters;

/* CHALLENGE
Select information from the voters table, including the day of the year when they first voted.
*/
SELECT 
	first_name,
	last_name,
	first_vote_date,
    -- Select the number of the day within the year
	DATENAME(DAYOFYEAR, first_vote_date) AS first_vote_dayofyear
FROM voters;

/* CHALLENGE
Select information from the voters table, including the day of the week when they first voted.
*/
SELECT 
	first_name,
	last_name,
	first_vote_date,
    -- Select day of the week from the first vote date
	DATENAME(WEEKDAY, first_vote_date) AS first_vote_dayofweek
FROM voters;


/* CHALLENGE
Extract the month number of the first vote.
Extract the month name of the first vote.
Extract the weekday number of the first vote.
Extract the weekday name of the first vote.
*/
SELECT 
	first_name,
	last_name,
   	-- Extract the month number of the first vote
	DATEPART(MONTH,first_vote_date) AS first_vote_month1,
	-- Extract the month name of the first vote
    DATENAME(MONTH,first_vote_date) AS first_vote_month2,
	-- Extract the weekday number of the first vote
	DATEPART(WEEKDAY,first_vote_date) AS first_vote_weekday1,
    -- Extract the weekday name of the first vote
	DATENAME(WEEKDAY,first_vote_date) AS first_vote_weekday2
FROM voters;


/* CHALLENGE - DATEFROMPARTS()
Select the year of the first vote.
Select the month of the first vote date.
Create a date as the start of the month of the first vote.
*/

SELECT 
	first_name,
	last_name,
    -- Select the year of the first vote
   	YEAR(first_vote_date) AS first_vote_year, 
    -- Select the month of the first vote
	MONTH(first_vote_date) AS first_vote_month,
    -- Create a date as the start of the month of the first vote
	DATEFROMPARTS(YEAR(first_vote_date), MONTH(first_vote_date) , 1) AS first_vote_starting_month
FROM voters;

--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
						--PERFORMING ARITHMETIC OPERATIONS ON DATE
							----------------------------------
--DATEADD & DATEDIFF
DECLARE @yearend DATE = '2022-12-31 23:59:59';
-- How many days to the end of the year?
SELECT 
	DATEDIFF(DAY,GETDATE(),@yearend) AS Daysleft,
	DATEDIFF(MONTH,GETDATE(),@yearend) AS Monthleft,
	DATEDIFF(HOUR,GETDATE(),@yearend) AS Hoursleft,
	DATEDIFF(SECOND,GETDATE(),@yearend) AS Secondsleft;


-- How many days to the end of the year?
SELECT DATEDIFF(DAY,GETDATE(),'2022-12-31');

SELECT SYSDATETIME();

/*
DECLARE @date1 datetime = '2018-12-01';
DECLARE @date2 datetime = '2030-03-03';
Create a SELECT statement, in which to perform the following operations:

Subtract @date1 from @date2.
Add @date1 to @date2.
Using DATEDIFF(), calculate the difference in years between the results of the subtraction and the addition above.
What is the result returned by the DATEDIFF() function?
*/

DECLARE @date1 datetime = '2018-12-01';
DECLARE @date2 datetime = '2030-03-03';

SELECT
@date2 - @date1,
@date1 + @date2,
DATEDIFF(YEAR, @date2 - @date1, @date1 + @date2);

/*
Retrieve the date when each voter had their 18th birthday.
*/
SELECT 
	first_name,
	birthdate,
    -- Add 18 years to the birthdate
	DATEADD(YEAR, 18, birthdate) AS eighteenth_birthday
  FROM voters;

/*
Add five days to the first_vote_date, to calculate the date when the vote was processed.
*/
SELECT 
	first_name,
	first_vote_date,
    -- Add 5 days to the first voting date
	DATEADD(DAY, 5, first_vote_date) AS processing_vote_date
  FROM voters;


/*
Calculate what day it was 476 days ago.
*/

SELECT
	-- Subtract 476 days from the current date
	DATEADD(DAY, -476, GETDATE()) AS date_476days_ago;


/* CHALLENGE
Calculate the number of years since a participant celebrated 
their 18th birthday until the first time they voted.
*/
SELECT
	first_name,
	birthdate,
	first_vote_date,
    -- Select the diff between the 18th birthday and first vote
	DATEDIFF(YEAR, DATEADD(YEAR, 18, birthdate), first_vote_date) AS adult_years_until_vote
FROM voters;


/* CHALLENGE
How many weeks have passed since the beginning of 2019 until now?
*/
SELECT 
	-- Get the difference in weeks from 2019-01-01 until now
	DATEDIFF(WEEK, '2019-01-01', GETDATE()) AS weeks_passed;

--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
						--VALIDATING IF AN EXPRESSION IS A DATE
							----------------------------------
--ISDATE()
--SETDATEFORMAT - To set the order of a dateparts for interpreting strings as dates.
-- SET LANGUGAE also change the date format.


/* CHALLENGE
Set the correct date format so that the variable @date1 is interpreted as a valid date.
*/

DECLARE @date1 NVARCHAR(20) = '15/2019/4';

-- Set the date format and check if the variable is a date
SET DATEFORMAT dym;
SELECT ISDATE(@date1) AS result;

/* CHALLENGE
Set the correct date format so that the variable @date1 is interpreted as a valid date.
*/
DECLARE @date1 NVARCHAR(20) = '10.13.2019';

-- Set the date format and check if the variable is a date
SET DATEFORMAT mdy;
SELECT ISDATE(@date1) AS result;

/*
Change the language, so that '30.03.2019' is considered a valid date. Select the name of the month.
*/

DECLARE @date1 NVARCHAR(20) = '30.03.2019';

-- Set the correct language
SET LANGUAGE DUTCH;
SELECT
	@date1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date1) AS is_valid,
    -- Select the name of the month
	DATENAME(MONTH, @date1) AS month_name;


DECLARE @date1 NVARCHAR(20) = '32/12/13';

-- Set the correct language
SET LANGUAGE CROATIAN;
SELECT
	@date1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date1) AS is_valid,
    -- Select the name of the month
	DATENAME(MONTH, @date1) AS month_name,
	-- Extract the year from the date
	YEAR(@date1) AS year_name;

-- challenge
DECLARE @date1 NVARCHAR(20) = '12/18/55';

-- Set the correct language
SET LANGUAGE ENGLISH;
SELECT
	@date1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date1) AS is_valid,
    -- Select the week day name
	DATENAME(WEEKDAY, @date1) AS week_day,
	-- Extract the year from the date
	YEAR(@date1) AS year_name;


/*
Calculate the current age of each partitipants
*/

SELECT
	first_name,
    last_name,
    birthdate,
	first_vote_date,
	-- Find out on which day of the week each participant voted 
	DATENAME(weekday, first_vote_date) AS first_vote_weekday,
	-- Find out the year of the first vote
	YEAR(first_vote_date) AS first_vote_year,
	-- Discover the participants' age when they joined the contest
	DATEDIFF(YEAR, birthdate, first_vote_date) AS age_at_first_vote,	
	-- Calculate the current age of each voter
	DATEDIFF(YEAR, birthdate, GETDATE()) AS current_age
FROM voters;


--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
								--WORKING WITH STRINGS
							----------------------------------
								-- FUNCTIONS FOR POSTITIONS
/*
These are 
LEN()			- Returns the no of characters of the provided string excluding the blank
CHARINDEX()		- Looks for a character expression in a given string and returns its starting point. (Just like MID function of excel) 
PATINDEX()		- Similar to CHARINDEX but more powerful. Returns the starting position of a pattern in an expression.
				  One can use widecard character in the expression of a PATINDEX
				  Which are
% = Matchany string of any length ( Including zero lengths)
- = match on a single character
[] = match on any character in the [] brackets ( for example, [abc] would match on a,b,or ccharacters.

SELECT 
  CHARINDEX('chocolate', 'White chocolate is not real chocolate'),
  CHARINDEX('chocolate', 'White chocolate is not real chocolate', 10),
  CHARINDEX('chocolates', 'White chocolate is not real chocolate')
*/
SELECT -- CHARINDEX
  CHARINDEX('chocolate', 'White chocolate is not real chocolate'),
  CHARINDEX('chocolate', 'White chocolate is not real chocolate', 10),
  CHARINDEX('chocolates', 'White chocolate is not real chocolate');


-- PATINDEX()
SELECT
  PATINDEX('%chocolate%', 'White chocolate is not real chocolate') AS sample1,
  PATINDEX('%ch_c%', 'White chocolate is not real chocolate') AS sample2;

/*
Calculate the length of each broad_bean_origin.
Order the results from the longest to shortest.
*/
SELECT TOP 10 
	company, 
	broad_bean_origin,
	-- Calculate the length of the broad_bean_origin column
	LEN(broad_bean_origin) AS length
FROM ratings
--Order the results based on the new column, descending
ORDER BY length DESC;

/*CHARINDEX -
Looking for a string within a string
If you need to check whether an expression exists within a string, you can use the CHARINDEX() function. This function returns the position of the expression you are searching within the string.
The syntax is: CHARINDEX(expression_to_find, expression_to_search [, start_location])*/

/*Restrict the query to select only the voters whose first name contains the expression "dan".*/
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0;

/*
Restrict the query to select the voters with "dan" in the first_name and "z" in the last_name.
*/
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0 
    -- Look for last_names that contain the letter "z"
	AND CHARINDEX('z', last_name) > 0;


/*
Restrict the query to select the voters with "dan" in the first_name 
and DO NOT have the letter "z" in the last_name.
*/
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0 
    -- Look for last_names that do not contain the letter "z"
	AND CHARINDEX('z', last_name) = 0;

/*

Looking for a pattern within a string
If you want to search for a pattern in a string, PATINDEX() is the function you are looking for. This function returns the starting position of the first occurrence of the pattern within the string.

The syntax is: PATINDEX('%pattern%', expression)
*/

-- Write a query to select the voters whose first name contains the letters "rr".

SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that contain "rr" in the middle
WHERE PATINDEX('%rr%', first_name) > 1;

-- Write a query to select the voters whose first name starts with "C" and has "r" as the third letter.
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that start with C and the 3rd letter is r
WHERE PATINDEX('C_r%', first_name) > 0;

/*Select the voters whose first name contains an "a" followed 
by other letters, then a "w", followed by other letters.*/
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that have an "a" followed by 0 or more letters and then have a "w"
WHERE PATINDEX('%a%w%', first_name) > 0;


/*Write a query to select the voters whose first name contains 
one of these letters: "x", "w" or "q". 
*/
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that contain one of the letters: "x", "w", "q"
WHERE PATINDEX('%[xwq]%', first_name) > 0;


--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
								--WORKING WITH STRINGS
							----------------------------------
							-- FUNCTIONS FOR STRINGS TRANSFORMATION

/*
1. lower()
2. Upper()
3. Left()
4. Right()
5. LRIM()
6. RTRIM()
7. TRIM()
8. REPLACE() - Return a string where all occurrences of an expression are replaced with another one.
9. SUBSTRING() - Returns only a part of a string (Mid of excel function)

*/

/*
Select information from the ratings table, excluding the unknown broad_bean_origins.
Convert the broad_bean_origins to lowercase when comparing it to the '%unknown%' expression.
*/
SELECT 
	company,
	bean_type,
	broad_bean_origin,
	'The company ' +  company + ' uses beans of type "' + bean_type + '", originating from ' + broad_bean_origin + '.'
FROM ratings
WHERE
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%';

/*
Restrict the query to make sure that the bean_type is not unknown.
Convert the bean_type to lowercase and compare it with an expression that contains the '%unknown%'
*/
SELECT 
	company,
	bean_type,
	broad_bean_origin,
	'The company ' +  company + ' uses beans of type "' + bean_type + '", originating from ' + broad_bean_origin + '.'
FROM ratings
WHERE 
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%'
    -- The 'bean_type' should not be unknown
    AND bean_type NOT LIKE '%unknown%';


/*Format the message so that company and broad_bean_origin are uppercase.*/
SELECT 
	(company),
	bean_type,
	(broad_bean_origin),
    -- 'company' and 'broad_bean_origin' should be in uppercase
	'The company ' +  UPPER(company) + ' uses beans of type "' + bean_type + '", originating from ' + UPPER(broad_bean_origin) + '.'
FROM ratings
WHERE 
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%'
     -- The 'bean_type' should not be unknown
    AND LOWER(bean_type) NOT LIKE '%unknown%';


/*
Create an alias for each voter with the following parts: 
the first 3 letters from the first name concatenated with the 
last 3 letters from the last name, followed by the _ character and 
the last 2 digits from the birth date.
*/

SELECT 
	first_name,
	last_name,
	country,
    -- Select only the first 3 characters from the first name
	LEFT(first_name, 3) AS part1,
    -- Select only the last 3 characters from the last name
    RIGHT(last_name, 3) AS part2,
    -- Select only the last 2 digits from the birth date
    RIGHT(birthdate, 2) AS part3,
    -- Create the alias for each voter
    LEFT(first_name, 3) + RIGHT(last_name, 3) + '_' + RIGHT(birthdate, 2) 
FROM voters;

/*
Extract the fruit names from the following sentence: "Apples are neither oranges nor potatoes".
*/
DECLARE @sentence NVARCHAR(200) = 'Apples are neither oranges nor potatoes.'
SELECT
	-- Extract the word "Apples" 
	SUBSTRING(@sentence, 1, 6) AS fruit1,
    -- Extract the word "oranges"
	SUBSTRING(@sentence, 20, 7) AS fruit2;


--REPLACE() FUNCTION

/*Add a new column in the query in which you replace the "yahoo.com" 
in all email addresses with "live.com". */

SELECT 
	first_name,
	last_name,
	email,
	-- Replace "yahoo.com" with "live.com"
	REPLACE(email, 'yahoo.com', 'live.com') AS new_email
FROM voters;

/*
Replace the character "&" from the company name with "and".
*/
SELECT 
	company AS initial_name,
    -- Replace '&' with 'and'
	REPLACE(company, '&', 'and') AS new_name 
FROM ratings
WHERE CHARINDEX('&', company) > 0;

/*
Remove the string "(Valrhona)" from the company name "La Maison du Chocolat (Valrhona)".
*/
SELECT 
	company AS old_company,
    -- Remove the text '(Valrhona)' from the name
	REPLACE(company, '(Valrhona)', '') AS new_company,
	bean_type,
	broad_bean_origin
FROM ratings
WHERE company = 'La Maison du Chocolat (Valrhona)';

--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
								--WORKING WITH STRINGS
							----------------------------------
							-- FUNCTIONS FOR MANIPULATING GROUPS OF STRINGS
/*
-- Released recently in SQL Server 2016, 2017
-- CONCAT() & CONCAT_WS
-- CONCAT adds one or more strings or words together 
-- CONCAT_WS() - concatenate with separator (WS)

-- Note that concatenating data with functions is better than using the '+' operator, 
This is because you can combine other data types not only strings with function

*/

SELECT
  CONCAT('Mangoes', 'and', 'peanut') AS concat_output,
  CONCAT_WS(' ', 'Mangoes', 'and', 'peanut') AS concat_output_ws1,
  CONCAT_WS('_', 'Mangoes', 'and', 'peanut') AS concat_output_ws2;

--2. STRING_AGG or STRING AGGREGATE: concatenate the values of string 
--expression and places separator values btw them' (Just like comnining rows)

--3. STRING_SPLIT() - returns a colum and it is the opposite of STRING_AGG.Concatenating multiple row values
--just like text to column

DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';


/*
Create a message similar to this one: "Chocolate with beans from Belize has 
a cocoa percentage of 0.6400" for each result of the query.
Use the + operator to concatenate data and the ' ' character as a separator.
*/

SELECT 
	bean_type,
	bean_origin,
	cocoa_percent,
	-- Create a message by concatenating values with "+"
	@string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1
FROM ratings
WHERE 
	company = 'Ambrosia' 
	AND bean_type <> 'Unknown';

/*
Create the same message, using the CONCAT() function.
*/
DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';

SELECT 
	bean_type,
	bean_origin,
	cocoa_percent,
	-- Create a message by concatenating values with "+"
	@string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1,
	-- Create a message by concatenating values with "CONCAT()"
	CONCAT(@string1, ' ' ,bean_origin, ' ', @string2, ' ', cocoa_percent) AS message2
FROM ratings
WHERE 
	company = 'Ambrosia' 
	AND bean_type <> 'Unknown';


/*
Create the same message, using the CONCAT_WS() function. 
Evaluate the difference between this method and the previous ones.
*/
DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';

SELECT 
	bean_type,
	bean_origin,
	cocoa_percent,
	-- Create a message by concatenating values with "+"
	@string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1,
	-- Create a message by concatenating values with "CONCAT()"
	CONCAT(@string1, ' ', bean_origin, ' ', @string2, ' ', cocoa_percent) AS message2,
	-- Create a message by concatenating values with "CONCAT_WS()"
	CONCAT_WS(' ', @string1, bean_origin, @string2, cocoa_percent) AS message3
FROM ratings
WHERE 
	company = 'Ambrosia' 
	AND bean_type <> 'Unknown';


/*
Create a list with all the values found in the bean_origin column 
for the companies: 'Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters'. 
The values should be separated by commas (,).
*/

SELECT
	-- Create a list with all bean origins, delimited by comma
	STRING_AGG(bean_origin, ',') AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters');


/*Create a list with the values found in the bean_origin column 
for each of the companies: 'Bar Au Chocolat', 'Chocolate Con Amor', 
'East Van Roasters'. The values should be separated by commas (,).
*/
SELECT 
	company,
    -- Create a list with all bean origins
	STRING_AGG(bean_origin, ',') AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;

/*
Arrange the values from the list in alphabetical order.
*/
SELECT 
	company,
    -- Create a list with all bean origins ordered alphabetically
	STRING_AGG(bean_origin, ',') WITHIN GROUP (ORDER BY bean_origin ASC) AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;


/* STRING_SPLIT() FUNCTION
This function splits the string into substrings based on the 
separator and returns a table, each row containing a part of the original string.

Remember: because the result of the function is a table, 
it cannot be used as a column in the SELECT clause; 
you can only use it in the FROM clause, just like a normal table.
*/


/*
Split the phrase declared in the variable @phrase into sentences (using the . separator).
*/
DECLARE @phrase NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT value
FROM STRING_SPLIT(@phrase, '.');

/*
Split the phrase2 declared in the variable @phrase2 into individual words.
*/
DECLARE @phrase2  NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'
SELECT value
FROM string_split(@phrase2, ' ');


/* CHALLENGE
Select only the voters whose first name has fewer than 5 characters 
and email address meets these conditions in the same time: 
(1) starts with the letter “j”, 
(2) the third letter is “a” and 
(3) is created at yahoo.com.
*/
SELECT
	first_name,
    last_name,
	birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for the desired pattern in the email address
	AND PATINDEX('j_a%@yahoo.com', email) > 0;

/*
Concatenate the first name and last name
in the same column and present it in this format: 
" *** Firstname LASTNAME *** ".
*/

	SELECT
    -- Concatenate the first and last name
	CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    last_name,
	birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
	AND PATINDEX('j_a%@yahoo.com', email) > 0;       


/*
Mask the year part from the birthdate column, 
by replacing the last two digits with "XX" (1986-03-26 becomes 19XX-03-26).
*/
SELECT
    -- Concatenate the first and last name
	CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    -- Mask the last two digits of the year
    REPLACE(birthdate, SUBSTRING(CAST(birthdate AS varchar), 3, 2), 'XX') AS birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
	AND PATINDEX('j_a%@yahoo.com', email) > 0;    


--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
								--WORKING WITH STRINGS
							----------------------------------
							-- AGGREGATE ARITHMETIC FUNCTIONS

/*
1. COUNT
2. COUNT(DISTINCT) 3. COUNT(*)
4. SUM() 5. SUM(DISTINCT) 6. SUM(ALL)
7. MAX() 8. MAX(ALL) 9. MAX(DISTINCT)
10. MIN()
11. AVG()

*/

/*
Count the number of voters for each group.
Calculate the total number of votes per group.
*/

SELECT 
	gender, 
	-- Count the number of voters for each group
	COUNT(*) AS voters,
	-- Calculate the total number of votes per group
	SUM(total_votes) AS total_votes
FROM voters
GROUP BY gender;

/*
1. Calculate the average percentage of cocoa used by each company.
2. Calculate the minimum rating received by each company.
3. Calculate the maximum rating received by each company.
4. Use an aggregate function to order the results of the query by the maximum rating, in descending order.
*/

SELECT 
	company,
	-- Calculate the average cocoa percent
	AVG(cocoa_percent) AS avg_cocoa,
	-- Calculate the minimum rating received by each company
	MIN(rating) AS min_rating,
	-- Calculate the maximum rating received by each company
	MAX(rating) AS max_rating
FROM ratings
GROUP BY company
-- Order the values by the maximum rating
ORDER BY MAX(rating) DESC;

--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
								-- ANALYTICS FUNCTION
							----------------------------------
/*
FIRST_VALUE() - Return the first value in an ordered set and used with OVER clause
Partition by is optional but order by is mandatory

LAST_VALUE() - Just like that first value, it returns the last value of an orderd set

PARTITION LIMITS
-----------------
UNBOUNDED PRECEDING - First row of the partition 
UNBOUNDED FOLLOWING - Last row of the partition
CURRENT ROW - Current row
PRECEDING - Previous row
FOLLOWING - Next row

Lag() - Access data from a previous row in the same result  
LEAD()  - Access data from A SUBSEQUENT ROW IN THE SAME RESULT SET
*/


/* CHALLENGE
Create a new column, showing the number of votes 
recorded for the next person in the list.

Create a new column with the difference between the current 
voter's total_votes and the votes of the next person.
*/
SELECT 
	first_name,
	last_name,
	total_votes AS votes,
    -- Select the number of votes of the next voter
	LEAD(total_votes) OVER (ORDER BY total_votes) AS votes_next_voter,
    -- Calculate the difference between the number of votes
	LEAD(total_votes) OVER (ORDER BY total_votes) - total_votes AS votes_diff
FROM voters
WHERE country = 'France'
ORDER BY total_votes;


/*
Create a new column, showing the cocoa percentage of the chocolate bar that 
received a lower score, with cocoa coming from the same location (broad_bean_origin is the same).

Create a new column with the difference between the current bar's cocoa percentage 
and the percentage of the previous bar.
*/

SELECT 
	broad_bean_origin AS bean_origin,
	rating,
	cocoa_percent,
    -- Retrieve the cocoa % of the bar with the previous rating
	LAG(cocoa_percent) 
		OVER(PARTITION BY broad_bean_origin ORDER BY rating) AS percent_lower_rating
FROM ratings
WHERE company = 'Fruition'
ORDER BY broad_bean_origin, rating ASC;

/*
Retrieve the birth date of the oldest voter from each country.
Retrieve the birth date of the youngest voter from each country.
*/
SELECT 
	first_name + ' ' + last_name AS name,
	country,
	birthdate,
	-- Retrieve the birthdate of the oldest voter per country
	MIN(birthdate) 
	OVER (PARTITION BY country ORDER BY birthdate) AS oldest_voter,
	-- Retrieve the birthdate of the youngest voter per country
	MAX(birthdate) 
		OVER (PARTITION BY country ORDER BY birthdate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
				) AS youngest_voter
FROM voters
WHERE country IN ('Spain', 'USA');


--------------------------------------------------------------------------------------------------	   
	
  							----------------------------------
								-- MATHEMATICAL FUNCTION
							----------------------------------
/*
ABS -  Absolute value of an expression
SIGN() - returns the signs of an expression (-1, 0 +1 is what it returns for negative, 0 and positive)

ROUNDING FUNCTIONS
- CEILING : Returns the smallest integer greater than or equal to the expression
- FLOOR : Returns the largest integer less than or equal to the expression
- ROUND : Returns a numeric value, rounded to the specific length

EXPONENTIAL FUNCTIONS
- POWER: Returns the expression raised to the specific power
- SQUARE: Returns the square of the expression
- SQRT: Returns the squareroot of the expression

NOTE: the type of the expression is float or can be implicitly converted to float
*/

/*
Calculate the absolute value of the result of the expression.

Find out the sign of the result (positive or negative).
*/

DECLARE @number1 DECIMAL(18,2) = -5.4;
DECLARE @number2 DECIMAL(18,2) = 7.89;
DECLARE @number3 DECIMAL(18,2) = 13.2;
DECLARE @number4 DECIMAL(18,2) = 0.003;

DECLARE @result DECIMAL(18,2) = @number1 * @number2 - @number3 - @number4;
SELECT 
	@result AS result,
	-- Show the absolute value of the result
	ABS(@result) AS abs_result,
	-- Find the sign of the result
	SIGN(@result) AS sign_result;

/*
1. Round up the ratings to the nearest integer value.
2. ound down the ratings to the nearest integer value.
3. Round the ratings to a decimal number with only 1 decimal.
4. Round the ratings to a decimal number with 2 decimals.
*/

SELECT
	rating,
	-- Round-up the rating to an integer value
	CEILING(rating) AS round_up,
	-- Round-down the rating to an integer value
	FLOOR(rating) AS round_down,
	-- Round the rating value to one decimal
	ROUND(rating, 1) AS round_onedec,
	-- Round the rating value to two decimals
	ROUND(rating, 2) AS round_twodec
FROM ratings;


/*
Raise the number stored in the @number variable to the power from the @power variable.
Calculate the square of the @number variable (square means the power of 2).
Calculate the square root of the number stored in the @number variable.

*/

DECLARE @number DECIMAL(4, 2) = 4.5;
DECLARE @power INT = 4;

SELECT
	@number AS number,
	@power AS power,
	-- Raise the @number to the @power
	POWER(@number, @power) AS number_to_power,
	-- Calculate the square of the @number
	SQUARE(@number) num_squared,
	-- Calculate the square root of the @number
	SQRT(@number) num_square_root;


/*
Calculate the average rating received by each company and perform the following approximations:
a. round-up to the next integer value
b. round-down to the previous integer value.
*/

SELECT 
	company, 
    -- Select the number of cocoa flavors for each company
	COUNT(*) AS flavors,
    -- Select the minimum, maximum and average rating
	MIN(rating) AS lowest_score,   
	MAX(rating) AS highest_score,   
	AVG(rating) AS avg_score,
    -- Round the average rating to 1 decimal
    ROUND(AVG(rating), 1) AS round_avg_score,
    -- Round up and then down the aveg. rating to the next integer 
    CEILING(AVG(rating)) AS round_up_avg_score,   
	FLOOR(AVG(rating)) AS round_down_avg_score
FROM ratings
GROUP BY company
ORDER BY flavors DESC;