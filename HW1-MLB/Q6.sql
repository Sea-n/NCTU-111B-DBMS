SELECT _Type AS Type
FROM pitches
GROUP BY _Type
HAVING MAX(MPH) <= 95;

/*
+------------------+
| Type             |
+------------------+
| Eephus Pitch     |
| Forkball         |
| Intentional Ball |
| Knuckle Curve    |
| Knuckleball      |
| Screwball        |
| Slow Curve       |
+------------------+
*/
