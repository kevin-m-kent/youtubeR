#' Get Video Status
#'
#' Retrieves the processing details for a list of videos
#'
#' @param video_ids list of video ids
#' @param client an httr2 oauth2 client for the google api
#' @param token_url google's oauth2 token url
#' @param auth_url google's oauth2 auth url
#' @param scope token scope, default is youtube
#'
#' @return list of processing details (processingStatus is probably of most interest)
#' @export
#'
#' @examples
#'
#' google_client <- construct_client()
#'
#' my_playlist_id <- get_playlist_ids(google_client)
#' video_ids <- purrr::map(my_playlist_id, get_video_ids, client = google_client)
#'video_details <- purrr::map(video_ids, get_video_status, client = google_client)
#'

get_video_status <- function(video_ids, client, token_url = "https://oauth2.googleapis.com/token",
                             auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
                             scope = "https://www.googleapis.com/auth/youtube") {

  all_ids_csv <- video_ids %>%
    paste(collapse = ",")

  req_video_details <- httr2::request(glue::glue("https://youtube.googleapis.com/youtube/v3/videos?part=processingDetails&part=snippet%2CcontentDetails%2Cstatistics&id={all_ids_csv}"))

  video_details <- httr2::req_oauth_auth_code(req_video_details,
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
  ) %>%
    # # req_body_multipart(
    #    list(
    #      metadata = curl::form_file(path = metadata, type = "application/json; charset=UTF-8"),
    #      media = curl::form_file("kkent intro.mp4"))
    #  ) %>%
    httr2::req_perform()

  video_details %>%
    httr2::resp_body_json() %>%
    purrr::pluck("items") %>%
    purrr::map(~ purrr::pluck(.,"processingDetails"))


}
