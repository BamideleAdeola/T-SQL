--CREATE NBA PLAYERS STATISTICS TABLE
CREATE TABLE NbaPlayerStats (
PlayerName VARCHAR (50),
Team CHAR (4),
Position CHAR(3),
GamesPlayed INT,
MinutesPlayed INT,
ThreePoints INT,
TwoPoints INT,
OffRebound INT,
DefRebound INT,
Assists INT,
Steals INT,
Blocks INT,
TurnOvers INT,
TotalPoints INT
);
GO

BULK INSERT NbaPlayerStats
FROM 'C:\Users\User\Downloads\NBAPlayerStatistics.csv'
WITH 
(
	FORMAT = 'CSV',
	FIRSTROW = 2
);
GO

SELECT * FROM NbaPlayerStats;


