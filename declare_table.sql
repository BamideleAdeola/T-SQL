DECLARE @MyFirstTable TABLE
(ID INT);

DECLARE @MySecondTable TABLE
(ID INT);

INSERT INTO @MyFirstTable
VALUES
(0),
(1),
(2),
(3),
(4),
(5),
(6);

INSERT INTO @MySecondTable
VALUES
(5),
(6),
(7),
(8),
(9),
(10);

-- Retrieve all IDs excluding IDs that are present in both tables.
SELECT ID 
FROM (SELECT ID FROM @MyFirstTable
	  UNION ALL 
	  SELECT ID FROM @MySecondTable) subquery
GROUP BY ID
HAVING COUNT(*) = 1;

-- Retrieve all IDs excluding IDs that are present in both tables.
-- USING EXCEPT FUNCTION
(SELECT ID FROM @MyFirstTable EXCEPT SELECT ID FROM @MySecondTable)
UNION
(SELECT ID FROM @MySecondTable EXCEPT SELECT ID FROM @MyFirstTable);

-- Retrieve all IDs excluding IDs that are present in both tables.
-- USING UNION
(SELECT ID FROM @MyFirstTable UNION SELECT ID FROM @MySecondTable)
EXCEPT
(SELECT ID FROM @MyFirstTable INTERSECT SELECT ID FROM @MySecondTable);

