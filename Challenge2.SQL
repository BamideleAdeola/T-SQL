 
 USE DataManipulation;
 
 /* CHALLENGE
Show all of the voters grouped into voting_group of their total_votes.
Show the total no of voters in each voting_group.
Order the list by the vote_group in decending Order.

e.g, if total vote is between 10 to 19 they are placed rounded down to 10 voting_group, 
20-29 = 20 voting_group, 100-109 = 100 voting_group, etc.
 */
 
 SELECT 
  FLOOR(total_votes / 10) * 10 AS voting_group,
  COUNT(*) AS voters_in_each_group
FROM voters
GROUP BY FLOOR(total_votes / 10) * 10
ORDER BY voting_group DESC;

SELECT 
  CAST(total_votes / 10 AS decimal) * 10 AS voting_group,
  COUNT(*) AS voters_in_each_group
FROM voters
GROUP BY CAST(total_votes / 10 AS decimal) * 10
ORDER BY voting_group DESC;