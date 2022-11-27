/* Total Votes
Retrieve a list of voters in voters table having a total_votes 
greater than 100 per vote and in Denmark, USA and United Kingdom. 
Sort your result by ascending customer_id.
*/
SELECT 
  customer_id,
  first_name,
  last_name,
  total_votes,
  country
FROM voters
WHERE total_votes > 100
AND country IN ('Denmark', 'USA', 'United Kingdom')
ORDER BY customer_id;