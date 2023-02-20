----------------
-- INTRODUCTION
----------------

/* SQL QUERY BEST PRACTICE
1. Be consistent
2. Use UPPER CASE for all SQL syntax
3. Create a new line for each major processing syntax: SELECT, FROM, WHERE, etc
4. Indent code:
	Sub-queries
	ON Statement
	AND / OR Conditions
	To avoid long single lines of code, for example, several column names
5. Complete the query wuth a semi colon (;)
6. Alias where required, using AS

*/


/* Challenge 1 - 
You want to create a query that returns the Body Mass Index (BMI) for each player from North America.

BMI = \dfrac{weight (kg)}{height (cm)^2}

*/

SELECT 
    PlayerName, 
    Country,
    ROUND(Weight_kg/SQUARE(Height_cm/100),2) BMI
FROM Players 
WHERE Country = 'USA'
  OR Country = 'Canada'
ORDER BY BMI;


-- Your friend's query
-- First attempt, contains errors and inconsistent formatting
/*
select PlayerName, p.Country,sum(ps.TotalPoints) 
AS TotalPoints  
FROM PlayerStats ps inner join Players On ps.PlayerName = p.PlayerName
WHERE p.Country = 'New Zeeland'
Group 
by PlayerName, Country
order by Country;
*/

-- Your query
-- Second attempt - errors corrected and formatting fixed

SELECT p.PlayerName, p.Country,
	   SUM(ps.TotalPoints) AS TotalPoints  
FROM PlayerStats ps 
INNER JOIN Players p
	ON ps.PlayerName = p.PlayerName
WHERE p.Country = 'New Zealand'
GROUP BY p.PlayerName, p.Country;

/*
Alias the new average BMI column as AvgTeamBMI.
Alias the PlayerStats table as ps.
Alias the sub-query as p.
The PlayerStats table and sub-query are joining on the column PlayerName. 
Add the aliases to the joining PlayerName columns.
*/

SELECT Team, 
   ROUND(AVG(BMI),2) AS AvgTeamBMI -- Alias the new column
FROM PlayerStats AS ps -- Alias PlayerStats table
INNER JOIN
		(SELECT PlayerName, Country,
			Weight_kg/SQUARE(Height_cm/100) BMI
		 FROM Players) AS p -- Alias the sub-query    
    -- Alias the joining columns
	ON p.PlayerName = ps.PlayerName 
GROUP BY Team
HAVING AVG(BMI) >= 25;




/*Processing order
The following query returns earthquakes with a magnitude higher than 8, and at a depth of more than 500km.
*/

SELECT Date, Country, Place, Depth, Magnitude
FROM Earthquakes
WHERE Magnitude > 8
    AND Depth > 500
ORDER BY Depth DESC;


/*
Complete the required query using FROM, WHERE, SELECT and ORDER BY.
Rearrange the query so that the syntax is in the order that it will run without error.
*/

/*
Returns earthquakes in New Zealand with a magnitude of 7.5 or more
*/

SELECT Date, Place, NearestPop, Magnitude
FROM Earthquakes
WHERE Country = 'NZ'
	AND Magnitude >= 7.5
ORDER BY Magnitude DESC;



-- Your query
SELECT Date, 
    Place, 
    NearestPop, 
    Magnitude
FROM Earthquakes
WHERE Country = 'JP' 
	AND Magnitude >= 8
ORDER BY Magnitude DESC;


---------
--FILTERING AND DATA INTERROGATION
---------


/*
Returns the location of the epicenter of earthquakes with a 9+ magnitude
*/

-- Replace Countries with the correct table name
SELECT n.CountryName AS Country
	,e.NearestPop AS ClosestCity
    ,e.Date
    ,e.Magnitude
FROM Nations AS n
INNER JOIN Earthquakes AS e
	ON n.Code2 = e.Country
WHERE e.Magnitude >= 9
ORDER BY e.Magnitude DESC;


/*
Returns the location of the epicenter of earthquakes with a 9+ magnitude
*/

-- Replace Magnatud with the correct column name
SELECT n.CountryName AS Country
	,e.NearestPop AS ClosestCity
    ,e.Date
    ,e.Magnitude
FROM Nations AS n
INNER JOIN Earthquakes AS e
	ON n.Code2 = e.Country
