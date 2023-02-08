
/*Using a table user-defined function retrieve voters who are born in 1990 from the voters table*/
USE TestDb;
GO

CREATE FUNCTION votersDOB (
	@YEAR INT)
RETURNS TABLE
AS
RETURN
  SELECT * FROM 
  voters
  WHERE YEAR(birthdate) = @YEAR
  GO

SELECT * FROM dbo.votersDOB(1990);
