SELECT * FROM eurovision;

-- Return all columns, restricting the percent of rows returned
SELECT 
  TOP (50) PERCENT * 
FROM 
  eurovision;
  GO


  -- Select the top 20 rows from description, nerc_region and event_date
SELECT 
  TOP (20) description,
  nerc_region,
  event_date
FROM 
  grids 
  -- Order by nerc_region, affected_customers & event_date
  -- Event_date should be in descending order
ORDER BY
  nerc_region,
  affected_customers,
  event_date DESC;
  GO

  /*
  WHERE
You won't usually want to retrieve every row in your database. 
You'll have specific information you need in order to answer questions from your boss or colleagues.

The WHERE clause is essential for selecting, updating (and deleting!) data from your tables. 
You'll continue working with the grid dataset for this exercise
  */
  -------------------------------------------------------------
  -- Q Select the description and event_year columns. Return rows WHERE the description is 'Vandalism'.
  -- Select description and event_year
SELECT 
  description, 
  event_year 
FROM 
  grids 
  -- Filter the results
WHERE 
  description = 'Vandalism';

  ---------------------------------------------------
  
  --Q3 Select the nerc_region and demand_loss_mw columns, limiting the results to those where affected_customers is greater than or equal to 500000 (500,000)
  
SELECT 
  nerc_region, 
  demand_loss_mw 
FROM 
  grids 
-- Retrieve rows where affected_customers is >= 500000  (500,000)
WHERE 
  affected_customers >= 500000;
-----------------------------------------------------------------------

  --Q4  select description and affected_customers, returning records where the event_date was the 22nd December, 2013
  -- Select description and affected customers
SELECT 
  description, 
  affected_customers
FROM 
  grids 
  -- Retrieve rows where the event_date was the 22nd December, 2013    
WHERE 
  event_date = '2013-12-22';

  ----------------------------------------------------------------

 -- Q5 Limit the results to those where the affected_customers is BETWEEN 50000 and 150000, and order in descending order of event_date.

 -- Select description, affected_customers and event date
SELECT 
  description, 
  affected_customers,
  event_date
FROM 
  grids 
  -- The affected_customers column should be >= 50000 and <=150000   
WHERE 
  affected_customers BETWEEN 50000
  AND 150000 
   -- Define the order   
ORDER BY 
  event_date DESC;

  ------------------------------------------------------------------
  -- Q6 -- Retrieve the song,artist and release_year columns
SELECT 
  song, 
  artist, 
  release_year 
FROM 
  songlists 
  -- Ensure there are no missing or unknown values in the release_year column
WHERE 
  release_year IS NOT NULL 
  -- Arrange the results by the artist and release_year columns
ORDER BY 
  artist, 
  release_year;

  -------------------------------------------------------
  -- Q7A Extend the WHERE clause so that the results are those with a release_year greater than or equal to 1980 and less than or equal to 1990.
  SELECT 
  song, 
  artist, 
  release_year
FROM 
  songlists 
WHERE 
  -- Retrieve records greater than and including 1980
  release_year >= 1980 
  -- Also retrieve records up to and including 1990
  AND release_year <= 1990 
ORDER BY 
  artist, 
  release_year;

  -- Q7B Update your query to use an OR instead of an AND.
  SELECT 
  song, 
  artist, 
  release_year
FROM 
  songlists 
WHERE 
  -- Retrieve records greater than and including 1980
  release_year >= 1980 
  -- Replace AND with OR
  OR release_year <= 1990 
ORDER BY 
  artist, 
  release_year;

  --------------------------------------------

 -- Q8 Select all artists beginning with B who released tracks in 1986, but also retrieve any records where the release_year is greater than 1990.
 SELECT 
  artist, 
  release_year, 
  song 
FROM 
  songlists 
  -- Choose the correct artist and specify the release year
WHERE 
  (
    artist LIKE 'B%' 
    AND release_year = 1986
  ) 
  -- Or return all songs released after 1990
  OR release_year > 1990 
  -- Order the results
ORDER BY 
  release_year, 
  artist, 
  song;