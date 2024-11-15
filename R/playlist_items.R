#' Get playlist items
#'
#' Retrieve a list of items in a given playlist.
#'
#' @param playlist_id The ID of a playlist.
#' @param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#'
#' @return A list of videos, each of which has a videoId and a videoPublishedAt.
#' @export
#'
#' @examplesIf yt_has_client_envvars() && interactive()
#' get_playlist_items(playlist_id = get_upload_playlist_id())
get_playlist_items <- function(playlist_id,
                               max_results = 100,
                               client = yt_construct_client(),
                               cache_disk = getOption("youtuberR.cache_disk",
                                                      FALSE),
                               cache_key = getOption("youtuberR.cache_key",
                                                     NULL),
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

#' Get playlist video ids
#'
#' Retrieves video ids for a particular playlist.
#'
#' @inheritParams get_playlist_items
#'
#' @return A character vector of video ids.
#' @export
#'
#' @examplesIf yt_has_client_envvars() && interactive()
#' get_playlist_video_ids(playlist_id = get_upload_playlist_id())
get_playlist_video_ids <- function(playlist_id,
                                   max_results = 100,
                                   client = yt_construct_client(),
                                   cache_disk = getOption(
                                     "yt_cache_disk", FALSE
                                   ),
                                   cache_key = getOption(
                                     "yt_cache_key", NULL
                                   ),
                                   token = NULL) {
  playlist_items <- get_playlist_items(
    playlist_id,
    max_results,
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  return(
    purrr::map_chr(playlist_items, purrr::pluck, "videoId")
  )
}
