-- part one
with recursive
    coords as (
        select input,
               row_number() over ()     as row,
               1                        as col,
               substr(input, 1, 1)::int as value
        from day09
        union all
        select input,
               row,
               col + 1,
               substr(input, col + 1, 1)::int
        from coords
        where col < 100
    ),
    smallest_coords as (
        select *,
               value < all (
                   select value
                   from coords as lookup
                   where (lookup.col = coords.col and (abs(lookup.row - coords.row) = 1))
                      or (lookup.row = coords.row and (abs(lookup.col - coords.col) = 1))
               ) as is_smallest
        from coords
    )
select sum(value + 1)
from smallest_coords
where is_smallest;

-- part two
with recursive
    coords as (
        select input,
               row_number() over ()     as row,
               1                        as col,
               substr(input, 1, 1)::int as value
        from day09
        union all
        select input,
               row,
               col + 1,
               substr(input, col + 1, 1)::int
        from coords
        where col < 100
    ),
    basin_starts as (
        select *
        from coords
        where value < all (
            select value
            from coords as lookup
            where (lookup.col = coords.col and (abs(lookup.row - coords.row) = 1))
               or (lookup.row = coords.row and (abs(lookup.col - coords.col) = 1))
        )
    ),
    basins as (
        select row, col, value, row_number() over () as basin_id
        from basin_starts
        union all
        select coords.row, coords.col, coords.value, basins.basin_id
        from coords
                 inner join basins
                            on ((basins.col = coords.col and (abs(basins.row - coords.row) = 1))
                                or (basins.row = coords.row and (abs(basins.col - coords.col) = 1)))
                                and not coords.value = 9
                                and coords.value > basins.value
    ),
    distinct_basins as (
        select distinct *
        from basins
    ),
    largest_basins as (
        select basin_id, count(*) as amt
        from distinct_basins
        group by 1
        order by 2 desc
        limit 3
    )
select distinct nth_value(amt, 1) over () * nth_value(amt, 2) over () * nth_value(amt, 3) over ()
from largest_basins;