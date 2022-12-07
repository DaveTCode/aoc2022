with recursive d7 as (select * from day7),
               cds
                   as
                   (select line_number,
                           row_number() over (order by line_number)                                    as cd_num,
                           case
                               when input = '$ cd ..' then '..'
                               else concat(replace(input, '$ cd ', ''), '_', d7.line_number::text) end as target
                    from d7
                    where input ~ '\$ cd.*'),
               cds_with_path(ix, target, path)
                   as
                   (select 0, null, array ['']
                    union all
                    select ix + 1,
                           cds.target,
                           case
                               when cds.target = '..' then path[1:cardinality(path) - 1]
                               else path || cds.target
                               end
                    from cds_with_path
                             join cds on cds.cd_num = cds_with_path.ix + 1),
               files
                   as
                   (select line_number,
                           (select target
                            from cds
                            where cds.target != '..'
                              and cds.line_number < d7.line_number
                            order by line_number desc
                            limit 1)                         as directory,
                           regexp_split_to_array(input, ' ') as file_metadata
                    from d7
                    where input ~ '\d+ \w+'),
               directories
                   as
                   (select cds_with_path.target                           as directory,
                           (select sum(file_metadata[1]::int)
                            from files
                            where files.directory = cds_with_path.target) as size,
                           cds_with_path.path                             as path
                    from cds_with_path
                    where cds_with_path.target != '..'),
               directories_with_size
                   as
                   (select directory,
                           (select sum(size) as total_size
                            from directories as a
                            where directories.directory = any (a.path)) as total_size
                    from directories),
               part1 as
                   (select sum(total_size) as answer
                    from directories_with_size
                    where total_size < 100000)
select part1.answer as part1,
       total_size   as part2
from directories_with_size
         cross join (select 30000000 - (70000000 - sum(size)) as total
                     from directories) as disk_usage
         cross join part1
where total_size - disk_usage.total >= 0
order by total_size - disk_usage.total
limit 1;