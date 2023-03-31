SELECT Pitcher, COUNT(1) AS cnt,
       ROUND(9 * AVG(2020_K), 4) AS `2020_avg_K/9`,
       ROUND(9 * AVG(2021_K), 4) AS `2021_avg_K/9`,
       CONCAT(ROUND(AVG(2020_PC), 4), '-', ROUND(AVG(2020_ST), 4)) AS `2020_PC-ST`,
       CONCAT(ROUND(AVG(2021_PC), 4), '-', ROUND(AVG(2021_ST), 4)) AS `2021_PC-ST`
FROM (  /* 每位投手的統計資料 */
    SELECT 2020_K, 2020_PC, 2020_ST, 2021_K, 2021_PC, 2021_ST, Pitcher
    FROM (  /* 符合條件的投手 */
        SELECT Pitcher_Id,
        SUM(IF(YEAR(Date) = 2020, IP, NULL)) AS ip_2020,
        SUM(IF(YEAR(Date) = 2021, IP, NULL)) AS ip_2021,
        IF(COUNT(DISTINCT Team) = 1, 'Unchanged', 'Changed') AS Pitcher
        FROM pitchers
        INNER JOIN games ON pitchers.Game = games.Game
        WHERE YEAR(Date) IN (2020, 2021)
        GROUP BY Pitcher_Id
        HAVING ip_2020 > 0 AND ip_2021 > 0 AND ip_2020 + ip_2021 > 50
    ) AS p1
    INNER JOIN (  /* 兩個年份分別取值到不同 column */
        SELECT Pitcher_Id,
        AVG(IF(YEAR(Date) = 2020, K / IP, NULL)) AS 2020_K,
        AVG(IF(YEAR(Date) = 2021, K / IP, NULL)) AS 2021_K,
        AVG(IF(YEAR(Date) = 2020, SUBSTRING(PC_ST, 1, POSITION('-' IN PC_ST)), NULL)) AS 2020_PC,
        AVG(IF(YEAR(Date) = 2021, SUBSTRING(PC_ST, 1, POSITION('-' IN PC_ST)), NULL)) AS 2021_PC,
        AVG(IF(YEAR(Date) = 2020, SUBSTRING(PC_ST, POSITION('-' IN PC_ST) + 1), NULL)) AS 2020_ST,
        AVG(IF(YEAR(Date) = 2021, SUBSTRING(PC_ST, POSITION('-' IN PC_ST) + 1), NULL)) AS 2021_ST
        FROM pitchers
        INNER JOIN games ON pitchers.Game = games.Game
        WHERE IP > 0
        GROUP BY Pitcher_Id
    ) AS p2 ON p2.Pitcher_Id = p1.Pitcher_Id
) AS p0
GROUP BY Pitcher;  /* 最後輸出 Changed/Unchanged 兩個 row */

/*
+-----------+-----+--------------+--------------+-----------------+-----------------+
| Pitcher   | cnt | 2020_avg_K/9 | 2021_avg_K/9 | 2020_PC-ST      | 2021_PC-ST      |
+-----------+-----+--------------+--------------+-----------------+-----------------+
| Changed   | 133 |      12.8063 |      12.1091 | 40.8364-25.6936 | 42.0674-26.9533 |
| Unchanged | 221 |      11.9625 |      11.8112 | 53.1891-33.6151 | 52.7626-33.9636 |
+-----------+-----+--------------+--------------+-----------------+-----------------+
*/
