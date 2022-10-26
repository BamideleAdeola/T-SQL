-- 4 --

-------------------------------------------------------------------
  --  GROUPING AND HAVING
-------------------------------------------------------------------

 ------------------------------------------------------------------------
/* Q1 Select nerc_region and the sum of demand_loss_mw for each region.
Exclude values where demand_loss_mw is NULL.
Group the results by nerc_region. Arrange in descending order of demand_loss*/
-------------------------------------------------------------------------
-- Select the region column
SELECT 
  nerc_region,
  -- Sum the demand_loss_mw column
  SUM(demand_loss_mw) AS demand_loss
FROM 
  grids
  -- Exclude NULL values of demand_loss
WHERE 
  demand_loss_mw IS NOT NULL
  -- Group the results by nerc_region
GROUP BY 
  nerc_region
  -- Order the results in descending order of demand_loss
ORDER BY 
  demand_loss DESC;


   ------------------------------------------------------------------------
/* Q2 Select nerc_region and the sum of demand_loss_mw for each region.
Exclude values where demand_loss_mw is NULL.
Group the results by nerc_region. Arrange in descending order of demand_loss*
filter for results with a total demand_loss_mw of greater than 10000 are returned.*/
-------------------------------------------------------------------------

SELECT 
  nerc_region, 
  SUM (demand_loss_mw) AS demand_loss 
FROM 
  grids 
  -- Remove the WHERE clause
WHERE demand_loss_mw  IS NOT NULL
GROUP BY 
  nerc_region 
  -- Enter a new HAVING clause so that the sum of demand_loss_mw is greater than 10000
HAVING 
  SUM(demand_loss_mw) > 10000 
ORDER BY 
  demand_loss DESC;


 ------------------------------------------------------------------------
/* Q3 Use MIN and MAX to retrieve the minimum and maximum values for the place and points columns respectively.*/
-------------------------------------------------------------------------

  -- Retrieve the minimum and maximum place, and point values
SELECT 
  -- the lower the value the higher the place, so MIN = the highest placing
  MIN(place) AS hi_place, 
  MAX(place) AS lo_place, 
  -- Retrieve the minimum and maximum points values. This time MIN = the lowest points value
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision;


  -- Q3B Let's obtain more insight from our results by adding a GROUP BY clause. Group the results by country.
  -- Retrieve the minimum and maximum place, and point values
SELECT 
  -- the lower the value the higher the place, so MIN = the highest placing
  MIN(place) AS hi_place, 
  MAX(place) AS lo_place,  
  -- Retrieve the minimum and maximum points values. This time MIN = the lowest points value
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision
  -- Group by country
GROUP BY
  country;

  -- Q3C Add COUNT OF country, country column to the GROUP BY clause of the previous query

  -- Obtain a count for each country
SELECT 
  COUNT (country) AS country_count, 
  -- Retrieve the country column
  country, 
  -- Return the average of the Place column 
  AVG(place) AS average_place, 
  AVG(points) AS avg_points, 
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country;

  -- 3D Apply a filter so we only return rows where the country_count is greater than 5. Then arrange by avg_place in ascending order, and avg_points in descending order.
  SELECT 
  country, 
  COUNT (country) AS country_count, 
  AVG (place) AS avg_place, 
  AVG (points) AS avg_points, 
  MIN (points) AS min_points, 
  MAX (points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country 
  -- The country column should only contain those with a count greater than 5
HAVING 
  COUNT(country) > 5 
  -- Arrange columns in the correct order
ORDER BY 
  avg_place, 
  avg_points DESC;