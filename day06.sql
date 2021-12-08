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