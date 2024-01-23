
/*Create a scalar function that adds 1000 to a given input in SQL server*/

CREATE FUNCTION dbo.Add1000 (@var INT)
RETURNS INT AS
BEGIN
	RETURN @var + 1000
END
GO

--
-- Select the function with 200 as parameter, this should return 1200

SELECT dbo.Add1000(200)
GO
