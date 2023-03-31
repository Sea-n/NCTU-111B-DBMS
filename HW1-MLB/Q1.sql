SELECT COUNT(1) AS cnt
FROM games
WHERE ABS(away_score - home_score) >= 10;

/*
+-----+
| cnt |
+-----+
| 558 |
+-----+
*/
