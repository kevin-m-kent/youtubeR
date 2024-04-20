#' Get videos for given playlistId
#'
#' @param playlistId Youtube assigned id for given playlist.
#' @param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#'
#' @return A list of playlists, each with title and description.
#' @export
#'
#' @examplesIf yt_has_client_envvars() && interactive()
#' get_videos_for_playlistId()
#'
#' playlistId <<- "PLbcglKxZP5PMU2rNPBpYIzLTgzd5aOHw2"
#' @export
# url \
#   'https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2Cstatus&maxResults=25&playlistId=PLbcglKxZP5PMU2rNPBpYIzLTgzd5aOHw2&fields=items(snippet(publishedAt%2Ctitle%2CvideoOwnerChannelTitle))&key=[YOUR_API_KEY]' \
#   --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
#   --header 'Accept: application/json' \
#   --compressed
get_videos_for_playlistId <- function(playlistId = NULL,
                                      max_results = 100,
                                      client = yt_construct_client(),
                                      cache_disk = getOption("yt_cache_disk", FALSE),
                                      cache_key = getOption("yt_cache_key", NULL),
                                      token = NULL) {
  query <- list(
    part = "snippet",
    fields = "nextPageToken,items(snippet(title, publishedAt, description, videoOwnerChannelTitle))",
    maxResults = max_results,
    playlistId = playlistId
  )
  res <- yt_call_api(
    endpoint = "playlistItems",
    query = query,
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  nextPageToken <- res[[1]] # res has 2 elements, 2nd has all video details
  cat(nextPageToken, "\n")

  if (length(res$items)) {
    #   return(purrr::map(res$items, purrr::pluck, "contentDetails"))
    return(purrr::map(res$items, purrr::pluck, "snippet"))
  } else {
    return(NULL) # nocov
  }
}


#'  Return tibble for videos for given playlist
#' @param playlistId Youtube assigned id for given playlist.
#' @export
make_video_tibble <- function(playlistId = playlistId) {
  res <- get_videos_for_playlistId(playlistId = playlistId)
  return(as.data.frame(do.call(rbind, res)))
}
