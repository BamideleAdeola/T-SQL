USE TestDb;
GO

CREATE TABLE CapitalTrips (
Duration INT,
Start_date SMALLDATETIME,
End_date SMALLDATETIME,
Start_station_number INT,
Start_station VARCHAR (150),
End_station_number INT,
End_station VARCHAR (150),
Bike_number VARCHAR (150),
Member_type VARCHAR (20)
);

GO

BULK INSERT CapitalTrips
FROM 'C:\Users\User\Documents\all_SQL_tasks\T-SQL\capitalTrips.csv'
WITH
(
		FORMAT = 'CSV',
		FIRSTROW =  2
);
GO

