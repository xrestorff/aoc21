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

-- part two
with recursive
    oxygen as (
        select input, counter, count(*) over () as row_count
        from (
                 select input,
                        1                                    as counter,
                        cast(substr(input, 1, 1) as integer) as current_bit,
                        sum(substr(input, 1, 1)::integer) over () as bit_sum,
                        count(*) over ()                          as num_rows
                 from day03
             ) as base
        where current_bit = case
           when bit_sum >= (num_rows - bit_sum) then 1
           else 0 end
        union all
        select input, counter, count(*) over ()
        from (
                 select input,
                        counter + 1                                    as counter,
                        cast(substr(input, counter + 1, 1) as integer) as current_bit,
                        sum(substr(input, counter + 1, 1)::integer) over () as bit_sum,
                        count(*) over ()                          as num_rows
                 from oxygen
                 where row_count > 1
             ) as base
        where current_bit = case
           when bit_sum >= (num_rows - bit_sum) then 1
           else 0 end
    ),

    co2 as (
        select input, counter, count(*) over () as row_count
        from (
                 select input,
                        1                                    as counter,
                        cast(substr(input, 1, 1) as integer) as current_bit,
                        sum(substr(input, 1, 1)::integer) over () as bit_sum,
                        count(*) over ()                          as num_rows
                 from day03
             ) as base
        where current_bit = case
           when bit_sum >= (num_rows - bit_sum) then 0
           else 1 end
        union all
        select input, counter, count(*) over ()
        from (
                 select input,
                        counter + 1                                    as counter,
                        cast(substr(input, counter + 1, 1) as integer) as current_bit,
                        sum(substr(input, counter + 1, 1)::integer) over () as bit_sum,
                        count(*) over ()                          as num_rows
                 from co2
                 where row_count > 1
             ) as base
        where current_bit = case
           when bit_sum >= (num_rows - bit_sum) then 0
           else 1 end
    ),

    oxygen_binary as (
        select distinct last_value(input) over () as oxygen
        from oxygen),
    co2_binary as (
        select distinct last_value(input) over () as co2
        from co2)

select (co2_binary.co2::bit(12))::integer * (oxygen_binary.oxygen::bit(12))::integer
from oxygen_binary
         cross join co2_binary;