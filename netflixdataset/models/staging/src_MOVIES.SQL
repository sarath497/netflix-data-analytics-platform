with raw_movies as (
    select * from NETFLIXDATASET.RAW.RAW_MOVIES
)
select movieid as movie_id, title, genres
from raw_movies;