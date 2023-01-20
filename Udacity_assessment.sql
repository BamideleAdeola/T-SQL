USE TestDb;
GO

/*
Are the most popular stations to start a trip also the most popular stations to end a trip? 
Limit to the first five popular stations
*/

WITH st_pop AS (
 SELECT start_station, 
   COUNT(start_date) AS st_count 
 FROM CapitalTrips
 GROUP BY start_station),   -- CTE 1, StartStation_Popularity

 end_pop AS (
 SELECT end_station,
   COUNT(end_date) AS end_count
 FROM CapitalTrips
 GROUP BY end_station)		-- CTE 2, EndStation_Popularity

SELECT TOP (5)
  s.start_station AS station,
  s.st_count AS starts,
  e.end_count AS ends
FROM st_pop s
INNER JOIN end_pop e 
ON s.start_station = e.end_station
ORDER BY starts DESC;



/*
Italy's country code is 10257. Which seasons are being identified in the CASE
statement to determine Italy's total goals scored?*/

SELECT season,
 SUM(CASE WHEN season = '2010/2011' 
     OR season = '2012/2013' 
     THEN home_goal END) AS italy_home_goals
FROM match
WHERE country_id = 10257
GROUP BY season;


/*
What is the correct way to use a subquery to filter the query for player_id's 
taller than 175cm? */

SELECT player_name, penalties
FROM players
WHERE player_id IN
 (
SELECT player_id
  FROM players 
WHERE height > 175
) 
LIMIT 5;

SELECT TOP (5) player_name, penalties
FROM players
WHERE player_id IN
 (
SELECT player_id
  FROM players 
WHERE height > 175
);

/*
Can you calculate a running total of minutes spent on bicycle trips per day? 
*/

SELECT
 start_station,
 start_date,
 duration,
SUM(Duration) OVER (ORDER BY start_date
 ROWS BETWEEN UNBOUNDED PRECEDING 
      AND CURRENT ROW) AS running_total
FROM CpaitalTrips;

SELECT TOP (5)
 start_station,
 start_date,
 duration,
 (ORDER BY start_date
 UNBOUNDED PRECEDING 
      AND 
) AS running_total
FROM trips;



/* Which countries have movies in more than a single language? */
SELECT country
FROM films
GROUP BY country
HAVING COUNT(DISTINCT language) > 1
LIMIT 5;

