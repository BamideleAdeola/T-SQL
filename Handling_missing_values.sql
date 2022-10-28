
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


/* Q3
Replace missing values in Country with the first non-missing value from IncidentState or City, 
in that order. Name the new column Location.
*/
-- Replace missing values 
SELECT country, COALESCE(Country, IncidentState, City) AS Location
FROM incidents
WHERE country IS NULL;


