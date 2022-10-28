CREATE TABLE eurovision(
ID SERIAL,
EventYear INTEGER,
Country VARCHAR(126),
Gender CHAR(10),
GroupType CHAR(6),
Place INTEGER,
Points INTEGER,
HostCountry CHAR(5),
HostRegion CHAR(5),
IsFinal INTEGER,
SFNumber INTEGER,
SongInEnglish INTEGER
);

SELECT * FROM eurovision;
