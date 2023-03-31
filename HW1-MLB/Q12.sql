SELECT t0.Pitcher, COUNT(1) AS cnt
FROM (  /* 後備投手 */
	SELECT Pitcher
	FROM pitches
	WHERE Inning IN ('T1', 'B1') AND Num = 1
	GROUP BY Pitcher
	HAVING COUNT(DISTINCT Game) <= 10
) t0
INNER JOIN pitches t1 ON t0.Pitcher = t1.Pitcher
GROUP BY t0.Pitcher
ORDER BY cnt DESC
LIMIT 10;

/*
+---------+-------+
| Pitcher | cnt   |
+---------+-------+
| Barnes  | 12961 |
| Diaz    |  9990 |
| Castro  |  6837 |
| Davis   |  6831 |
| Shaw    |  6279 |
| Petit   |  6213 |
| Feliz   |  6118 |
| Baez    |  6020 |
| Robles  |  5908 |
| Ramos   |  5868 |
+---------+-------+
*/
