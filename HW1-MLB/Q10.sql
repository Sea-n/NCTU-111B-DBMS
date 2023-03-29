/* WIP */

SELECT t1.Pitcher
FROM (  /* 打滿五局 */
    SELECT Game, Pitcher
    FROM pitches
    GROUP BY Game, Pitcher
    HAVING COUNT(DISTINCT Inning) >= 5
) t1
INNER JOIN (  /* 先發投手 */
    SELECT DISTINCT Game, Pitcher
    FROM pitches
    WHERE (Inning = 'T1' OR Inning = 'B1') AND Num = 1 /* ? */
) t2 ON t1.Game = t2.Game AND t1.Pitcher = t2.Pitcher
GROUP BY t1.Pitcher
HAVING COUNT(t1.Game) >= 100  /* 常駐投手 */
;

/*
66 rows in set (17.762 sec)
*/


INNER JOIN games ON t0.Game = games.Game
INNER JOIN (  /* 取得投手資料 */
    SELECT * FROM pitchers
    INNER JOIN players ON players.Id = Pitcher_Id
) t3 ON t3.Name LIKE CONCAT('%', t0.Pitcher, '%')
AND t3.Team = IF(Inning='T1', home, away)  /* 避免名字誤判別隊 */
GROUP BY Id, Name;
