
  /* Write an SQL query to fetch the position of a in first_name field of the voters table. 
   Retrieve only instance where a occurs in your output.*/

Select * from voters;

SELECT first_name, CHARINDEX('a' , first_name) AS position_of_a
FROM voters
where CHARINDEX('a' , first_name) != 0;

--
