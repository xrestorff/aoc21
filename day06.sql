-- part one
with recursive fish as (
    select *,
           0 as counter
    from day06
    union all
    select *
    from (
             with fish_inner as (select * from fish)
             select input,
                    counter + 1
             from (
                      select case
                                 when input = 0 then 6
                                 else input - 1
                                 end as input,
                             counter
                      from fish_inner
                      union all
                      select 8, counter
                      from fish_inner
                      where input = 0
                  ) as base
             where counter < 80
         ) as pg_workaround
)
select count(*)
from fish
where counter = 80;

-- part two
with recursive fish as (
    select 0                as counter,
           input,
           count(*)::bigint as amount
    from day06
    group by 1, 2
    union all
    select *
    from (
             with fish_inner as (select * from fish)
             select counter + 1,
                    input,
                    sum(amount)::bigint
             from (
                      select counter,
                             case
                                 when input = 0 then 6
                                 else input - 1
                                 end as input,
                             amount
                      from fish_inner
                      union all
                      select counter, 8, amount
                      from fish_inner
                      where input = 0
                  ) as base
             where counter < 256
             group by 1, 2
         ) as pg_workaround
)
select sum(amount)
from fish
where counter = 256;