WHERE e.Magnitude >= 9
ORDER BY e.Magnitude DESC;


/*
Location of the epicenter of earthquakes with a 9+ magnitude
*/

-- Replace City with the correct column name
SELECT n.CountryName AS Country
	,e.NearestPop AS ClosestCity
    ,e.Date
    ,e.Magnitude
FROM Nations AS n
INNER JOIN Earthquakes AS e
	ON n.Code2 = e.Country
WHERE e.Magnitude >= 9
ORDER BY e.Magnitude DESC;


/*
you want a query that returns NBA players with average total rebounds of 12 or more per game. 
The following formula calculates average total rebounds from the PlayerStats table;

Average Total Rebounds = \dfrac{(Defensive Rebounds + Offensive Rebounds)}{Games Played}
*/

-- First query

SELECT PlayerName, 
    Team, 
    Position,
    (DRebound+ORebound)/CAST(GamesPlayed AS numeric) AS AvgRebounds
FROM PlayerStats;
--WHERE AvgRebounds >= 12;

/*
In the sub-query calculate average total rebounds in a new column, AvgRebounds.
Add the new column to the SELECT statement.
Apply a filter condition for 12 or more average total rebounds.
*/

-- Second query

-- Add the new column to the select statement
SELECT PlayerName, 
       Team, 
       Position, 
       AvgRebounds -- Add the new column
FROM
     -- Sub-query starts here                             
	(SELECT 
      PlayerName, 
      Team, 
      Position,
      -- Calculate average total rebounds
     (DRebound+ORebound)/CAST(GamesPlayed AS numeric) AS AvgRebounds
	 FROM PlayerStats) tr
WHERE AvgRebounds >= 12; -- Filter rows




SELECT PlayerName, 
      Country, 
      College, 
      DraftYear, 
      DraftNumber 
FROM Players
-- WHERE UPPER(LEFT(College,5)) LIKE 'LOU%'
WHERE College LIKE 'Louisiana%'; -- Add the wildcard filter

/*
FILTERING WITH HAVING
- Do not use HAVING to filter individual or ungrouped rows
- Use WHERE to filter individual rows and HAVING for a numeric filter on grouped rows.
- HAVING can only be applied to a numeric column in an aggregate function filter
*/


/*
In this exercise, you want to know the number of players from Latin American 
countries playing in the 2017-2018 NBA season.
*/

SELECT Country, COUNT(*) CountOfPlayers
FROM Players
-- Add the filter condition
WHERE Country
-- Fill in the missing countries
	IN ('Argentina','Brazil','Dominican Republic'
        ,'Puerto Rico')
GROUP BY Country;

/*
Use the WHERE filter condition on individual, or ungrouped, rows.
Although using HAVING produced the same results it is less efficient 
because the rows are grouped first and then filtered, potentially 
affecting performance by unnecessarily tying up processing resources.
*/


/*
You want a query that returns the total points contribution of a teams 
Power Forwards where their total points contribution is greater than 3000.
*/

SELECT Team, 
	SUM(TotalPoints) AS TotalPFPoints
FROM PlayerStats
-- Filter for only rows with power forwards
WHERE Position = 'PF'
GROUP BY Team
-- Filter for total points greater than 3000
HAVING sum(TotalPoints) > 3000;

/*
WHERE is used as a filter condition on individual rows, in this case, 
Position = 'PF', and HAVING is used as a numeric filter condition on 
grouped rows and must be used with an aggregate function, in this case, 
SUM(TotalPoints) >3000.

Looking at the results, Cleveland Cavaliers must've had some good Power 
Forwards that season.
*/


---------
--INTERROGATION AFTER SELECT
---------
/*
1. All is not always good. e.g 
SELECT * is always good for data interrogation but potentially bad for performance.

There is no TOP or BOTTOM in SQL, Order BY does the trick.

TOP		-	ORDER BY		= SQL SERVER
ROWNUM	-	ORDER BY		= ORACLE
LIMIT	-	ORDER BY		= POSTGRESQL
*/



/*
She asks you for a query that returns coordinate locations, strength, depth and nearest city of all earthquakes 
in Papua New Guinea and Indonesia.

All the information you need is in the Earthquakes table, and your initial interrogation of the data tells 
you that the column for the country code is Country and that the Codes for Papua New Guinea and Indonesia are PG and ID respectively.

*/

