{{ config(materialized='ephemeral') }}
with movies as(
    select * from {{ ref('dim_movies') }}
)
,tags as(
    select * from {{ ref('dim_genome_tags')}}
)
scores as(
    select * from {{ ref('fct_genome_score')}}
)
select m.movie_id,m.movie_title,t.tag_name,s.relevance_score,m.genres
from movies m
left join scores s on m.movie_id = s.movie_id
left join tags t on s.tag_id = t.tag_id