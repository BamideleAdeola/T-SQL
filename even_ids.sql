
/*Retrieve a list of first and last names of voters with an even customer_id number. 
Exclude duplicates from the output*/

SELECT 
  DISTINCT  customer_id, first_name, last_name
FROM voters
WHERE customer_id % 2 = 0; -- remainder 0 for even numbers