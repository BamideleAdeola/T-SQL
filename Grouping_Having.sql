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