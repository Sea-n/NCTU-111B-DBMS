SELECT Name AS Hitter,
       ROUND(AVG(num_P / (BB+K+AB)), 4) AS `avg_P/PA`,
       AVG(AB) AS avg_AB, AVG(BB) AS avg_BB, AVG(K) AS avg_K,
       SUM(BB+K+AB) AS tol_PA
FROM hitters
INNER JOIN players ON Hitter_Id = players.Id
WHERE AB > 0
GROUP BY Hitter_Id, Name
HAVING tol_PA >= 20
ORDER BY `avg_P/PA` DESC
LIMIT 3;

/*
+----------------+----------+--------+--------+--------+--------+
| Hitter         | avg_P/PA | avg_AB | avg_BB | avg_K  | tol_PA |
+----------------+----------+--------+--------+--------+--------+
| E. Butler      |   4.2101 | 1.3913 | 0.0870 | 0.3478 |     42 |
| C. Quantrill   |   4.1852 | 1.5000 | 0.0556 | 0.3333 |     34 |
| N. Margevicius |   3.9861 | 1.2500 | 0.0000 | 0.5833 |     22 |
+----------------+----------+--------+--------+--------+--------+
*/
