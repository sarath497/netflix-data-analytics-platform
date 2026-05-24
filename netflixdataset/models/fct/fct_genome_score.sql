{{ config(materialized='table') }}
with src_genome_scores as (
    select * from {{ ref('src_GENOME_SCORES')}}
)
select movie_id, tag_id, round(relevance,4) as relevance
from src_genome_scores
where relevance >  0