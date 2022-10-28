------------------------------
-- CASE STATEMENT
------------------------------

-- used just like if statemnet to confirm if a column contains a value and when it does, return another.
-- Atleast 4 keywords - CASE, WHEN, THEN, END. Although ELSE is optional

-- CHANGING COLUMN VALUES WITH CASE IN T-SQL
SELECT Continent,
	CASE WHEN Continent = 'Europe' OR Continent = "Asia' THEN 'Eurasia'
	ELSE 'Other'
	END AS NewContinent
FROM EconomicIndicators;


/* Q1
Create a new column, SourceCountry, defined from these cases:
When Country is 'us' then it takes the value 'USA'.
Otherwise it takes the value 'International'.
*/

SELECT Country, 
       CASE WHEN Country = 'us'  THEN 'USA'
       ELSE 'International'
       END AS SourceCountry
FROM Incidents;

----------------------------------------------
/*Q2
-- Goup the DurationSeconds into 5 buckets of 1-5 as shown below:
*/
----------------------------------------------

-- Complete the syntax for cutting the duration into different cases
SELECT DurationSeconds, 
-- Start with the 2 TSQL keywords, and after the condition a TSQL word and a value
      CASE WHEN (DurationSeconds <= 120) THEN 1
-- The pattern repeats with the same keyword and after the condition the same word and next value          
       WHEN (DurationSeconds > 120 AND DurationSeconds <= 600) THEN 2
-- Use the same syntax here             
       WHEN (DurationSeconds > 601 AND DurationSeconds <= 1200) THEN 3
-- Use the same syntax here               
       WHEN (DurationSeconds > 1201 AND DurationSeconds <= 5000) THEN 4
-- Specify a value      
       ELSE 5 
       END AS SecondGroup   
FROM Incidents;

