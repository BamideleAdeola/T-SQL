 /* Create a view to store matches played in 2011 */

  CREATE VIEW Matches_2011 AS
  SELECT * FROM eurovis
  WHERE EventYear = 2011;

  SELECT * FROM Matches_2011;	-- Display the data in a view


