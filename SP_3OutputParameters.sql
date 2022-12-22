/* Create a Stored Procedure with an output parameter of total sum of votes with an input of country*/

CREATE PROCEDURE GetVotersDetails2
@country VARCHAR(50),
@TotalVote INT OUTPUT  --output parameter

AS
BEGIN
	SELECT @TotalVote = SUM(total_votes) FROM voters 
	WHERE country = @country
END;

--Query 1
DECLARE @tvote INT							--You have to declare the output parameter here before executing SP
EXEC GetVotersDetails2 'USA', @tvote OUT	-- You can either call it out or output
PRINT @tvote								-- Print the declared variable to cal the output

--Query 2
DECLARE @tvote INT							
EXEC GetVotersDetails2 'Denmark', @tvote OUT	
SELECT @tvote	AS sum_of_Denmark_votes		-- You can also use select statement to call the output					