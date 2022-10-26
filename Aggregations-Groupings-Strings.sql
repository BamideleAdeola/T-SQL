-- 2 --

-- AGGREGATION, STRINGS, GrOUPINGS
-------------------------------------------------------------------

/* Q1 Obtain a grand total of the demand_loss_mw column by using the SUM function, and alias the result as MRO_demand_loss.
Only retrieve rows WHERE demand_loss_mw is not NULL and nerc_region is 'MRO'.*/

-- Sum the demand_loss_mw column
SELECT 
  SUM(demand_loss_mw) AS MRO_demand_loss 
FROM 
  grids 
WHERE
  -- demand_loss_mw should not contain NULL values
  demand_loss_mw IS NOT NULL 
  -- and nerc_region should be 'MRO';
  AND nerc_region = 'MRO';
  -------------------------------------------------------------------

  /* Q2 Return the COUNT of the grid_id column, aliasing the result as grid_total.
  Make the count more meaningful by restricting it to records where the nerc_region is 'RFC'. Name the result RFC_count.*/

  -- Obtain a count of 'grid_id'
SELECT 
  COUNT(grid_id) AS RFC_count
FROM 
  grids
-- Restrict to rows where the nerc_region is 'RFC'
WHERE 
  nerc_region = 'RFC';

  -------------------------------------------------------------------
  --  MIN, MAX, AVG
  -------------------------------------------------------------------
   /* Q3 Find the minimum, Maximum and Average value from the affected_customers column, 
   but only for rows where demand_loss_mw has a value. Name the result min_affected_customers..*/

   -- Find the average number of affected customers
SELECT 
  MIN(affected_customers) AS min_affected_customers,
  MAX(affected_customers) AS max_affected_customers, 
  AVG(affected_customers) AS avg_affected_customers 
FROM 
  grids
-- Only retrieve rows where demand_loss_mw has a value
WHERE 
  demand_loss_mw IS NOT NULL;

    -------------------------------------------------------------------
  --  STRINGS
  -------------------------------------------------------------------
