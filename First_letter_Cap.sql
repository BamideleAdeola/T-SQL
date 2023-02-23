USE TestDb;
GO

--UPDATE voters
--SET first_name = replace(first_name, 'A', 'a')

--UPDATE voters
--SET first_name = replace(first_name, 'G', 'g')

--UPDATE voters
--SET first_name = replace(first_name, 'M', 'm')
  /* Write an SQL query to fetch the lower, all capital and first letter capital 
  letter of first_name field of the voters table. */

SELECT first_name, 
	LOWER(first_name) AS lowercase,
	UPPER(first_name) AS uppercase,
	UPPER(LEFT(first_name,1)) + SUBSTRING(first_name, 2, LEN(first_name)) AS FirstletterCaps  --First letter Capital
FROM voters;


