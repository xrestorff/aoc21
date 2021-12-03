-- part one
with add_priors as (
    select *,
           lag(input) over () as prior
    from day01_data
)
select count(*)
from add_priors
where prior < input;

-- part two
with add_two_priors as (
    select *,
           lag(input, 1) over () as one_prior,
           lag(input, 2) over () as two_prior
    from day01_data
),
     full_windows as (
         select input + one_prior + two_prior as input
         from add_two_priors
         where one_prior notnull
           and two_prior notnull
     ),
     add_priors as (
         select *,
                lag(input) over () as prior
         from full_windows
     )
select count(*)
from add_priors
where prior < input;