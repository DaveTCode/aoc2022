# Day 7 - Advent Treets

Most of the code here is simply bookkeeping and not particularly hard sql, the tricky bit is turning the list of directories into a path array.

The key there is the code

```sql
cds_with_path(ix, target, path)
  as
  (
    select 0, null, array ['']
      union all
    select ix + 1,
          cds.target,
          case
              when cds.target = '..' then path[1:cardinality(path) - 1]
              else path || cds.target
              end
    from cds_with_path
            join cds on cds.cd_num = cds_with_path.ix + 1),
```

which uses a recursive CTE trick where you anchor on an index (column 0) and then increment it each time through the recursion. That allows you to essentially walk a table creating one row per existing row without doing it all at once. The path array can then be built up step by step (just dropping the last element in the array or adding it corresponding to the cd)

Let's just be thankful Eric isn't a complete ass and decided to add symlinks to get loops, maybe tomorrow.