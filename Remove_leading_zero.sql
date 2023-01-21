-- Remove Leading Zeros in any situation T-SQL
-- A quick script that removes leading zeros in a numeric stored as a string.


--Example 1: - Starts with Zero
--=========
DECLARE @String varchar(30)
SELECT @String = '000067346'
SELECT CASE WHEN ISNUMERIC(@String) = 0 
THEN SUBSTRING (@String,0,CHARINDEX('0',@String)) 
+ SUBSTRING(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''), 
PATINDEX('%[^0]%', REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),'')+'.'), 
LEN(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''))) 
ELSE SUBSTRING(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''), 
PATINDEX('%[^0]%', REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),'')+'.'), 
LEN(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''))) 
END AS No_preceding_zeros
GO


--Example 2: - Starts with Text but still has leading zeros
--=========
DECLARE @String VARCHAR(30)
SELECT @String = 'GOD00000000247'
SELECT CASE WHEN ISNUMERIC(@String) = 0 
THEN SUBSTRING (@String,0,CHARINDEX('0',@String)) + SUBSTRING(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''), 
PATINDEX('%[^0]%', REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),'')+'.'), 
LEN(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''))) 
ELSE SUBSTRING(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''), 
PATINDEX('%[^0]%', REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),'')+'.'), 
LEN(REPLACE(@String,SUBSTRING (@String,0,CHARINDEX('0',@String)),''))) 
END AS No_inner_zeros
GO