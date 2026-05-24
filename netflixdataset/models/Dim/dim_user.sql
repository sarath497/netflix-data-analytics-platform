{{ config(materialized='table') }}
with ratings as (
    select DISTINCT user_id from {{ ref('src_RATINGS')}}
),
tags as (
    select DISTINCT user_id from {{ref('src_TAGS')}}
)
SELECT DISTINCT user_id
FROM (SELECT user_id FROM RATINGS
UNION
SELECT user_id FROM TAGS)