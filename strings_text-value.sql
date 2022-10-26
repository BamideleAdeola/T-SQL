
  -------------------------------------------------------------------
  --  STINGS OR TEXT VALUES
  -------------------------------------------------------------------
 -- LEN FUNCTION - To count the number of characters but it is LENGTH in PostgreSQL
 -- LEFT FUNCTION -  To extracts the N-number of characters from the left of a string
 -- RIGHT FUNCTION -  To extracts the N-number of characters from the right of a string
 -- CHARINDEX FUNCTION - To extract no of characters to the point of parenthesis specified
 -- SUBSTRING FUNCTION - To extract from the middle of a string just like MID function of an Excel
 -- REPLACE FUNCTION - To replace a character with another.

 ------------------------------------------------------------------------
-- Q1 Retrieve the length of the description column, returning the results as description_length.
-------------------------------------------------------------------------

-- Calculate the length of the description column
SELECT 
  LEN (description) AS description_length 
FROM 
  grids;

   ------------------------------------------------------------------------
-- Q2 Retrieve the first 25 characters from the description column in the grid table. Name the results first_25_left.
-------------------------------------------------------------------------
-- Select the first 25 characters from the left of the description column
SELECT 
  LEFT(description, 25) AS first_25_left 
FROM 
  grids;

 ------------------------------------------------------------------------
-- Q3 Retrieve the LAST 25 characters from the description column in the grid table. Name the results first_25_left.
-------------------------------------------------------------------------
SELECT 
  RIGHT(description, 25) AS last_25_right 
FROM 
  grids;

 ------------------------------------------------------------------------
-- Q4  use CHARINDEX to find a specific character or pattern within a column. 
--Return the CHARINDEX of the string 'Weather' whenever it appears within the description column.
-------------------------------------------------------------------------

  -- Complete the query to find `Weather` within the description column
SELECT 
  description, 
  CHARINDEX('Weather', description) 
FROM 
  grids
WHERE description LIKE '%Weather%';


 ------------------------------------------------------------------------
-- Q5  Return the length of the string Weather from the above output 
-------------------------------------------------------------------------

-- Complete the query to find the length of `Weather'
SELECT 
  description, 
  CHARINDEX('Weather', description) AS start_of_string,
  LEN('Weather') AS length_of_string 
FROM 
  grids
WHERE description LIKE '%Weather%'; 

 ------------------------------------------------------------------------
-- Q6  Return everything after Weather for the first ten rows. 
-- The start index here is 15, because the CHARINDEX for each row is 8, and the LEN of Weather is 7.
-------------------------------------------------------------------------
-- Complete the substring function to begin extracting from the correct character in the description column
SELECT TOP (10)
  description, 
  CHARINDEX('Weather', description) AS start_of_string, 
  LEN ('Weather') AS length_of_string, 
  SUBSTRING(
    description, 
    15, 
    LEN(description)
  ) AS additional_description 
FROM 
  grids
WHERE description LIKE '%Weather%';