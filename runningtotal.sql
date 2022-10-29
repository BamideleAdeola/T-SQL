/****** Running total using window function ******/
SELECT
id,
Country,
Points,
SUM(Points)
  OVER (ORDER BY id ASC) AS RunningTotal  -- cummulative addition of points
FROM eurovision;