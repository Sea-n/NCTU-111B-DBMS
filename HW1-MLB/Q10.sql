SELECT Id, Name
FROM (  /* 先發投手 */
    SELECT DISTINCT Game, Pitcher
    FROM pitches
    WHERE (Inning = 'T1' OR Inning = 'B1') AND Num = 1 /* ? */
) t1
INNER JOIN (  /* 打滿五局 */
    SELECT Game, Pitcher, Inning, COUNT(DISTINCT Inning) AS cnt
    FROM pitches
    GROUP BY Game, Pitcher
    HAVING cnt >= 5
) t2 ON t1.Game = t2.Game AND t1.Pitcher = t2.Pitcher
/* INNER JOIN pitches ON t1.Game = pitches.Game AND t1.Pitcher = pitches.Pitcher */

INNER JOIN games ON t1.Game = games.Game AND YEAR(Date) = 2021

INNER JOIN (  /* 取得投手資料 */
    SELECT * FROM pitchers
    INNER JOIN players ON players.Id = Pitcher_Id
) t3 ON t3.Name LIKE CONCAT('%', t1.Pitcher, '%')
AND t3.Team = CASE WHEN Inning = 'T1' THEN home ELSE away END  /* 避免名字誤判別隊 */
GROUP BY Id, Name;

/*
350 rows in set (4 min 34.389 sec)
*/
