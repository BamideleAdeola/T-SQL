
-- Delete 3 characters from a string, starting in position 1, and then insert "HTML" in position 1:
SELECT STUFF('SQL Tutorial', 1, 3, 'HTML');

SELECT 
    STUFF('SQL Tutorial', 1 , 3, 'SQL Server') result;


SELECT 
    STUFF('1230', 3, 0, ':') AS formatted_time;

SELECT 
    STUFF(STUFF('03102019', 3, 0, '/'), 6, 0, '/') formatted_date;


SELECT * FROM voters;

  /* Write an #SQL #query to replace the first two characters in first_name field of voters table with the string 'Mr. '*/
SELECT 
	first_name,
	STUFF(first_name, 1, 2,'Mr. ')
FROM voters;