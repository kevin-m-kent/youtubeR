#'  Get my playlists, `mine=TRUE`
#'
#'  Retrieve a list of playlists where mine=TRUE
#'  (TODO: refactor to accept mine or any valid channelId)
#'
#' @param mine boolean
#' @param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#'
#' @return A list of playlists, each with title and description.
#' @export
#'
#' @examplesIf yt_has_client_envvars() && interactive()
#' get_my_playlists()
#' #  (TODO refactor to allow:  channelId =  "UClB5qWyXejlAwwkDAzJis-Q" # my channel  )
#' @export
get_my_playlists <- function(max_results = 100,
                             client = yt_construct_client(),
                             cache_disk = getOption("yt_cache_disk", FALSE),
                             cache_key = getOption("yt_cache_key", NULL),
                             token = NULL) {
  res <- yt_call_api(
    endpoint = "playlists",
    query = list(
      part = "snippet, contentDetails",
      fields = "items(id, snippet(title, description))",
      maxResults = max_results,
      # (TODO channelId = channelId),
      mine = TRUE
    ),
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


#'  Given a handle (Youtube name), return the channel_id

#'
#' @param handle Youtube account name.
#' @param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#'
#' @return A channel_id
#' @export
#'
#' @examplesIf yt_has_client_envvars() && interactive()
#' get_channel_id("SFIScience")
#' get_channel_id("@GoogleDevelopers")
#' @export
get_channel_id <- function(handle,
                           max_results = 100,
                           client = yt_construct_client(),
                           cache_disk = getOption("yt_cache_disk", FALSE),
                           cache_key = getOption("yt_cache_key", NULL),
                           token = NULL) {
  res <- yt_call_api(
    endpoint = "channels",
    query = list(
      part = "id",
      forHandle = handle
    ),
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

#' Given a channelId, return the playlists.

#' @param channelId The Youtube assigned channelId for a specific channel.
#' @param max_results The maximum number of results to return.
#' @inheritParams yt_call_api
#' @export
get_playlists <- function(channelId,
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
  if (length(res$items)) {
    #   return(purrr::map(res$items, purrr::pluck, "contentDetails"))
    # return(purrr::map(res$items, purrr::pluck, "snippet"))
    return(purrr::map(res$items, unlist, recursive = F))
  } else {
    return(NULL) # nocov
  }
}
