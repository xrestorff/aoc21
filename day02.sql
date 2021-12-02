-- part one
with split_data as (
    select substr(command, 1, instr(command, ' ') - 1) as command,
           rightstr(command, 1)                        as value
    from day02_data
),
     command_sums as (
         select sum(case when command = 'forward' then value else 0 end) as forward,
                sum(case when command = 'down' then value else 0 end)    as down,
                sum(case when command = 'up' then value else 0 end)      as up
         from split_data
     )
select forward * (down - up)
from command_sums;

-- part two
with base_data as (
    select substr(command, 1, instr(command, ' ') - 1) as command,
           rightstr(command, 1)                        as value,
           row_number() over ()                        as row_num
    from day02_data
),
     add_sums as (
         select *,
                case when command = 'forward' then value else 0 end as forward,
                case when command = 'down' then value else 0 end    as down,
                case when command = 'up' then value else 0 end      as up
         from base_data
     ),
     add_aim as (
         select *,
                sum(down) over (order by row_num) - sum(up) over (order by row_num) as aim
         from add_sums
     ),
     add_depth as (
         select *,
                aim * forward as depth
         from add_aim
     )
select sum(forward) * sum(depth)
from add_depth