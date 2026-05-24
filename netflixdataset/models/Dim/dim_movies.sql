{{ config(materialized='table') }}
with src_movies as (
    select * from {{ ref('src_MOVIES') }}
)
select
    movie_id,
    initcap(trim(title)) as movie_title,
    split(genres,'|') as genres,
from src_movies