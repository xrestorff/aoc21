-- part one
with split_data as (
    select substr(input, 1, position(' ' in input) - 1) as input,
           right(input, 1)::integer                     as value
    from day02
),
     input_sums as (
         select sum(case when input = 'forward' then value else 0 end) as forward,
                sum(case when input = 'down' then value else 0 end)    as down,
                sum(case when input = 'up' then value else 0 end)      as up
         from split_data
     )
select forward * (down - up)
from input_sums;

-- part two
with base_data as (
    select substr(input, 1, position(' ' in input) - 1) as input,
           right(input, 1)::integer                     as value,
           row_number() over ()                         as row_num
    from day02
),
     add_sums as (
         select *,
                case when input = 'forward' then value else 0 end as forward,
                case when input = 'down' then value else 0 end    as down,
                case when input = 'up' then value else 0 end      as up
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
from add_depth;