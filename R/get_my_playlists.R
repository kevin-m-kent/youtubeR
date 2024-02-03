#'  Get my playlists, `mine=TRUE`
#'
#'  Retrieve a list of playlists where mine=TRUE
#'  (TODO: refactor to accept mine or any valid channelId)
#'
#'  @param mine boolean
#'  @param max_results The maximum number of results to return.
#'  @inheritParams yt_call_api
#'
#'  @return A list of playlists, each with title and description.
#'  @export
#'
#' @examples get_my_playlists()
#' # from Youtube - get all playlists
# curl \
#' #  'https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&maxResults=25&mine=true&fields=items(snippet(title%2C%20description))&key=[YOUR_API_KEY]' \
#' #  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
#' #  --header 'Accept: application/json' \
#' #--compressed
# (TODO refactor to allow:  channelId =  "UClB5qWyXejlAwwkDAzJis-Q" # my channel  )
get_my_playlists <- function(max_results = 100,
                             client = yt_construct_client(),
                             cache_disk = getOption("yt_cache_disk", FALSE),
                             cache_key = getOption("yt_cache_key", NULL),
                             token = NULL) {
  res <- yt_call_api(
    endpoint = "playlists",
    query = list(
      part = "snippet, contentDetails",
      fields = "items(snippet(title, description))",
      maxResults = max_results,
      # (TODO channelId = channelId),
      mine = TRUE
    ),
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )
  # browser()
  # if (length(res$items)) {
  #    return(purrr::map(res$items, purrr::pluck, "contentDetails"))
  #    return(purrr::map(res$items, purrr::pluck, "snippet"))
  #  } else {
  #    return(NULL) # nocov
  #  }
}
