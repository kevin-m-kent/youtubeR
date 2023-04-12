#' Get Video Ids
#'
#' Retrieves video ids for a particular playlist.
#'
#' @param playlist_id id retrieved from get_playlist_id
#' @param client httr2 oauth2 client for google apis
#' @param token_url google's oauth2 token url
#' @param auth_url google's oauth2 auth url
#' @param scope token scope, default is youtube
#'
#' @return list of video ids
#' @export
#'
#' @examples
#'
#' #'google_client <- construct_client()
#'
#'playlist_ids <- get_playlist_ids(google_client)
#'
#'video_ids <- purrr::map(my_playlist_id, get_video_ids, client = my_client)
get_video_ids <- function(playlist_id, client,  token_url = "https://oauth2.googleapis.com/token",
                          auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
                          scope = "https://www.googleapis.com/auth/youtube") {

  req_2 <- httr2::request(glue::glue("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=100&playlistId={playlist_id}"))

  resp_2 <- httr2::req_oauth_auth_code( req_2,
                                        client = client,
                                        auth_url = auth_url,
                                        scope = scope,
                                        pkce = FALSE,
                                        auth_params = list(scope=scope, response_type="code"),
                                        token_params = list(scope=scope, grant_type="authorization_code"),
                                        host_name = "localhost",
                                        host_ip = "127.0.0.1",
                                        #port = httpuv::randomPort()
                                        port = 8080,
  ) |>
    # # req_body_multipart(
    #    list(
    #      metadata = curl::form_file(path = metadata, type = "application/json; charset=UTF-8"),
    #      media = curl::form_file("kkent intro.mp4"))
    #  ) |>
    httr2::req_perform()

  all_ids <-  resp_2 |>
    httr2::resp_body_json() |>

    purrr::pluck("items") |>
    purrr::map(~ purrr::pluck(.,"contentDetails",  "videoId"))

  all_ids

}
