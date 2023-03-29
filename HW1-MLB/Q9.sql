SELECT ROUND(MIN(hr), 2) AS hit_rate_diff,
SUM(hit_win = winer) / COUNT(*) AS win_rate
FROM (
    SELECT Game,
    Team AS hit_win,
    AVG(H/NULLIF(AB, 0)) - LAG(AVG(H/NULLIF(AB, 0)), 1)
    OVER (PARTITION BY Game ORDER BY AVG(H/NULLIF(AB, 0))) AS hr
    FROM hitters
    GROUP BY Game, Team
) t1
INNER JOIN (
    SELECT Game,
    IF(home_score > away_score, home, away) AS winer
    FROM games
    WHERE YEAR(Date) = 2021
) t2 ON t1.Game = t2.Game
WHERE hr > 0.14;

/*
+---------------+----------+
| hit_rate_diff | win_rate |
+---------------+----------+
|          0.14 |   0.9517 |
+---------------+----------+
*/
