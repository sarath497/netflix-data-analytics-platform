with raw_links as (
    select * from NETFLIXDATASET.RAW.RAW_LINKS
)
select movieid as movie_id, imdbid, tmdbid
from raw_links;