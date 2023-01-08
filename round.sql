
/* Round 248774 to 249000 in #SQL 
- Round, Ceiling and Floor function*/

SELECT 
ROUND(248774, -3) AS round_no_5above,	--5-9 rounded up as 1  
ROUND(248374, -3) AS round_no_below_5;	--0-4 is rounded down as 0

SELECT 
CEILING(547.34)	AS Ceiling_Value,	-- Approximates upwards
FLOOR(547.34) AS Floor_value;		-- Removes decimal values and return the integer values