WITH theirs AS (SELECT 'A' as choice, 1 as score UNION ALL SELECT 'B', 2 UNION ALL SELECT 'C', 3),
     ours AS (SELECT 'X' as choice, 1 AS score UNION ALL SELECT 'Y', 2 UNION ALL SELECT 'Z', 3),
     combined_scores AS
         (SELECT theirs.choice                                                                AS their_choice,
                 theirs.score                                                                 AS their_score,
                 ours.choice                                                                  AS our_choice,
                 ours.score                                                                   AS our_score,
                 (CASE
                      WHEN theirs.choice = 'A' AND ours.choice = 'X' THEN 3
                      WHEN theirs.choice = 'A' AND ours.choice = 'Y' THEN 6
                      WHEN theirs.choice = 'A' AND ours.choice = 'Z' THEN 0
                      WHEN theirs.choice = 'B' AND ours.choice = 'X' THEN 0
                      WHEN theirs.choice = 'B' AND ours.choice = 'Y' THEN 3
                      WHEN theirs.choice = 'B' AND ours.choice = 'Z' THEN 6
                      WHEN theirs.choice = 'C' AND ours.choice = 'X' THEN 6
                      WHEN theirs.choice = 'C' AND ours.choice = 'Y' THEN 0
                      WHEN theirs.choice = 'C' AND ours.choice = 'Z' THEN 3 END) + ours.score AS part1_round_score,
                 (CASE
                      WHEN ours.choice = 'Y' THEN theirs.score + 3
                      WHEN ours.choice = 'X' AND theirs.choice = 'A' THEN 3
                      WHEN ours.choice = 'X' AND theirs.choice = 'B' THEN 1
                      WHEN ours.choice = 'X' AND theirs.choice = 'C' THEN 2
                      WHEN ours.choice = 'Z' AND theirs.choice = 'A' THEN 2 + 6
                      WHEN ours.choice = 'Z' AND theirs.choice = 'B' THEN 3 + 6
                      WHEN ours.choice = 'Z' AND theirs.choice = 'C' THEN 1 + 6 END)          AS part2_round_score
          FROM theirs
                   CROSS JOIN ours)
SELECT SUM(part1_round_score) as part1,
       SUM(part2_round_score) AS part2
FROM day2
         INNER JOIN combined_scores ON LEFT(day2.input, 1) = combined_scores.their_choice AND
                                       RIGHT(day2.input, 1) = combined_scores.our_choice