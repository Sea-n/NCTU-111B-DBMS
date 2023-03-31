SELECT Team, The_month,
       TIME_FORMAT(MIN(diff), '%H:%i') AS time_interval
FROM (
    SELECT Team, The_month,
           TIMEDIFF(Date, LAG(Date, 1) OVER (PARTITION BY Team ORDER BY Date)) AS diff
    FROM (
        SELECT SUBSTR(Date, 1, 7) AS The_month,
               COUNT(1) AS cnt
        FROM games
        GROUP BY The_month
        ORDER BY cnt DESC
        LIMIT 1
    ) t0
    INNER JOIN (
        SELECT home AS Team, Date FROM games
        UNION ALL SELECT away AS Team, Date FROM games
    ) t1 ON SUBSTR(t1.Date, 1, 7) = The_month
) t2
WHERE diff > 0
GROUP BY Team;

/*
+------+-----------+---------------+
| Team | The_month | time_interval |
+------+-----------+---------------+
| ARI  | 2017-08   | 17:00         |
| ATL  | 2017-08   | 03:25         |
| BAL  | 2017-08   | 17:30         |
| BOS  | 2017-08   | 18:20         |
| CHC  | 2017-08   | 17:30         |
| CHW  | 2017-08   | 04:10         |
| CIN  | 2017-08   | 17:25         |
| CLE  | 2017-08   | 04:00         |
| COL  | 2017-08   | 17:00         |
| DET  | 2017-08   | 18:00         |
| HOU  | 2017-08   | 18:00         |
| KC   | 2017-08   | 03:36         |
| LAA  | 2017-08   | 17:30         |
| LAD  | 2017-08   | 18:00         |
| MIA  | 2017-08   | 03:45         |
| MIL  | 2017-08   | 17:30         |
| MIN  | 2017-08   | 04:10         |
| NYM  | 2017-08   | 06:25         |
| NYY  | 2017-08   | 04:00         |
| OAK  | 2017-08   | 17:30         |
| PHI  | 2017-08   | 03:25         |
| PIT  | 2017-08   | 18:00         |
| SD   | 2017-08   | 17:25         |
| SEA  | 2017-08   | 03:36         |
| SF   | 2017-08   | 06:00         |
| STL  | 2017-08   | 18:00         |
| TB   | 2017-08   | 18:00         |
| TEX  | 2017-08   | 17:00         |
| TOR  | 2017-08   | 18:00         |
| WSH  | 2017-08   | 06:00         |
+------+-----------+---------------+
*/
