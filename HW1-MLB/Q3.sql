SELECT Pitcher_Id,
Name AS Pitcher,
ROUND(SUM(IP), 1) AS tol_innings
FROM pitchers
INNER JOIN players ON Pitcher_Id = Id
INNER JOIN games ON pitchers.Game = games.Game AND YEAR(Date) = 2021
GROUP BY Pitcher_Id
ORDER BY tol_innings DESC
LIMIT 3;

/*
+------------+---------------+-------------+
| Pitcher_Id | Pitcher       | tol_innings |
+------------+---------------+-------------+
|      39251 | W. Buehler    |       222.5 |
|       5403 | A. Wainwright |       209.8 |
|      31267 | Z. Wheeler    |       209.6 |
+------------+---------------+-------------+
*/
