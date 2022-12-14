USE sql_server_test_data;

select * from shipments;
-- Retrieve first orderdate of each Mixid and clean the date approprately
SELECT 
	MixId,
	MIN(OrderDate) AS first_orderdate
FROM shipments
GROUP BY MixId;
--------------------------------------------------------------------------
SELECT 
	MixId,
	CAST(MIN(OrderDate) AS DATETIME) AS first_orderdate
FROM shipments
GROUP BY MixId;
-------------------------------------------------------------------------
/*
How would you go about finding the most common order day (Day of Week) of a MixID in the last 30 days.

For example, MixID may have a pattern of ordering on Fridays.
*/

SELECT 
	TOP (1) MixId,
	DATENAME(WEEKDAY, OrderDate) as WeekDay, 
	COUNT(*) AS orders
FROM shipments 
GROUP BY MixId, DATENAME(WEEKDAY, OrderDate)
OrDER BY COUNT(*) DESC;