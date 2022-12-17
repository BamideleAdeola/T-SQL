
 /*Query the list of voters firstname starting with vowels (a, e, i, o, u) from voters table. 
Your result cannot contain duplicates.*/

--Query 1 -- using wildcard function
SELECT DISTINCT first_name
FROM voters
WHERE first_name LIKE '[a,e,i,o,u]%';

--Query 2 -- Using left function
SELECT DISTINCT first_name
FROM voters
WHERE LEFT (first_name, 1) IN ('a','e','i','o','u');

--Query 3 -- Using substring function
SELECT DISTINCT first_name
FROM voters
WHERE SUBSTRING(first_name, 1, 1) IN ('a','e','i','o','u');

