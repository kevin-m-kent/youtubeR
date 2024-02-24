# test-jim-test.R
# PURPOSE:  place for jim to test, to be removed

#' Given a channelId, return the playlists.

#' @param channelId The Youtube assigned channelId for a specific channel.
#' @param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#' @export
get_test_playlists <- function(channelId,
                               max_results = 100,
                               client = yt_construct_client(),
                               cache_disk = getOption("yt_cache_disk", FALSE),
                               cache_key = getOption("yt_cache_key", NULL),
                               token = NULL) {
  res <- yt_call_api(
    endpoint = "playlists",
    query = list(
      part = "id, snippet, contentDetails",
      fields = "items(id, snippet(title, description))",
      maxResults = max_results,
      channelId = channelId
    ),
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  #   if (F) {
  #     if (length(res$items)) {
  #       #   return(purrr::map(res$items, purrr::pluck, "contentDetails"))
  #       # return(purrr::map(res$items, purrr::pluck, "snippet"))
  #       return(purrr::map(res$items, unlist, recursive = F))
  #     } else {
  #       return(NULL) # nocov
  #     }
  #   }
}
