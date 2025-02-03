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
#' # Copy/paste values from your client.
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
#' yt_has_client_envvars()
#' yt_has_client_envvars("an_id_string", "a_secret_string")
yt_has_client_envvars <- function(client_id = Sys.getenv("YOUTUBE_CLIENT_ID"),
                                  client_secret = Sys.getenv(
                                    "YOUTUBE_CLIENT_SECRET"
                                  )) {
  return(nchar(client_id) && nchar(client_secret))
}


#' Construct a YouTube OAuth client
#'
#' Builds the OAuth client object for google apis.
#'
#' @inheritParams yt_has_client_envvars
#'
#' @return An [httr2::oauth_client()] object.
#' @export
#'
#' @examples
#' client <- yt_construct_client()
yt_construct_client <- function(client_id = Sys.getenv("YOUTUBE_CLIENT_ID"),
                                client_secret = Sys.getenv(
                                  "YOUTUBE_CLIENT_SECRET"
                                )) {
  if (!yt_has_client_envvars(client_id, client_secret)) {
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
      name = "youtube_data_api"
    )
  )
}

#' Authenticate with a YouTube OAuth client
#'
#' Load or generate a YouTube OAuth token for use in the other functions in
#' this package. The primary use of this function is to cache values early in a
#' script (so the user can walk away). Otherwise the other functions in this
#' package will prompt for authentication when needed. Once the values are
#' cached, the rest of this package will use them by default for that client.
#'
#' @param client A YouTube OAuth client created with [yt_construct_client()].
#' @param force A logical indicating whether to force a refresh of the token.
#' @param refresh_token A refresh token associated with this `client`. This
#'   parameter exists primarily for testing. If you wish to provide a refresh
#'   token (for example, for automated processes), we recommend setting a
#'   `YOUTUBE_REFRESH_TOKEN` environment variable.
#'
#' @return A YouTube OAuth token, invisibly.
#' @export
#' @examplesIf yt_has_client_envvars() && interactive()
#' token <- yt_authenticate()
yt_authenticate <- function(client = yt_construct_client(),
                            force = FALSE,
                            refresh_token = NULL) {
  if (force) {
    if (is.null(refresh_token)) {
      token <- NULL
    } else {
      token <- .yt_refresh_token(client, refresh_token)
    }
  } else {
    # This tries everything that we can try without bugging the user.
    token <- .get_token_noninteractive(client, refresh_token)
  }

  if (rlang::is_interactive() && is.null(token)) { # nocov start
    token <- httr2::oauth_flow_auth_code(
      client = client,
      auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
      scope = "https://www.googleapis.com/auth/youtube",
      redirect_uri = "http://127.0.0.1:8888/authorize/"
    )

    the[[rlang::hash(client)]] <- token
  } # nocov end

  return(invisible(token))
}

#' Retrieve a YouTube OAuth token if possible
#'
#' @inheritParams yt_authenticate
#' @param refresh_token A refresh token associated with this `client`.
#'
#' @return A YouTube OAuth token, or `NULL`.
#' @keywords internal
.get_token_noninteractive <- function(client, refresh_token = NULL) {
  key <- rlang::hash(client)
  if (!is.null(the[[key]])) {
    if (!.is_expired(the[[key]]$expires_at)) {
      return(the[[key]])
    }
  }

  return(.yt_refresh_token(client, refresh_token = refresh_token))
}

.is_expired <- function(expiration_ts) {
  return(
    expiration_ts < as.integer(Sys.time())
  )
}

#' Refresh a YouTube OAuth token
#'
#' @inherit .get_token_noninteractive params return
#' @keywords internal
.yt_refresh_token <- function(client, refresh_token = NULL) {
  refresh_token <- refresh_token %||%
    the[[rlang::hash(client)]]$refresh_token %||%
    Sys.getenv("YOUTUBE_REFRESH_TOKEN")
  if (nchar(refresh_token)) {
    return(httr2::oauth_flow_refresh(client, refresh_token))
  }
  return(NULL)
}

#' YouTube OAuth authentication
#'
#' This function is the main way authentication is handled in this package. It
#' tries to find a token non-interactively if possible, but bothers the user if
#' necessary.
#'
#' @inheritParams yt_authenticate
#' @inheritParams httr2::req_oauth_auth_code
#' @param request A [httr2::request()].
#' @param cache_key If you are authenticating with multiple users using the same
#'   client, use this key to differentiate between those users.
#' @param token A YouTube API OAuth token, or the `access_token` string from
#'   such a token. We recommend that you instead supply a `client`, in which
#'   case an appropriate token will be located if possible.
#'
#' @return A [httr2::request()] with oauth authentication information.
#' @keywords internal
.yt_req_auth <- function(request,
                         client = yt_construct_client(),
                         cache_disk = getOption("youtuberR.cache_disk", FALSE),
                         cache_key = getOption("youtuberR.cache_key", NULL),
                         token = NULL) {
  if (!is.null(token)) {
    if (inherits(token, "httr2_token")) {
      if (!.is_expired(token[["expires_at"]])) {
        return(httr2::req_auth_bearer_token(request, token[["access_token"]]))
      }
    } else {
      return(httr2::req_auth_bearer_token(request, token))
    }
  }

  # If cache_disk is TRUE, we need to let httr2 deal with things; we can't dig
  # into that cache without digging into unexported httr2 functions (and thus
  # implementation might change).
  if (!cache_disk) {
    token <- .get_token_noninteractive(client)
    if (!is.null(token)) {
      return(httr2::req_auth_bearer_token(request, token$access_token))
    }
  }

  return(
    httr2::req_oauth_auth_code(
      req = request,
      client = client,
      auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
      scope = "https://www.googleapis.com/auth/youtube",
      cache_disk = cache_disk,
      cache_key = cache_key,
      redirect_uri = "http://127.0.0.1:8888/authorize/"
    )
  )
}
