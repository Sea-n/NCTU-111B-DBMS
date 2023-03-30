/* WIP */

SELECT DISTINCT t0.Pitcher, t5.Game, t6.Team
FROM (  /* 過濾常駐百場投手 */
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
    HAVING COUNT(t1.Game) >= 100
) t0
INNER JOIN (  /* 依投手抓取常駐賽局 */
    SELECT t3.Pitcher, t3.Game, t4.Inning
    FROM (  /* 打滿五局 */
        SELECT Game, Pitcher
        FROM pitches
        GROUP BY Game, Pitcher
        HAVING COUNT(DISTINCT Inning) >= 5
    ) t3
    INNER JOIN (  /* 先發投手 */
        SELECT DISTINCT Game, Pitcher, Inning
        FROM pitches
        WHERE (Inning = 'T1' OR Inning = 'B1') AND Num = 1 /* ? */
    ) t4 ON t3.Game = t4.Game AND t3.Pitcher = t4.Pitcher
) t5 ON t0.Pitcher = t5.Pitcher
INNER JOIN games ON t5.Game = games.Game  /* 加入主客隊資訊 */
INNER JOIN (  /* 取得投手資料 */
    SELECT * FROM pitchers
    INNER JOIN players ON players.Id = Pitcher_Id
) t6 ON t6.Name LIKE CONCAT('%', t0.Pitcher, '%')
AND t6.Team = IF(Inning='T1', home, away)  /* 避免名字誤判別隊 */
;

/*
8710 rows in set (45 min 50.435 sec)
*/
