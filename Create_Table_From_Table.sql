USE TestDb;
GO

/* Write an SQL query to create a ratings_dump table with data structure copied from ratings table.*/

SELECT * INTO ratings_dump		-- Create ratings_dump table and insert data from existing ratings
FROM ratings;

SELECT * FROM ratings_dump;

