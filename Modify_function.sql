
 /*Modify an existing function dbo.votesfn to remove 10% from total votes field in the voters table*/
USE TestDb
GO

CREATE OR ALTER FUNCTION dbo.votesfn (@votes INT, @Percent INT)
RETURNS INT AS
BEGIN
	RETURN @votes - (@votes * @Percent)/100
END
GO


SELECT * , 
  dbo.votesfn(total_votes, 10) AS Ten_Percent_Minus,	-- Subtracts 10% of total_votes from total votes field
  dbo.votesfn(total_votes, 5) AS Five_Percent_Minus		-- Subtracts 5% 0f total_votes from total votes field
FROM voters
GO
