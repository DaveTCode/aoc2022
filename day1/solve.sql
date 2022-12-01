WITH grouped_inputs
         AS
         (SELECT CAST(input AS numeric),
                 (SELECT b.line_number
                  FROM day1 as b
                  WHERE b.input = ''
                    AND b.line_number > a.line_number
                  ORDER BY b.line_number - a.line_number
                  LIMIT 1) AS grouped_line_number
          FROM public.day1 as a
          WHERE input != '')
, top_3
         AS
         (SELECT grouped_line_number, SUM(input) AS sum
          FROM grouped_inputs
          GROUP BY grouped_line_number
          ORDER BY sum DESC
          LIMIT 3)
SELECT MAX(sum) AS part1, SUM(sum) as part2
FROM top_3;