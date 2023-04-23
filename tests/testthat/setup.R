library(httptest2)

# TODO: To make R CMD Check, all of the tests now require exactly the token
# settings I used. That's not going to be viable long-term, so we'll fix that
# the next time through. These tests will almost definitely fail for you, or
# perhaps just be kinda boring (they'll get skipped).

# Make sure the YT environment variables, if they exist, are for the test
# client.
yt_client_id_env <- Sys.getenv("YOUTUBE_CLIENT_ID")
if (nchar(yt_client_id_env)) {
  yt_test_client_id <- "1019074353027-99p3n5618jqnd0ush3p7gb9lrtt6gjec.apps.googleusercontent.com"
  if (yt_client_id_env != yt_test_client_id) {
    yt_client_secret_env <- Sys.getenv("YOUTUBE_CLIENT_SECRET")
    yt_refresh_env <- Sys.getenv("YOUTUBE_REFRESH_TOKEN")
    Sys.unsetenv("YOUTUBE_CLIENT_ID")
    Sys.unsetenv("YOUTUBE_CLIENT_SECRET")
    Sys.unsetenv("YOUTUBE_REFRESH_TOKEN")
    withr::defer(
      Sys.setenv(
        YOUTUBE_CLIENT_ID = yt_client_id_env,
        YOUTUBE_CLIENT_SECRET = yt_client_secret_env,
        YOUTUBE_REFRESH_TOKEN = yt_refresh_env
      ),
      teardown_env()
    )
  }
}