SELECT longitude, -- Y location coordinate column
       latitude, -- X location coordinate column
	   magnitude , -- Earthquake strength column
	   depth, -- Earthquake depth column
	   NearestPop -- Nearest city column
FROM Earthquakes
WHERE Country = 'PG' -- Papua New Guinea country code
	OR Country = 'ID'; -- Indonesia country code


-- Upper Quartile
	SELECT TOP 25 PERCENT -- Limit rows to the upper quartile
       Latitude,
       Longitude,
	   Magnitude,
	   Depth,
	   NearestPop
FROM Earthquakes
WHERE Country = 'PG'
	OR Country = 'ID'
ORDER BY Magnitude DESC; -- Order the results



/*
Get the number of cities near earthquakes of magnitude 8 or more.
*/

SELECT NearestPop, 
       Country, 
       COUNT(NearestPop) NumEarthquakes -- Number of cities
FROM Earthquakes
WHERE Magnitude >= 8
	AND Country IS NOT NULL
GROUP BY NearestPop, Country -- Group columns
ORDER BY NumEarthquakes DESC;

/*
Nice! You can use DISTINCT() to remove duplicate rows. If you want to apply an aggregate function DISTINCT() 
is not required and you can just use GROUP BY instead.

Check out the results of the query. Sentyabrskiy is in the Kuril Islands group, north of Japan. 
The islands are part of Russia.
*/


-------
--UNION AND UNION ALL
--Great! UNION ALL returns more rows than UNION because it does not remove duplicates. Therefore, duplicate rows were removed with UNION.
----------

--QUERY 1
SELECT CityName AS NearCityName,
	   CountryCode
FROM Cities

UNION -- Append queries

SELECT Capital AS NearCityName,
       Code2 AS CountryCode  -- Country code column
FROM Nations;


-- QUERY 2
SELECT CityName AS NearCityName,
	   CountryCode
FROM Cities

UNION ALL-- Append queries

SELECT Capital AS NearCityName,
       Code2 AS CountryCode  -- Country code column
FROM Nations;


/* NARRATION
Good job! Even queries you think that are good may return unwanted duplicate rows. 
Before starting a project in SQL make sure you have a good understanding of what 
the database contains and ensure you perform a thorough interrogation of the data sets you will be using.
*/



---------------
--SUB QUERIES AND PRESENCE OR ABSENCE
--------------

/* 2 TYPES OF SUB QUERIES
1. Uncorrelated  - used with WHERE and FROM
2. Correlated -  Found in WHERE and SELECT


Correlated can be inefficient . 

Instead of correlated subquery, use INNER JOIN

*/



/* Uncorrelated sub-query
A sub-query is another query within a query. The sub-query returns its results to an outer query to be processed.

You want a query that returns the region and countries that have experienced earthquakes centered at a depth of 
400km or deeper. Your query will use the Earthquakes table in the sub-query, and Nations table in the outer query.
*/

SELECT UNStatisticalRegion,
       CountryName 
FROM Nations
WHERE Code2 -- Country code for outer query 
         IN (SELECT Country -- Country code for sub-query
             FROM Earthquakes
             WHERE Depth >= 400 ) -- Depth filter
ORDER BY UNStatisticalRegion;

-- Great! In uncorrelated sub-queries, the sub-query does not reference the outer query and therefore can run independently of the outer query.


/* Correlated sub-query
Sub-queries are used to retrieve information from another table, or query, that is separate to the main query.

A friend is working on a project looking at earthquake hazards around the world. She requires a table that lists all countries, 
their continent and the average magnitude earthquake by country. This query will need to access data from the Nations and Earthquakes tables.

*/

SELECT UNContinentRegion,
       CountryName, 
        (SELECT AVG(magnitude) -- Add average magnitude
        FROM Earthquakes e 
         	  -- Add country code reference
        WHERE n.Code2 = e.Country) AS AverageMagnitude 
FROM Nations n
ORDER BY UNContinentRegion DESC, 
         AverageMagnitude DESC;


/*
You want to find out the 2017 population of the biggest city for every country in the world. 
You can get this information from the Earthquakes database with the Nations table as the outer query and Cities table in the sub-query.

You will first create this query as a correlated sub-query then rewrite it using an INNER JOIN.

*/

