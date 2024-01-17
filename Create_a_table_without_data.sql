
USE TestDb;
GO

/* Write an SQL query to create a Blank_table using ratings table structure.*/

SELECT * INTO blank_table
FROM ratings
WHERE 1 = 0;		-- This removes every data on the ratings table

SELECT * FROM blank_table;

--Creating a table without data 
