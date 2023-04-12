#' Get Playlist Ids
#'
#' Retrieves the upload playlist ids.
#'
#' @param client an httr2 oauth2 client for the google api
#' @param token_url google's oauth2 token url
#' @param auth_url google's oauth2 auth url
#' @param scope token scope, default is youtube
#'
#' @return list of playlist ids for uploads
#' @export
#'
#' @examples
#'
#'google_client <- construct_client()
#'
#'playlist_ids <- get_playlist_ids(google_client)
get_playlist_ids <- function(client, token_url = "https://oauth2.googleapis.com/token",
                             auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
                             scope = "https://www.googleapis.com/auth/youtube") {

  req <- httr2::request("https://www.googleapis.com/youtube/v3/channels?part=contentDetails&mine=true")

  resp <- httr2::req_oauth_auth_code( req,
                                      client = client,
                                      auth_url = auth_url,
                                      scope = scope,
                                      pkce = FALSE,
                                      auth_params = list(scope=scope, response_type="code"),
                                      token_params = list(scope=scope, grant_type="authorization_code"),
                                      host_name = "localhost",
                                      host_ip = "127.0.0.1",
                                      port = 8080,
  ) |>
    httr2::req_perform()

  resp |>
    httr2::resp_body_json() |>
    purrr::pluck("items") |>
    purrr::map(~ purrr::pluck(.,"contentDetails", "relatedPlaylists", "uploads"))

}
