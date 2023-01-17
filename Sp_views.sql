
/* List all Stored Procedures present in a database called TestDb and their object definitions*/
USE TestDb;
GO



--Scan through all system object type
SELECT * FROM SYS.OBJECTS;

-- Retrieve only the name and stored procedure definition
SELECT 
 name AS Procedures, 
 object_definition(object_id) AS [Procedure Definition]
FROM sys.objects 
WHERE type='P';

SELECT * 
FROM sys.sql_modules;