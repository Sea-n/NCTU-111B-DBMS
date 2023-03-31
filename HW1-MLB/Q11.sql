SELECT YEAR(Date),
       SUM(home_score > away_score) / COUNT(1) AS home_adv
FROM games
GROUP BY YEAR(Date);

/*
+----------+
| home_adv |
+----------+
|   0.5401 |
+----------+
*/

SELECT IF(home_score > away_score, home, away) win,
       COUNT(1) AS cnt
FROM games
WHERE YEAR(Date) = 2021
GROUP BY win
ORDER BY cnt DESC;
