{{ config(materialized='table') }}
with src_GENOME_TAGS as(
    select * from {{ ref('src_GENOME_TAGS')}}
)
select tag_id, initcap(trim(tag)) as tag_name
from src_GENOME_TAGS