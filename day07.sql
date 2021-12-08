-- part one
with recursive
    positions as (
        select 0 as position
        union all
        select position + 1
        from positions
        where position < (select max(input) from day07)
    ),
    distances as (
        select *, abs(day07.input - positions.position) as distance
        from day07
                 cross join positions),
    sum_distances as (
        select position, sum(distance) as distance
        from distances
        group by 1
    )
select min(distance)
from sum_distances;

-- part two
with recursive
    positions as (
        select 0 as position
        union all
        select position + 1
        from positions
        where position < (select max(input) from day07)
    ),
    distances as (
        select *, abs(day07.input - positions.position) as distance
        from day07
                 cross join positions),
    sum_distances as (
        select position,
               sum(
                       distance * (distance + 1) / 2
                   ) as distance
        from distances
        group by 1
    )
select min(distance)
from sum_distances;