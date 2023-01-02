/* CHALLENGE
Pull all columns for the voter(s) who matches the following criteria:
- First_name contains  'a' after the first two letters.
- Male gender 'M'
- Born in February, June, or December
- Total votes between 50 and 130
- customer_id is an odd number
- Having a country of 'Switzerland' 
*/

SELECT * 
FROM voters 
WHERE first_name  LIKE '__a%'				-- First_name contains an 'r' after the first two letters.
 AND gender = 'M'							-- Identifies their gender as 'F'
 AND month(birthdate) IN (2, 6, 12)			-- Born in February, June, or December
 AND total_votes BETWEEN 50 AND 130			-- Their total votes would be between 50 and 130
 AND customer_id % 2 = 1					-- Their customer_id is an odd number
 AND (country = 'Switzerland');				-- They are from the country 'Switzerland'