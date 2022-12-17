USE TestDb;
GO

/* Write a query  that returns the node type ordered by the value of nodes in ascending order. 
There are 3 types.
Root — if the node is a root
Leaf — if the node is a leaf
Inner — if the node is neither root nor leaf.*/

-- QUERY 1
SELECT CASE
    WHEN P IS NULL THEN CONCAT(N, ' Root')
    WHEN N IN (SELECT DISTINCT P FROM mytree) THEN CONCAT(N, ' Inner')
    ELSE CONCAT(N, ' Leaf') 
    END AS Node_Type
FROM mytree
ORDER BY N ASC;


select * from mytree;

SELECT CASE
		WHEN 


