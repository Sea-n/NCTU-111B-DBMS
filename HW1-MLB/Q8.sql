SELECT Pitcher, COUNT(*) AS cnt,
ROUND(9 * AVG(2020_K), 4) AS `2020_avg_K/9`,
ROUND(9 * AVG(2021_K), 4) AS `2021_avg_K/9`,
CONCAT(ROUND(AVG(2020_PC), 4), '-', ROUND(AVG(2020_ST), 4)) AS `2020_PC-ST`,
CONCAT(ROUND(AVG(2021_PC), 4), '-', ROUND(AVG(2021_ST), 4)) AS `2021_PC-ST`
FROM (  /* 每位投手的統計資料 */
    SELECT 2020_K, 2020_PC, 2020_ST, 2021_K, 2021_PC, 2021_ST,
    CASE WHEN team_cnt = 1 THEN 'Unchanged' ELSE 'Changed' END AS Pitcher
    FROM (  /* 符合條件的投手 */
        SELECT Pitcher_Id,
        SUM(CASE WHEN YEAR(Date) = 2020 THEN IP ELSE NULL END) AS ip_2020,
        SUM(CASE WHEN YEAR(Date) = 2021 THEN IP ELSE NULL END) AS ip_2021,
        COUNT(DISTINCT Team) AS team_cnt
        FROM pitchers
        INNER JOIN games ON pitchers.Game = games.Game
        WHERE YEAR(Date) = 2020 OR YEAR(Date) = 2021
        GROUP BY Pitcher_Id
        HAVING ip_2020 > 0 AND ip_2021 > 0 AND ip_2020 + ip_2021 > 50
    ) AS p2
    INNER JOIN (  /* 兩個年份分別取值到不同 column */
        SELECT Pitcher_Id, AVG(K / IP) AS 2020_K,
        AVG(SUBSTRING(PC_ST, 1, POSITION('-' IN PC_ST))) AS 2020_PC,
        AVG(SUBSTRING(PC_ST, POSITION('-' IN PC_ST) + 1)) AS 2020_ST
        FROM pitchers
        INNER JOIN games ON pitchers.Game = games.Game
        WHERE YEAR(Date) = 2020
        GROUP BY Pitcher_Id
    ) AS p0 ON p0.Pitcher_Id = p2.Pitcher_Id
    INNER JOIN (
        SELECT Pitcher_Id, AVG(K / IP) AS 2021_K,
        AVG(SUBSTRING(PC_ST, 1, POSITION('-' IN PC_ST))) AS 2021_PC,
        AVG(SUBSTRING(PC_ST, POSITION('-' IN PC_ST) + 1)) AS 2021_ST
        FROM pitchers
        INNER JOIN games ON pitchers.Game = games.Game
        WHERE YEAR(Date) = 2021
        GROUP BY Pitcher_Id
    ) AS p1 ON p1.Pitcher_Id = p2.Pitcher_Id
    GROUP BY p2.Pitcher_Id
) AS p3
GROUP BY Pitcher;  /* 最後輸出 Changed/Unchanged 兩個 row */

/*
助教答案：
+-----------+-----+--------------+--------------+-----------------+-----------------+
| Pitcher   | cnt | 2020_avg_K/9 | 2021_avg_K/9 | 2020_PC-ST      | 2021_PC-ST      |
+-----------+-----+--------------+--------------+-----------------+-----------------+
| Changed   | 133 |      12.8063 |      12.1091 | 40.8364-25.6936 | 42.0674-26.9533 |
| Unchanged | 221 |      11.9625 |      11.8112 | 53.1891-33.6151 | 52.7626-33.9636 |
+-----------+-----+--------------+--------------+-----------------+-----------------+

目前輸出：
+-----------+-----+--------------+--------------+-----------------+-----------------+
| Pitcher   | cnt | 2020_avg_K/9 | 2021_avg_K/9 | 2020_PC-ST      | 2021_PC-ST      |
+-----------+-----+--------------+--------------+-----------------+-----------------+
| Changed   | 133 |      12.8063 |      12.1091 | 40.8138-25.6677 | 42.0341-26.9229 |
| Unchanged | 221 |      11.9625 |      11.8112 | 53.0557-33.5250 | 52.6564-33.8840 |
+-----------+-----+--------------+--------------+-----------------+-----------------+
*/
