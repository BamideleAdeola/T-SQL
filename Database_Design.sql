
/*
cars_rented holds one or more car_ids and invoice_id holds multiple values. Create a new table to hold individual car_ids and invoice_ids of the customer_ids who've rented those cars.
Drop two columns from customers table to satisfy 1NF
*/


-- Create a new table to hold the cars rented by customers
CREATE TABLE cust_rentals (
  customer_id INT NOT NULL,
  car_id VARCHAR(128) NULL,
  invoice_id VARCHAR(128) NULL
);

-- Drop column from customers table to satisfy 1NF
ALTER TABLE customers
DROP COLUMN cars_rented,
DROP COLUMN premium_member;


/*
Create a new table for the non-key columns that were conflicting with 2NF criteria.
Drop those non-key columns from customer_rentals
*/

-- Create a new table to satisfy 2NF
CREATE TABLE cars (
  car_id VARCHAR(256) NULL,
  model VARCHAR(128),
  Manufacturer VARCHAR(128),
  type_car VARCHAR(128),
  condition VARCHAR(128),
  color VARCHAR(128)
);

-- Drop columns in customer_rentals to satisfy 2NF
ALTER TABLE customer_rentals
DROP COLUMN end_date,
DROP COLUMN start_date, 
DROP COLUMN color,
DROP COLUMN type_car,
DROP COLUMN condition;


/*
Create a new table for the non-key columns that were conflicting with 3NF criteria.
Drop those non-key columns from rental_cars.

*/
-- Create a new table to satisfy 3NF
CREATE TABLE car_model(
  model VARCHAR(128),
  manufacturer VARCHAR(128),
  type_car VARCHAR(128)
);

-- Drop columns in rental_cars to satisfy 3NF
ALTER TABLE rental_cars
DROP COLUMN condition, 
DROP COLUMN color;


-------------------------
--DATABASE VIEWS
------------------------
/*
--A view is a virtual table that is not part of the physical schema
Query not data is stored in the memory
Data is aggregated from  data in tables 
can be queried like a regular database
No need to retype common queries or alter schemas


running a view in POSTGRESQL IS DIFFERENT FROM SQL SERVER

SELECT * FROM INFORMATION.SCHEMA,views  --POSGRESQL 
SELECT * FROM views -- SQL SERVER


To exclude system views

SELECT * FROM INFORMATION.SCHEMA,views
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

*/

/*
Query the information schema to get views.
Exclude system views in the results.
*/
-- Get all non-systems views
SELECT * FROM information_schema.views
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

/*
Create a view called high_scores that holds reviews with scores above a 9.
*/

-- Create a view for reviews with a score above 9
CREATE VIEW high_scores AS
SELECT * FROM reviews
WHERE score > 9;

/*
Count the number of records in high_scores that are self-released in the label field of the labels table.
*/

-- Create a view for reviews with a score above 9
CREATE VIEW high_scores AS
SELECT * FROM REVIEWS
WHERE score > 9;

-- Count the number of self-released works in high_scores
SELECT COUNT(*) FROM high_scores
INNER JOIN labels ON high_scores.reviewid = labels.reviewid
WHERE labels.label = 'self-released';


---------------------------------
--GRANT AND REVOKING ACCESS TO A VIEW
-----------------------------------

/*

GRANT privilege(s) or REVOKE privilege(s)
privileges: SELECT, INSERT, UPDATE, DELETE, ETC


*/

GRANT UPDATE ON ratings TO PUBLIC;
REVOKE INSERT ON films FROM db_user;



/*
Create a view called top_artists_2017 with artist from artist_title.
To only return the highest scoring artists of 2017, join the views top_15_2017 and artist_title on reviewid.
Output top_artists_2017.
*/

-- Create a view with the top artists in 2017
CREATE VIEW top_artists_2017 AS
-- with only one column holding the artist field
SELECT artist_title.artist FROM artist_title
INNER JOIN top_15_2017
ON top_15_2017.reviewid = artist_title.reviewid;

-- Output the new view
SELECT * FROM top_artists_2017;


/*
Revoke all database users' update and insert privileges on the long_reviews view.
Grant the editor user update and insert privileges on the long_reviews view.
*/

-- Revoke everyone's update and insert privileges
REVOKE UPDATE, INSERT ON long_reviews FROM PUBLIC; 

-- Grant the editor update and insert privileges 
GRANT UPDATE, INSERT ON long_reviews TO editor; 


/*
Use CREATE OR REPLACE to redefine the artist_title view.
Respecting artist_title's original columns of reviewid, title, and artist, add a label column from the labels table.
Join the labels table using the reviewid field.

*/
-- Redefine the artist_title view to have a label column
CREATE OR REPLACE view artist_title AS
SELECT reviews.reviewid, reviews.title, artists.artist, labels.label
FROM reviews
INNER JOIN artists
ON artists.reviewid = reviews.reviewid
INNER JOIN labels
ON labels.reviewid = reviews.reviewid;

SELECT * FROM artist_title;



-------------------
--MATERIALIZE VIEW
-----------------

/*

IN POSGRESQL

CREATE MATERIALIZED VIEW my_vv AS SELECT * FROM existing_table;


REFRESH MATERIALIZED VIEW my_vv;
*/


/*
Create a materialized view called genre_count that holds the number of reviews for each genre.
Refresh genre_count so that the view is up-to-date.
*/

-- Create a materialized view called genre_count 
CREATE MATERIALIZED VIEW genre_count AS
SELECT genre, COUNT(*) 
FROM genres
GROUP BY genre;

INSERT INTO genres
VALUES (50000, 'classical');

