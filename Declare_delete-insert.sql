-- 9 -- 
------------------------------
-- INSERT, UPDATE, DELCARE AND DELETE RECORDS
------------------------------

/* Q1
Create a table called tracks with 2 VARCHAR columns named track and album, 
and one integer column named track_length_mins. 
Then SELECT all columns from your new table using the * shortcut to verify the table structure.

*/

-- Create the table
CREATE TABLE tracks(
	-- Create track column
	track VARCHAR(200),
    -- Create album column
  	album VARCHAR(160),
	-- Create track_length_mins column
	track_length_mins INT
);
-- Select all columns from the new table
SELECT 
  * 
FROM 
  tracks;


/* Q2
Insert the track 'Basket Case', from the album 'Dookie', with a track length of 3, 
into the appropriate columns. Then perform the SELECT * once more to view your newly inserted row.
*/

-- Create the table
CREATE TABLE tracks(
  -- Create track column
  track VARCHAR(200), 
  -- Create album column
  album VARCHAR(160), 
  -- Create track_length_mins column
  track_length_mins INT
);
-- Complete the statement to enter the data to the table         
INSERT INTO tracks
-- Specify the destination columns
(track, album, track_length_mins)
-- Insert the appropriate values for track, album and track length
VALUES
  ('Basket Case', 'Dookie', 3);
-- Select all columns from the new table
SELECT 
  *
FROM 
  tracks;

-------------------
-- UPDATE ---
-------------------

-- Q1 Select the title column from the album table where the album_id is 213.

-- Select the album
SELECT 
  title 
FROM 
  album 
WHERE 
  album_id = 213;

  ----------------------------
 -- Q2 That's a very long album title, isn't it? Use an UPDATE statement to modify the title to 'Pure Cult: The Best Of The Cult'.
 ------------------------------
  -- Run the query
SELECT 
  title 
FROM 
  album 
WHERE 
  album_id = 213;
-- UPDATE the album table
UPDATE 
  album
-- SET the new title    
SET 
  title = 'Pure Cult: The Best Of The Cult'
WHERE album_id = 213;


-----------------------------
     --  DELETE --
-----------------------------

-- Q1 DELETE the record from album where album_id is 1 and then hit 'Submit Answer'.

-- Run the query
SELECT 
  * 
FROM 
  album 
  -- DELETE the record
DELETE FROM 
  album 
WHERE 
  album_id = 1 
  -- Run the query again
SELECT 
  * 
FROM 
  album;


-----------------------------
     --  DECLARE YOURSELF -- you can declare int or string
-----------------------------

-- To avoid repetition, create a variable
DECLARE @test_int INT
SET @test_int = 3

--or

DECLARE @my_artist VARCHAR(100)
SET @my_artist = 'AC/DC'

---------------------------------------------
-- Q1 DECLARE the variable @region, which has a data type of VARCHAR and length of 10.
---------------------------------------------
-- Declare the variable @region
DECLARE @region VARCHAR(10)


---------------------------------------------
-- Q2 SET your newly defined variable to 'RFC'.
---------------------------------------------
-- Declare the variable @region
DECLARE @region VARCHAR(10)

-- Update the variable value
SET @region = 'RFC'

---------------------------------------------
-- Q3 TEST IT OUT.
---------------------------------------------
-- Declare the variable @region
DECLARE @region VARCHAR(10)

-- Update the variable value
SET @region = 'RFC'

SELECT description,
       nerc_region,
       demand_loss_mw,
       affected_customers
FROM grid
WHERE nerc_region = @region;


---------------------------------------------
-- Q4 Declare a new variable called @start of type DATE.
---------------------------------------------
-- Declare @start
DECLARE @start DATE

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'

---------------------------------------------
-- Q5 Declare a new variable called @stop of type DATE.
---------------------------------------------

-- Declare @start
DECLARE @start DATE

-- Declare @stop
DECLARE @stop DATE

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'

-- SET @stop to '2014-07-02'
SET @stop = '2014-07-02'

---------------------------------------------
-- Q5 Declare a new variable called @affected of type INT.
---------------------------------------------
-- Declare @start
DECLARE @start DATE

-- Declare @stop
DECLARE @stop DATE

-- Declare @affected
DECLARE @affected INT

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'

-- SET @stop to '2014-07-02'
SET @stop  = '2014-07-02'

-- Set @affected to 5000
SET @affected = 5000

---------------------------------------------
-- Q6 Retrieve all rows where event_date is BETWEEN @start and @stop and affected_customers is greater than or equal to @affected.
---------------------------------------------
-- Declare your variables
DECLARE @start DATE
DECLARE @stop DATE
DECLARE @affected INT;
-- SET the relevant values for each variable
SET @start = '2014-01-24'
SET @stop  = '2014-07-02'
SET @affected =  5000 ;

SELECT 
  description,
  nerc_region,
  demand_loss_mw,
  affected_customers
FROM 
  grid
-- Specify the date range of the event_date and the value for @affected
WHERE event_date BETWEEN @start  AND @stop
AND affected_customers >= @affected;


---------------------------------------------
/* Q7 
Insert data via a SELECT statement into a temporary table called #maxtracks.
Join album to artist using artist_id, and track to album using album_id.
Run the final SELECT statement to retrieve all the columns from your new table.*/
---------------------------------------------

SELECT  album.title AS album_title,
  artist.name as artist,
  MAX(track.milliseconds / (1000 * 60) % 60 ) AS max_track_length_mins
-- Name the temp table #maxtracks
INTO #maxtracks
FROM album
-- Join album to artist using artist_id
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Join track to album using album_id
INNER JOIN track ON track.album_id = album.album_id
GROUP BY artist.artist_id, album.title, artist.name,album.album_id
-- Run the final SELECT query to retrieve the results from the temporary table
SELECT album_title, artist, max_track_length_mins
FROM  #maxtracks
ORDER BY max_track_length_mins DESC, artist;