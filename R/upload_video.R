#' Upload a video to youtube
#'
#' Takes a client and a video file path and uploads the video to youtube. It returns the video id.ß
#'
#' Requires the following environment variables: YOUTUBE_CLIENT_ID, YOUTUBE_CLIENT_SECRET
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
#' 
#' snippet <- list("title" = unbox("video kids test"),
#'                       "description" = unbox("description_test"),
#'                       "tags" = "kevin,kent"),
#' status = list("privacyStatus" = unbox("private"),
#'              "selfDeclaredMadeForKids" = unbox("false"))
upload_video <- function(client, snippet, video_path) {

    req <- request("https://www.googleapis.com/upload/youtube/v3/videos?part=snippet&part=status")

    snippet_string <- list(snippet = snippet) %>%
        jsonlite::toJSON()

    metadata <- tempfile()
    writeLines(snippet_string, metadata)

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
        ) %>%
        req_body_multipart(
            list(
            metadata = curl::form_file(path = metadata, type = "application/json; charset=UTF-8"),
            media = curl::form_file(vide_path))
        ) %>%
        req_perform()

    videoId <- resp %>%
        resp_body_json() %>%
        pluck("id")

    videoId

}
