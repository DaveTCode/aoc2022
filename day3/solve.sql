with compartments
         as
         (select input                                      as backpack,
                 substring(input, 0, length(input) / 2 + 1) as comp1,
                 substring(input, length(input) / 2 + 1)    as comp2
          from day3),
     arrays as
         (select backpack,
                 comp1,
                 comp2,
                 regexp_split_to_array(comp1, '') as comp1_contents,
                 regexp_split_to_array(comp2, '') as comp2_contents
          from compartments),
     duplicates as
         (select (select unnest(comp1_contents) intersect select unnest(comp2_contents) limit 1) as letter,
                 arrays.*
          from arrays),
     part1 as
         (select case
                     when ascii(letter) >= ascii('a') then ascii(letter) - ascii('a') + 1
                     else ascii(letter) - ascii('A') + 27 end as score
          from duplicates)
select sum(score)
from part1;

with priorities
         as (select case
                        when ascii(a) >= ascii('a') then ascii(a) - ascii('a') + 1
                        else ascii(a) - ascii('A') + 27 end as score,
                    a                                       as letter
             from unnest(regexp_split_to_array('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '')) as a)
        ,
     groups
         as
         (select ((line_number - 1) / 3)                                                 as elf_group,
                 (line_number - 1) % 3                                                   as rem,
                 (select array(select score
                               from unnest(regexp_split_to_array(input, '')) as a
                                        inner join priorities on priorities.letter = a)) as priorities
          from day3)
        ,
     unnested
         as
         (select elf_group, rem, unnest(priorities) as priority
          from groups)
select sum(priority)
from (select distinct r0.elf_group,
                      r0.priority
      from unnested as r0
               inner join unnested as r1 on r0.elf_group = r1.elf_group and r1.rem = 1 and r0.priority = r1.priority
               inner join unnested as r2 on r0.elf_group = r2.elf_group and r2.rem = 2 and r0.priority = r2.priority
      where r0.rem = 0) as priorities;