				---------------------------------
					--  COMMON TABLE EXPRESSION -- CTE
				---------------------------------
/*
Can be used multiple times
It makes codes easier to read
It allows for removal of tautology. 

*/
--Create a CTE to retrieve Maximum Blood Pressure per Age
WITH BloodpressureAge(Age, MaxBloodPressure)
AS 
(SELECT Age, MAX(BloodPressure) AS MaxBloodPressure
FROM kidney 
GROUP BY Age)

-- Create a query where earlier created CTE can be used as a table
SELECT a.Age, MIN(a.BloodPressure) AS MinBloodPressure, b.MaxBloodPressure
FROM kidney a
JOIN BloodpressureAge b
ON a.Age = b.Age
GROUP BY a.Age, b.MaxBloodPressure;


/* Q1
Create a CTE BloodGlucoseRandom that returns one 
column (MaxGlucose) which contains the maximum 
BloodGlucoseRandom in the table.

Join the CTE to the main table (Kidney) on 
BloodGlucoseRandom and MaxGlucose.*/

-- Specify the keyowrds to create the CTE
WITH BloodGlucoseRandom (MaxGlucose) 
AS (SELECT MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney)

SELECT a.Age, b.MaxGlucose
FROM Kidney a
-- Join the CTE on blood glucose equal to max blood glucose
JOIN BloodGlucoseRandom b
ON a.BloodGlucoseRandom = b.MaxGlucose;



/* Q2
Create a CTE BloodPressure that returns one column (
MaxBloodPressure) which contains the maximum 
BloodPressure in the table.

Join this CTE (using an alias b) to the main table (
Kidney) to return information about patients with the 
maximum BloodPressure.*/


-- Create the CTE
WITH BloodPressure (MaxBloodPressure) 
AS (SELECT MAX(BloodPressure) AS MaxBloodPressure FROM Kidney)

SELECT *
FROM Kidney a
-- Join the CTE  
JOIN BloodPressure b
ON a.BloodPressure = b.MaxBloodPressure;


