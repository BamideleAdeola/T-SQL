
USE TestDb;
GO

CREATE VIEW vtest AS		
SELECT * FROM ratings_dump
WHERE company_location = 'France';

SELECT * FROM vtest;	  -- There is output here because the underlining table is active

DROP TABLE ratings_dump;  -- Drop the attached ratings_dump table

SELECT * FROM vtest;	  -- Invalid Object name 'ratings_dump'




