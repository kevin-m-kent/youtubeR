#' Get Channel Id by Name
#'
#' Retrieves the Youtube channel ID from the username.
#'
#'
#' @param handle youtube handle (not including the @ symbol)
#' @param max_results  The maximum number of results to return.
#' @inheritParams yt_call_api
#'
#' @return The channel ID for that username, string.
#' @export
#'
#' @examples
#' @export
get_channel_id <- function(  handle,
                               max_results = 100,
                             client = yt_construct_client(),
                             cache_disk = getOption("yt_cache_disk", FALSE),
                             cache_key = getOption("yt_cache_key", NULL),
                             token = NULL) {
  res <- yt_call_api(
    endpoint = "channels",
    query = list(
      part = "id",
      forHandle = handle),
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  if (length(res$items)) {
      return(purrr::pluck(res, "items", 1, "id"))
    return(res)
  } else {
    return(NULL) # nocov
  }
}
