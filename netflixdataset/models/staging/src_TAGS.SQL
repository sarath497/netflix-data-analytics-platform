with raw_tags as (
    select * from NETFLIXDATASET.RAW.RAW_TAGS
)
select userid as user_id, movieid as movie_id, tag, to_timestamp_ltz(timestamp) as tag_timestamp
from raw_tags;