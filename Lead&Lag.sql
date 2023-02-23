USE DataManipulation;
GO
select * from voters;
/*
Write a query that retrieves annual sum of total votes side by side previous year and next year.
And their differences.
*/

SELECT vote_year,
	   sum_total_vote,
	   LAG(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lag,
       LEAD(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lead,
       sum_total_vote - LAG(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lag_difference,
       LEAD(sum_total_vote) OVER (ORDER BY sum_total_vote) - sum_total_vote AS lead_difference
FROM (
SELECT YEAR(first_vote_date) AS vote_year,
	   SUM(total_votes) AS sum_total_vote
FROM voters 
GROUP BY YEAR(first_vote_date)) sub;



SELECT voters_id,
	   sum_total_vote,
	   LAG(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lag,
       LEAD(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lead,
       sum_total_vote - LAG(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lag_difference,
       LEAD(sum_total_vote) OVER (ORDER BY sum_total_vote) - sum_total_vote AS lead_difference
FROM (
SELECT customer_id AS voters_id,
	   SUM(total_votes) AS sum_total_vote
FROM voters 
GROUP BY customer_id) sub;



SELECT voters_id,
	   sum_total_vote,
	   LAG(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lag,
       LEAD(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lead,
       sum_total_vote - LAG(sum_total_vote) OVER (ORDER BY sum_total_vote) AS lag_difference,
       LEAD(sum_total_vote) OVER (ORDER BY sum_total_vote) - sum_total_vote AS lead_difference
FROM (
SELECT customer_id AS voters_id,
	   SUM(total_votes) AS sum_total_vote
FROM voters 
GROUP BY customer_id) sub;



SELECT vote_year,
	   sum_total_vote,
	   LAG(sum_total_vote) OVER (ORDER BY vote_year) AS lag,
       LEAD(sum_total_vote) OVER (ORDER BY vote_year) AS lead,
       sum_total_vote - LAG(sum_total_vote) OVER (ORDER BY vote_year) AS lag_difference,
       LEAD(sum_total_vote) OVER (ORDER BY vote_year) - sum_total_vote AS lead_difference
FROM (
SELECT YEAR(first_vote_date) AS vote_year,
	   SUM(total_votes) AS sum_total_vote
FROM voters 
GROUP BY YEAR(first_vote_date)) sub;