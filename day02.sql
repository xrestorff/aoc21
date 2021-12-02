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