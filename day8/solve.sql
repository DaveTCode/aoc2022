with d8 as (select * from day8),
     forest as
         (select line_number                      as row,
                 regexp_split_to_array(input, '') as row_data
          from d8),
     forest_expanded as
         (select row,
                 col,
                 element
          from forest
                   cross join unnest(row_data) with ordinality as f(element, col)),
     forest_with_can_be_seen as
         (select *,
                 coalesce((select count(1)
                           from forest_expanded as a
                           where a.row = forest_expanded.row
                             and a.col < forest_expanded.col
                             and a.element >= forest_expanded.element), 0) = 0                     as clear_up,
                 coalesce((select count(1)
                           from forest_expanded as a
                           where a.row = forest_expanded.row
                             and a.col > forest_expanded.col
                             and a.element >= forest_expanded.element), 0) = 0                     as clear_down,
                 coalesce((select count(1)
                           from forest_expanded as a
                           where a.row < forest_expanded.row
                             and a.col = forest_expanded.col
                             and a.element >= forest_expanded.element), 0) = 0                     as clear_left,
                 coalesce((select count(1)
                           from forest_expanded as a
                           where a.row > forest_expanded.row
                             and a.col = forest_expanded.col
                             and a.element >= forest_expanded.element), 0) = 0                     as clear_right,
                 coalesce((select forest_expanded.col - b.col
                           from forest_expanded as b
                           where forest_expanded.row = b.row
                             and b.col < forest_expanded.col
                             and b.element >= forest_expanded.element
                           order by b.col desc
                           limit 1), forest_expanded.col - 1)                                      as count_clear_left,
                 coalesce((select b.col - forest_expanded.col
                           from forest_expanded as b
                           where forest_expanded.row = b.row
                             and b.col > forest_expanded.col
                             and b.element >= forest_expanded.element
                           order by b.col
                           limit 1), (select max(col) from forest_expanded) - forest_expanded.col) as count_clear_right,
                 coalesce((select forest_expanded.row - b.row
                           from forest_expanded as b
                           where forest_expanded.col = b.col
                             and b.row < forest_expanded.row
                             and b.element >= forest_expanded.element
                           order by b.row desc
                           limit 1), forest_expanded.row - 1)                                      as count_clear_up,
                 coalesce((select b.row - forest_expanded.row
                           from forest_expanded as b
                           where forest_expanded.col = b.col
                             and b.row > forest_expanded.row
                             and b.element >= forest_expanded.element
                           order by b.row
                           limit 1), (select max(row) from forest_expanded) - forest_expanded.row) as count_clear_down
          from forest_expanded)
select (select count(1)
        from forest_with_can_be_seen
        where clear_down or clear_up or clear_left or clear_right)              as part_1,
       count_clear_down * count_clear_up * count_clear_right * count_clear_left as part_2
from forest_with_can_be_seen
order by count_clear_down * count_clear_up * count_clear_right * count_clear_left desc
limit 1;