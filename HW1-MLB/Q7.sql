SELECT t1.Team, Hitter, avg_hit_rate, tol_hit, win_rate
FROM (
    SELECT Team, SUM(win) / SUM(ttl) AS win_rate FROM (
        SELECT home AS Team, 0 AS win, COUNT(1) AS ttl FROM games WHERE YEAR(Date) = 2021 GROUP BY home
        UNION ALL SELECT away, 0, COUNT(1) FROM games WHERE YEAR(Date) = 2021 GROUP BY away
        UNION ALL SELECT away, COUNT(1), 0 FROM games WHERE YEAR(Date) = 2021 AND away_score > home_score GROUP BY away
        UNION ALL SELECT home, COUNT(1), 0 FROM games WHERE YEAR(Date) = 2021 AND away_score < home_score GROUP BY home
    ) t0
    GROUP BY Team
    ORDER BY win_rate DESC
    LIMIT 5
) t1
INNER JOIN (
    SELECT Team, MAX(h_ab) AS max_hit_rate FROM (
        SELECT Team, ROUND(AVG(H / AB), 4) AS h_ab
        FROM hitters
        INNER JOIN games ON hitters.Game = games.Game AND YEAR(Date) = 2021
        WHERE AB > 0
        GROUP BY Hitter_id, Team
        HAVING SUM(AB) > 100
    ) t2 GROUP BY Team
) t3 ON t1.Team = t3.Team
INNER JOIN (
    SELECT Team, Name AS Hitter,
    ROUND(AVG(H / AB), 4) AS avg_hit_rate,
    SUM(AB) AS tol_hit
    FROM hitters
    INNER JOIN players ON Hitter_id = players.Id
    INNER JOIN games ON hitters.Game = games.Game AND YEAR(Date) = 2021
    WHERE AB > 0
    GROUP BY Hitter_id, Team
    HAVING tol_hit > 100
) t4 ON t1.Team = t4.Team AND t3.max_hit_rate = t4.avg_hit_rate;

/*
+------+-------------+--------------+---------+----------+
| Team | Hitter      | avg_hit_rate | tol_hit | win_rate |
+------+-------------+--------------+---------+----------+
| SF   | B. Crawford |       0.2940 |     503 |   0.6527 |
| LAD  | T. Turner   |       0.3167 |     258 |   0.6437 |
| TB   | W. Franco   |       0.2860 |     300 |   0.6084 |
| HOU  | Y. Gurriel  |       0.3137 |     591 |   0.5843 |
| MIL  | E. Escobar  |       0.2965 |     189 |   0.5783 |
+------+-------------+--------------+---------+----------+
*/
