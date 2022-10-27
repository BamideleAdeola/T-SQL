
-- correlation using statistical formular seen in books
SELECT ((SUM(x * y) -- sum of product
			- (SUM(x) * SUM(y)) -- product of sum     
			/ COUNT(*)) -- count of no
   )
   / (SQRT(SUM(x * x)

           - (SUM(x) * SUM (x)) / COUNT(*)
          )

      * SQRT(SUM(y * y)

             - (SUM(y) * SUM(y)) / COUNT(*)

            )

     ) AS Pearsons_Corr
 FROM correlation;

 -- CORRELATION COEFFICIENT
----------------------------
 /* there is built-in StDevP function giving the
  statistical standard deviation for the population for all values */

 SELECT (Avg(x * y) - (Avg(x) * Avg(y))) / (StDevP(x) * StDevP(y)) AS Pearsons_corr
  FROM correlation;