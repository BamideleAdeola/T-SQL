-- creating a table
CREATE TABLE mytree
(
N Integer,
P Integer
);
GO

--After creating table, insert below records into the table.

INSERT INTO mytree(N,P) VALUES(1,2);
INSERT INTO mytree(N,P) VALUES(3,2);
INSERT INTO mytree(N,P) VALUES(6,8);
INSERT INTO mytree(N,P) VALUES(9,8);
INSERT INTO mytree(N,P) VALUES(2,5);
INSERT INTO mytree(N,P) VALUES(8,5);
INSERT INTO mytree(N,P) VALUES(5,NULL);
COMMIT;

SELECT * FROM mytree;