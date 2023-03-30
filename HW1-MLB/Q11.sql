SELECT SUM(home_score > away_score) / COUNT(*) AS home_adv
FROM games;

/*
+----------+
| home_adv |
+----------+
|   0.5350 |
+----------+
*/
