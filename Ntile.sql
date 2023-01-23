USE DataManipulation;
GO
select * from voters;


--Changing the previous customer_id to voter_id
-------------------------------------------
--EXEC sp_rename 'voters.customer_id', 'voter_id';

/*
Divide voters into 4 levels in terms of the total_votes. 
Your resulting table should have the voters_id, first_vote_date, the total_votes, 
and one of four levels in a standard_quartile column.
*/


SELECT
    voter_id,
    first_vote_date,
    total_votes,
    NTILE(4) OVER (PARTITION BY voter_id ORDER BY total_votes) AS standard_quartile
FROM voters
ORDER BY voter_id DESC;




SELECT voter_id + total_votes
FROM voters
