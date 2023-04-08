#' Construct Client
#'
#' Builds the oauth client object for google apis.
#'
#' Requires the following environment variables: YOUTUBE_CLIENT_ID, YOUTUBE_CLIENT_SECRET
#'
#'
#'
#'
#' @param token_url Google's oauth url
#'
#'
#' @return an httr2 oauth client object
#' @export
#'
#' @examples
#'
#' google_client <- construct_client()
construct_client <- function(token_url = "https://oauth2.googleapis.com/token") {

  client_id <- Sys.getenv("YOUTUBE_CLIENT_ID")
  client_secret <- Sys.getenv("YOUTUBE_CLIENT_SECRET")

  stopifnot(
      "YOUTUBE_CLIENT_ID environment variables must be set." = nchar(client_id) > 0,
     "YOUTUBE_CLIENT_SECRET environment variables must be set." = nchar(client_secret) > 0
    )

  client <- httr2::oauth_client(id=  client_id,
                         token_url  = token_url,
                         secret = client_secret,
                         auth = "body",   # header or body
                         name = "video_info_api")

  client

}
