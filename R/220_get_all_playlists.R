# 220_get_all_playlists.R

library(youtubeR)

#  from Youtube - get all playlists

# curl \
#   'https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&maxResults=25&mine=true&fields=items(snippet(title%2C%20description))&key=[YOUR_API_KEY]' \
#   --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
#   --header 'Accept: application/json' \
# --compressed


channelId =  "UClB5qWyXejlAwwkDAzJis-Q" # my channel  
get_all_playlists  <- function(channelId,
                               max_results = 100,
                               client = yt_construct_client(),
                               cache_disk = getOption("yt_cache_disk", FALSE),
                               cache_key = getOption("yt_cache_key", NULL),
                               token = NULL) {
res  <- yt_call_api(
  endpoint = "playlists",
  query = list(
               part = "snippet, contentDetails",
               fields = "items(snippet(title, description))",
               maxResults = max_results,
               channelId = channelId
               ),
                    client=client,
                    cache_disk = cache_disk,
                    cache_key = cache_key,
                    token = token
                    )
# browser()
  if (length(res$items)) {
#    return(purrr::map(res$items, purrr::pluck, "contentDetails"))
    return(purrr::map(res$items, purrr::pluck, "snippet"))
  } else {
    return(NULL) # nocov
  }
}

get_all_playlists(channelId)

if (F) {
get_playlist_items <- function(playlist_id,
                               max_results = 100,
                               client = yt_construct_client(),
                               cache_disk = getOption("yt_cache_disk", FALSE),
                               cache_key = getOption("yt_cache_key", NULL),
                               token = NULL) {
  res <- yt_call_api(
    endpoint = "playlistItems",
    query = list(
      part = "contentDetails",
      maxResults = max_results,
      playlistId = playlist_id
    ),
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  if (length(res$items)) {
    return(purrr::map(res$items, purrr::pluck, "contentDetails"))
  } else {
    return(NULL) # nocov
  }
}
}
#   LEGACY
# ----------

browse_gc_credentials()


#
## API_KEY
## OAUTH2_ID
## OAUTH2_SECRET
#

# I used different names in .Renviron
YOUTUBE_CLIENT_ID <- Sys.getenv("OAUTH2_ID")
YOUTUBE_CLIENT_SECRET <- Sys.getenv("OAUTH2_SECRET")

Sys.setenv(YOUTUBE_CLIENT_ID = Sys.getenv("OAUTH2_ID"))
Sys.setenv(YOUTUBE_CLIENT_SECRET = Sys.getenv("OAUTH2_SECRET"))


my_playlist_id <- get_upload_playlist_id()
my_playlist_id
# Ideally, set these in your .Renviron file.
video_ids <- get_playlist_video_ids(my_playlist_id)
video_ids

video_details <- get_video_processing_details(video_ids)
video_details

# --------------------------------------------------------
# one of my playlists
channelId =  "UClB5qWyXejlAwwkDAzJis-Q", # my channel  
videoId <- "QgdVd7ujEro" # Brenda Lee
playlist_id <- "PLbcglKxZP5PMU2rNPBpYIzLTgzd5aOHw2"
get_playlist_items(playlist_id = playlist_id)
