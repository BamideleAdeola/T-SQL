

/* CHALENGE
We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston' */

SELECT * 
FROM patients 
WHERE first_name  LIKE '__r%'			-- First_name contains an 'r' after the first two letters.
 AND gender = 'F'						-- Identifies their gender as 'F'
 AND month(birth_date) IN (2, 5, 12)	-- Born in February, May, or December
 AND weight BETWEEN 60 AND 80			-- Their weight would be between 60kg and 80kg
 AND patient_id % 2 = 1					-- Their patient_id is an odd number
 AND (city = 'Kingston');				-- They are from the city 'Kingston'



 /* CHALLENGE
Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
 */


 SELECT 
  COUNT(*) AS patients_in_group, 
  FLOOR(weight / 10) * 10 as weight_group
FROM patients
group by weight_group
order by weight_group desc;


/* CHALLENGE
Show patient_id, weight, height, isObese from the patients table.
Display isObese as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)2) >= 30.
weight is in units kg.
height is in units cm.
*/

SELECT
  patient_id,
  weight,
  height,
  CASE
  	WHEN weight/(POWER(height/100.0, 2)) >= 30 THEN 1
    ELSE 0
  END AS isObese
FROM patients;



/*
Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

Check patients, admissions, and doctors tables for required information.
*/


SELECT 
  p.patient_id,
  p.first_name,
  p.last_name,
  d.specialty
FROM patients p
INNER JOIN doctors d
  ON p.patient_id = a.patient_id
inner join admissions a
  ON a.attending_doctor_id = d.doctor_id
WHERE 
  a.diagnosis = 'Epilepsy' AND 
  d.first_name = 'Lisa';