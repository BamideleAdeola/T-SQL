USE DataManipulation;
GO

SELECT * FROM voters;

--Write a query to retrieve column names and data types of the voters table.

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'voters';


exec sp_help voters;


SELECT TABLE_NAME,COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'voters'