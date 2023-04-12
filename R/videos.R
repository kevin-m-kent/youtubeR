#' Get video processing details
#'
#' Retrieves the processing details for a vector of video IDs
#'
#' @param video_ids A character vector of video ids.
#' @inheritParams .call_youtube_api
#'
#' @return A list of processing status details. processingStatus is probably of
#'   most interest
#' @export
#'
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_upload_playlist_id() |>
#'   get_playlist_items() |>
#'   get_video_processing_details()
get_video_processing_details <- function(video_ids, token = fetch_token()) {
  res <- .call_youtube_api(
    endpoint = "videos",
    query = list(
      part = "processingDetails",
      id = paste(video_ids, collapse = ",")
    ),
    token = token
  )

  # TODO: Clean this up. I like to convert names to snake_case, and we should at
  # least consider rectangling this data (although that might come in a
  # downstream package).

  if (length(res$items)) {
    # TODO: Technically these could come back in a different order, or be
    # missing some. We should dig into res$items[[x]]$id to match up to
    # video_ids.
    names(res$items) <- video_ids
    return(purrr::map(res$items, purrr::pluck, "processingDetails"))
  } else {
    return(NULL)
  }
}
