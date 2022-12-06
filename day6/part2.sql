with letter_table
         as
         (select u.letter, u.idx
          from day6
                   cross join unnest(regexp_split_to_array(input, '')) with ordinality as u(letter, idx)
          where test_number = 5)
select
    a.idx - 1
from letter_table as a
where a.idx > 14
  and (select count(distinct b.letter) from letter_table as b where b.idx < a.idx and b.idx >= a.idx - 14) = 14
order by idx
limit 1;