-- QUERY 1 - USING CORRELATED
SELECT
	n.CountryName,
	 (SELECT MAX(c.Pop2017) -- Add 2017 population column
	 FROM Cities AS c 
                       -- Outer query country code column
	 WHERE c.CountryCode = n.Code2) AS BiggestCity
FROM Nations AS n; -- Outer query table


-- QUERY 2 USING INNER JOIN
SELECT n.CountryName, 
       c.BiggestCity 
FROM Nations AS n
INNER JOIN -- Join the Nations table and sub-query
    (SELECT CountryCode, 
     MAX(Pop2017) AS BiggestCity 
     FROM Cities
     GROUP BY CountryCode) AS c
ON n.Code2 = c.CountryCode; -- Add the joining columns


/* NARRATION
Great work! Sub-queries and INNER JOIN's can be used to return the same results. However, in practice large, 
complex queries may contain lots of sub-queries, many of which could be re-written as INNER JOIN's to improve performance.
*/



-----------------------
-- INTERSECT AND EXCEPT
-----------------------

/*
You want to know which, if any, country capitals are listed as the nearest city to recorded earthquakes. 
You can get this information by comparing the Nations table with the Earthquakes table.


INTERSECT is useful for data interrogation. It also removes duplicate rows from the results.
*/

SELECT Capital
FROM Nations -- Table with capital cities

INTERSECT -- Add the operator to compare the two queries

SELECT NearestPop -- Add the city name column
FROM Earthquakes;


/*

You want to know which countries have no recorded earthquakes. 
You can get this information by comparing the Nations table with the Earthquakes table.
*/

SELECT Code2 -- Add the country code column
FROM Nations

EXCEPT -- Add the operator to compare the two queries

SELECT Country 
FROM Earthquakes; -- Table with country codes



SELECT CountryName 
FROM Nations -- Table from Earthquakes database

INTERSECT -- Operator for the intersect between tables

SELECT Country
FROM Players; -- Table from NBA Season 2017-2018 database


---------------
EXISTS vs. IN
----------------
/*
1. EXISTS will stop searching the sub-query when the condition is TRUE
2. IN collects all the results from a sub-query before passing to the outer query
3. Consider using EXISTS instead of IN with a sub-query
*/


-- Second attempt
SELECT CountryName,   
	   Capital,
       Pop2016, -- 2016 country population
       WorldBankRegion
FROM Nations AS n
WHERE EXISTS -- Add the operator to compare queries
	  (SELECT 1
	   FROM Earthquakes AS e
	   WHERE n.Capital = e.NearestPop); -- Columns being compared

/*
IN and EXISTS are the appropriate operators to use here. Their advantage over INTERSECT is that the results can 
contain any column from the outer query in any order, the population column appears after the capital city column now.
*/


/* NOT IN and NOT EXISTS

You are interested to know if there are some countries in the Nations table that do not appear in the Cities table. 
There may be many reasons for this. For example, all the city populations from a country may be too small to be listed, 
or there may be no city data for a particular country at the time the data was compiled.

You will compare the queries using country codes.
*/

SELECT WorldBankRegion,
       CountryName
FROM Nations
WHERE Code2 NOT IN -- Add the operator to compare queries
	(SELECT CountryCode -- Country code column
	 FROM Cities);


SELECT WorldBankRegion,
       CountryName,
	   Code2,
       Capital, -- Country capital column
	   Pop2017
FROM Nations AS n
WHERE NOT EXISTS -- Add the operator to compare queries
	(SELECT 1
	 FROM Cities AS c
	 WHERE n.Code2 = c.CountryCode); -- Columns being compared




/*
NOT IN with IS NOT NULL
You want to know which country capitals have never been the closest city to recorded earthquakes. 
You decide to use NOT IN to compare Capital from the Nations table, in the outer query, 
with NearestPop, from the Earthquakes table, in a sub-query.
*/
SELECT WorldBankRegion,
       CountryName,
       Capital
FROM Nations
WHERE Capital NOT IN
	(SELECT NearestPop
     FROM Earthquakes
     WHERE NearestPop IS NOT NULL); -- filter condition



