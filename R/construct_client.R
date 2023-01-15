#' Construct Client
#'
#' Builds the oauth client object for google apis.
#'
#' Requires the following environment variables:
#'
#' CLIENT_ID
#' CLIENT_SECRET
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
#' google_client <- create_client()
construct_client <- function(token_url = "https://oauth2.googleapis.com/token") {

  client_id <- Sys.getenv("CLIENT_ID")
  client_secret <- Sys.getenv("CLIENT_SECRET")

  client <- httr2::oauth_client(id=  client_id,
                         token_url  = token_url,
                         secret = client_secret,
                         auth = "body",   # header or body
                         name = "video_info_api")

  client

}