-- Refresh genre_count
REFRESH MATERIALIZED VIEW genre_count;

SELECT * FROM genre_count;



-------------------------------------------------
--DATABASE ROLES AND ACCESS CONTROLS
-----------------------------------------------
/*
--Database Roles
Roles are used to manage database access permissions
A database role is an entity that contains informations that:
1 Define role privileges
a. can you login
b.  can you create databases
c. can you write to tables

2. Interact with the client authentification system
a. Password

3. Roles can be assigned to one or more users

4. Roles are global across a database cluster installation
*/


CREATE ROLE data_analyst;

CREATE ROLE interns WITH PASSWORD 'PasswordForInterns' VALID UNTIL '2022-12-31';


CREATE ROLE admin CREATEDB;

-- To change the roles of already created roles

ALTER ROLE admin CREATEROLE;

GRANT UPDATE ON ratings TO data_analyst;
REVOKE UPDATE ON ratings FROM data_analyst;


/* USER or GROUP ROLE

*/

GRANT data_analyst TO Bamidele;
REVOKE data_analyst FROM Bamidele;


/* 1
Create a role called data_scientist.
*/
-- Create a data scientist role
CREATE ROLE data_scientist;

/* 2
Create a role called marta that has one attribute: the ability to login (LOGIN).
*/
-- Create a role for Marta
CREATE ROLE Marta LOGIN;

/* 3
Create a role called admin with the ability to create databases (CREATEDB) and to create roles (CREATEROLE).
*/
-- Create an admin role
CREATE ROLE admin WITH CREATEDB CREATEROLE;


/* Grant/Revoke permission
Grant the data_scientist role update and insert privileges on the long_reviews view.
Alter Marta's role to give her the provided password.
*/

-- Grant data_scientist update and insert privileges
GRANT UPDATE, INSERT ON long_reviews TO data_scientist;

-- Give Marta's role a password
ALTER ROLE marta WITH PASSWORD 's3cur3p@ssw0rd';


/* Add a user role to a group role
Add Marta's user role to the data scientist group role.
Celebrate! You hired multiple data scientists.
Remove Marta's user role from the data scientist group role.
*/

-- Add Marta to the data scientist group
GRANT data_scientist TO Marta;

-- Celebrate! You hired data scientists.

-- Remove Marta from the data scientist group
REVOKE data_scientist FROM Marta;



-----------------------------------
--TABLE PARTITIONING
------------------------------------
/*
Create a new table film_descriptions containing 2 fields: film_id, 
which is of type INT, and long_description, which is of type TEXT.

Occupy the new table with values from the film table.
*/

-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Copy the descriptions from the film table
INSERT INTO film_descriptions
SELECT film_id, long_description FROM film;


/*
Drop the field long_description from the film table.
Join the two resulting tables to view the original table.

*/
-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Copy the descriptions from the film table
INSERT INTO film_descriptions
SELECT film_id, long_description FROM film;
    
-- Drop the descriptions from the original table
ALTER TABLE film DROP COLUMN long_description;

-- Join to view the original table
SELECT * FROM film 
JOIN film_descriptions USING(film_id);


/*
Create the table film_partitioned, partitioned on the field release_year.
*/

-- Create a new table called film_partitioned
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);


/*
Create three partitions: one for each release year: 
2017, 2018, and 2019. Call the partition for 2019 film_2019, etc.

*/

-- Create a new table called film_partitioned
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);

-- Create the partitions for 2019, 2018, and 2017
CREATE TABLE film_2019
	PARTITION OF film_partitioned FOR VALUES IN ('2019');

CREATE TABLE film_2018
	PARTITION OF film_partitioned FOR VALUES IN ('2018');

CREATE TABLE film_2017
	PARTITION OF film_partitioned FOR VALUES IN ('2017');


/*
Occupy the new table, film_partitioned, with the three fields required from the film table.
*/
-- Create a new table called film_partitioned
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);

-- Create the partitions for 2019, 2018, and 2017
CREATE TABLE film_2019
	PARTITION OF film_partitioned FOR VALUES IN ('2019');

CREATE TABLE film_2018
	PARTITION OF film_partitioned FOR VALUES IN ('2018');

CREATE TABLE film_2017
	PARTITION OF film_partitioned FOR VALUES IN ('2017');

-- Insert the data into film_partitioned
INSERT INTO film_partitioned
SELECT film_id, title, release_year FROM film;

-- View film_partitioned
SELECT * FROM film_partitioned;


-------------------------
--DATA INTEGRATION
-------------------------
/*
Data Integration combines data from different sources, formats , technologies to provide users
with a translated and unified view of that data
1. 360 - degree system view
2. Acquisition
3. Legacy system


----------------------------------
DATABASE MANAGEMENT SYSTEMS (DBMs)
----------------------------------
1. Creating and maintaining Databses
--- It manages 3 important thing
a. Data
b. Database Schema
c. Database Engine

2. It serves as an interface between database and end users

TWO(S) TYPES OF DBMMS
A. SQLDBMS - 
B. NOSQL DBMS
-----------------------------

A. SQLDBMS - - Relational Database Management System
- Based on relational model of data
- Query Language = SQ

B. NoSQL DBMS - Non Relational DBMS
- Less structured
- Document centered rather than table centered
- Data doesnt have to fit into well-defined rows and columns
- Best options for companies experiencing
	- Rapid growth
	- No clear schema definitions
	- Large qty of data
Types of NoSQL
1. Key-Value store
2.Document Store
3.. Columnar Database
4. Graph Database
Redis
e.g MongoDB, Cassandra(Graph)