/*
INNER JOIN
An insurance company that specializes in sports franchises has asked you to assess the geological hazards of cities hosting NBA teams. 
You believe you can get this information by querying the Teams and Earthquakes tables across the Earthquakes and NBA Season 2017-2018 
databases respectively. Your initial query will use EXISTS to compare tables. The second query will use a more appropriate operator.
*/

-- Initial query
SELECT TeamName,
       TeamCode,
	   City
FROM Teams AS t -- Add table
WHERE EXISTS -- Operator to compare queries
      (SELECT 1 
	  FROM Earthquakes AS e -- Add table
	  WHERE t.City = e.NearestPop);


-- Second query
SELECT t.TeamName,
       t.TeamCode,
	   t.City,
	   e.Date,
	   e.place, -- Place description
	   e.Country -- Country code
FROM Teams AS t
INNER JOIN Earthquakes AS e -- Operator to compare tables
	  ON t.City = e.NearestPop


/* Exclusive LEFT OUTER JOIN
An exclusive LEFT OUTER JOIN can be used to check for the presence of data in one table that is absent in another table. 
To create an exclusive LEFT OUTER JOIN the right query requires an IS NULL filter condition on the joining column.

Your sales manager is concerned that orders from French customers are declining. He wants you to compile a list of 
French customers that have not placed any orders so he can contact them.
*/

-- First attempt
SELECT c.CustomerID,
       c.CompanyName,
	   c.ContactName,
	   c.ContactTitle,
	   c.Phone 
FROM Customers c
LEFT OUTER JOIN Orders o -- Joining operator
	ON c.CustomerID = o.CustomerID -- Joining columns
WHERE c.Country = 'France';


-- Second attempt
SELECT c.CustomerID,
       c.CompanyName,
	   c.ContactName,
	   c.ContactTitle,
	   c.Phone 
FROM Customers c
LEFT OUTER JOIN Orders o
	ON c.CustomerID = o.CustomerID
WHERE c.Country = 'France'
	AND o.CustomerID IS NULL; -- Filter condition

/* An inclusive LEFT OUTER JOIN returns all the rows in the left query, whereas an exclusive LEFT OUTER JOIN
returns only rows in the left query that are absent in the right query.
Looking at the results, you can put your manager at ease: there is only one French customer that has not placed any orders.*/


--------------------
-- 4 QUERRY PERFORMANCE TUNING
--------------------
/*
--1. TIME STATISTICS

--STATISTICS TIME -  Returns no of milliseconds, required to parse, compile and execute a query
To get the statistics, we must first SET THE STATISTICS TIME ON

*/



/*
--2. STATISTICS IO

- Page level stats

*/

-- Example 2
SELECT c.CustomerID,
       c.CompanyName,
       COUNT(o.CustomerID)
FROM Customers AS c
INNER JOIN Orders AS o -- Join operator
    ON c.CustomerID = o.CustomerID
WHERE o.ShipCity IN -- Shipping destination column
     ('Berlin','Bern','Bruxelles','Helsinki',
	 'Lisboa','Madrid','Paris','London')
GROUP BY c.CustomerID,
         c.CompanyName;



---------
--INDEXES
---------

/*

Clustered index
Clustered indexes can be added to tables to speed up search operations in queries. You have two copies of the Cities table from the Earthquakes database: one copy has a clustered index on the CountryCode column. The other is not indexed.

You have a query on each table with a different filter condition:

Query 1
Returns all rows where the country is either Russia or China.
Query 2
Returns all rows where the country is either Jamaica or New Zealand.

*/

-- Query 1
SELECT *
FROM Cities
WHERE CountryCode = 'RU' -- Country code
		OR CountryCode = 'CN' -- Country code


-- Query 2 - The best
SELECT *
FROM Cities
WHERE CountryCode IN ('JM','NZ') -- Country codes


---------
--EXECUTION PLAN
---------
/*This is read from right to left

Sort operator in execution plans
Execution plans can tell us if and where a query used an internal sorting operation. Internal sorting is 
often required when using an operator in a query that checks for and removes duplicate rows.

You are given an execution plan of a query that returns all cities listed in the Earthquakes database. 
The query appends queries from the Nations and Cities tables. Use the following execution plan to determine 
if the appending operator used is UNION or UNION ALL


*/