SELECT Game, num_innings
FROM (
    SELECT Game, ROUND(COUNT(*) / 2) AS num_innings
    FROM inning
    GROUP BY Game
) t0
WHERE num_innings = (
    SELECT ROUND(COUNT(*) / 2) AS cnt
    FROM inning
    GROUP BY Game
    ORDER BY CNT DESC
    LIMIT 1
)
ORDER BY Game;

/*
+-----------+-------------+
| Game      | num_innings |
+-----------+-------------+
| 360701114 |          19 |
| 370905102 |          19 |
| 401077087 |          19 |
+-----------+-------------+
*/
