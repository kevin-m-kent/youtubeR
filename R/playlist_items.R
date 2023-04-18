#' Get playlist items
#'
#' Retrieve a list of items in a given playlist.
#'
#' @param playlist_id The ID of a playlist.
#' @param max_results The maximum number of results to return.
#' @inheritParams .call_youtube_api
#'
#' @return A list of videos, each of which has a videoId and a videoPublishedAt.
#' @export
#'
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_playlist_items(playlist_id = get_upload_playlist_id())
get_playlist_items <- function(playlist_id,
                               max_results = 100,
                               token = fetch_token()) {
  res <- .call_youtube_api(
    endpoint = "playlistItems",
    query = list(
      part = "contentDetails",
      maxResults = max_results,
      playlistId = playlist_id
    ),
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
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_playlist_video_ids(playlist_id = get_upload_playlist_id())
get_playlist_video_ids <- function(playlist_id,
                                   max_results = 100,
                                   token = fetch_token()) {
  playlist_items <- get_playlist_items(playlist_id, max_results, token)

  return(
    purrr::map_chr(playlist_items, purrr::pluck, "videoId")
  )
}
