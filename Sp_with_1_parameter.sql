
-- Stored procedure with a single parameter without NOCOUNT Condition

CREATE PROCEDURE voters_vote(@min_vote AS INT)		-- Single parameter @min_vote
AS
BEGIN		-- Begin block
	SELECT first_name, gender, country, total_votes
	FROM voters
	WHERE total_votes >= @min_vote					-- Dynamic imputation here
	ORDER BY total_votes DESC
END;		-- End block

EXEC voters_vote 100		-- This returns voters >= 100

-- Stored procedure with a single parameter with NOCOUNT Condition
CREATE PROCEDURE least_vote(@min_vote AS INT)		-- Single parameter @min_vote
AS
SET NOCOUNT ON  
BEGIN		-- Begin block
	SELECT first_name, gender, country, total_votes
	FROM voters
	WHERE total_votes >= @min_vote					-- Dynamic imputation here
	ORDER BY total_votes DESC
END;		-- End block

EXEC least_vote 100;	-- This returns total_vote >= 100

EXEC least_vote 180;	-- Returns total_vote >= 180




