
--Retrive Century of date of births from table Centdata

SELECT 
	id,
	date_of_birth,
	1 + (YEAR(date_of_birth) - 1)/100 AS century1,
	(YEAR(date_of_birth) + 99) / 100 as century2
FROM centdata;