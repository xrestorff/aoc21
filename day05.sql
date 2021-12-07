-- part one
with recursive
    coords as (
        select *,
               substr(input, 1, position(',' in input) - 1)::int                                                  as x1,
               substr(substr(input, position(',' in input) + 1), 1,
                      position(' ' in substr(input, position(',' in input) + 1)))::int                            as y1,
               reverse(substr(reverse(input), 1, position(',' in reverse(input)) - 1))::int                       as y2,
               reverse(substr(substr(reverse(input), position(',' in reverse(input)) + 1), 1,
                              position(' ' in substr(reverse(input), position(',' in reverse(input)) + 1))))::int as x2
        from day05
    ),
    scope as (
        select *,
               true as is_vertical,
               x1   as fixed_point,
               y1   as point1,
               y2   as point2
        from coords
        where x1 = x2
        union all
        select *,
               false,
               y1,
               x1,
               x2
        from coords
        where y1 = y2
    ),
    all_lines as (
        select *,
               case
                   when point1 < point2 then point1
                   else point2
                   end as start_point,
               case
                   when point2 > point1 then point2
                   else point1
                   end as end_point
        from scope
    ),
    all_points as (
        select min(start_point) as point
        from all_lines
        union all
        select point + 1
        from all_points
        where point < (select max(end_point) from all_lines)
    ),
    line_points as (
        select *
        from all_lines
                 inner join all_points
                            on all_points.point between all_lines.start_point and all_lines.end_point
    ),
    covered_points as (
        select *,
               fixed_point as x,
               point       as y
        from line_points
        where is_vertical
        union all
        select *,
               point,
               fixed_point
        from line_points
        where not is_vertical
    ),
    multiple_points as (
        select x, y, count(*)
        from covered_points
        group by 1, 2
        having count(*) > 1
    )
select count(*)
from multiple_points;

-- part two
with recursive
    parsed as (
        select *,
               substr(input, 1, position(',' in input) - 1)::int                                                  as x1,
               substr(substr(input, position(',' in input) + 1), 1,
                      position(' ' in substr(input, position(',' in input) + 1)))::int                            as y1,
               reverse(substr(reverse(input), 1, position(',' in reverse(input)) - 1))::int                       as y2,
               reverse(substr(substr(reverse(input), position(',' in reverse(input)) + 1), 1,
                              position(' ' in substr(reverse(input), position(',' in reverse(input)) + 1))))::int as x2
        from day05
    ),
    coords as (
        select *,
               x1 = x2                  as is_vertical,
               y1 = y2                  as is_horizontal,
               not (x1 = x2 or y1 = y2) as is_diagonal,
               x2 > x1                  as is_x_asc,
               y2 > y1                  as is_y_asc
        from parsed
    ),
    distances as (
        select *,
               case
                   when is_vertical then abs(y2 - y1)
                   else abs(x2 - x1)
                   end as distance
        from coords
    ),
    steps as (
        select 0 as step
        union all
        select step + 1
        from steps
        where step < (select max(distance) from distances)
    ),
    covered_points as (
        select *,
               case
                   when is_vertical then x1
                   when is_x_asc then x1 + steps.step
                   else x1 - steps.step
                   end as x,
               case
                   when is_horizontal then y1
                   when is_y_asc then y1 + steps.step
                   else y1 - steps.step
                   end as y
        from distances
                 inner join steps
                            on distances.distance >= steps.step
    ),
    multiple_points as (
        select x, y, count(*)
        from covered_points
        group by 1, 2
        having count(*) > 1
    )
select count(*)
from multiple_points;