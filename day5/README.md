# Day 5

Recursive CTEs need to act on a single row at a time (no subquerying into the table you're recursing over) so all data needs to be in a single row. To achieve that I wanted an array of arrays which could be indexed by the from/to of the move. However that's not possible because PSQL multi dimensional arrays need same cardinality on all arrays.

Upshot? Hard code each column like I'm 13 and haven't been taught about arrays all over again.

This was a truly disgusting problem to solve in SQL though

Part 2 and part 1 are obviously basically the same thing except that I solved part 1 by splitting each move into multiple single step moves. Copy paste sql between the two is fine of course.