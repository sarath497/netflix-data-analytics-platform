{{ config(materialized='table') }}
with fct_ratings as (
    select * from {{ ref('fct_ratings')}}
)
,seed_dates as (
    select * from {{ ref('seed_movie_realese_date')}}
)
select f.*,
       case 
            when s.release_date is null then 'unknown'
            else 'known'
        end as release_date_status
from fct_ratings f
join seed_dates s on f.movie_id = s.movie_id