#' Visit Google Cloud Credentials page
#'
#' Launch the Google Cloud "Credentials" page (where you can configure OAuth 2.0
#' Clients). After you configure a client, copy/paste the Client ID and Client
#' Secret into the `YOUTUBE_CLIENT_ID` and `YOUTUBE_CLIENT_SECRET` environment
#' variables. We recommend placing these environment variables in your
#' `.Renviron` file.
#'
#' @return The url of the "Credentials" page, invisibly.
#' @export
#'
#' @examples
#' gc_credentials_url <- browse_gc_credentials()
#' Sys.setenv(YOUTUBE_CLIENT_ID = "12345-ab12c.apps.googleusercontent.com")
#' Sys.setenv(YOUTUBE_CLIENT_SECRET = "ABCD-eFg_H")
browse_gc_credentials <- function() {
  gc_creds_url <- "https://console.cloud.google.com/apis/credentials"
  if (rlang::is_interactive()) { # nocov start
    utils::browseURL(gc_creds_url)
  } # nocov end
  return(invisible(gc_creds_url))
}

#' Check for YouTube client environment variables
#'
#' Reports whether YouTube client environment variables are set (or, if
#' arguments are provided, check that they have characters).
#'
#' @param client_id A [Google Cloud OAuth
#'   2.0](https://console.cloud.google.com/apis/credentials) client ID. We
#'   recommend you save it as an environment variable, `YOUTUBE_CLIENT_ID`.
#' @param client_secret A [Google Cloud OAuth
#'   2.0](https://console.cloud.google.com/apis/credentials) client secret. We
#'   recommend you save it as an environment variable, `YOUTUBE_CLIENT_SECRET`.
#'
#' @return A logical indicating whether the variables are available.
#' @export
#'
#' @examples
#' has_youtube_client_envvars()
#' has_youtube_client_envvars("an_id_string", "a_secret_string")
has_youtube_client_envvars <- function(client_id = Sys.getenv("YOUTUBE_CLIENT_ID"),
                                       client_secret = Sys.getenv("YOUTUBE_CLIENT_SECRET")) {
  return(nchar(client_id) && nchar(client_secret))
}


#' Construct a YouTube OAuth client
#'
#' Builds the OAuth client object for google apis.
#'
#' @inheritParams has_youtube_client_envvars
#'
#' @return An [httr2::oauth_client()] object.
#' @export
#'
#' @examples
#' google_client <- construct_client()
construct_client <- function(client_id = Sys.getenv("YOUTUBE_CLIENT_ID"),
                             client_secret = Sys.getenv("YOUTUBE_CLIENT_SECRET")) {
  if (!has_youtube_client_envvars(client_id, client_secret)) {
    cli::cli_abort(
      "Please provide a YOUTUBE_CLIENT_ID and YOUTUBE_CLIENT_SECRET.",
      class = "missing_youtube_client"
    )
  }

  return(
    httr2::oauth_client(
      id = client_id,
      token_url = "https://oauth2.googleapis.com/token",
      secret = client_secret,
      auth = "header",
      name = "video_info_api"
    )
  )
}

#' Fetch a YouTube API token
#'
#' Load or generate a `YOUTUBE_TOKEN` for use in the other functions in this
#' package.
#'
#' @param google_client A client created with [construct_client()].
#' @param force A logical indicating whether to force a refresh of the token.
#'
#' @return A YouTube token, invisibly.
#' @export
#' @examples
#' token <- fetch_token()
fetch_token <- function(google_client = construct_client(), force = FALSE) {
  token <- Sys.getenv("YOUTUBE_TOKEN")

  # Long-term we might want to look into mocking this, but gargle will deal with
  # this so it's probably not worth it.
  if (rlang::is_interactive() && (force || nchar(token) == 0)) { # nocov start
    full_token <- httr2::oauth_flow_auth_code(
      client = google_client,
      auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
      port = 8080L,
      scope = "https://www.googleapis.com/auth/youtube",
      pkce = TRUE
    )

    # gargle will handle this better, but for now we just keep the bearer token
    # piece. We'll save it in an environment variable in this session, and return
    # it invisibly.
    token <- full_token$access_token
    Sys.setenv(YOUTUBE_TOKEN = token)

    cli::cli_inform(
      "{.envvar YOUTUBE_TOKEN} environment variable set."
    )
  } # nocov end

  return(invisible(token))
}
