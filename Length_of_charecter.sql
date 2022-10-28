 SELECT 
	DISTINCT country,
	LEN(Country) AS 'Country Length'
FROM dbo.eurovision
WHERE LEN(Country) > 8;