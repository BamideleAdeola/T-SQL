
------------------------------
-- Dealing with missing values
------------------------------

-- ISNULL and COALESCE FUNCTION

/* Q1
Write a T-SQL query which returns only the IncidentDateTime 
and IncidentState columns where IncidentState is not missing.
*/

-- Return the specified columns
SELECT IncidentDateTime, IncidentState
FROM Incidents
-- Exclude all the missing values from IncidentState  
WHERE IncidentState IS NOT NULL;


/* Q2
Write a T-SQL query which only returns rows where IncidentState is missing.
Replace all the missing values in the IncidentState column with 
the values in the City column and name this new column Location.
*/

SELECT IncidentState, ISNULL(IncidentState, City) AS Location
FROM Incidents
-- Filter to only return missing values from IncidentState
WHERE IncidentState IS NULL;