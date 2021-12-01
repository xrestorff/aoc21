-- part one
with add_priors as (
    select *,
           lag(measurement) over () as prior
    from day01_data
)
select count(*)
from add_priors
where prior < measurement;

-- part two
with add_two_priors as (
    select *,
           lag(measurement, 1) over () as one_prior,
           lag(measurement, 2) over () as two_prior
    from day01_data
),
     full_windows as (
         select measurement + one_prior + two_prior as measurement
         from add_two_priors
         where one_prior notnull
           and two_prior notnull
     ),
     add_priors as (
         select *,
                lag(measurement) over () as prior
         from full_windows
     )
select count(*)
from add_priors
where prior < measurement;