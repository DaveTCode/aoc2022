with elves
         as
         (select line_number,
                 input,
                 regexp_split_to_array(input, '[,-]')::int[] as parts
          from day4)
select sum(case
               when parts[1] <= parts[3] and parts[2] >= parts[4] then 1
               when parts[3] <= parts[1] and parts[4] >= parts[2] then 1
               else 0 end) as part1,
       sum(case
               when parts[1] <= parts[4] and parts[2] >= parts[3] then 1
               else 0 end) as part2
from elves;