-- part one
with positions as (
    select distinct input as position
    from day07
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