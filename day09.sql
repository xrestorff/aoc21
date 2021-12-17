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