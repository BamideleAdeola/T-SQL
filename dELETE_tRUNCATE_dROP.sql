USE TestDb;

DELETE FROM Orders
WHERE OrderID = 5; -- Deleterows with OrderID = 5

DELETE FROM Orders; -- Delete all datafrom Orders without deleting table

TRUNCATE TABLE Orders; -- Delete all datasets leaving the table structure

DROP TABLE Orders;  -- Remove table and datasets