/*
Query all firstnames immediately followed by the first letter in 
the last_name column enclosed in parenthesis.
*/

select * from voters; -- confirm the data

--QUERY 1		-- using CONCAT and LEFT
SELECT
 CONCAT(first_name,' (', LEFT(last_name,1), ')')
FROM voters;

--QUERY 2		-- using CONCAT and SUBSTRING
SELECT
 CONCAT(first_name,' (', SUBSTRING(last_name, 1,1), ')')
FROM voters;