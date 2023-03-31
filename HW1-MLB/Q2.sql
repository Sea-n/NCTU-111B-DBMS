SELECT Game, CEILING(COUNT(1) / 2) AS num_innings
FROM inning
GROUP BY Game
HAVING num_innings = CEILING((
    SELECT COUNT(1) AS cnt
    FROM inning
    GROUP BY Game
    ORDER BY cnt DESC
    LIMIT 1
) / 2)
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
