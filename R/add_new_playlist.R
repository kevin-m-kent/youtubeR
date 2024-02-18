#'  Add new playlist
#'
#'  Add a new playlist
#'
#' #@param mine boolean
#' #@param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#'
#' @return A list of playlists, each with title and description.
#' @export
#'
# #@examplesIf yt_has_client_envvars() && interactive()
# # POST https://www.googleapis.com/youtube/v3/playlists
# #   body must contain --data '{"snippet":{"title":"new"}}' \
#' @export
add_new_playlist <- function(endpoint = "playlists",
                             method = "POST",
                             query = list(
                               part = "snippet, contentDetails"
                             ),
                             #              body = '{"snippet":{"title":"new"}}',
                             body = NULL,
                             client = yt_construct_client(),
                             cache_disk = getOption("yt_cache_disk", FALSE),
                             cache_key = getOption("yt_cache_key", NULL),
                             token = NULL) {
  res <- yt_call_api(
    endpoint = "playlists",
    query = query,
    body = body,
    method = method,
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  if (length(res$items)) {
    #   return(purrr::map(res$items, purrr::pluck, "contentDetails"))
    return(purrr::map(res$items, purrr::pluck, "snippet"))
  } else {
    return(NULL) # nocov
  }
}
