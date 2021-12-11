-- part one
with parsed as (
    select trim(split_part(input, '|', 2)) as output
from day08
    ),
    digits as (
select *,
    length (split_part(output, ' ', 1)) as len1,
    length (split_part(output, ' ', 2)) as len2,
    length (split_part(output, ' ', 3)) as len3,
    length (split_part(output, ' ', 4)) as len4
from parsed
    ),
    uniqueness as (
select *,
    len1 in (2, 4, 3, 7) as is_unique1,
    len2 in (2, 4, 3, 7) as is_unique2,
    len3 in (2, 4, 3, 7) as is_unique3,
    len4 in (2, 4, 3, 7) as is_unique4
from digits)
select sum(is_unique1 ::int + is_unique2 ::int + is_unique3 ::int + is_unique4 ::int)
from uniqueness;