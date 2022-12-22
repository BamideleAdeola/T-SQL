/*Create a stored procedure with a default parameter total_votes of 145 from the voters table*/

-- Stored procedure with a default parameter

CREATE PROCEDURE Voters_withDefaultParameters(@vta AS INT = 145)		--default of 145
AS
SET NOCOUNT ON  
BEGIN
	SELECT first_name, gender, country, total_votes
	FROM voters
	WHERE total_votes = @vta					
	ORDER BY total_votes DESC
END;

EXEC Voters_withDefaultParameters;	-- This returns total_vote = 145 (Since 145 is the default parameter)

EXEC Voters_withDefaultParameters 110;	-- Specifying a parameter different from the default

select * from voters;

