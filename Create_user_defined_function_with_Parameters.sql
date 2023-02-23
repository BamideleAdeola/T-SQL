
/*Create a function that computes dynamic percentage increase to total_votes in the voters table*/
USE TestDb
GO

CREATE FUNCTION dbo.votesfn (@votes INT, @Percent INT)
RETURNS INT AS
BEGIN
	RETURN @votes + (@votes * @Percent)/100
END
GO


SELECT * , 
  dbo.votesfn(total_votes, 10) AS Ten_Percent_Add, 
  dbo.votesfn(total_votes, 5) AS Five_Percent_Add 
FROM voters
GO
