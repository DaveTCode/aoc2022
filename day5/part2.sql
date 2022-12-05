with recursive
    moves as
        (select line_number   as move_number,
                parts[2]::int as amount,
                parts[4]::int as from_stack,
                parts[6]::int as to_stack
         from (select line_number, regexp_split_to_array(input, ' ') as parts
               from day5_moves) as move_parts),
    halt as (select count(1) as halt from moves),
    game_as_rows
        as
        (select (select max(line_number) from day5_game) - line_number                 as stack_pos,
                unnest(array [1, 2, 3, 4, 5, 6, 7, 8, 9])                              as col,
                unnest(array [substr(input, 2, 1), substr(input, 6, 1), substr(input, 10, 1),
                    substr(input, 14, 1), substr(input, 18, 1), substr(input, 22, 1),
                    substr(input, 26, 1), substr(input, 30, 1), substr(input, 34, 1)]) as val
         from day5_game),
    filtered_blanks
        as
            (select * from game_as_rows where val != ' '),
    game_as_arrays
        as
        (select col, array_agg(val) as stack
         from filtered_blanks
         group by col),
    game_as_row
        as
        (select (select stack from game_as_arrays where col = 1) as stack_1,
                (select stack from game_as_arrays where col = 2) as stack_2,
                (select stack from game_as_arrays where col = 3) as stack_3,
                (select stack from game_as_arrays where col = 4) as stack_4,
                (select stack from game_as_arrays where col = 5) as stack_5,
                (select stack from game_as_arrays where col = 6) as stack_6,
                (select stack from game_as_arrays where col = 7) as stack_7,
                (select stack from game_as_arrays where col = 8) as stack_8,
                (select stack from game_as_arrays where col = 9) as stack_9
         from game_as_arrays
         limit 1),
    states
        as (select 0                                as state_number,
                   cardinality(game_as_row.stack_1) +
                   cardinality(game_as_row.stack_2) +
                   cardinality(game_as_row.stack_3) +
                   cardinality(game_as_row.stack_4) +
                   cardinality(game_as_row.stack_5) +
                   cardinality(game_as_row.stack_6) +
                   cardinality(game_as_row.stack_7) +
                   cardinality(game_as_row.stack_8) +
                   cardinality(game_as_row.stack_9) as total_pieces,
                   game_as_row.stack_1,
                   game_as_row.stack_2,
                   game_as_row.stack_3,
                   game_as_row.stack_4,
                   game_as_row.stack_5,
                   game_as_row.stack_6,
                   game_as_row.stack_7,
                   game_as_row.stack_8,
                   game_as_row.stack_9,
                   0                                as from_stack,
                   0                                as to_stack,
                   0                                as amount
            from game_as_row
            union all
            select state_number + 1,
                   cardinality(stack_1) +
                   cardinality(stack_2) +
                   cardinality(stack_3) +
                   cardinality(stack_4) +
                   cardinality(stack_5) +
                   cardinality(stack_6) +
                   cardinality(stack_7) +
                   cardinality(stack_8) +
                   cardinality(stack_9) as total_pieces,
                   case
                       when moves.from_stack = 1 then stack_1[(1 + moves.amount):cardinality(stack_1)]
                       when moves.to_stack = 1 then array_remove((case
                                                                      when moves.from_stack = 1
                                                                          then reverse(stack_1[1:moves.amount])
                                                                      when moves.from_stack = 2
                                                                          then stack_2[1:moves.amount]
                                                                      when moves.from_stack = 3
                                                                          then stack_3[1:moves.amount]
                                                                      when moves.from_stack = 4
                                                                          then stack_4[1:moves.amount]
                                                                      when moves.from_stack = 5
                                                                          then stack_5[1:moves.amount]
                                                                      when moves.from_stack = 6
                                                                          then stack_6[1:moves.amount]
                                                                      when moves.from_stack = 7
                                                                          then stack_7[1:moves.amount]
                                                                      when moves.from_stack = 8
                                                                          then stack_8[1:moves.amount]
                                                                      when moves.from_stack = 9
                                                                          then stack_9[1:moves.amount]
                                                                      end || stack_1), null)
                       else stack_1
                       end              as stack_1,
                   case
                       when moves.from_stack = 2 then stack_2[(1 + moves.amount):cardinality(stack_2)]
                       when moves.to_stack = 2 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_2), null)
                       else stack_2
                       end              as stack_2,
                   case
                       when moves.from_stack = 3 then stack_3[(1 + moves.amount):cardinality(stack_3)]
                       when moves.to_stack = 3 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_3), null)
                       else stack_3
                       end              as stack_3,
                   case
                       when moves.from_stack = 4 then stack_4[(1 + moves.amount):cardinality(stack_4)]
                       when moves.to_stack = 4 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_4), null)
                       else stack_4
                       end              as stack_4,
                   case
                       when moves.from_stack = 5 then stack_5[(1 + moves.amount):cardinality(stack_5)]
                       when moves.to_stack = 5 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_5), null)
                       else stack_5
                       end              as stack_5,
                   case
                       when moves.from_stack = 6 then stack_6[(1 + moves.amount):cardinality(stack_6)]
                       when moves.to_stack = 6 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_6), null)
                       else stack_6
                       end              as stack_6,
                   case
                       when moves.from_stack = 7 then stack_7[(1 + moves.amount):cardinality(stack_7)]
                       when moves.to_stack = 7 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_7), null)
                       else stack_7
                       end              as stack_7,
                   case
                       when moves.from_stack = 8 then stack_8[(1 + moves.amount):cardinality(stack_8)]
                       when moves.to_stack = 8 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_8), null)
                       else stack_8
                       end              as stack_8,
                   case
                       when moves.from_stack = 9 then stack_9[(1 + moves.amount):cardinality(stack_9)]
                       when moves.to_stack = 9 then array_remove((
                                                                         case
                                                                             when moves.from_stack = 1
                                                                                 then stack_1[1:moves.amount]
                                                                             when moves.from_stack = 2
                                                                                 then stack_2[1:moves.amount]
                                                                             when moves.from_stack = 3
                                                                                 then stack_3[1:moves.amount]
                                                                             when moves.from_stack = 4
                                                                                 then stack_4[1:moves.amount]
                                                                             when moves.from_stack = 5
                                                                                 then stack_5[1:moves.amount]
                                                                             when moves.from_stack = 6
                                                                                 then stack_6[1:moves.amount]
                                                                             when moves.from_stack = 7
                                                                                 then stack_7[1:moves.amount]
                                                                             when moves.from_stack = 8
                                                                                 then stack_8[1:moves.amount]
                                                                             when moves.from_stack = 9
                                                                                 then stack_9[1:moves.amount]
                                                                             end || stack_9), null)
                       else stack_9
                       end              as stack_9,

                   moves.from_stack,
                   moves.to_stack,
                   moves.amount
            from states
                     left join (select row_number() over (order by move_number) as num, moves.* from moves) as moves
                               on moves.num = state_number + 1
            where state_number < (select halt from halt))
select concat(states.stack_1[1], states.stack_2[1], states.stack_3[1], states.stack_4[1], states.stack_5[1],
              states.stack_6[1], states.stack_7[1], states.stack_8[1], states.stack_9[1])
from states
order by states.state_number desc
limit 1;