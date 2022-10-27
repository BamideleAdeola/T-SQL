--JOINS


SELECT 
  track_id,
  name AS track_name,
  title AS album_title
FROM track
  -- Complete the join type and the common joining column
JOIN album on track.album_id = album.album_id;

-----------------------------------------------------------------------

/* Q2
Select the album_id and title columns from album (the main source table name).
Select the name column from artist and alias it as artist.
Identify a common column between the album and artist tables and perform an inner join.
*/
--------------------------------------------------------------------------

-- Select album_id and title from album, and name from artist
SELECT 
  album_id,
  title,
  name AS artist
  -- Enter the main source table name
FROM album
  -- Perform the inner join
INNER JOIN artist on artist.artist_id = album.artist_id;


-----------------------------------------------------------------------
/* Q3
Qualify the name column by specifying the correct table prefix in both cases.
Complete both INNER JOIN clauses to join album with track, and artist with album.
*/
--------------------------------------------------------------------------

SELECT track_id,
-- Enter the correct table name prefix when retrieving the name column from the track table
  track.name AS track_name,
  title as album_title,
  -- Enter the correct table name prefix when retrieving the name column from the artist table
  artist.name AS artist_name
FROM track
  -- Complete the matching columns to join album with track, and artist with album
INNER JOIN album on track.album_id = album.album_id 
INNER JOIN artist on album.artist_id = artist.artist_id;

-----------------------------------------------------------------------
/* Q4
Complete the LEFT JOIN, returning all rows from the specified columns from invoiceline and any matches from invoice.
*/
--------------------------------------------------------------------------
SELECT 
  invoiceline_id,
  unit_price, 
  quantity,
  billing_state
  -- Specify the source table
FROM invoiceline
  -- Complete the join to the invoice table
LEFT JOIN invoice
ON invoiceline.invoice_id = invoice.invoice_id;


-----------------------------------------------------------------------
/* Q5
ELECT the fully qualified column names album_id from album and name from artist. 
Then, join the tables so that only matching rows are returned (non-matches should be discarded).
*/
--------------------------------------------------------------------------

-- SELECT the fully qualified album_id column from the album table
SELECT 
  album.album_id,
  title,
  album.artist_id,
  -- SELECT the fully qualified name column from the artist table
  artist.name as artist
FROM album
-- Perform a join to return only rows that match from both tables
INNER JOIN artist ON album.artist_id = artist.artist_id
WHERE album.album_id IN (213,214);

-----------------------------------------------------------------------
/* Q6
To complete the query, join the album table to the track table using the relevant fully qualified album_id column. 
The album table is on the left-hand side of the join, and the additional join should return all matches or NULLs.
*/
--------------------------------------------------------------------------

SELECT 
  album.album_id,
  title,
  album.artist_id,
  artist.name as artist
FROM album
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Perform the correct join type to return matches or NULLS from the track table
INNER JOIN track on track.album_id = album.album_id
WHERE album.album_id IN (213,214);

--Joins could be INNER JOIN, LEFT JOIN, RIGHT JOIN, UNION, UNION ALL