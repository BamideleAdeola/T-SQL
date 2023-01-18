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

