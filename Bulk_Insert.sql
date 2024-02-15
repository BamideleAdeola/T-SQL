/* Bulk Insert eurovis.csv located in downloads into a table dbo.eurovis 
Remove previous data and load the new dataset*/

-- truncate the table first
TRUNCATE TABLE dbo.eurovis;
GO
 
-- Import a CSV from my download file
BULK INSERT dbo.eurovis
FROM 'C:\Users\User\Downloads\eurovis.csv'
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)
GO

SELECT * FROM dbo.eurovis; --
