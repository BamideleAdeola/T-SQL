-- 7 -- 
------------------------------
-- UNION AND UNION ALL
------------------------------

/*-- Q1
Make the first selection from the album table. 
Then join the results by providing the relevant keyword and selecting from the artist table*/

SELECT 
  album_id AS ID,
  title AS description,
  'Album' AS Source
  -- Complete the FROM statement
FROM Album
 -- Combine the result set using the relevant keyword
UNION
SELECT 
  artist_id AS ID,
  name AS description,
  'Artist'  AS Source
  -- Complete the FROM statement
FROM Artist;

/*-- Q2
Make the first selection from the album table. 
Then join the results by providing the relevant keyword and selecting from the artist table keeping duplicates*/

SELECT 
  album_id AS ID,
  title AS description,
  'Album' AS Source
  -- Complete the FROM statement
FROM Album
 -- Combine the result set using the relevant keyword
UNION ALL  --union all helps to keep all duplicates
SELECT 
  artist_id AS ID,
  name AS description,
  'Artist'  AS Source
  -- Complete the FROM statement
FROM Artist;