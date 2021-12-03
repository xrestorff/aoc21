-- part one
with recursive
    bits as (
        select input,
               1                            as pos,
               substr(input, 1, 1)::integer as bit
        from day03
        union all
        select input,
               pos + 1,
               substr(input, pos + 1, 1)::integer
        from bits
        where pos < length(input)
    ),
    pos_counts as (
        select pos,
               sum(bit) as freq
        from bits
        group by 1
    ),
    add_rates as (
        select *,
               case
                   when freq > (select count(*) / 2 from day03)
                       then 1
                   else 0 end                            as gamma,
               case
                   when freq > (select count(*) / 2 from day03)
                       then 0
                   else 1 end                            as epsilon,
               row_number() over (order by pos desc) - 1 as pow
        from pos_counts
    ),
    add_decimals as (
        select *,
               gamma * power(2, pow)   as gamma_dec,
               epsilon * power(2, pow) as epsilon_dec
        from add_rates
    )
select sum(gamma_dec) * sum(epsilon_dec)
from add_decimals;