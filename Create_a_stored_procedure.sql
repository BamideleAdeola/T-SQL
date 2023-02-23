/* Create a stored procedure for france voters from the voters table */

CREATE PROCEDURE FranceVoters
 
AS
	SELECT * FROM voters
	WHERE country = 'France';
GO

EXEC FranceVoters;